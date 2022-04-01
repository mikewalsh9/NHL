CREATE TABLE NHL.NHLTeamStatsbySeason
SELECT CONVERT(`season`, CHAR(40)) Season,
CONVERT(`team.id`, CHAR(10)) TeamID,
ROUND(CONVERT(`stat.gamesPlayed`, DOUBLE), 0) AS GamesPlayed,
ROUND(CONVERT(`stat.wins`, DOUBLE), 0) AS Wins,
ROUND(CONVERT(`stat.losses`, DOUBLE), 0) AS Losses,
ROUND(CONVERT(`stat.ot`, DOUBLE), 0) AS OT,
ROUND(CONVERT(`stat.pts`, DOUBLE), 0) AS Points,
CONVERT(`stat.ptPctg`, DOUBLE) AS PointsPerc,
CONVERT(`stat.goalsPerGame`, DOUBLE) AS GoalsPerGame,
CONVERT(`stat.goalsAgainstPerGame`, DOUBLE) AS GoalsAgainstPerGame,
CONVERT(`stat.evGGARatio`, DOUBLE) AS EvGFGARatio,
CONVERT(`stat.PowerPlayPercentage`, DOUBLE) AS PowerPlayPerc,
ROUND(CONVERT(`stat.powerPlayGoals`, DOUBLE), 0) AS PowerPlayGoals,
ROUND(CONVERT(`stat.powerPlayGoalsAgainst`, DOUBLE), 0) AS PowerPlayGoalsAgainst,
ROUND(CONVERT(`stat.powerPlayOpportunities`, DOUBLE), 0) AS PowerPlayOpportunities,
CONVERT(`stat.penaltyKillPercentage`, DOUBLE) AS PenaltyKillPerc,
CONVERT(`stat.shotsPerGame`, DOUBLE) AS ShotsPerGame,
CONVERT(`stat.shotsAllowed`, DOUBLE) AS ShotsAllowedPerGame,
CONVERT(`stat.winScoreFirst`, DOUBLE) AS WinPercWhenScoringFirst,
CONVERT(`stat.winOppScoreFirst`, DOUBLE) AS WinPercWhenOppScoringFirst,
CONVERT(`stat.winLeadFirstPer`, DOUBLE) AS WinPercWhenLeadingFirstPer,
CONVERT(`stat.winLeadSecondPer`, DOUBLE) AS WinPercWhenLeadingSecondPer,
CONVERT(`stat.winOutshootOpp`, DOUBLE) AS WinPercWhenOutshootingOpp,
CONVERT(`stat.winOutshotbyOpp`, DOUBLE) AS WinPercWhenOutshotByOpp,
ROUND(CONVERT(`stat.faceOffsTaken`, DOUBLE), 0) AS FaceoffsTaken,
ROUND(CONVERT(`stat.faceOffsWon`, DOUBLE), 0) AS FaceoffsWon,
ROUND(CONVERT(`stat.faceOffsLost`, DOUBLE), 0) AS FaceoffsLost,
CONVERT(`stat.faceOffWinPercentage`, DOUBLE) AS FaceoffWinPerc,
CONVERT(`stat.shootingPctg`, DOUBLE) AS ShootingPerc,
CONVERT(`stat.savePctg`, DOUBLE) AS SavePerc,
NOW() AS LastUpdate,
NOW() AS CreateDate
FROM NHLStaging.NHLTeamStats;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY Season VARCHAR(40) NOT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY TeamID VARCHAR(10) NOT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
ADD PRIMARY KEY (Season, TeamID);

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY GamesPlayed INT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY Wins INT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY Losses INT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY OT INT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY Points INT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY PowerPlayGoals INT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY PowerPlayGoalsAgainst INT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY PowerPlayOpportunities INT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY FaceoffsTaken INT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY FaceoffsWon INT NULL;

ALTER TABLE NHL.NHLTeamStatsbySeason
MODIFY FaceoffsLost INT NULL;
