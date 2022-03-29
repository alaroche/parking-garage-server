import hashlib
import jwt
from fastapi import APIRouter, Request
from lib.database_connection import DatabaseConnection

SECRET_TOKEN = '7c3a4e52502438e4f4596861c6040542a8632a688ffef1ea88c85f19626e71b2'

router = APIRouter(prefix='/auth')

def get_user_from_database(username: str):
    sql = "SELECT * FROM users WHERE username = '{}'".format(username)

    return DatabaseConnection.run(sql)[0]

def get_user_from_request(request):
    auth_header = request.headers.get('Authorization')

    if (auth_header):
        given_jwt = auth_header.split(' ')[1]
        decoded_jwt = jwt.decode(
            given_jwt,
            SECRET_TOKEN,
            algorithms=["HS256"],
            options={'verify_signature': True}
        )

        res = get_user_from_database(decoded_jwt['username'])

        return {'username': res['username'], 'garage_id': res['garage_id']}
    else:
        return {'username': None, 'garage_id': None}

@router.post('/authenticate')
def authenticate_user(username: str, given_pswd: str):
    try:
        res = get_user_from_database(username)
    except:
        # TODO: include http codes
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

@router.post('/authorize')
def validate_jwt(request: Request):
    user = get_user_from_request(request)

    if (user['username']):
        return {'success': True, 'result': {'username': user['username'], 'garageId': user['garage_id']}}
    else:
        return {'success': False, 'result': 'auth_validation_failed'}
