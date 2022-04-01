# NHL
This is a mini NHL database that pulls from the NHLStatsAPI. Some of the tables were created in a one-off fashion, while others are updated every day. 

The Python scripts that are run daily are GameLog.py, Players.py, NHLTeamSeasonStats.py, NHLPlayerSeasonStats.py, and NHLPlayerGameLogStats.py. Each Python script is associated with a stored procedure in the SQL folder. These scripts / sprocs are run at 12:00am.

As of now, the NHLStatsAPI is the only data source being used in this database. When I find the time, I'd like to start loading in data from other sites / APIs as well. 
