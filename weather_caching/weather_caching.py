import logging
import random
import time

from flask import Flask, request

APP = Flask(__name__)


# simple method to get randomized weather data this will be expanded/replaced
# later to include real data, caching, and selectable location
def get_temp():
    APP.logger.debug("Generating random temperature")
    return random.randrange(40, 90)


@APP.route("/temperature", methods=["GET"])
def temperature():
    APP.logger.debug("Entering handler, request: %s" % request)
    response = {"query_time": time.time(),
                "temperature": get_temp()}
    APP.logger.debug("Exiting Handler, response: %s" % response)
    return response


if __name__ == "__main__":
    APP.logger.warning("Starting app in debug mode")
    APP.logger.setLevel(logging.DEBUG)
    APP.run(debug=True)
