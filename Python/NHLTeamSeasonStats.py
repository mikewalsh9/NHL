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

logging.basicConfig(filename='/Users/michaelwalsh/Desktop/NHL DB/NHLTeamStatsbySeason/NHLTeamStatsbySeason.log', level=(logging.INFO), filemode='w', force=True)
logging.info(datetime.now())

# Read in params json
with open('/Users/michaelwalsh/Desktop/NHL DB/NHLParams.json') as f:
   params = json.load(f)

# Create connection to SQL and get list of teamid's
try :
   cnx = create_engine('mysql+pymysql://MWALSH:Bruins12!@localhost/NHL')
   sql = """
   SELECT TeamID
   FROM Teams
   """
   teamids = pd.read_sql_query(sql, cnx)
   teamids = teamids['TeamID'].to_list()
except :
   logging.warning('Failed getting TeamIDs from MySQL')

# Iterate through teamid's to get each team's stats
try :
   my_list = []
   for id in teamids :
      r = requests.get(params['baseURL'] + 'teams/' + str(id) + '/stats')
      if r.status_code != 200 :
         logging.warning('Issue with ' + id)
      stats = r.json()
      splits = stats['stats'][0]['splits']
      my_list.extend(splits)

   df = pd.DataFrame(my_list)
   df = json.loads(df.to_json(orient = 'records'))
   df = pd.json_normalize(df)
   df['season'] = params['thisyear']
   logging.info('NHLTeamStats formatting successful')
except :
   logging.warning('Formatting failed')

# Create connection and send to Staging DB
try :
   staging_cnx = create_engine('mysql+pymysql://MWALSH:Bruins12!@localhost/NHLStaging')
   eng = cnx.connect()
   trunc = sqlalchemy.text('TRUNCATE TABLE NHLStaging.NHLTeamStats')
   eng.execution_options(autocommit=True).execute(trunc)
   df.to_sql(con = staging_cnx, name = 'NHLTeamStats', index = False, if_exists = 'append')
   logging.info('NHLTeamStats load to SQL was successful')
except :
   logging.warning('Load failed')