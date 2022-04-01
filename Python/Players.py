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

logging.basicConfig(filename='/Users/michaelwalsh/Desktop/NHL DB/Players/Players.log', level=(logging.INFO), filemode='w', force=True)
logging.info(datetime.now())

# Read in params json
with open('/Users/michaelwalsh/Desktop/NHL DB/NHLParams.json') as f:
   params = json.load(f)

# Send request to teams API to get playerid's
response = requests.get(params['baseURL'] + 'teams?expand=team.roster')
if response.status_code != 200:
    logging.info('Request failed')
players = response.json()

# Create table
try :
    df = pd.DataFrame(players['teams'])
    df = df[['roster']]

    df = json.loads(df.to_json(orient = 'records'))
    df = pd.json_normalize(df)

    df = df.explode('roster.roster')
    df = json.loads(df.to_json(orient = 'records'))
    df = pd.json_normalize(df)

    # Send new request to API's to grab more player information
    id_list = df['roster.roster.person.id'].to_list()
    my_list = []

    for id in id_list :
        r = requests.get(params['baseURL'] + 'people/' + str(id))
        if r.status_code != 200 :
            print('Issue with ' + id)
        info = r.json()
        person = info['people']
        my_list.extend(person)

    finaldf = pd.DataFrame(my_list)
    finaldf = json.loads(finaldf.to_json(orient = 'records'))
    finaldf = pd.json_normalize(finaldf)
    logging.info('Players formatting successful')
except :
    logging.warning('Formatting failed')


# Create connection and send to Staging DB
try :
    cnx = create_engine('mysql+pymysql://MWALSH:Bruins12!@localhost/NHLStaging')
    eng = cnx.connect()
    trunc = sqlalchemy.text('TRUNCATE TABLE NHLStaging.Players')
    eng.execution_options(autocommit=True).execute(trunc)
    finaldf.to_sql(con = cnx, name = 'Players', index = False, if_exists = 'append')
    logging.info('Players load to SQL was successful')
except :
    logging.warning('Load failed')