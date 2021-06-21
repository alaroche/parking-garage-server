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

-- Leave
DELETE FROM vehicle_spots
WHERE vehicle_id = %{id}


 -- Query for free spots (wip)
/*
SELECT parking_spots.id as 'parking_spot_id'
FROM parking_spots
LEFT JOIN parking_sessions
ON parking_spots.id = parking_spot_sessions.parking_spot_id
WHERE parking_spot_sessions.parking_spot_id IS NULL;
*/

-- park a bus
        def park
            // select:
            //  first row where
            //  available = true
            //  
            // select FIRST row where number of 'available' spots WITHIN 'accepted spot types' >= SPOT_USAGE_REQ
            // fill spots (insert into where ^^)
            // MySql.Connection("")

            // find a row
            // where there are 5 consecutive avaiable spots
            possible_rows_to_park_in = ```
            
            ```

            possible_rows_to_park_in.each do |row|

            end

            spot_ids = ```
                SELECT id FROM spots
                WHERE type = %{appropriate_spot_type}
                AND available IS TRUE
            ```
            // GROUP BY spot row?
            
            ```
            INSERT INTO vehicle_spots (spot_id, vehicle_id)
            VALUES (%{spot_id}, %{id})