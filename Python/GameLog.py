import pandas as pd 
import numpy as np 
import json
import pymysql
import sqlalchemy
from sqlalchemy import create_engine
import requests
import logging
import datetime
from datetime import date
from datetime import datetime

logging.basicConfig(filename='/Users/michaelwalsh/Desktop/NHL DB/GameLog/GameLog.log', level=(logging.INFO), filemode='w', force=True)
logging.info(datetime.now())

# Get params
with open('/Users/michaelwalsh/Desktop/NHL DB/NHLParams.json') as f:
    params = json.load(f)

# Make API request
response = requests.get(params['baseURL'] + 'schedule?season=' + params['thisyear'])
if response.status_code != 200:
    logging.info('Request failed')
sched = response.json()

# Create df
try:
    df = pd.DataFrame(sched['dates'])
    df = df.explode('games')
    df = json.loads(df.to_json(orient='records'))
    df = pd.json_normalize(df)
    df = df[(df['games.gameType'] == 'R')]
    df = df.drop(columns=['events', 'matches'])
    logging.info('GameLog formatting successful')
except:
    logging.warning('Formatting failed')

# Send to staging DB
try:
    cnx = create_engine('mysql+pymysql://MWALSH:Bruins12!@localhost/NHLStaging')
    eng = cnx.connect()
    trunc = sqlalchemy.text('TRUNCATE TABLE NHLStaging.GameLog')
    eng.execution_options(autocommit=True).execute(trunc)
    df.to_sql(con=cnx, name='GameLog', index=False, if_exists='append')
    logging.info('GameLog load to SQL was successful')
except:
    logging.warning('Load failed')