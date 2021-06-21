class Vehicle:
    def __init__(vehicle_type):
        self.type = vehicle_type

    def appropriate_spot_type
        a = SPOT_TYPES_SMALLEST_TO_LARGEST.zip(ACCEPTABLE_SPOT_TYPES).flatten
        a.detect { |st| st.count > 1 }

    class Motorcycle(Vehicle):
        ACCEPTABLE_SPOT_TYPES: ['motorcycle', 'compact', 'large']
        SPOT_USAGE_REQ: 1

    class Car(Vehicle):
        ACCEPTABLE_SPOT_TYPES: ['compact', 'large']
        SPOT_USAGE_REQ: 1

    class Bus(Vehicle):
        ACCEPTABLE_SPOT_TYPES: ['large']
        SPOT_USAGE_REQ: 5

        def park
            # how to

        def appropriate_spot_type
            "large"