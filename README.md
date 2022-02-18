# Parking Garage Server
Parking Garage Server is a back-end API interface for a MySQL Server.  The intent is for demonstration purposes only.

Works with [Parking Garage Client](https://github.com/alaroche/parking-garage-client).

## Requirements
* [MySQL 8.0.24](https://dev.mysql.com/doc/refman/8.0/en/)
* [Python 3](https://www.python.org/downloads/)
* [Uvicorn](https://www.uvicorn.org/)

## Setup
### MySQL
* Run setup script in SQL which (re-)creates the database and pre-populates tables with sample data: https://github.com/alaroche/parking-garage-server/blob/main/tools/ParkingGarageSetup.sql.
* Create a user for interaction with the new database:
```
CREATE USER 'parking_garage_user'@'localhost' IDENTIFIED BY 'pg_sql123';
GRANT ALL PRIVILEGES ON parking_garage.* TO 'parking_garage_user'@'localhost';
```

### User Access
* Run setup script to setup the admin user:
From `parking-garage-server/` directory:
```
python3 setup_admin_user.py
```

Login will be `admin/admin`.

## Run
### Start Server
From `parking-garage-server/` directory:
```
uvicorn main:app --reload
```
A FastAPI interface should come up locally at http://127.0.0.1:8000.

### Optional
Start the Valet Runner to simulate timestamped activity
```
python3 valet_runner.py
```
