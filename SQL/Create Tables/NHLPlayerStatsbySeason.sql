CREATE TEMPORARY TABLE NHL.PlayersTable
SELECT s.*
FROM NHLStaging.NHLSeasonStats s
JOIN NHL.PlayerXRef x
ON x.identifier = s.NHL_ID
JOIN NHL.Players p
ON p.playerid = x.playerid
WHERE p.poscode <> 'G';

CREATE TABLE NHL.NHLPlayerStatsbySeason
SELECT CONVERT(season, CHAR(30)) AS Season,
CONVERT(NHL_ID, CHAR(40)) AS NHL_ID,
ROUND(CONVERT(`stat.games`, DOUBLE), 0) AS Games,
CONVERT(`stat.timeOnIce`, DOUBLE) AS TimeOnIce,
CONVERT(`stat.timeOnIcePerGame`, DOUBLE) AS TimeOnIcePerGame,
CONVERT(`stat.evenTimeOnIce`, DOUBLE) AS EvenTimeOnIce,
CONVERT(`stat.evenTimeOnIcePerGame`, DOUBLE) AS EvenTimeOnIcePerGame,
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
CONVERT(`stat.powerPlayTimeOnIce`, DOUBLE) AS PowerPlayTimeOnIcePerGame,
ROUND(CONVERT(`stat.powerPlayGoals`, DOUBLE), 0) AS PowerPlayGoals,
ROUND(CONVERT(`stat.powerPlayPoints`, DOUBLE), 0) AS PowerPlayPoints,
CONVERT(`stat.faceOffPct`, DOUBLE) AS FaceoffPerc,
CONVERT(`stat.shotPct`, DOUBLE) AS ShotPerc,
ROUND(CONVERT(`stat.gameWinningGoals`, DOUBLE), 0) AS GWGoals,
ROUND(CONVERT(`stat.overTimeGoals`, DOUBLE), 0) AS OTGoals,
CONVERT(`stat.shortHandedTimeOnIce`, DOUBLE) AS ShortHandedTimeOnIce,
CONVERT(`stat.shortHandedTimeOnIcePerGame`, DOUBLE) AS ShortHandedTimeOnIcePerGame,
ROUND(CONVERT(`stat.shortHandedGoals`, DOUBLE), 0) AS ShortHandedGoals,
ROUND(CONVERT(`stat.shortHandedPoints`, DOUBLE), 0) AS ShortHandedPoints,
NOW() AS LastUpdate,
NOW() AS CreateDate
FROM NHL.PlayersTable;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY Season VARCHAR(30) NOT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY NHL_ID VARCHAR(40) NOT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
ADD PRIMARY KEY (Season, NHL_ID);

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY Games INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY Assists INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY Goals INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY PenaltyMinutes INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY Shots INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY Hits INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY Blocked INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY Points INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY Shifts INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY PlusMinus INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY PowerPlayGoals INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY PowerPlayPoints INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY GWGoals INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY OTGoals INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY ShortHandedGoals INT NULL;

ALTER TABLE NHL.NHLPlayerStatsbySeason
MODIFY ShortHandedPoints INT NULL;
