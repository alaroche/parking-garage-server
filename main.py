import hashlib
import jwt
from lib.database_connection import DatabaseConnection
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware

SECRET_TOKEN = '7c3a4e52502438e4f4596861c6040542a8632a688ffef1ea88c85f19626e71b2'

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_headers=['*'],
    allow_methods=['*'],
    allow_origins=[
        'http://aaronhost:3000',
        'http://localhost:3000'
    ]
)

@app.get('/availability')
def read_item():
    output = {}
    num_of_total_spots = DatabaseConnection.run('SELECT COUNT(*) FROM parking_spots')[0]['COUNT(*)']
    num_of_filled_spots = DatabaseConnection.run('SELECT COUNT(*) FROM parking_sessions WHERE stopped_at IS NULL')[0]['COUNT(*)']
    num_of_free_spots = num_of_total_spots - num_of_filled_spots

    output['total_spots_free'] = num_of_free_spots
    output['total_spots'] = num_of_total_spots
    output['parking_levels'] = {}

    parking_levels = DatabaseConnection.run('SELECT * FROM parking_levels')

    for idx, parking_level in enumerate(parking_levels):
        total_spots_on_level_sql = '''
        SELECT COUNT(*) FROM parking_spots
        INNER JOIN parking_rows
        ON parking_spots.parking_row_id = parking_rows.id
        INNER JOIN parking_levels
        ON parking_rows.parking_level_id = parking_levels.id
        WHERE parking_level_id = {level_id}
        '''.format(level_id = parking_level['id'])
        num_of_spots_on_level = DatabaseConnection.run(total_spots_on_level_sql)[0]['COUNT(*)']

        num_of_filled_spots_on_level_sql = '''
        SELECT COUNT(*) from parking_spots
        INNER JOIN parking_rows
        ON parking_spots.parking_row_id = parking_rows.id
        INNER JOIN parking_levels
        ON parking_rows.parking_level_id = parking_levels.id
        INNER JOIN parking_sessions
        ON parking_sessions.parking_spot_id = parking_spots.id
        WHERE parking_sessions.stopped_at IS NULL
        AND parking_level_id = {level_id}
        '''.format(level_id = parking_level['id'])
        num_of_spots_filled_on_level = DatabaseConnection.run(num_of_filled_spots_on_level_sql)[0]['COUNT(*)']
        num_of_spots_free_on_level = num_of_spots_on_level - num_of_spots_filled_on_level

        output['parking_levels'][idx] = {}
        output['parking_levels'][idx]['name'] = parking_level['name']
        output['parking_levels'][idx]['spots_free'] = num_of_spots_free_on_level
        output['parking_levels'][idx]['total_spots'] = num_of_spots_on_level

    return output

@app.post('/auth')
def authenticate_user(username: str, given_pswd: str):
    try:
        sql = "SELECT * FROM users WHERE username = '{}'".format(username)
        res = DatabaseConnection.run(sql)[0]
    except:
        return {'isError': True, 'result': 'login_failed'}

    salt = res['salted_pswd'][:64]
    actual_pswd_encrypted = res['salted_pswd'][64:]

    given_pswd_encrypted = hashlib.pbkdf2_hmac('sha256',
                                     given_pswd.encode('utf-8'),
                                     bytearray.fromhex(salt),
                                     10000)

    if given_pswd_encrypted.hex() == actual_pswd_encrypted:
        json_web_token = jwt.encode({'username': res['username']}, SECRET_TOKEN, algorithm='HS256')

        return {'isError': False, 'result': json_web_token}
    else:
        return {'isError': True, 'result': 'login_failed'}

@app.post('/auth_validate')
def validate_jwt(request: Request):
    jwt_from_header = request.headers.get('Authorization').split(' ')[1]

    decoded_jwt = jwt.decode(
        jwt_from_header,
        SECRET_TOKEN,
        algorithms=["HS256"],
        options={'verify_signature': True}
    )

    return {'username': decoded_jwt['username']}

@app.post('/park')
def update_item():
    spot_id = find_parking_spot();

    if bool(spot_id):
        vehicle_session_insert = '''
        INSERT INTO parking_sessions (parking_spot_id, started_at)
        VALUES({spot_id}, CURRENT_TIMESTAMP)
        '''.format(spot_id = spot_id)

        DatabaseConnection.insert(vehicle_session_insert)
    else:
        raise HTTPException(status_code=403, detail='No parking spots are available.')

@app.put('/unpark/{session_id}')
def unpark_vehicle(session_id: int):
    close_parking_session = '''
    UPDATE parking_sessions
    SET stopped_at = CURRENT_TIMESTAMP
    WHERE id = {id}
    '''.format(id = session_id)

    DatabaseConnection.insert(close_parking_session);

def find_parking_spot():
    taken_spots_query = '''
    SELECT parking_spot_id
    FROM parking_sessions
    WHERE stopped_at IS NULL
    '''

    taken_spots_result = DatabaseConnection.run(taken_spots_query)

    taken_spot_ids = [0,0]
    for obj in taken_spots_result:
        taken_spot_ids.append(obj['parking_spot_id']);

    parking_spots_query = '''
    SELECT id FROM parking_spots
    WHERE id NOT IN {}
    ORDER BY id
    LIMIT 1;
    '''.format(tuple(taken_spot_ids));

    free_spot = DatabaseConnection.run(parking_spots_query)

    if free_spot:
        return free_spot[0]['id']
    else:
        return []
