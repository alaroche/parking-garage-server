from mysql.connector.connection import MySQLConnection
from database_connection import DatabaseConnection
from datetime import datetime

from typing import Optional

from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/parking_spots")
def read_item():
    query = """
    SELECT 
        parking_spots.id, 
        parking_row_id, 
        parking_spot_types.name as 'kind', 
        levels.name as 'level_name'
    FROM parking_spots
    LEFT JOIN parking_rows ON parking_spots.parking_row_id=parking_rows.id
    LEFT JOIN levels ON parking_rows.level_id=levels.id
    LEFT JOIN parking_spot_types on parking_spots.parking_spot_type_id=parking_spot_types.id;
    """

    return DatabaseConnection.run(query)

# TODO: spot_usage_requirement? change name?
@app.put("/park/{vehicle_type}")
def update_item(vehicle_type: str):
    vehicle_type_query = """
    SELECT id, spot_usage_requirement FROM vehicle_types WHERE name = '{vehicle_type}'
    """ .format(vehicle_type=vehicle_type);

    vehicle_type_res = DatabaseConnection.run(vehicle_type_query);

    vehicle_spot_usage_req = vehicle_type_res[0]['spot_usage_requirement'];
    vehicle_type_id = vehicle_type_res[0]['id'];

    parking_spots_query = """
    SELECT parking_spots.id from parking_spots
    LEFT JOIN parking_spot_sessions
    ON parking_spots.id = parking_spot_sessions.parking_spot_id
    WHERE parking_spot_sessions.vehicle_parking_session_id IS NULL
    LIMIT {vehicle_spot_usage_req};
    """.format(vehicle_spot_usage_req = vehicle_spot_usage_req);

    parking_spots = DatabaseConnection.run(parking_spots_query);

    vehicle_session_insert = """
    INSERT INTO vehicle_parking_sessions (vehicle_type_id,parked_at)
    VALUES({vehicle_type_id},CURRENT_TIMESTAMP);
    """.format(vehicle_type_id = vehicle_type_id);
    session_id = DatabaseConnection.insert(vehicle_session_insert);

    for spot in parking_spots:
        spot_session_insert = """
        INSERT INTO parking_spot_sessions (parking_spot_id,vehicle_parking_session_id)
        VALUES({spot_id}, {session_id});
        """.format(spot_id = spot['id'], session_id = session_id)
        DatabaseConnection.insert(spot_session_insert);

@app.delete("/park/{vehicle_parking_session_id}/leave")
def remove_item(vehicle_parking_session_id: int):
    DatabaseConnection.insert("DELETE FROM vehicle_parking_sessions WHERE id = {id}".format(id = vehicle_parking_session_id))