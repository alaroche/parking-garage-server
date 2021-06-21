-- Find an individual parking spot
 SELECT id FROM parking_spots
                WHERE parking_spot_type_id = 1
                #AND available IS TRUE
                LIMIT 1;
                
                -- All free spots
                SELECT * FROM parking_spots
                WHERE id = parking_sessions.parking_spot_id
                UNION parking_sessions
                
 -- Query for occupied spots
SELECT parking_spots.id as 'parking_spot_id'
FROM parking_spots
LEFT JOIN parking_sessions
ON parking_spots.id = parking_sessions.parking_spot_id
WHERE parking_sessions.left_at IS NULL;


 -- Query for free spots (wip)
/*
SELECT parking_spots.id as 'parking_spot_id'
FROM parking_spots
LEFT JOIN parking_sessions
ON parking_spots.id = parking_spot_sessions.parking_spot_id
WHERE parking_spot_sessions.parking_spot_id IS NULL;
*/