# Parking Garage Server
Parking Garage Server is a back-end API interface for a MySQL Server.  The intent is for demonstration purposes only.

Works with [Parking Garage Client](https://github.com/alaroche/parking-garage-client).

## Requirements
* [MySQL 8.0.24](https://dev.mysql.com/doc/refman/8.0/en/)
* [Python 3](https://www.python.org/downloads/)

## Setup
### MySQL
* Run setup script in SQL which (re-)creates the database and pre-populates tables with sample data: https://github.com/alaroche/parking-garage-server/blob/main/sql/ParkingGarage.sql.
* Create a user for interaction with the new database:
```
CREATE USER 'parking_garage_user'@'localhost' IDENTIFIED BY 'pg_sql123';
GRANT ALL PRIVILEGES ON parking_garage.* TO 'parking_garage_user'@'localhost';
```

## Run
### Start Server
From `parking-garage-server/` directory:
```
uvicorn main:app --reload
```
FastAPI interface should come up locally.

### Optional
Start the Valet Runner to simulate timestamped activity
```
python3 valet_runner.py
```

---
## About the Complete App

### [Parking Garage Server](https://github.com/alaroche/parking-garage-server)
* Back-end API written in [Python3](https://www.python.org/)
* Server runs on [Uvicorn](https://www.uvicorn.org/)
* Interacts with [MySQL 8.0.24](https://dev.mysql.com/doc/refman/8.0/en/)
* Valet Runner test script simulates timestamped activity

### [Parking Garage Client](https://github.com/alaroche/parking-garage-client)
* Front-End interface bootstrapped with [Create React App](https://github.com/facebook/create-react-app)
* Builds and runs on [Yarn](https://classic.yarnpkg.com/)
