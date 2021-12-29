from mysql.connector import connect, Error

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
    except Error as e:
        print("Error getting record(s)")
        print(e)

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
    except Error as e:
        print("Error inserting record(s)")
        print(e)