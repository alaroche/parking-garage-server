#import app;
import time;
import random;
from datetime import datetime;

ACTIONS = ['park','leave','nothing']

# every 30 seconds
    # a car goes in
        # is there enough room?
    # a car leaves
    # or nothing

while True:
    choice = random.choice(ACTIONS)
    currentTime = datetime.now().strftime("%Y-%m-%d %I:%M %p") + " | ";

    if choice == 'park':
        print(currentTime + "entering");
    elif choice == 'leave':
        print(currentTime + "leaving");
    else:
        print(currentTime + "nothing to do");

    time.sleep(30);