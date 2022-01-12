DROP DATABASE IF EXISTS parking_garage;
CREATE DATABASE parking_garage;

USE parking_garage;

-- Structural --

CREATE TABLE parking_levels (
	id int NOT NULL AUTO_INCREMENT,
    name varchar(12) NOT NULL,
    PRIMARY KEY (id)
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
    stopped_at timestamp NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (parking_spot_id) REFERENCES parking_spots(id)
);

-- INSERT DATA --
INSERT INTO parking_levels (id,name) VALUES (1,'Level A'),(2,'Level B'),(3,'Level C'),(4,'Level D');

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