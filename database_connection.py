from getpass import getpass
from mysql.connector import connect, Error
import pdb

class DatabaseConnection:
  def run(query):
    try:
      with connect(
          host='127.0.0.1',
          user='root',
          password='rootroot',
          database='parking_garage',
      ) as connection:
          print("has connection")
          with connection.cursor() as cursor:
              cursor.execute(query)
              for db in cursor:
                print(db)
    except Error as e:
        print("Has error")
        print(e)
