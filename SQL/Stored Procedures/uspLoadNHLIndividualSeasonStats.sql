DELIMITER //
CREATE PROCEDURE uspLoadNHLIndividualSeasonStats()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END;
    START TRANSACTION;
    
    # Create table of non-goalies
    CREATE TEMPORARY TABLE NonGoalies
	SELECT s.*
	FROM NHLStaging.NHLSeasonStats s
	JOIN NHL.PlayerXRef x
	ON x.identifier = s.NHL_ID
	JOIN NHL.Players p
	ON p.playerid = x.playerid
	WHERE p.poscode <> 'G';
    
    ALTER TABLE NonGoalies
    MODIFY season VARCHAR(30) NOT NULL;
    
	ALTER TABLE NonGoalies
    MODIFY NHL_ID VARCHAR(40) NOT NULL;
    
	ALTER TABLE NonGoalies
    ADD PRIMARY KEY (season, NHL_ID);
    
    # IODKU statement here
    INSERT INTO NHL.NHLPlayerStatsbySeason(Season,
		NHL_ID,
        Games,
        TimeOnIce,
        TimeOnIcePerGame,
        EvenTimeOnIce,
        EvenTimeOnIcePerGame,
        Assists,
        Goals,
        PenaltyMinutes,
        Shots,
        Hits,
        Blocked,
        Points,
        Shifts,
        PlusMinus,
        PowerPlayTimeOnIce,
        PowerPlayTimeOnIcePerGame,
        PowerPlayGoals,
        PowerPlayPoints,
        FaceoffPerc,
        ShotPerc,
        GWGoals,
        OTGoals,
        ShortHandedTimeOnIce,
        ShortHandedTimeOnIcePerGame,
        ShortHandedGoals,
        ShortHandedPoints,
        LastUpdate,
        CreateDate
        )
		SELECT
        g.`season`,
        g.`NHL_ID`,
        g.`stat.games`,
        CONVERT(g.`stat.timeOnIce`, DOUBLE),
        CONVERT(g.`stat.timeOnIcePerGame`, DOUBLE),
        CONVERT(g.`stat.evenTimeOnIce`, DOUBLE),
        CONVERT(g.`stat.evenTimeOnIcePerGame`, DOUBLE),
        g.`stat.assists`,
        g.`stat.goals`,
        g.`stat.pim`,
        g.`stat.shots`,
        g.`stat.hits`,
        g.`stat.blocked`,
        g.`stat.points`,
        g.`stat.shifts`,
        g.`stat.plusMinus`,
        CONVERT(g.`stat.powerPlayTimeOnIce`, DOUBLE),
        CONVERT(g.`stat.powerPlayTimeOnIcePerGame`, DOUBLE),
        g.`stat.powerPlayGoals`,
        g.`stat.powerPlayPoints`,
        g.`stat.faceOffPct` / 100,
        g.`stat.shotPct` / 100,
        g.`stat.gameWinningGoals`,
        g.`stat.overTimeGoals`,
        CONVERT(g.`stat.shortHandedTimeOnIce`, DOUBLE),
        CONVERT(g.`stat.shortHandedTimeOnIcePerGame`, DOUBLE),
        g.`stat.shortHandedGoals`,
        g.`stat.shortHandedPoints`,
        NOW(),
        NOW()
		FROM NonGoalies g
	ON DUPLICATE KEY
		UPDATE
        Games = g.`stat.games`,
        TimeOnIce = CONVERT(g.`stat.timeOnIce`, DOUBLE),
        TimeOnIcePerGame = CONVERT(g.`stat.timeOnIcePerGame`, DOUBLE),
        EvenTimeOnIce = CONVERT(g.`stat.evenTimeOnIce`, DOUBLE),
        EvenTimeOnIcePerGame = CONVERT(g.`stat.evenTimeOnIcePerGame`, DOUBLE),
        Assists = g.`stat.assists`,
        Goals = g.`stat.goals`,
        PenaltyMinutes = g.`stat.pim`,
        Shots = g.`stat.shots`,
        Hits = g.`stat.hits`,
        Blocked = g.`stat.blocked`,
        Points = g.`stat.points`,
        Shifts = g.`stat.shifts`,
        PlusMinus = g.`stat.plusMinus`,
        PowerPlayTimeOnIce = CONVERT(g.`stat.powerPlayTimeOnIce`, DOUBLE),
        PowerPlayTimeOnIcePerGame = CONVERT(g.`stat.powerPlayTimeOnIcePerGame`, DOUBLE),
        PowerPlayGoals = g.`stat.powerPlayGoals`,
        PowerPlayPoints = g.`stat.powerPlayPoints`,
        FaceoffPerc = g.`stat.faceOffPct` / 100,
        ShotPerc = g.`stat.shotPct` / 100,
        GWGoals = g.`stat.gameWinningGoals`,
        OTGoals = g.`stat.overTimeGoals`,
        ShortHandedTimeOnIce = CONVERT(g.`stat.shortHandedTimeOnIce`, DOUBLE),
        ShortHandedTimeOnIcePerGame = CONVERT(g.`stat.shortHandedTimeOnIcePerGame`, DOUBLE),
        ShortHandedGoals = g.`stat.shortHandedGoals`,
        ShortHandedPoints = g.`stat.shortHandedPoints`,
        LastUpdate = NOW();
        
	# Create table of goalies
    CREATE TEMPORARY TABLE Goalies
	SELECT s.*
	FROM NHLStaging.NHLSeasonStats s
	JOIN NHL.PlayerXRef x
	ON x.identifier = s.NHL_ID
	JOIN NHL.Players p
	ON p.playerid = x.playerid
	WHERE p.poscode = 'G';
    
	ALTER TABLE Goalies
    MODIFY season VARCHAR(30) NOT NULL;
    
	ALTER TABLE Goalies
    MODIFY NHL_ID VARCHAR(40) NOT NULL;
    
	ALTER TABLE Goalies
    ADD PRIMARY KEY (season, NHL_ID);
    
    # IODKU statement here
    INSERT INTO NHL.NHLGoalieStatsbySeason(Season,
		NHL_ID,
        Games,
        GamesStarted,
        ShotsAgainst,
        GoalsAgainst,
        TimeOnIce,
        TimeOnIcePerGame,
        Wins,
        Losses,
        `Ties`,
        OT,
        Shutouts,
        Saves,
        PowerPlaySaves,
        PowerPlayShots,
        PowerPlaySavePerc,
        ShortHandedSaves,
        ShortHandedShots,
        ShortHandedSavePerc,
        EvenSaves,
        EvenShots,
        EvenSavePerc,
        SavePerc,
        GoalsAgainstAverage,
        LastUpdate,
        CreateDate)
		SELECT 
        g.`season`,
        g.`NHL_ID`,
        g.`stat.games`,
        g.`stat.gamesStarted`,
        g.`stat.shotsAgainst`,
        g.`stat.goalsAgainst`,
        CONVERT(g.`stat.timeOnIce`, DOUBLE),
        CONVERT(g.`stat.timeOnIcePerGame`, DOUBLE),
        g.`stat.wins`,
        g.`stat.losses`,
        g.`stat.ties`,
        g.`stat.ot`,
        g.`stat.shutouts`,
        g.`stat.saves`,
        g.`stat.powerPlaySaves`,
        g.`stat.powerPlayShots`,
        g.`stat.powerPlaySavePercentage` / 100,
        g.`stat.shortHandedSaves`,
        g.`stat.shortHandedShots`,
        g.`stat.shortHandedSavePercentage` / 100,
        g.`stat.evenSaves`,
        g.`stat.evenShots`,
        g.`stat.evenStrengthSavePercentage` / 100,
        g.`stat.savePercentage`,
        g.`stat.goalAgainstAverage`,
        NOW(),
        NOW()
        FROM Goalies g
	ON DUPLICATE KEY
		UPDATE
		Games = g.`stat.games`,
        GamesStarted = g.`stat.gamesStarted`,
        ShotsAgainst = g.`stat.shotsAgainst`,
        GoalsAgainst = g.`stat.goalsAgainst`,
        TimeOnIce = CONVERT(g.`stat.timeOnIce`, DOUBLE),
        TimeOnIcePerGame = CONVERT(g.`stat.timeOnIcePerGame`, DOUBLE),
        Wins = g.`stat.wins`,
        Losses = g.`stat.losses`,
        `Ties` = g.`stat.ties`,
        OT = g.`stat.ot`,
        Shutouts = g.`stat.shutouts`,
        Saves = g.`stat.saves`,
        PowerPlaySaves = g.`stat.powerPlaySaves`,
        PowerPlayShots = g.`stat.powerPlayShots`,
        PowerPlaySavePerc = g.`stat.powerPlaySavePercentage` / 100,
        ShortHandedSaves = g.`stat.shortHandedSaves`,
        ShortHandedShots = g.`stat.shortHandedShots`,
        ShortHandedSavePerc = g.`stat.shortHandedSavePercentage` / 100,
        EvenSaves = g.`stat.evenSaves`,
        EvenShots = g.`stat.evenShots`,
        EvenSavePerc = g.`stat.evenStrengthSavePercentage` / 100,
        SavePerc = g.`stat.savePercentage`,
        GoalsAgainstAverage = g.`stat.goalAgainstAverage`,
        LastUpdate = NOW();
    
    DROP TEMPORARY TABLE NonGoalies;
    DROP TEMPORARY TABLE Goalies;
    
	COMMIT;
END //