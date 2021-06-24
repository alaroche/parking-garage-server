from getpass import getpass
from mysql.connector import connect, Error
import pdb

class DbConnection:
  def run(query):
    try:
      with connect(
          host='127.0.0.1',
          port='3306',
          user='root',
          password='rootroot',
          database='parking_garage',
      ) as connection:
          print("has connection")
          with connection.cursor() as cursor:
              pdb.set_trace()
              cursor.execute(query)
    except Error as e:
        print("Has error")
        print(e)
