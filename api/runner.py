from lib.database_connection import DatabaseConnection
from fastapi import APIRouter, HTTPException

router = APIRouter(prefix='/go')


@router.post('/park', status_code=201)
def park_vehicle():
    spot_id = find_parking_spot()

    if bool(spot_id):
        vehicle_session_insert = '''
        INSERT INTO parking_sessions (parking_spot_id, started_at)
        VALUES({}, CURRENT_TIMESTAMP)
        '''.format(spot_id)

        DatabaseConnection.insert(vehicle_session_insert)
    else:
        raise HTTPException(status_code=404, detail='no_parking_available')


@router.put('/unpark/{session_id}')
def unpark_vehicle(session_id: int):
    close_parking_session = '''
    UPDATE parking_sessions
    SET stopped_at = CURRENT_TIMESTAMP
    WHERE id = {}
    '''.format(session_id)

    DatabaseConnection.insert(close_parking_session)


def find_parking_spot():
    filled_spots = DatabaseConnection.run('''
    SELECT parking_spot_id
    FROM parking_sessions
    WHERE stopped_at IS NULL
    ''')

    # Built-in values to satisfy SQL syntax
    filled_spot_ids_str = '0,'
    for obj in filled_spots:
        if type(obj) != None:
            id = obj['parking_spot_id']
            filled_spot_ids_str = filled_spot_ids_str + str(id) + ','

    free_spot = DatabaseConnection.run('''
    SELECT id FROM parking_spots
    WHERE id NOT IN ({})
    ORDER BY id
    LIMIT 1;
    '''.format(filled_spot_ids_str[:-1]))

    if free_spot:
        return free_spot[0]['id']
    else:
        return []
