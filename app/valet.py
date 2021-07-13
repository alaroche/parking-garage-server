from database_connection import DatabaseConnection
from datetime import datetime;

def find_parking(vehicle_type):
    query = """
    SELECT parking_spots.id from parking_spots
    LEFT JOIN parking_spot_sessions
    ON parking_spots.id = parking_spot_sessions.parking_spot_id
    WHERE parking_spot_sessions.parking_session_id IS NULL
    LIMIT {size};
    """.format(vehicle_type.SPOT_USAGE_REQ);

    return DatabaseConnection.run(query)

def park_vehicle(vehicle_type):
    vehicle_type_query = """
    SELECT id
    FROM vehicle_types
    WHERE name={vehicle_type}
    LIMIT 1
    """.format(vehicle_type = vehicle_type)

    vehicle_type_id = DatabaseConnection(vehicle_type_query)

    sql = """
    INSERT INTO vehicle_parking_sessions COLUMNS('vehicle_type_id','parked_at')
    VALUES({vehicle_type_id},NOW())
    """.format(vehicle_type_id = vehicle_type_id)

    return DatabaseConnection(sql);