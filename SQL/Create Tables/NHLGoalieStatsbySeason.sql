CREATE TEMPORARY TABLE NHL.GoaliesTable
SELECT s.*
FROM NHLStaging.NHLSeasonStats s
JOIN NHL.PlayerXRef x
ON x.identifier = s.NHL_ID
JOIN NHL.Players p
ON p.playerid = x.playerid
WHERE p.poscode = 'G';

CREATE TABLE NHL.NHLGoalieStatsbySeason
SELECT CONVERT(season, CHAR(30)) AS Season,
CONVERT(NHL_ID, CHAR(40)) AS NHL_ID,
ROUND(CONVERT(`stat.games`, DOUBLE), 0) AS Games,
ROUND(CONVERT(`stat.gamesStarted`, DOUBLE), 0) AS GamesStarted,
ROUND(CONVERT(`stat.shotsAgainst`, DOUBLE), 0) AS ShotsAgainst,
ROUND(CONVERT(`stat.goalsAgainst`, DOUBLE), 0) AS GoalsAgainst,
CONVERT(`stat.timeOnIce`, DOUBLE) AS TimeOnIce,
CONVERT(`stat.timeOnIcePerGame`, DOUBLE) AS TimeOnIcePerGame,
ROUND(CONVERT(`stat.wins`, DOUBLE), 0) AS Wins,
ROUND(CONVERT(`stat.losses`, DOUBLE), 0) AS Losses,
ROUND(CONVERT(`stat.ties`, DOUBLE), 0) AS Ties,
ROUND(CONVERT(`stat.ot`, DOUBLE), 0) AS OT,
ROUND(CONVERT(`stat.shutouts`, DOUBLE), 0) AS Shutouts,
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
CONVERT(`stat.goalAgainstAverage`, DOUBLE) AS GoalsAgainstAverage,
NOW() AS LastUpdate,
NOW() AS CreateDate
FROM NHL.GoaliesTable;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY Season VARCHAR(30) NOT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY NHL_ID VARCHAR(40) NOT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
ADD PRIMARY KEY (Season, NHL_ID);

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY Games INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY GamesStarted INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY Wins INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY Losses INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY Ties INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY OT INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY ShotsAgainst INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY GoalsAgainst INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY Shutouts INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY Saves INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY PowerPlaySaves INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY PowerPlayShots INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY ShortHandedSaves INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY ShortHandedShots INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY EvenSaves INT NULL;

ALTER TABLE NHL.NHLGoalieStatsbySeason
MODIFY EvenShots INT NULL;
