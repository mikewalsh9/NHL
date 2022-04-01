CREATE TABLE NHL.Players
SELECT UUID() AS PlayerID,
CONVERT(firstName, CHAR(80)) AS FirstName,
CONVERT(lastName, CHAR(80)) AS LastName,
CONVERT(birthDate, date) AS BirthDate,
CONVERT(primaryNumber, CHAR(10)) AS JerseyNumber,
CONVERT(currentAge, CHAR(10)) AS Age,
CONVERT(birthCity, CHAR(60)) AS BirthCity,
CONVERT(birthStateProvince, CHAR(60)) AS BirthStateProvince,
CONVERT(birthCountry, CHAR(60)) AS BirthCountry,
CONVERT(height, CHAR(20)) AS Height,
CONVERT(weight, CHAR(20)) AS Weight,
CONVERT(rookie, CHAR(10)) AS IsRookie,
CONVERT(alternateCaptain, CHAR(10)) AS IsAlternateCaptain,
CONVERT(captain, CHAR(10)) AS IsCaptain,
CONVERT(shootsCatches, CHAR(10)) AS ShootsCatches,
CONVERT(`currentTeam.id`, CHAR(10)) AS CurrentTeamID,
CONVERT(`currentTeam.name`, CHAR(60)) AS CurrentTeamName,
CONVERT(`primaryPosition.code`, CHAR(10)) AS PosCode,
NOW() AS LastUpdate,
NOW() AS CreateDate
FROM NHLStaging.Players;

ALTER TABLE NHL.Players
MODIFY PlayerID VARCHAR(36) NOT NULL;

ALTER TABLE NHL.Players
ADD PRIMARY KEY (PlayerID);

ALTER TABLE NHL.Players
ADD FOREIGN KEY (CurrentTeamID) REFERENCES Teams(TeamID);

ALTER TABLE NHL.Players
ADD FOREIGN KEY (PosCode) REFERENCES Positions(PosCode);

ALTER TABLE NHL.Players
MODIFY JerseyNumber INT NULL;

ALTER TABLE NHL.Players
MODIFY Age INT NULL;

ALTER TABLE NHL.Players
MODIFY Weight INT NULL;

ALTER TABLE NHL.Players
MODIFY IsRookie INT NULL;

ALTER TABLE NHL.Players
MODIFY IsCaptain INT NULL;

ALTER TABLE NHL.Players
MODIFY IsAlternateCaptain INT NULL;