DROP DATABASE IF EXISTS parking_garage;
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
    spot_usage_requirement int(1),
    PRIMARY KEY(id)
);

CREATE TABLE vehicle_type_parking_spot_type_compatibilities (
	vehicle_type_id int NOT NULL,
    parking_spot_type_id int NOT NULL,
    FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id),
    FOREIGN KEY (parking_spot_type_id) REFERENCES parking_spot_types(id)
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

CREATE TABLE parking_sessions (
	id int NOT NULL AUTO_INCREMENT,
    vehicle_type_id int NOT NULL,
    parked_at timestamp NOT NULL,
    #left_at timestamp,
    PRIMARY KEY (id),
    FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id)
);

CREATE TABLE parking_spots (
	id int NOT NULL AUTO_INCREMENT,
    parking_row_id int NOT NULL,
    parking_spot_type_id int NOT NULL,
    current_parking_session_id int,
    PRIMARY KEY (id),
    FOREIGN KEY (parking_row_id) REFERENCES parking_rows(id),
    FOREIGN KEY (parking_spot_type_id) REFERENCES parking_spot_types(id),
    FOREIGN KEY (current_parking_session_id) REFERENCES parking_sessions(id)
);

-- INSERT DATA

INSERT INTO levels (id,name) VALUES (1,'Gamma'),(2,'Theta'),(3,'Kappa'),(4,'Lambda'),(5,'Upsilon');

INSERT INTO parking_rows (level_id) VALUES (1),(1),(1),(1),(2),(2),(2),(2),(3),(3),(3),(3),(4),(4),(4),(4),(5),(5),(5),(5);

INSERT INTO parking_spot_types (id,name) VALUES (1,'motorcycle'),(2,'compact'),(3,'large');
INSERT INTO vehicle_types (id,name,spot_usage_requirement) VALUES (1,'motorcycle',1),(2,'car',1),(3,'bus',5);

INSERT INTO vehicle_type_parking_spot_type_compatibilities (vehicle_type_id, parking_spot_type_id)
VALUES (1,1),(1,2),(1,3),
(2,2),(2,3),
(3,3);

-- 12 spots in each row: 5 large, 5 compact, 2 motorcycle
INSERT INTO parking_spots (parking_row_id,parking_spot_type_id)
VALUES (1,3),(1,3),(1,3),(1,3),(1,3),(1,2),(1,2),(1,2),(1,2),(1,2),(1,1),(1,1),
(2,3),(2,3),(2,3),(2,3),(2,3),(2,2),(2,2),(2,2),(2,2),(2,2),(2,1),(2,1),
(3,3),(3,3),(3,3),(3,3),(3,3),(3,2),(3,2),(3,2),(3,2),(3,2),(3,1),(3,1),
(4,3),(4,3),(4,3),(4,3),(4,3),(4,2),(4,2),(4,2),(4,2),(4,2),(4,1),(4,1),
(5,3),(5,3),(5,3),(5,3),(5,3),(5,2),(5,2),(5,2),(5,2),(5,2),(5,1),(5,1),
(6,3),(6,3),(6,3),(6,3),(6,3),(6,2),(6,2),(6,2),(6,2),(6,2),(6,1),(6,1),
(7,3),(7,3),(7,3),(7,3),(7,3),(7,2),(7,2),(7,2),(7,2),(7,2),(7,1),(7,1),
(8,3),(8,3),(8,3),(8,3),(8,3),(8,2),(8,2),(8,2),(8,2),(8,2),(8,1),(8,1),
(9,3),(9,3),(9,3),(9,3),(9,3),(9,2),(9,2),(9,2),(9,2),(9,2),(9,1),(9,1),
(10,3),(10,3),(10,3),(10,3),(10,3),(10,2),(10,2),(10,2),(10,2),(10,2),(10,1),(10,1),
(11,3),(11,3),(11,3),(11,3),(11,3),(11,2),(11,2),(11,2),(11,2),(11,2),(11,1),(11,1),
(12,3),(12,3),(12,3),(12,3),(12,3),(12,2),(12,2),(12,2),(12,2),(12,2),(12,1),(12,1),
(13,3),(13,3),(13,3),(13,3),(13,3),(13,2),(13,2),(13,2),(13,2),(13,2),(13,1),(13,1),
(14,3),(14,3),(14,3),(14,3),(14,3),(14,2),(14,2),(14,2),(14,2),(14,2),(14,1),(14,1),
(15,3),(15,3),(15,3),(15,3),(15,3),(15,2),(15,2),(15,2),(15,2),(15,2),(15,1),(15,1),
(16,3),(16,3),(16,3),(16,3),(16,3),(16,2),(16,2),(16,2),(16,2),(16,2),(16,1),(16,1),
(17,3),(17,3),(17,3),(17,3),(17,3),(17,2),(17,2),(17,2),(17,2),(17,2),(17,1),(17,1),
(18,3),(18,3),(18,3),(18,3),(18,3),(18,2),(18,2),(18,2),(18,2),(18,2),(18,1),(18,1),
(19,3),(19,3),(19,3),(19,3),(19,3),(19,2),(19,2),(19,2),(19,2),(19,2),(19,1),(19,1),
(20,3),(20,3),(20,3),(20,3),(20,3),(20,2),(20,2),(20,2),(20,2),(20,2),(20,1),(20,1)

#INSERT INTO parking_sessions (vehicle_type_id, parked_at, left_at)
#VALUES (3,CURRENT_TIME(), NULL),