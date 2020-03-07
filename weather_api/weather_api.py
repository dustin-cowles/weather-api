from datetime import datetime, timedelta
import logging
import random
import requests

from flask import Flask, request
import sqlite3

# I would normally wrap everything here classes and not use so many globals,
# but this is just a quick and dirty API handler.


APP = Flask(__name__)
DB_FILE = "weather_cache.db"


class db_conn(object):
    """
    A simple class for abstracting sqlite queries.
    """
    CREATE_TABLE_CMD = """CREATE TABLE IF NOT EXISTS weather (
                          temperature float NOT NULL,
                          time timestamp
                          );"""
    GET_LATEST_TEMP = """SELECT temperature, time FROM weather
                         ORDER BY time DESC
                         LIMIT 1"""
    ADD_TEMP = """INSERT INTO weather values (?, ?);"""

    def __init__(self, db_file=DB_FILE):
        try:
            self.conn = sqlite3.connect(db_file,
                                        detect_types=sqlite3.PARSE_DECLTYPES |
                                                     sqlite3.PARSE_COLNAMES)
            self._execute(self.CREATE_TABLE_CMD)
        except Exception as e:
            APP.logger.error("sqlite connection error: %s" % e)
            raise

    def _execute(self, cmd, args=None):
        APP.logger.debug("Executing query: %s, args: %s" % (cmd, args))
        # the sqlite library does not like a NoneType arg being passed so this
        # strips them if present
        query = (i for i in [cmd, args] if i is not None)
        try:
            cursor = self.conn.cursor()
            result = cursor.execute(*query)
            self.conn.commit()
            return result
        except Exception as e:
            APP.logger.error("sqlite query error: %s" % e)
            raise

    def get_latest_temp(self):
        result = self._execute(self.GET_LATEST_TEMP).fetchone()
        # APP.logger.debug("Query Result: %s" % result)
        return result

    def insert_temp(self, temp, time):
        APP.logger.debug("Inserting temp: %s, time: %s" % (temp, time))
        self._execute(self.ADD_TEMP, (temp, time))


# tries to get metaweather.com forecast for the requested location
# default location is Portland, OR
def get_metaweather(location="2475687"):
    uri = "https://www.metaweather.com/api/location/" + str(location)
    APP.logger.debug("Getting external weather: %s" % uri)
    response = requests.get(uri).json()
    try:
        # I am not sure what goes into creating this `predictability` score
        # but the higher the number, the more likely to be accurate according
        # to the API provider.
        temp = sorted(response["consolidated_weather"],
                      key=lambda k: k['predictability'])[-1]["the_temp"]
        time = datetime.utcnow()
    except Exception:
        APP.logger.debug("Failed to parse weather response: %s" % response)
        raise
    return temp, time


# simple method to get weather data
def get_temp():
    conn = db_conn(DB_FILE)
    result = conn.get_latest_temp()
    temp = None
    # I could probably do most/all of this in SQL but I'm not that good at SQL
    if result is not None:
        APP.logger.debug("Cache result found, checking age")
        if datetime.utcnow() - result[1] < timedelta(minutes=5):
            APP.logger.debug("Using cached temperature")
            temp = result[0]
    if temp is None:
        APP.logger.debug("Using new temperature")
        APP.logger.debug("Generating random temperature")
        temp, time = get_metaweather()
        conn.insert_temp(temp, time)
    return temp


@APP.route("/temperature", methods=["GET"])
def temperature():
    APP.logger.debug("Entering handler, request: %s" % request)
    response = {"query_time": datetime.now(),
                "temperature": get_temp()}
    APP.logger.debug("Exiting Handler, response: %s" % response)
    return response


if __name__ == "__main__":
    APP.logger.warning("Starting app in debug mode")
    APP.logger.setLevel(logging.DEBUG)
    APP.run(debug=True)
