from lib.database_connection import DatabaseConnection
from fastapi import APIRouter, HTTPException, Request
from .auth import get_user_from_request

SECRET_TOKEN = '7c3a4e52502438e4f4596861c6040542a8632a688ffef1ea88c85f19626e71b2'

router = APIRouter(prefix='/garage')

@router.get('/{garage_id}/availability', status_code=200)
def get_availability(garage_id: int):
    output = {}
    output['parking_levels'] = {}

    # Initialize counters
    total_spots_free_in_garage = 0
    total_spots_filled_in_garage = 0

    parking_levels = DatabaseConnection.run("SELECT * FROM parking_levels WHERE garage_id = {}".format(garage_id))

    if (len(parking_levels) == 0):
        raise HTTPException(status_code=404) 

    for idx, parking_level in enumerate(parking_levels):
        total_spots_on_level_sql = '''
        SELECT COUNT(*) FROM parking_spots
        INNER JOIN parking_rows
        ON parking_spots.parking_row_id = parking_rows.id
        INNER JOIN parking_levels
        ON parking_rows.parking_level_id = parking_levels.id
        WHERE parking_level_id = {level_id}
        '''.format(level_id=parking_level['id'])
        num_of_spots_on_level = DatabaseConnection.run(
            total_spots_on_level_sql)[0]['COUNT(*)']

        num_of_filled_spots_on_level_sql = '''
        SELECT COUNT(*) from parking_spots
        INNER JOIN parking_rows
        ON parking_spots.parking_row_id = parking_rows.id
        INNER JOIN parking_levels
        ON parking_rows.parking_level_id = parking_levels.id
        INNER JOIN parking_sessions
        ON parking_sessions.parking_spot_id = parking_spots.id
        WHERE parking_sessions.stopped_at IS NULL
        AND parking_level_id = {level_id}
        '''.format(level_id=parking_level['id'])
        num_of_spots_filled_on_level = DatabaseConnection.run(
            num_of_filled_spots_on_level_sql)[0]['COUNT(*)']
        num_of_spots_free_on_level = num_of_spots_on_level - num_of_spots_filled_on_level

        total_spots_free_in_garage += num_of_spots_free_on_level
        total_spots_filled_in_garage += num_of_spots_filled_on_level

        output['parking_levels'][idx] = {}
        output['parking_levels'][idx]['name'] = parking_level['name']
        output['parking_levels'][idx]['spots_free'] = num_of_spots_free_on_level
        output['parking_levels'][idx]['total_spots'] = num_of_spots_on_level

    output['total_spots_free'] = total_spots_free_in_garage
    output['total_spots'] = total_spots_free_in_garage + total_spots_filled_in_garage

    return output

@router.get('/{garage_id}/profile')
def get_profile_info(garage_id: int):
    print('get_profile_info')
    print(garage_id)

    try:
        result = DatabaseConnection.run('''
        SELECT *
        FROM garages
        WHERE id = {}
        '''.format(garage_id))[0]

        print(result)
        return { 'success': True, 'result' : result } 
    except:
        raise HTTPException(status_code=404)

@router.put('/profile')
def update_profile_info(
    request: Request,
    garage_name: str,
    address1: str,
    address2: str,
    city: str,
    state: str,
    zip: str,
    email: str
):
    user = get_user_from_request(request)
    username = user['username']
    garage_id = user['garage_id']

    user = DatabaseConnection.run("SELECT id, garage_id FROM users WHERE username = '{}'".format(username))[0]['id']

    if (user is None):
        raise HTTPException(status_code=404)

    update_profile_info = '''
    UPDATE garages
    SET
    name = '{garage_name}',
    address1 = '{address1}',
    address2 = '{address2}',
    city = '{city}',
    state = '{state}',
    zip = '{zip}',
    email = '{email}'
    WHERE
    id = {garage_id}
    '''.format(
        garage_name=garage_name,
        address1=address1,
        address2=address2,
        city=city,
        state=state,
        zip=zip,
        email=email,
        garage_id=garage_id
    )

    try: 
        DatabaseConnection.insert(update_profile_info)

        return { 'success': True, 'result': 'saved'}
    except:
        raise HTTPException(status_code=500)