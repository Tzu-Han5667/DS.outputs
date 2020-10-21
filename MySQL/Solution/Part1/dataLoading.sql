-- Part 1.2 dataLoading.sql
--
-- Submitted by: Tzu-Han Lin
-- 


-- Part 1.2.1 Table Creation
CREATE TABLE crimes2013 (date_reported TEXT NOT NULL, date_occ TEXT NOT NULL, time_occ TEXT NOT NULL, dr_no TEXT , area TEXT, area_name TEXT, rd TEXT, crime_no TEXT NOT NULL, crime_desc TEXT, status TEXT, status_desc TEXT, image_no TEXT);
CREATE TABLE crimes2014 (date_reported TEXT NOT NULL, date_occ TEXT NOT NULL, time_occ TEXT NOT NULL, dr_no TEXT , area TEXT, area_name TEXT, rd TEXT, crime_no TEXT NOT NULL, crime_desc TEXT, status TEXT, status_desc TEXT, image_no TEXT);

-- Part 1.2.1 Data Load
-- load 'crimes2013.txt'
LOAD DATA LOCAL INFILE '/home/k1814539/Documents/database/coursework/C2/crimes2013.txt' INTO TABLE crimes2013 FIELDS TERMINATED BY '\t' ESCAPED BY '\\' ENCLOSED BY '\'' LINES TERMINATED BY '\n' IGNORE 1 LINES
(@dr_no, @date_reported, @date_occ, @time_occ, @area, @area_name, @rd, @crime_no, @crime_desc, @status, @status_desc, @image_no)
SET date_reported=@date_reported, date_occ=@date_occ, time_occ=@time_occ, dr_no=@dr_no, area=@area, area_name=@area_name, rd=@rd, crime_no=@crime_no, crime_desc=@crime_desc, status=@status, status_desc=@status_desc, image_no=@image_no;

-- load 'crimes2014.csv'
LOAD DATA LOCAL INFILE '/home/k1814539/Documents/database/coursework/C2/crimes2014.csv' INTO TABLE crimes2014 FIELDS TERMINATED BY ';' ENCLOSED BY '\'' LINES TERMINATED BY '\r\n' IGNORE 1 LINES 
(@date_reported, @dr_no, @date_occ, @time_occ, @area, @area_name, @rd, @crime_no, @crime_desc, @status, @status_desc, @image_no)
SET date_reported=@date_reported, date_occ=@date_occ, time_occ=@time_occ, dr_no=@dr_no, area=@area, area_name=@area_name, rd=@rd, crime_no=@crime_no, crime_desc=@crime_desc, status=@status, status_desc=@status_desc, image_no=@image_no;
