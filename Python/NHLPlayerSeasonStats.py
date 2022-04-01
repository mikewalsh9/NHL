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

logging.basicConfig(filename='/Users/michaelwalsh/Desktop/NHL DB/NHLPlayerStatsbySeason/NHLPlayerStatsbySeason.log', level=(logging.INFO), filemode='w', force=True)
logging.info(datetime.now())

# Read in params json
with open('/Users/michaelwalsh/Desktop/NHL DB/NHLParams.json') as f:
   params = json.load(f)

# Create connection to SQL and get list of playerid's
try :
   cnx = create_engine('mysql+pymysql://MWALSH:Bruins12!@localhost/NHL')
   sql = """
   SELECT DISTINCT Identifier
   FROM PlayerXRef
   WHERE SourceSystem = 'NHL'
   """
   playerids = pd.read_sql_query(sql, cnx)
   playerids = playerids['Identifier'].to_list()
except :
   logging.warning('Failed getting NHL IDs from MySQL')

# Iterate through playerid's to get each player's stats
try :
   df = pd.DataFrame()
   for id in playerids :
      r = requests.get(params['baseURL'] + 'people/' + str(id) + '/stats?stats=statsSingleSeason&season=' + params['thisyear'])
      if r.status_code != 200 :
         logging.warning('Issue with ' + id)
      stats = r.json()
      splits = stats['stats'][0]['splits']
      tempdf = pd.DataFrame(splits)
      tempdf['NHL_ID'] = id
      df = pd.concat([df, tempdf])

   df = json.loads(df.to_json(orient = 'records'))
   df = pd.json_normalize(df)
   logging.info('NHLPlayerSeasonStats formatting successful')
except :
   logging.warning('Formatting failed')

# Create connection and send to Staging DB
try :
   staging_cnx = create_engine('mysql+pymysql://MWALSH:Bruins12!@localhost/NHLStaging')
   eng = staging_cnx.connect()
   trunc = sqlalchemy.text('TRUNCATE TABLE NHLStaging.NHLSeasonStats')
   eng.execution_options(autocommit=True).execute(trunc)
   df.to_sql(con = staging_cnx, name = 'NHLSeasonStats', index = False, if_exists = 'append')
   logging.info('NHLPlayerSeasonStats load to SQL was successful')
except :
   logging.warning('Load failed')