-- Part 1.5 databaseNormalization.sql
--
-- Submitted by: Tzu-Han Lin
-- 


--  Write your Database Normalization statements here
-- area_info(area, area_name, <rd>)
CREATE TABLE area_info (area INT(2) NOT NULL, area_name VARCHAR(20) NOT NULL, rd INT(4) NOT NULL);
INSERT INTO area_info SELECT DISTINCT area, area_name, rd FROM cases;
ALTER TABLE area_info ADD PRIMARY KEY (rd);

-- crime_category(<crime_no>, crime_desc)
-- crime_no: 440/813/930 have duplicate description
UPDATE cases SET crime_no = 438 WHERE crime_no = 439;
UPDATE cases SET crime_no = 439 WHERE crime_desc LIKE 'THEFT PLAIN - PETTY ($950 & UNDER)';
UPDATE cases SET crime_no = 814 WHERE crime_desc LIKE 'CHILD ENDANGERMENT/NEG.';
UPDATE cases SET crime_no = 929 WHERE crime_desc LIKE 'THREATS, VERBAL/TERRORIST';

CREATE TABLE crime_category (crime_no INT(3) NOT NULL, crime_desc VARCHAR(500) NOT NULL);
INSERT INTO crime_category SELECT DISTINCT crime_no, crime_desc FROM cases;
ALTER TABLE crime_category ADD PRIMARY KEY (crime_no);

-- case_status(<status_id>, status, status_desc)
CREATE TABLE case_status (status_id INT(2) AUTO_INCREMENT, status VARCHAR(3) NOT NULL, status_desc VARCHAR(20) NOT NULL, PRIMARY KEY (status_id));
INSERT INTO case_status (status, status_desc)  SELECT DISTINCT status, status_desc FROM cases;

-- cases(<dr_no>, date_reported, date_occ, time_occ, rd, crime_no, status_id, image_no)
ALTER TABLE cases MODIFY COLUMN dr_no INT(9) NOT NULL, MODIFY COLUMN date_reported DATE, MODIFY COLUMN date_occ DATE, MODIFY COLUMN time_occ TIME, MODIFY COLUMN rd INT(4) NOT NULL, MODIFY COLUMN crime_no INT(3) NOT NULL, MODIFY COLUMN status VARCHAR(3) NOT NULL, MODIFY COLUMN image_no INT(3) NOT NULL;
ALTER TABLE cases MODIFY COLUMN dr_no INT, MODIFY COLUMN date_reported DATE, MODIFY COLUMN date_occ DATE, MODIFY COLUMN time_occ TIME, MODIFY COLUMN rd INT(4), MODIFY COLUMN status VARCHAR(3), MODIFY COLUMN image_no INT(3);
ALTER TABLE cases ADD COLUMN status_id INT(2);
UPDATE cases a SET status_id = (SELECT status_id FROM case_status b WHERE a.status = b.status); 
ALTER TABLE cases DROP area, DROP area_name, DROP crime_desc, DROP status, DROP status_desc;
