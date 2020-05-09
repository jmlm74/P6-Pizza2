# Created by jmlm at 30/03/2020-22:29 - testP5
from pathlib import Path

from prompt_toolkit.styles import style_from_dict
from pygments.token import Token

# the curent path
BASEDIR = Path(__file__).resolve().parent


# DATABASE
DATABASE_TYPE = 'postgresql'
# DATABASE-TYPE = 'mysql'
# DATABASE-TYPE = 'none'

DBHOST = '192.168.1.99'  # Database host (may be localhost)
DBUSER = 'jmlm'
DBPW = 'jmlm'
DBNAME = 'P6_DB'

