import datetime
import hashlib
import jwt
from fastapi import APIRouter, HTTPException, Request
from lib.database_connection import DatabaseConnection

SECRET_TOKEN = '7c3a4e52502438e4f4596861c6040542a8632a688ffef1ea88c85f19626e71b2'

router = APIRouter(prefix='/auth')

def get_user_from_database(username: str):
    sql = "SELECT * FROM users WHERE username = '{}'".format(username)

    return DatabaseConnection.run(sql)[0]

@router.post('/authenticate')
def authenticate_user(username: str, given_pswd: str):
    try:
        res = get_user_from_database(username)
    except:
        raise HTTPException(status_code=401)

    salt = res['salted_pswd'][:64]
    actual_pswd_encrypted = res['salted_pswd'][64:]

    given_pswd_encrypted = hashlib.pbkdf2_hmac('sha256',
                                               given_pswd.encode('utf-8'),
                                               bytearray.fromhex(salt),
                                               10000)

    if given_pswd_encrypted.hex() == actual_pswd_encrypted:
        now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        DatabaseConnection.insert('''
        UPDATE users
        SET signed_in_at = CAST('{now}' as time)
        WHERE
        username = '{username}'
        '''.format(now=now,username=username))

        json_web_token = jwt.encode(
            {
                'username': res['username'],
                'signed_in_at': now,
            },
            SECRET_TOKEN,
            algorithm='HS256'
        )

        return {'result': json_web_token}
    else:
        raise HTTPException(status_code=401)


@router.post('/authorize')
def authorize_with_jwt(request: Request):
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

        if (str(decoded_jwt['signed_in_at']) == str(res['signed_in_at'])):
            return {'username': res['username'], 'garage_id': res['garage_id']}
    else:
        raise HTTPException(status_code=401)
