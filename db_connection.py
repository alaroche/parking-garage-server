from getpass import getpass
from mysql.connector import connect, Error

class DbConnection:
  def __init__(self, query):
    self.config = {
      'user': 'root',
      'host': '127.0.0.1',
      'database': 'parking_garage',
    }
    self.query = query

  def run(query):
    # TODO: cnx -> connection?
    #self.cnx = mysql.connector.connect(CONFIG)

    #cursor = self.cnx.cursor(buffered=True)
    
    #result?

    try:
      with connect(
          user='root',
          host='127.0.0.1',
          database='parking_garage',
      ) as connection:
          with connection.cursor() as cursor:
              cursor.execute(self.query)
    except Error as e:
        print(e)

    #self.cnx.close()
    # TODO: return cursor result
    # return cursor