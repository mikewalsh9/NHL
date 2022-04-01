CREATE TABLE NHL.Divisions
SELECT CONVERT(id, CHAR(10)) AS DivisionID,
CONVERT(name, CHAR(40)) AS DivisionName,
CONVERT(`conference.id`, CHAR(10)) AS ConfID
FROM NHLStaging.Divisions;

ALTER TABLE NHL.Divisions 
MODIFY DivisionID VARCHAR(10) NOT NULL;

ALTER TABLE NHL.Divisions
ADD PRIMARY KEY (DivisionID);

ALTER TABLE NHL.Divisions
ADD FOREIGN KEY (ConfID) REFERENCES Conferences(ConfID);