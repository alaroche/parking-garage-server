from mysql.connector import connect
from fastapi.exceptions import HTTPException

HTTP_INTERNAL_SERVER_ERROR_CODE = 500


class DatabaseConnection:
  def run(query):
    try:
      with connect(
          host='127.0.0.1',
          user='parking_garage_user',
          password='pg_sql123',
          database='parking_garage',
      ) as connection:
          res = []
          with connection.cursor(dictionary=True) as cursor:
              cursor.execute(query)
              for db in cursor:
                res.append(db)
          return res
    except:
      raise HTTPException(status_code=HTTP_INTERNAL_SERVER_ERROR_CODE)

  def insert(statement):
    try:
      with connect(
          host='127.0.0.1',
          user='parking_garage_user',
          password='pg_sql123',
          database='parking_garage',
      ) as connection:
          with connection.cursor(dictionary=True) as cursor:
              cursor.execute(statement)
              connection.commit()
              return cursor.lastrowid
    except:
      raise HTTPException(status_code=HTTP_INTERNAL_SERVER_ERROR_CODE)
