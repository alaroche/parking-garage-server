import random
import time
import requests
from lib.database_connection import DatabaseConnection
from datetime import datetime

def around_business_hours():
    return now.time().hour > 8 and now.time().hour < 18

def find_random_session_id():
    session_id_res = DatabaseConnection.run("SELECT id FROM parking_sessions ORDER BY RAND() LIMIT 1")
    if (session_id_res):
        return session_id_res[0]['id']
    else:
        return None

while True:
    now = datetime.now()
    nowStr = now.strftime("%Y-%m-%d %I:%M:%S %p") + " > "

    if around_business_hours():
        choice = random.choice(['park','leave','relax'])
    else:
        choice = random.choice(['leave','relax'])

    if choice == 'park':
        print(nowStr + "parking")
        requests.post("http://127.0.0.1:8000/park")
    elif choice == 'leave':
        print(nowStr + "leaving")
        session_id = find_random_session_id()
        if (session_id):
            requests.put("http://127.0.0.1:8000/unpark/{id}".format(id = session_id))
    else:
        print(nowStr + "relaxing")

    time.sleep(10)
