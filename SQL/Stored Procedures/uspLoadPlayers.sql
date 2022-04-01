DELIMITER //
CREATE PROCEDURE uspLoadPlayers()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END;
    START TRANSACTION;
    
    # Get all guys we have in the DB and update them in Players
    CREATE TEMPORARY TABLE GuysWeHave
    SELECT x.PlayerID, p.*
    FROM NHLStaging.Players p
    JOIN NHL.PlayerXRef x
    ON p.id = x.identifier
    WHERE SourceSystem = 'NHL';
    
    UPDATE NHL.Players p
    JOIN GuysWeHave g
    ON (p.PlayerID = g.PlayerID)
    SET p.FirstName = g.`firstName`,
        p.LastName = g.`lastName`,
        p.BirthDate = g.`birthDate`,
        p.JerseyNumber = g.`primaryNumber`,
        p.Age = g.`currentAge`,
        p.BirthCity = g.`birthCity`,
        p.BirthStateProvince = g.`birthStateProvince`,
        p.BirthCountry = g.`birthStateProvince`,
        p.Height = g.`height`,
        p.Weight = g.`weight`,
        p.IsRookie = g.`rookie`,
        p.IsAlternateCaptain = g.`alternateCaptain`,
        p.IsCaptain = g.`captain`,
        p.ShootsCatches = g.`shootsCatches`,
        p.CurrentTeamID = g.`currentTeam.id`,
        p.CurrentTeamName = g.`currentTeam.name`,
        p.PosCode = g.`primaryPosition.code`,
        p.LastUpdate = NOW();
	
    # Get all guys we DON'T have in the DB, give them UUID's, and insert them into PlayerXRef
    CREATE TEMPORARY TABLE DontHave
    SELECT *
    FROM NHLStaging.Players
    WHERE id NOT IN (SELECT Identifier FROM PlayerXRef WHERE SourceSystem = 'NHL');
    
    INSERT INTO NHL.PlayerXRef(PlayerID,
		Identifier,
        SourceSystem,
        LastUpdate,
        CreateDate)
        SELECT UUID(),
        id,
        'NHL',
        NOW(),
        NOW()
        FROM DontHave;
	
    # Get all guys we just inserted into PlayerXRef and insert them into Players
    CREATE TEMPORARY TABLE LastInsert
    SELECT x.PlayerID, d.*
    FROM NHL.PlayerXRef x
    JOIN DontHave d
    ON x.Identifier = d.id
    WHERE x.SourceSystem = 'NHL';
    
	INSERT INTO NHL.Players(PlayerID,
		FirstName,
        LastName,
        BirthDate,
        JerseyNumber,
        Age,
        BirthCity,
        BirthStateProvince,
        BirthCountry,
        Height,
        Weight,
        IsRookie,
        IsAlternateCaptain,
        IsCaptain,
        ShootsCatches,
        CurrentTeamID,
        CurrentTeamName,
        PosCode,
        LastUpdate,
        CreateDate)
		SELECT g.`PlayerID`,
		g.`firstName`,
        g.`lastName`,
        g.`birthDate`,
        g.`primaryNumber`,
        g.`currentAge`,
        g.`birthCity`,
        g.`birthStateProvince`,
        g.`birthCountry`,
        g.`height`,
        g.`weight`,
        g.`rookie`,
        g.`alternateCaptain`,
        g.`captain`,
        g.`shootsCatches`,
        g.`currentTeam.id`,
        g.`currentTeam.name`,
        g.`primaryPosition.code`,
        NOW(),
        NOW()
        FROM LastInsert g;
        
        DROP TEMPORARY TABLE GuysWeHave;
        DROP TEMPORARY TABLE DontHave;
        DROP TEMPORARY TABLE LastInsert;
        
	COMMIT;
END //
    