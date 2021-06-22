import mysql.connector
from app import parking_garage
from db_connection import DbConnection

from typing import Optional

from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/parking_spots")
def read_item():
    return DbConnection.run("SELECT * FROM parking_spots")