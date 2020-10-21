-- Part 2.1 constraints.sql
--
-- Submitted by: Tzu-Han Lin
-- 


--  2.1: Status Description Consistency
DELIMITER //
CREATE TRIGGER same_i BEFORE INSERT ON crimes2015
FOR EACH ROW 
BEGIN 
IF NEW.status NOT IN(SELECT DISTINCT status FROM crimes2015 WHERE NEW.status_desc = status_desc)
 THEN SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'This status and description not consistency.';
END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER same_u BEFORE UPDATE ON crimes2015
FOR EACH ROW 
BEGIN 
IF NEW.status NOT IN(SELECT DISTINCT status FROM crimes2015 WHERE NEW.status_desc = status_desc)
 THEN SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'This status and description not consistency.';
END IF;
END//
DELIMITER ;

DROP TRIGGER same_i ;
DROP TRIGGER same_u ;

--  2.2: Status Transition
--  Default UNK
DELIMITER //
CREATE TRIGGER status_default BEFORE INSERT ON crimes2015 
FOR EACH ROW
BEGIN
IF NEW.status IS NULL THEN
 SET NEW.status = 'UNK';
END IF;
END//
DELIMITER ;

--  Status Transition
DELIMITER //
CREATE TRIGGER status_code BEFORE UPDATE ON crimes2015
FOR EACH ROW
BEGIN
IF (OLD.status = 'UNK' AND NEW.status != 'UNK' AND NEW.status != 'IC')
 THEN SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'You can only change to IC.';
ELSEIF (OLD.status = 'IC' AND NEW.status != 'IC' AND NEW.status !='AO' AND NEW.status != 'JO')
 THEN SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'You can only change to AO or JO.';
ELSEIF (OLD.status = 'AO' AND NEW.status != 'AO' AND NEW.status != 'AA')
 THEN SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'You can only change to AA.';
ELSEIF (OLD.status = 'JO' AND NEW.status != 'JO' AND NEW.status != 'JA')
 THEN SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'You can only change to JA';
END IF;
END//
DELIMITER ;

--  Can be deleted
DELIMITER //
CREATE TRIGGER status_del BEFORE DELETE ON crimes2015
FOR EACH ROW
BEGIN
IF (status != 'JA' OR status != 'AA')
 THEN SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Only the case in JA or AA status can be deleted. ';
END IF;
END//
DELIMITER ;