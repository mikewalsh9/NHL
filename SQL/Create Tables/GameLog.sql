CREATE TABLE NHL.GameLog
SELECT CONVERT(`games.gamePk`, CHAR(40)) AS GamePK,
CONVERT(date, DATE) AS GameDate,
CONVERT(`games.teams.home.team.name`, CHAR(70)) AS HomeTeamName,
CONVERT(`games.teams.home.team.id`, CHAR(10)) AS HomeTeamID,
CONVERT(`games.teams.home.score`, CHAR(10)) AS HomeTeamScore,
CONVERT(`games.teams.away.team.name`, CHAR(70)) AS AwayTeamName,
CONVERT(`games.teams.away.team.id`, CHAR(10)) AS AwayTeamID,
CONVERT(`games.teams.away.score`, CHAR(10)) AS AwayTeamScore,
CONVERT(`games.status.abstractGameState`, CHAR(20)) AS GameStatus,
NOW() AS LastUpdate,
NOW() AS CreateDate
FROM NHLStaging.GameLog;

ALTER TABLE NHL.GameLog
MODIFY GamePK VARCHAR(10) NOT NULL;

ALTER TABLE NHL.GameLog
ADD PRIMARY KEY (GamePK);

ALTER TABLE NHL.GameLog
ADD FOREIGN KEY (HomeTeamID) REFERENCES Teams(TeamID);

ALTER TABLE NHL.GameLog
ADD FOREIGN KEY (AwayTeamID) REFERENCES Teams(TeamID);

ALTER TABLE NHL.GameLog
MODIFY HomeTeamScore INT NULL;

ALTER TABLE NHL.GameLog
MODIFY AwayTeamScore INT NULL;