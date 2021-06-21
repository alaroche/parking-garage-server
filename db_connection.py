import mysql.connector

class DbConnection:
  CONFIG = {
    'user': 'root',
    'host': '127.0.0.1',
    'database': 'parking_garage',
  }

  def __init__(self):
    self.cnx = mysql.connector.connect(self.CONFIG)

  def query(query):
    # TODO: testing
    query = "SELECT * FROM parking_spots"
    cursor = self.cnx.cursor(buffered=True)

    self.cnx.close()
    # TODO: return cursor result
    return cursor