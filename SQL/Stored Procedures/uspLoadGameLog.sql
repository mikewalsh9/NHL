DELIMITER //
CREATE PROCEDURE uspLoadGameLog()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SHOW ERRORS;
        ROLLBACK;   
    END;
    START TRANSACTION;
	INSERT INTO NHL.GameLog(GamePK,
		GameDate,
        HomeTeamName,
        HomeTeamID,
        HomeTeamScore,
        AwayTeamName,
        AwayTeamID,
        AwayTeamScore,
        GameStatus,
        LastUpdate,
        CreateDate)
		SELECT g.`games.gamePK`,
		g.`date`,
        g.`games.teams.home.team.name`,
        g.`games.teams.home.team.id`,
        g.`games.teams.home.score`,
        g.`games.teams.away.team.name`,
        g.`games.teams.away.team.id`,
        g.`games.teams.away.score`,
        g.`games.status.abstractGameState`,
        NOW(),
        NOW()
        FROM NHLStaging.GameLog g
	ON DUPLICATE KEY
        UPDATE
        GameDate = g.`date`,
        HomeTeamName = g.`games.teams.home.team.name`,
        HomeTeamID = g.`games.teams.home.team.id`,
        HomeTeamScore = g.`games.teams.home.score`,
        AwayTeamName = g.`games.teams.away.team.name`,
        AwayTeamID = g.`games.teams.away.team.id`,
        AwayTeamScore = g.`games.teams.away.score`,
        GameStatus = g.`games.status.abstractGameState`,
        LastUpdate = NOW();
	COMMIT;
END //
    