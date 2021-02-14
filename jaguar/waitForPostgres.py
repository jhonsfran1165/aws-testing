import logging
import time
import psycopg2
from decouple import config

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def main():

    database = config('DATABASE')
    user = config('USER_DB')
    password = config('PASSWORD_DB')
    host = config('HOST_DB')
    port = config('PORT_DB')

    exc = None

    for _ in range(5):
        try:
            #establishing the connection
            conn = psycopg2.connect(
                database=database, user=user, password=password, host=host, port=port
            )
        except Exception as e:
            logging.warning(
                "Error connecting to postgres, will retry in 3 sec: {}".format(e))
            time.sleep(3)
            exc = e
        else:
            logging.info("Connected...")
            logging.info("Everything goes well, you're a fu*** pro...")
            break
    else:
        logging.error("Unable to connect to {} DB".format(database))
        raise exc


if __name__ == "__main__":
    main()
