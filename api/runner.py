from lib.database_connection import DatabaseConnection
from fastapi import APIRouter

router = APIRouter(prefix='/go')

@router.post('/park')
def park_vehicle():
    spot_id = find_parking_spot()

    if bool(spot_id):
        vehicle_session_insert = '''
        INSERT INTO parking_sessions (parking_spot_id, started_at)
        VALUES({spot_id}, CURRENT_TIMESTAMP)
        '''.format(spot_id=spot_id)

        DatabaseConnection.insert(vehicle_session_insert)
    else:
        return {'success': False, 'result': 'no_spots_available'}

@router.put('/unpark/{session_id}')
def unpark_vehicle(session_id: int):
    close_parking_session = '''
    UPDATE parking_sessions
    SET stopped_at = CURRENT_TIMESTAMP
    WHERE id = {id}
    '''.format(id=session_id)

    DatabaseConnection.insert(close_parking_session)

def find_parking_spot():
    filled_spots_query = '''
    SELECT parking_spot_id
    FROM parking_sessions
    WHERE stopped_at IS NULL
    '''

    filled_spots_result = DatabaseConnection.run(filled_spots_query)

    filled_spot_ids = [0, 0]
    for obj in filled_spots_result:
        filled_spot_ids.append(obj['parking_spot_id'])

    parking_spots_query = '''
    SELECT id FROM parking_spots
    WHERE id NOT IN {}
    ORDER BY id
    LIMIT 1;
    '''.format(tuple(filled_spot_ids))

    free_spot = DatabaseConnection.run(parking_spots_query)

    if free_spot:
        return free_spot[0]['id']
    else:
        return []