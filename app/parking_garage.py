state = "catawampus"
import mysql.connector

class ParkingGarage:
    def state(self):
        mysql.connector.query("SELECT * FROM parking_spots")
        #return {'hello': 'world'}