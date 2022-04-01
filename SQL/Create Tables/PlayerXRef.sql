CREATE TABLE NHL.PlayerXRef (
PlayerID VARCHAR(36) NOT NULL,
Identifier varchar(40) NOT NULL,
SourceSystem VARCHAR(40) NOT NULL,
LastUpdate DATETIME,
CreateDate DATETIME
);

ALTER TABLE NHL.PlayerXRef
ADD PRIMARY KEY (PlayerID, Identifier, SourceSystem);