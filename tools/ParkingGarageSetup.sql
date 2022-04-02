/*** WARNING !!! 
THIS WILL ERASE ALL DATA
AND SET TO DEFAULT  ***/

DROP DATABASE IF EXISTS parking_garage;
CREATE DATABASE parking_garage;

USE parking_garage;

CREATE TABLE garages (
    id int NOT NULL AUTO_INCREMENT,
    name varchar(255),
    address1 varchar(255),
    address2 varchar(255),
    city varchar(35),
    state char(2),
    zip char(5),
    email varchar(255),

    PRIMARY KEY (id)
);

CREATE TABLE users (
    id int NOT NULL AUTO_INCREMENT,
    garage_id int NOT NULL,
    username varchar(11) NOT NULL,
    salted_pswd varchar(255) NOT NULL,
    signed_in_at timestamp,
    UNIQUE(username),
    PRIMARY KEY (id),
    FOREIGN KEY (garage_id) REFERENCES garages(id)
);

CREATE TABLE parking_levels (
	id int NOT NULL AUTO_INCREMENT,
    garage_id int NOT NULL,
    name varchar(12) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (garage_id) REFERENCES garages(id)
);

CREATE TABLE parking_rows (
	id int NOT NULL AUTO_INCREMENT,
    parking_level_id int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (parking_level_id) REFERENCES parking_levels(id)
);

CREATE TABLE parking_spots (
	id int NOT NULL AUTO_INCREMENT,
    parking_row_id int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (parking_row_id) REFERENCES parking_rows(id)
);

CREATE TABLE parking_sessions (
    id int NOT NULL AUTO_INCREMENT,
    parking_spot_id int NOT NULL,
    started_at timestamp NOT NULL,
    stopped_at timestamp,
    PRIMARY KEY (id),
    FOREIGN KEY (parking_spot_id) REFERENCES parking_spots(id)
);

-- INSERT DATA --
INSERT INTO garages (id, name, address1, address2, city, state, zip, email)
VALUES (1,'Cherry Tree Plaza Parking','795 Spruce St',NULL,'Jay','VT','05401',NULL);

INSERT INTO parking_levels (id,garage_id,name) VALUES (1,1,'Level A'),(2,1,'Level B'),(3,1,'Level C'),(4,1,'Level D');

INSERT INTO parking_rows (parking_level_id) VALUES (1),(1),(1),(1),(2),(2),(2),(2),(3),(3),(3),(3),(4),(4),(4),(4);

-- 12 spots for each row
-- 4 rows for each level
-- 4 levels generated for an example
INSERT INTO parking_spots (parking_row_id)
VALUES 
(1),(1),(1),(1),(1),(1),(1),(1),(1),(1),(1),(1),
(2),(2),(2),(2),(2),(2),(2),(2),(2),(2),(2),(2),
(3),(3),(3),(3),(3),(3),(3),(3),(3),(3),(3),(3),
(4),(4),(4),(4),(4),(4),(4),(4),(4),(4),(4),(4),
(5),(5),(5),(5),(5),(5),(5),(5),(5),(5),(5),(5),
(6),(6),(6),(6),(6),(6),(6),(6),(6),(6),(6),(6),
(7),(7),(7),(7),(7),(7),(7),(7),(7),(7),(7),(7),
(8),(8),(8),(8),(8),(8),(8),(8),(8),(8),(8),(8),
(9),(9),(9),(9),(9),(9),(9),(9),(9),(9),(9),(9),
(10),(10),(10),(10),(10),(10),(10),(10),(10),(10),(10),(10),
(11),(11),(11),(11),(11),(11),(11),(11),(11),(11),(11),(11),
(12),(12),(12),(12),(12),(12),(12),(12),(12),(12),(12),(12),
(13),(13),(13),(13),(13),(13),(13),(13),(13),(13),(13),(13),
(14),(14),(14),(14),(14),(14),(14),(14),(14),(14),(14),(14),
(15),(15),(15),(15),(15),(15),(15),(15),(15),(15),(15),(15),
(16),(16),(16),(16),(16),(16),(16),(16),(16),(16),(16),(16)