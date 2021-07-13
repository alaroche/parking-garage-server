from app import valet;
import random;
import time;
from datetime import datetime

def around_business_hours():
    now.time().hour > 8 and now.time().hour < 18;

def get_vehicle():
    # retrieve from db or, if around_business_hours(), get new one
    query = """
    
    """
    random.choice(['motorcycle','car','bus']);

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
        valet.park_vehicle('car');
    elif choice == 'leave':
        print(nowStr + "leaving");
    else:
        print(nowStr + "nothing to do");

    time.sleep(30);
