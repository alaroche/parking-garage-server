from lib.database_connection import DatabaseConnection
from fastapi import APIRouter, HTTPException, Request
from .auth import get_user_from_request

SECRET_TOKEN = '7c3a4e52502438e4f4596861c6040542a8632a688ffef1ea88c85f19626e71b2'

router = APIRouter(prefix='/garage')

@router.get('/{garage_id}/availability')
def get_availability(garage_id: int):
    output = {}
    output['parking_levels'] = {}

    # Initialize counters
    total_spots_free_in_garage = 0
    total_spots_filled_in_garage = 0

    parking_levels = DatabaseConnection.run("SELECT * FROM parking_levels WHERE garage_id = {}".format(garage_id))

    if (len(parking_levels) == 0):
        raise HTTPException(status_code=404) 

    for idx, parking_level in enumerate(parking_levels):
        total_spots_on_level_sql = '''
        SELECT COUNT(*) FROM parking_spots
        INNER JOIN parking_rows
        ON parking_spots.parking_row_id = parking_rows.id
        INNER JOIN parking_levels
        ON parking_rows.parking_level_id = parking_levels.id
        WHERE parking_level_id = {level_id}
        '''.format(level_id=parking_level['id'])
        num_of_spots_on_level = DatabaseConnection.run(
            total_spots_on_level_sql)[0]['COUNT(*)']

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
        '''.format(level_id=parking_level['id'])
        num_of_spots_filled_on_level = DatabaseConnection.run(
            num_of_filled_spots_on_level_sql)[0]['COUNT(*)']
        num_of_spots_free_on_level = num_of_spots_on_level - num_of_spots_filled_on_level

        total_spots_free_in_garage += num_of_spots_free_on_level
        total_spots_filled_in_garage += num_of_spots_filled_on_level

        output['parking_levels'][idx] = {}
        output['parking_levels'][idx]['name'] = parking_level['name']
        output['parking_levels'][idx]['spots_free'] = num_of_spots_free_on_level
        output['parking_levels'][idx]['total_spots'] = num_of_spots_on_level

    output['total_spots_free'] = total_spots_free_in_garage
    output['total_spots'] = total_spots_free_in_garage + total_spots_filled_in_garage
    output['success'] = True

    return output

def find_parking_spot():
    filled_spots_query = '''
    SELECT parking_spot_id
    FROM parking_sessions
    WHERE stopped_at IS NULL
    '''

    filled_spots_result = DatabaseConnection.run(filled_spots_query)

    filled_spot_ids = [0, 0]
    for obj in filled_spots_result:
        filled_spot_ids.append(obj['parking_spot_id'])

    parking_spots_query = '''
    SELECT id FROM parking_spots
    WHERE id NOT IN {}
    ORDER BY id
    LIMIT 1;
    '''.format(tuple(filled_spot_ids))

    free_spot = DatabaseConnection.run(parking_spots_query)

    if free_spot:
        return free_spot[0]['id']
    else:
        return []

@router.post('/park')
def park_vehicle():
    spot_id = find_parking_spot()

    if bool(spot_id):
        vehicle_session_insert = '''
        INSERT INTO parking_sessions (parking_spot_id, started_at)
        VALUES({spot_id}, CURRENT_TIMESTAMP)
        '''.format(spot_id=spot_id)

        DatabaseConnection.insert(vehicle_session_insert)
    else:
        return {'success': False, 'result': 'no_spots_available'}

@router.put('/unpark/{session_id}')
def unpark_vehicle(session_id: int):
    close_parking_session = '''
    UPDATE parking_sessions
    SET stopped_at = CURRENT_TIMESTAMP
    WHERE id = {id}
    '''.format(id=session_id)

    DatabaseConnection.insert(close_parking_session)

@router.get('/{garage_id}/profile')
def get_profile_info(garage_id: int):
    print('get_profile_info')
    print(garage_id)

    try:
        result = DatabaseConnection.run('''
        SELECT *
        FROM garages
        WHERE id = {}
        '''.format(garage_id))[0]

        print(result)
        return { 'success': True, 'result' : result } 
    except:
        return { 'success': False, 'result' : None } 

@router.put('/profile')
def update_profile_info(
    request: Request,
    garageName: str,
    address1: str,
    address2: str,
    city: str,
    state: str,
    zip: str,
    email: str
):
    user = get_user_from_request(request)
    username = user['username']
    garageId = user['garage_id']

    user = DatabaseConnection.run("SELECT id, garage_id FROM users WHERE username = '{}'".format(username))[0]['id']

    if (user is None):
        return {'success': False, 'result': None}

    update_profile_info = '''
    UPDATE garages
    SET
    name = '{garageName}',
    address1 = '{address1}',
    address2 = '{address2}',
    city = '{city}',
    state = '{state}',
    zip = '{zip}',
    email = '{email}'
    WHERE
    id = {garageId}
    '''.format(
        garageName=garageName,
        address1=address1,
        address2=address2,
        city=city,
        state=state,
        zip=zip,
        email=email,
        garageId=garageId
    )

    try: 
        DatabaseConnection.insert(update_profile_info)

        return { 'success': True, 'result': 'saved'}
    except:
        return { 'success': False, 'result': 'database_error'}
