class ParkingGarage:
    RULES = {
        'motorcycle':
            'size': 1,
            'compatible_parking_spot_types': [
                'motorcycle',
                'compact',
                'large'
            ],
        'car':
            'size': 1,
            'compatible_parking_spot_types': [
                'compact',
                'large'
            ],
        'bus':
            'size': 5,
            'compatible_parking_spot_types': [
                'large'
            ],
    }

    SUPPORTED_VEHICLE_TYPES = RULES.keys

    def state:
        pass
        # sql query