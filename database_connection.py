from mysql.connector import connect, Error
#import yaml

class DatabaseConnection:
  def run(query):
    try:
      with connect(yaml.open("database.yml")) as connection:
          res = []
          with connection.cursor(dictionary=True) as cursor:
              cursor.execute(query)
              for db in cursor:
                res.append(db)
          return res
    except Error as e:
      raise e