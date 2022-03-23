import hashlib
import jwt
from lib.database_connection import DatabaseConnection
from fastapi import APIRouter, Request

SECRET_TOKEN = '7c3a4e52502438e4f4596861c6040542a8632a688ffef1ea88c85f19626e71b2'

router = APIRouter(prefix='/user')

def get_user_from_database(username: str):
    sql = "SELECT * FROM users WHERE username = '{}'".format(username)

    return DatabaseConnection.run(sql)[0]

def get_username_from_request(request):
    given_jwt = request.headers.get('Authorization').split(' ')[1]
    decoded_jwt = decode_jwt(given_jwt)

    res = get_user_from_database(decoded_jwt['username'])

    return res['username']

@router.post('/auth')
def authenticate_user(username: str, given_pswd: str):
    try:
        res = get_user_from_database(username)
    except:
        return {'success': False, 'result': 'login_failed'}

    salt = res['salted_pswd'][:64]
    actual_pswd_encrypted = res['salted_pswd'][64:]

    given_pswd_encrypted = hashlib.pbkdf2_hmac('sha256',
                                     given_pswd.encode('utf-8'),
                                     bytearray.fromhex(salt),
                                     10000)

    if given_pswd_encrypted.hex() == actual_pswd_encrypted:
        json_web_token = jwt.encode({'username': res['username']}, SECRET_TOKEN, algorithm='HS256')

        return {'success': True, 'result': json_web_token}
    else:
        return {'success': False, 'result': 'login_failed'}

@router.post('/auth_validate')
def validate_jwt(request: Request):
    username = get_username_from_request(request)

    if (username):
        return {'success': True, 'result': username}
    else:
        return {'success': False, 'result': 'auth_validation_failed'}

@router.get('/profile')
def get_profile_info(request: Request):
    try:
        result = DatabaseConnection.run('''
        SELECT *
        FROM garages
        LEFT JOIN users
        ON garages.id = users.garage_id
        LIMIT 1;
        ''')[0]

        return { 'success': True, 'result' : result } 
    except:
        return { 'success': False, 'result' : None } 

@router.put('/profile')
def update_profile_info(
    request: Request,
    garageId: int,
    garageName: str,
    address1: str,
    address2: str,
    city: str,
    state: str,
    zip: str,
    email: str
):
    username = get_username_from_request(request)

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

def decode_jwt(given_jwt: str):
    return jwt.decode(
        given_jwt,
        SECRET_TOKEN,
        algorithms=["HS256"],
        options={'verify_signature': True}
    )
