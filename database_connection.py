from mysql.connector import connect, Error

class DatabaseConnection:
  def run(query):
    try:
      with connect(
          host='127.0.0.1',
          user='root',
          password='rootroot',
          database='parking_garage',
      ) as connection:
          res = []
          with connection.cursor(dictionary=True) as cursor:
              cursor.execute(query)
              for db in cursor:
                res.append(db)
          return res
    except Error as e:
        print("Has error")
        print(e)
