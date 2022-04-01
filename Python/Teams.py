import pandas as pd
import numpy as np
import json
import pymysql
import sqlalchemy
from sqlalchemy import create_engine
import requests

# Read in params json
with open('/Users/michaelwalsh/Desktop/NHL API/NHLParams.json') as f:
   params = json.load(f)

# Send request to API
response = requests.get(params['baseURL'] + 'teams')
teams = response.json()

# Create table
df = pd.DataFrame(teams['teams'])
df = json.loads(df.to_json(orient = 'records'))
df = pd.json_normalize(df)

# Create connection and send to Staging DB
cnx = create_engine('mysql+pymysql://MWALSH:Bruins12!@localhost/NHLStaging')
df.to_sql(con = cnx, name = 'Teams', index = False)
