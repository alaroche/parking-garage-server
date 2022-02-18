from hashlib import pbkdf2_hmac
from os import urandom
from lib.database_connection import DatabaseConnection

username = 'admin'
pswd = 'admin'

salt = urandom(32)
print('salt: ' + salt.hex())
key = pbkdf2_hmac('sha256', pswd.encode('utf-8'), salt, 10000)
print('key: ' + key.hex())

salted_pswd = salt + key
print('salted_pswd: ' + salted_pswd.hex())

sql = '''
INSERT INTO users (username, salted_pswd) VALUES ("{}","{}")
'''.format(username, salted_pswd.hex())

DatabaseConnection.insert(sql)