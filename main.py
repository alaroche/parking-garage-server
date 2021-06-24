import mysql.connector
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
    return DatabaseConnection.run("SELECT * FROM parking_spots")