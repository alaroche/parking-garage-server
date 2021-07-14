import random;
import time;
import requests;
from datetime import datetime

def around_business_hours():
    now.time().hour > 8 and now.time().hour < 18;

while True:
    now = datetime.now();
    nowStr = now.strftime("%Y-%m-%d %I:%M:%S %p") + " > ";

    # TODO: weight
    if around_business_hours():
        choice = random.choice(['park','leave','nothing']);
    else:
        choice = random.choice(['leave','nothing']);

    if choice == 'park':
        print(nowStr + "parking");
        requests.put("http://127.0.0.1:8000/park/{vehicle_type}".format(vehicle_type = random.choice(['motorcycle','car','bus'])))
    elif choice == 'leave':
        print(nowStr + "leaving");
        #main.unpark_random()
    else:
        print(nowStr + "nothing to do");

    time.sleep(30);
