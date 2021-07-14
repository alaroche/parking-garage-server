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

@app.get("/availability")
def read_item():
    output = {}
    total_spots_taken = DatabaseConnection.run("SELECT COUNT(*) FROM parking_spots WHERE current_parking_session_id IS NOT NULL")[0]['COUNT(*)']
    total_spots = DatabaseConnection.run("SELECT COUNT(*) FROM parking_spots")[0]['COUNT(*)']
    output["total_spots_taken"] = total_spots_taken
    output["total_spots"] = total_spots

    levels = DatabaseConnection.run("SELECT * FROM levels")
    print(levels);

    for level in levels:
        spots_taken_on_level_sql = """
        SELECT COUNT(*) FROM parking_spots
        INNER JOIN parking_rows
        ON parking_spots.parking_row_id = parking_rows.id
        INNER JOIN levels
        ON parking_rows.level_id = levels.id
        WHERE parking_spots.current_parking_session_id IS NOT NULL
        AND level_id = {level_id};
        """.format(level_id = level['id'])
        spots_taken_on_level = DatabaseConnection.run(spots_taken_on_level_sql)[0]['COUNT(*)']

        total_spots_on_level_sql = """
        SELECT COUNT(*) FROM parking_spots
        INNER JOIN parking_rows
        ON parking_spots.parking_row_id = parking_rows.id
        INNER JOIN levels
        ON parking_rows.level_id = levels.id
        WHERE level_id = {level_id};
        """.format(level_id = level['id'])
        total_spots_on_level = DatabaseConnection.run(total_spots_on_level_sql)[0]['COUNT(*)']
        level_key = "level_{level_id}".format(level_id = level['id'])

        output[level_key] = {}
        output[level_key]["name"] = level['name']
        output[level_key]["spots_taken"] = spots_taken_on_level
        output[level_key]["total_spots"] = total_spots_on_level

    return output

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

@app.delete("/sessions/{id}")
def remove_item(id: int):
    DatabaseConnection.insert("""
    UPDATE parking_spots
    SET current_parking_session_id = NULL
    WHERE current_parking_session_id = {id}
    """.format(id = id));

    DatabaseConnection.insert("""
    DELETE FROM parking_sessions
    WHERE id = {session_id}
    """.format(id = id));