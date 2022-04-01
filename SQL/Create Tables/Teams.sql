CREATE TABLE NHL.Teams
SELECT CONVERT(id, CHAR(10)) AS TeamID,
CONVERT(abbreviation, CHAR(10)) AS TeamAbbrev,
CONVERT(teamName, CHAR(50)) AS TeamNickName,
CONVERT(locationName, CHAR(50)) AS TeamLocation,
CONVERT(officialSiteUrl, CHAR(200)) AS TeamURL,
CONVERT(`division.id`, CHAR(10)) AS DivisionID,
CONVERT(`conference.id`, CHAR(10)) AS ConfID
FROM NHLStaging.Teams;

ALTER TABLE NHL.Teams
MODIFY TeamID VARCHAR(10) NOT NULL;

ALTER TABLE NHL.Teams
ADD PRIMARY KEY (TeamID);

ALTER TABLE NHL.Teams
ADD FOREIGN KEY (DivisionID) REFERENCES Divisions(DivisionID);

ALTER TABLE NHL.Teams
ADD FOREIGN KEY (ConfID) REFERENCES Conferences(ConfID);