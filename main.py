from database_connection import DatabaseConnection
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
    SELECT id from parking_spots
    WHERE current_parking_session_id IS NULL
    LIMIT {vehicle_spot_usage_req};
    """.format(vehicle_spot_usage_req = vehicle_spot_usage_req);

    parking_spots = DatabaseConnection.run(parking_spots_query);

    vehicle_session_insert = """
    INSERT INTO parking_sessions (vehicle_type_id,parked_at)
    VALUES({vehicle_type_id},CURRENT_TIMESTAMP);
    """.format(vehicle_type_id = vehicle_type_id);
    session_id = DatabaseConnection.insert(vehicle_session_insert);

    # TODO: Use WHERE IN, not this loop
    for spot in parking_spots:
        spot_session_insert = """
        UPDATE parking_spots
        SET current_parking_session_id = {session_id}
        WHERE id = {spot_id};
        """.format(session_id = session_id, spot_id = spot['id'])

        DatabaseConnection.insert(spot_session_insert);

@app.delete("/leave/{session_id}")
def remove_item(session_id: int):
    print(session_id);
    DatabaseConnection.insert("""
    UPDATE parking_spots
    SET current_parking_session_id = NULL
    WHERE current_parking_session_id = {session_id}
    """.format(session_id = session_id));

    DatabaseConnection.insert("""
    DELETE FROM parking_sessions
    WHERE id = {session_id}
    """.format(session_id = session_id));