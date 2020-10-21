-- Part 1.4 dataIntegration.sql
--
-- Submitted by: Tzu-Han Lin
-- 


--  Write your Data Integration statements here
CREATE TABLE cases (dr_no TEXT , date_reported TEXT NOT NULL, date_occ TEXT NOT NULL, time_occ TEXT NOT NULL, area TEXT, area_name TEXT, rd TEXT, crime_no TEXT NOT NULL, crime_desc TEXT, status TEXT, status_desc TEXT, image_no TEXT);

INSERT INTO cases SELECT dr_no, date_reported, date_occ, time_occ, area, area_name, rd, crime_no, crime_desc, status, status_desc, image_no FROM crimes2013;
INSERT INTO cases SELECT dr_no, date_reported, date_occ, time_occ, area, area_name, rd, crime_no, crime_desc, status, status_desc, image_no FROM crimes2014;
INSERT INTO cases SELECT dr_no, date_reported, date_occ, time_occ, area, area_name, rd, crime_no, crime_desc, status, status_desc, image_no FROM crimes2015;