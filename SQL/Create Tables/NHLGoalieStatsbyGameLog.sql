CREATE TEMPORARY TABLE NHL.GoaliesGameLog
SELECT s.*
FROM NHLStaging.NHLGameLogStats s
JOIN NHL.PlayerXRef x
ON x.identifier = s.NHL_ID
JOIN NHL.Players p
ON p.playerid = x.playerid
WHERE p.poscode = 'G';

CREATE TABLE NHL.NHLGoalieStatsbyGameLog
SELECT CONVERT(NHL_ID, CHAR(40)) AS NHL_ID,
CONVERT(`game.gamePK`, CHAR(40)) AS GamePK,
CONVERT(date, DATE) AS GameDate,
CONVERT(season, CHAR(30)) AS Season,
CONVERT(`stat.timeOnIce`, DOUBLE) AS TimeOnIce,
ROUND(CONVERT(`stat.shotsAgainst`, DOUBLE), 0) AS ShotsAgainst,
ROUND(CONVERT(`stat.goalsAgainst`, DOUBLE), 0) AS GoalsAgainst,
CONVERT(`stat.decision`, CHAR(10)) AS Decision,
ROUND(CONVERT(`stat.shutouts`, DOUBLE), 0) AS Shutout,
ROUND(CONVERT(`stat.saves`, DOUBLE), 0) AS Saves,
ROUND(CONVERT(`stat.powerPlaySaves`, DOUBLE), 0) AS PowerPlaySaves,
ROUND(CONVERT(`stat.powerPlayShots`, DOUBLE), 0) AS PowerPlayShots,
CONVERT(`stat.powerPlaySavePercentage`, DOUBLE) AS PowerPlaySavePerc,
ROUND(CONVERT(`stat.shortHandedSaves`, DOUBLE), 0) AS ShortHandedSaves,
ROUND(CONVERT(`stat.shortHandedShots`, DOUBLE), 0) AS ShortHandedShots,
CONVERT(`stat.shortHandedSavePercentage`, DOUBLE) AS ShortHandedSavePerc,
ROUND(CONVERT(`stat.evenSaves`, DOUBLE), 0) AS EvenSaves,
ROUND(CONVERT(`stat.evenShots`, DOUBLE), 0) AS EvenShots,
CONVERT(`stat.evenStrengthSavePercentage`, DOUBLE) AS EvenSavePerc,
CONVERT(`stat.savePercentage`, DOUBLE) AS SavePerc,
NOW() AS LastUpdate,
NOW() AS CreateDate
FROM NHL.GoaliesGameLog;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY NHL_ID VARCHAR(40) NOT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY GamePK VARCHAR(10) NOT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
ADD PRIMARY KEY (NHL_ID, GamePK);

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY ShotsAgainst INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY GoalsAgainst INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY Decision INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY Shutout INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY Saves INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY PowerPlaySaves INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY PowerPlayShots INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY ShortHandedSaves INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY ShortHandedShots INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY EvenSaves INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbyGameLog
MODIFY EvenShots INT NULL;