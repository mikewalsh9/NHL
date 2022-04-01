DELIMITER //
CREATE PROCEDURE uspLoadNHLIndividualGameLogStats()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END;
    START TRANSACTION;
    
    # Create table of non-goalies
    CREATE TEMPORARY TABLE NonGoaliesGL
	SELECT s.*
	FROM NHLStaging.NHLGameLogStats s
	JOIN NHL.PlayerXRef x
	ON x.identifier = s.NHL_ID
	JOIN NHL.Players p
	ON p.playerid = x.playerid
	WHERE p.poscode <> 'G';
    
    ALTER TABLE NonGoaliesGL
    MODIFY NHL_ID VARCHAR(40) NOT NULL;
    
	ALTER TABLE NonGoaliesGL
    MODIFY `game.gamePk` VARCHAR(10) NOT NULL;
    
	ALTER TABLE NonGoaliesGL
    ADD PRIMARY KEY (NHL_ID, `game.gamePk`);
    
    # IODKU statement here
    INSERT INTO NHL.NHLPlayerStatsbyGameLog(NHL_ID,
        GamePK,
        GameDate,
        Season,
        TimeOnIce,
        EvenTimeOnIce,
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
        PowerPlayGoals,
        PowerPlayPoints,
        FaceoffPerc,
        ShotPerc,
        GWGoals,
        OTGoals,
        ShortHandedTimeOnIce,
        ShortHandedGoals,
        ShortHandedPoints,
        LastUpdate,
        CreateDate
        )
		SELECT
        g.`NHL_ID`,
        g.`game.gamePk`,
        g.`date`,
        g.`season`,
        CONVERT(g.`stat.timeOnIce`, DOUBLE),
        CONVERT(g.`stat.evenTimeOnIce`, DOUBLE),
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
        g.`stat.powerPlayGoals`,
        g.`stat.powerPlayPoints`,
        g.`stat.faceOffPct` / 100,
        g.`stat.shotPct` / 100,
        g.`stat.gameWinningGoals`,
        g.`stat.overTimeGoals`,
        CONVERT(g.`stat.shortHandedTimeOnIce`, DOUBLE),
        g.`stat.shortHandedGoals`,
        g.`stat.shortHandedPoints`,
        NOW(),
        NOW()
		FROM NonGoaliesGL g
	ON DUPLICATE KEY
		UPDATE
        GameDate = g.`date`,
        Season = g.`season`,
        TimeOnIce = CONVERT(g.`stat.timeOnIce`, DOUBLE),
        EvenTimeOnIce = CONVERT(g.`stat.evenTimeOnIce`, DOUBLE),
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
        PowerPlayGoals = g.`stat.powerPlayGoals`,
        PowerPlayPoints = g.`stat.powerPlayPoints`,
        FaceoffPerc = g.`stat.faceOffPct` / 100,
        ShotPerc = g.`stat.shotPct` / 100,
        GWGoals = g.`stat.gameWinningGoals`,
        OTGoals = g.`stat.overTimeGoals`,
        ShortHandedTimeOnIce = CONVERT(g.`stat.shortHandedTimeOnIce`, DOUBLE),
        ShortHandedGoals = g.`stat.shortHandedGoals`,
        ShortHandedPoints = g.`stat.shortHandedPoints`,
        LastUpdate = NOW();
        
	# Create table of goalies
    CREATE TEMPORARY TABLE GoaliesGL
	SELECT s.*
	FROM NHLStaging.NHLGameLogStats s
	JOIN NHL.PlayerXRef x
	ON x.identifier = s.NHL_ID
	JOIN NHL.Players p
	ON p.playerid = x.playerid
	WHERE p.poscode = 'G';
    
	ALTER TABLE GoaliesGL
    MODIFY NHL_ID VARCHAR(40) NOT NULL;
    
	ALTER TABLE GoaliesGL
    MODIFY `game.gamePk` VARCHAR(10) NOT NULL;
    
	ALTER TABLE GoaliesGL
    ADD PRIMARY KEY (NHL_ID, `game.gamePk`);
    
    # IODKU statement here
    INSERT INTO NHL.NHLGoalieStatsbyGameLog(NHL_ID,
        GamePK,
        GameDate,
        Season,
        TimeOnIce,
        ShotsAgainst,
        GoalsAgainst,
        Decision,
        Shutout,
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
        LastUpdate,
        CreateDate)
		SELECT 
        g.`NHL_ID`,
        g.`game.gamePk`,
        g.`date`,
        g.`season`,
		CONVERT(g.`stat.timeOnIce`, DOUBLE),
        g.`stat.shotsAgainst`,
        g.`stat.goalsAgainst`,
        g.`stat.decision`,
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
        NOW(),
        NOW()
        FROM GoaliesGL g
	ON DUPLICATE KEY
		UPDATE
		GameDate = g.`date`,
        Season = g.`season`,
		TimeOnIce = CONVERT(g.`stat.timeOnIce`, DOUBLE),
        ShotsAgainst = g.`stat.shotsAgainst`,
        GoalsAgainst = g.`stat.goalsAgainst`,
        Decision = g.`stat.decision`,
        Shutout = g.`stat.shutouts`,
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
        LastUpdate = NOW();
    
    DROP TEMPORARY TABLE NonGoaliesGL;
    DROP TEMPORARY TABLE GoaliesGL;
    
	COMMIT;
END //