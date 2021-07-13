# parking_spot_sessions
# parking_spots
# parking_rows
# levels

SELECT * 
FROM parking_spots
#FULL OUTER JOIN parking_spot_sessions
UNION
SELECT * FROM parking_spot_sessions;
#ON parking_spot_sessions.parking_spot_id = parking_spots.id;