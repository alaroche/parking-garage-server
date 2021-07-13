import random;

class Vehicle:
    # TODO: make this a class
    def __init__(self):
        # self.type = vehicle_type
        self.suitable_spot_types = self.SUITABLE_SPOT_TYPES;

   # def appropriate_spot_type():
   #     a = SPOT_TYPES_SMALLEST_TO_LARGEST.zip(SUITABLE_SPOT_TYPES).flatten
   #     a.detect { |st| st.count > 1 }

class Motorcycle(Vehicle):
    SUITABLE_SPOT_TYPES: ['motorcycle', 'compact', 'large']
    SPOT_USAGE_REQ: 1

class Car(Vehicle):
    SUITABLE_SPOT_TYPES: ['compact', 'large']
    SPOT_USAGE_REQ: 1

class Bus(Vehicle):
    SUITABLE_SPOT_TYPES: ['large']
    SPOT_USAGE_REQ: 5

    def appropriate_spot_type():
        "large"