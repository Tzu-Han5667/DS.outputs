-- Part 1.3 dataPreprocessing.sql
--
-- Submitted by: Tzu-Han Lin
-- 


-- Write your Data Preprocessing statements here
-- Modifying time to 2 column
ALTER TABLE crimes2015 ADD COLUMN (date_occ TEXT, time_occ TEXT);
UPDATE crimes2015 SET date_occ = SUBSTRING(occured, 1, 10);
UPDATE crimes2015 SET time_occ = SUBSTRING(occured from 11);

-- Remove Duplicate
DELETE c1 FROM crimes2013 c1
INNER JOIN crimes2013 c2
WHERE c1.dr_no < c2.dr_no
 AND c1.date_reported = c2.date_reported
 AND c1.date_occ = c2.date_occ
 AND c1.time_occ = c2.time_occ
 AND c1.area = c2.area
 AND c1.area_name = c2.area_name 
 AND c1.rd = c2.rd 
 AND c1.crime_no = c2.crime_no 
 AND c1.crime_desc = c2.crime_desc 
 AND c1.status = c2.status 
 AND c1.status_desc = c2.status_desc 
 AND c1.image_no = c2.image_no;

CREATE TABLE temp_c14 (date_reported TEXT NOT NULL, date_occ TEXT NOT NULL, time_occ TEXT NOT NULL, dr_no TEXT , area TEXT, area_name TEXT, rd TEXT, crime_no TEXT NOT NULL, crime_desc TEXT, status TEXT, status_desc TEXT, image_no TEXT);
INSERT INTO temp_c14 SELECT DISTINCT * FROM crimes2014;
DROP TABLE crimes2014;
RENAME TABLE temp_c14 TO crimes2014;

--2015 Road
UPDATE crimes2015 SET rd = SUBSTRING(rd FROM 6);

-- TIME OCC
UPDATE crimes2013
SET time_occ = SUBSTRING(SEC_TO_TIME(time_occ*36), 1, 5);
UPDATE crimes2014
SET time_occ = SUBSTRING(SEC_TO_TIME(time_occ*36), 1, 5);
UPDATE crimes2015
SET time_occ = SUBSTRING(time_occ, 1, 6);

--Image No
UPDATE crimes2013 SET image_no = 0 WHERE image_no < 0;
UPDATE crimes2015 SET image_no = 0 WHERE image_no IS NULL;

--Status
UPDATE crimes2013 SET status = UPPER(status);

--Dates
UPDATE crimes2013
SET date_occ = STR_TO_DATE(date_occ, '%D %M, %Y'), date_reported = STR_TO_DATE(date_reported, '%D %M, %Y');
UPDATE crimes2014 
SET date_occ = STR_TO_DATE(date_occ, '%Y-%M-%d'), date_reported = STR_TO_DATE(date_reported, '%Y-%M-%d');
UPDATE crimes2015
SET date_occ = STR_TO_DATE(date_occ, '%m/%d/%Y'), date_reported = STR_TO_DATE(date_reported, '%m/%d/%Y');

-- Missing area
CREATE TABLE ar_temp AS SELECT DISTINCT area, area_name FROM crimes2015 WHERE area_name != 'NULL';
UPDATE crimes2015 a SET area_name = (SELECT area_name FROM ar_temp b WHERE a.area = b.area);
DROP TABLE ar_temp;