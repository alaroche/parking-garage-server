from app import parking_garage
from database_connection import DatabaseConnection

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
