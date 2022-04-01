# NHL
In this repo is code to build a mini NHL database pulling from the NHLStatsAPI. Some of the tables were built in a one-off fashion (mostly reference tables), while others are updated daily. 

The Python scripts that run every day are GameLog.py, Players.py, NHLTeamSeasonStats.py, NHLPlayerSeasonStats.py, and NHLPlayerGameLogStats.py. Each of those 5 Python scripts are associated with a stored procedure in the SQL folder. These scripts / sprocs are run at 12:00am.

As of now, the NHLStatsAPI is the only data source being used in this database. When I find the time, I'd like to start loading in data from other sites / APIs as well. 
