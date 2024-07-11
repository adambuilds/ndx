-- MySQL dump 10.13  Distrib 5.6.23, for Win64 (x86_64)
--
-- Host: interversal.chpbdpdleafb.us-east-2.rds.amazonaws.com    Database: isme
-- ------------------------------------------------------
-- Server version	5.6.37-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping events for database 'isme'
--

--
-- Dumping routines for database 'isme'
--
/*!50003 DROP PROCEDURE IF EXISTS `EstimateMigrate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`system_user`@`%` PROCEDURE `EstimateMigrate`()
BEGIN
	DECLARE done INT DEFAULT FALSE;
    DECLARE varLaborTypeID INT;
    DECLARE varJobID VARCHAR(45);
    DECLARE payload FLOAT;
    
	DECLARE cur1 CURSOR FOR SELECT ID, Design FROM Jobs WHERE Design IS NOT NULL AND Design > 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur1;
    
    read_loop: LOOP
		FETCH cur1 INTO varJobID, payload;
        IF done THEN
			LEAVE read_loop;
		END IF;
        INSERT INTO LaborEstimates (JobID, LaborTypeID, Hours, Migrated) Values ( varJobID, 19, payload, 1 );
	END LOOP;
    
    CLOSE cur1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `LaborMigrate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`system_user`@`%` PROCEDURE `LaborMigrate`()
BEGIN
	DECLARE done INT DEFAULT FALSE;
    DECLARE varID INT;
    DECLARE varDate DATETIME;
    DECLARE varEmployeeID INT;
    DECLARE varJobID VARCHAR(45);
    DECLARE payload FLOAT;
    
	DECLARE cur1 CURSOR FOR SELECT ID, Date, EmployeeID, JobID, Fence FROM Labor WHERE Fence IS NOT NULL AND Fence > 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur1;
    
    read_loop: LOOP
		FETCH cur1 INTO varID, varDate, varEmployeeID, varJobID, payload;
        IF done THEN
			LEAVE read_loop;
		END IF;
        INSERT INTO LaborNew (Hours, LaborTypeID, EmployeeID, JobID, Date, Migrated) Values ( payload, 16, varEmployeeID, varJobID, varDate, 1 );
	END LOOP;
    
    CLOSE cur1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `MigrateEmbeddedStatuses` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`system_user`@`%` PROCEDURE `MigrateEmbeddedStatuses`()
BEGIN
	-- for loop
	DECLARE done INT DEFAULT FALSE;
    -- data variables
    DECLARE varJobID VARCHAR(255);
    DECLARE varCode INT;
    DECLARE varTime DATETIME;
    
    -- cursor query to get and calculate all jobs' actual and estimated hours, 0 if null
	DECLARE cur1 CURSOR FOR SELECT ID, Drawn FROM Jobs WHERE Drawn IS NOT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur1;
    
    SET varCode = 21;
    
    read_loop: LOOP
		-- fill the data variables from the query output
		FETCH cur1 INTO varJobID, varTime;
        IF done THEN
			LEAVE read_loop;
		END IF;
        -- update the table with the calculated data (...I guess this is considered caching it?)
        INSERT INTO JobStatus SET StatusJobID = varJobID, StatusDate = varTime, StatusCode = varCode;
	END LOOP;
    
    CLOSE cur1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ProjectSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`system_user`@`%` PROCEDURE `ProjectSummary`()
BEGIN
	-- for loop
	DECLARE done INT DEFAULT FALSE;
    -- data variables
    DECLARE varJobID VARCHAR(255);
    DECLARE varActualHours FLOAT;
    DECLARE varEstimatedHours FLOAT;
    
    -- cursor query to get and calculate all jobs' actual and estimated hours, 0 if null
	DECLARE cur1 CURSOR FOR
		SELECT ActualHours.JobID as JobID, CalculatedActualHours, EstimatedActualHours
		FROM 
		(SELECT JobID, IFNULL(SUM(Hours), 0) AS CalculatedActualHours FROM LaborNew GROUP BY JobID) ActualHours 
		INNER JOIN
		(SELECT JobID, IFNULL(SUM(Hours), 0) AS EstimatedActualHours FROM LaborEstimates GROUP BY JobID) EstimatedHours 
		ON 
		ActualHours.JobID = EstimatedHours.JobID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur1;
    
    read_loop: LOOP
		-- fill the data variables from the query output
		FETCH cur1 INTO varJobID, varActualHours, varEstimatedHours;
        IF done THEN
			LEAVE read_loop;
		END IF;
        -- update the table with the calculated data (...I guess this is considered caching it?)
        UPDATE Jobs SET ActualHours = varActualHours, EstimatedHours = varEstimatedHours WHERE ID = varJobID;
	END LOOP;
    
    CLOSE cur1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-09-24 17:53:58