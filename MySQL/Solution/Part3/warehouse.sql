-- Part 3.1 warehouse.sql
--
-- Submitted by: Write your Name here
-- 


--  Write your SQL statements to create and populate the crimes data warehouse
--  Processing
ALTER TABLE crimes2015 ADD COLUMN (date_occ TEXT, time_occ TIME);
UPDATE crimes2015 SET date_occ = STR_TO_DATE(SUBSTRING(occured, 1, 10), '%m/%d/%Y');
UPDATE crimes2015 SET time_occ = SUBSTRING(occured from 11);
UPDATE crimes2015 SET date_reported = STR_TO_DATE(date_reported, '%m/%d/%Y');

CREATE TABLE ar_temp AS SELECT DISTINCT area, area_name FROM crimes2015 WHERE area_name != 'NULL';
UPDATE crimes2015 a SET area_name = (SELECT area_name FROM ar_temp b WHERE a.area = b.area);
DROP TABLE ar_temp;

-- reported_timed (<timeCode>, year, month, day)
CREATE TABLE reported_timed (timeCode INT(11) NOT NULL AUTO_INCREMENT, year INT(4) DEFAULT NULL, month INT(2) DEFAULT NULL, day INT(2) DEFAULT NULL, PRIMARY KEY (timeCode));
INSERT INTO reported_timed (year, month, day) SELECT DISTINCT YEAR(date_reported), MONTH(date_reported), DAY(date_reported) FROM crimes2015 ORDER BY date_reported ASC;

-- occ_timed (<timeCode>, year, month, day, hour, minute)
CREATE TABLE occ_timed (timeCode INT(11) NOT NULL AUTO_INCREMENT, year INT(4) DEFAULT NULL, month INT(2) DEFAULT NULL, day INT(2) DEFAULT NULL, hour INT(2) DEFAULT NULL, minute INT(2) DEFAULT NULL, PRIMARY KEY (timeCode));
INSERT INTO occ_timed (year, month, day, hour, minute) SELECT DISTINCT YEAR(date_occ), MONTH(date_occ), DAY(date_occ), HOUR(time_occ), MINUTE(time_occ) FROM crimes2015 ORDER BY date_occ ASC, time_occ ASC;

--  area_info(<area>, area_name)
CREATE TABLE area_info (area INT(2) NOT NULL, area_name VARCHAR(20) NOT NULL);
INSERT INTO area_info SELECT DISTINCT area, area_name FROM crimes2015;
ALTER TABLE area_info ADD PRIMARY KEY (area);

-- crime_type(<crime_no>, crime_desc)
CREATE TABLE crime_type (crime_no INT(3) NOT NULL, crime_desc VARCHAR(500) NOT NULL);
INSERT INTO crime_type SELECT DISTINCT crime_no, crime_desc FROM crimes2015;
ALTER TABLE crime_type ADD PRIMARY KEY (crime_no);

-- case_status(<status_id>, status, status_desc)
CREATE TABLE case_status (status_id INT(2) AUTO_INCREMENT, status VARCHAR(3) NOT NULL, status_desc VARCHAR(20) NOT NULL, PRIMARY KEY (status_id));
INSERT INTO case_status (status, status_desc)  SELECT DISTINCT status, status_desc FROM crimes2015;

-- case_record(<dr_no>, report_tcode, occ_tcode, area, crime_no, status_id)
CREATE TABLE case_record(dr_no INT(9) NOT NULL, report_tcode INT(11), occ_tcode INT(11), area INT(2) NOT NULL, crime_no INT(3) NOT NULL, status_id INT(2),
PRIMARY KEY(dr_no, report_tcode, occ_tcode, area, crime_no, status_id), 
FOREIGN KEY(area) REFERENCES area_info(area), 
FOREIGN KEY(crime_no) REFERENCES crime_type(crime_no),
FOREIGN KEY(status_id) REFERENCES case_status(status_id),
FOREIGN KEY(occ_tcode) REFERENCES occ_timed(timeCode),
FOREIGN KEY(report_tcode) REFERENCES reported_timed(timeCode));

INSERT INTO case_record(dr_no, report_tcode, occ_tcode, area, crime_no, status_id)
SELECT a.dr_no, b.timeCode, c.timeCode, d.area, e.crime_no, f.status_id
FROM crimes2015 a, reported_timed b, occ_timed c, area_info d, crime_type e, case_status f
WHERE YEAR(a.date_reported) = b.year AND MONTH(a.date_reported) = b.month AND DAY(a.date_reported) = b.day
AND YEAR(a.date_occ) = c.year AND MONTH(a.date_occ) = c.month AND DAY(a.date_occ) = c.day AND HOUR(a.time_occ) = c.hour AND MINUTE(a.time_occ) = c.minute
AND a.area = d.area
AND a.crime_no = e.crime_no
AND a.status = f.status;