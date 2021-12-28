## Requirements
parking-garage-client: https://github.com/alaroche/parking-garage-client

## Getting Started

### Setup
mysql database
setup scripts

### How to Play

### * Start Client
From `parking-garage-client/` directory:
```
yarn start
```

### * Start Server and Runner
From `parking-garage-server/` directory:
```
uvicorn main:app --reload
python3 valet_runner.py
```

## About the App

### [Parking Garage Server](https://github.com/alaroche/parking-garage-server)
Back-end architecture written in [Python3](https://www.python.org/)
Runs on [Uvicorn](https://www.uvicorn.org/)
Intereacts with [MySQL Community Server - GPL 8.0.24](https://dev.mysql.com/)
(fastapi?)

#### Components
Public API

#### Valet Runner
Feeds data to the MySQL Server.

### [Parking Garage Client](https://github.com/alaroche/parking-garage-client)
Front-End interface bootstrapped with [Create React App](https://github.com/facebook/create-react-app)
Runs with [Yarn](https://classic.yarnpkg.com/)
