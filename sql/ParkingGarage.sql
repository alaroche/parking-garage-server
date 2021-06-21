DROP DATABASE parking_garage;
CREATE DATABASE parking_garage;

USE parking_garage;

-- Informative

CREATE TABLE parking_spot_types (
	id int NOT NULL AUTO_INCREMENT,
    name varchar(12),
    PRIMARY KEY (id)
);

CREATE TABLE vehicle_types (
	id int NOT NULL AUTO_INCREMENT,
    name varchar(12),
    PRIMARY KEY(id)
);

-- Structural

CREATE TABLE levels (
	id int NOT NULL AUTO_INCREMENT,
    name varchar(12) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE parking_rows (
	id int NOT NULL AUTO_INCREMENT,
    level_id int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (level_id) REFERENCES levels(id)
);

CREATE TABLE parking_spots (
	id int NOT NULL AUTO_INCREMENT,
    parking_row_id int NOT NULL,
    parking_spot_type_id int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (parking_row_id) REFERENCES parking_rows(id),
    FOREIGN KEY (parking_spot_type_id) REFERENCES parking_spot_types(id)
);

-- Misc

CREATE TABLE vehicle_parking_sessions (
	id int NOT NULL AUTO_INCREMENT,
    vehicle_type_id int NOT NULL,
    parked_at timestamp NOT NULL,
    #left_at timestamp,
    PRIMARY KEY (id),
    FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id)
);

CREATE TABLE parking_spot_sessions (
	id int NOT NULL AUTO_INCREMENT,
    parking_spot_id int NOT NULL,
    parking_session_Id int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (parking_spot_id) REFERENCES parking_spots(id),
    FOREIGN KEY (parking_session_id) REFERENCES vehicle_parking_sessions(id)
);

-- INSERT DATA

INSERT INTO levels (id,name) VALUES (1,'Red'),(2,'Orange'),(3,'Yellow'),(4,'Green'),(5,'Blue');

INSERT INTO parking_rows (level_id) VALUES (1),(1),(1),(1),(2),(2),(2),(2),(3),(3),(3),(3),(4),(4),(4),(4),(5),(5),(5),(5);

INSERT INTO parking_spot_types (id,name) VALUES (1,'motorcycle'),(2,'compact'),(3,'large');
INSERT INTO vehicle_types (id,name) VALUES (1,'motorocycle'),(2,'car'),(3,'bus');

-- 12 spots in each row: 5 large, 5 compact, 2 motorcycle
INSERT INTO parking_spots (parking_row_id,parking_spot_type_id) VALUES (1,3),(1,3),(1,3),(1,3),(1,3),(1,2),(1,2),(1,2),(1,2),(1,2),(1,1),(1,1),
(2,3),(2,3),(2,3),(2,3),(2,3),(2,2),(2,2),(2,2),(2,2),(2,2),(2,1),(2,1),
(3,3),(3,3),(3,3),(3,3),(3,3),(3,2),(3,2),(3,2),(3,2),(3,2),(3,1),(3,1),
(4,3),(4,3),(4,3),(4,3),(4,3),(4,2),(4,2),(4,2),(4,2),(4,2),(4,1),(4,1),
(5,3),(5,3),(5,3),(5,3),(5,3),(5,2),(5,2),(5,2),(5,2),(5,2),(5,1),(5,1);

#INSERT INTO vehicle_parking_sessions (vehicle_type_id, parked_at, left_at)
#VALUES (3,CURRENT_TIME(), NULL),