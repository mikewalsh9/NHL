CREATE TEMPORARY TABLE NHL.PlayersGameLog
SELECT s.*
FROM NHLStaging.NHLGameLogStats s
JOIN NHL.PlayerXRef x
ON x.identifier = s.NHL_ID
JOIN NHL.Players p
ON p.playerid = x.playerid
WHERE p.poscode <> 'G';

CREATE TABLE NHL.NHLPlayerStatsbyGameLog
SELECT CONVERT(NHL_ID, CHAR(40)) AS NHL_ID,
CONVERT(`game.gamePK`, CHAR(40)) AS GamePK,
CONVERT(date, DATE) AS GameDate,
CONVERT(season, CHAR(30)) AS Season,
CONVERT(`stat.timeOnIce`, DOUBLE) AS TimeOnIce,
CONVERT(`stat.evenTimeOnIce`, DOUBLE) AS EvenTimeOnIce,
ROUND(CONVERT(`stat.assists`, DOUBLE), 0) AS Assists,
ROUND(CONVERT(`stat.goals`, DOUBLE), 0) AS Goals,
ROUND(CONVERT(`stat.pim`, DOUBLE), 0) AS PenaltyMinutes,
ROUND(CONVERT(`stat.shots`, DOUBLE), 0) AS Shots,
ROUND(CONVERT(`stat.hits`, DOUBLE), 0) AS Hits,
ROUND(CONVERT(`stat.blocked`, DOUBLE), 0) AS Blocked,
ROUND(CONVERT(`stat.points`, DOUBLE), 0) AS Points,
ROUND(CONVERT(`stat.shifts`, DOUBLE), 0) AS Shifts,
ROUND(CONVERT(`stat.plusMinus`, DOUBLE), 0) AS PlusMinus,
CONVERT(`stat.powerPlayTimeOnIce`, DOUBLE) AS PowerPlayTimeOnIce,
ROUND(CONVERT(`stat.powerPlayGoals`, DOUBLE), 0) AS PowerPlayGoals,
ROUND(CONVERT(`stat.powerPlayPoints`, DOUBLE), 0) AS PowerPlayPoints,
CONVERT(`stat.faceOffPct`, DOUBLE) AS FaceoffPerc,
CONVERT(`stat.shotPct`, DOUBLE) AS ShotPerc,
ROUND(CONVERT(`stat.gameWinningGoals`, DOUBLE), 0) AS GWGoals,
ROUND(CONVERT(`stat.overTimeGoals`, DOUBLE), 0) AS OTGoals,
CONVERT(`stat.shortHandedTimeOnIce`, DOUBLE) AS ShortHandedTimeOnIce,
ROUND(CONVERT(`stat.shortHandedGoals`, DOUBLE), 0) AS ShortHandedGoals,
ROUND(CONVERT(`stat.shortHandedPoints`, DOUBLE), 0) AS ShortHandedPoints,
NOW() AS LastUpdate,
NOW() AS CreateDate
FROM NHL.PlayersGameLog;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY NHL_ID VARCHAR(40) NOT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY GamePK VARCHAR(10) NOT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
ADD PRIMARY KEY (NHL_ID, GamePK);

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY Assists INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY Goals INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY PenaltyMinutes INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY Shots INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY Hits INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY Blocked INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY Points INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY Shifts INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY PlusMinus INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY PowerPlayGoals INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY PowerPlayPoints INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY GWGoals INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY OTGoals INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY ShortHandedGoals INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbyGameLog
MODIFY ShortHandedPoints INT NULL;
