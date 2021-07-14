import random;
import time;
import requests;
from database_connection import DatabaseConnection
from datetime import datetime;

def around_business_hours():
    now.time().hour > 8 and now.time().hour < 18;

def find_random_session_id():
    session_id_res = DatabaseConnection.run("SELECT id FROM parking_sessions ORDER BY RAND() LIMIT 1;");
    return session_id_res[0]['id'];

while True:
    now = datetime.now();
    nowStr = now.strftime("%Y-%m-%d %I:%M:%S %p") + " > ";

    # TODO: weight
    #if around_business_hours():
    choice = random.choice(['park','leave','relax']);
    #else:
        #choice = random.choice(['leave','relax']);

    if choice == 'park':
        print(nowStr + "parking");
        requests.put("http://127.0.0.1:8000/park/{vehicle_type}".format(vehicle_type = random.choice(['motorcycle','car','bus'])))
    elif choice == 'leave':
        print(nowStr + "leaving");
        requests.delete("http://127.0.0.1:8000/sessions/{id}".format(id = find_random_session_id()));
    else:
        print(nowStr + "relaxing");

    time.sleep(10);
