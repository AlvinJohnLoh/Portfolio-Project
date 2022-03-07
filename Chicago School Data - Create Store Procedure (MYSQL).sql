-- List the school names, community names and average attendance for communities with a hardship index of 98
SELECT 
	cs.community_area_number,
    cs.community_area_name,
    cp.name_of_school,
    hardship_index
FROM chicago_socioeconomic_data cs
JOIN chicago_public_schools cp
	ON cs.community_area_number = cp.community_area_number
WHERE hardship_index = '98'


-- List all crimes that took place at a school. Include case number, crime type and community name
SELECT 
	cp.community_area_name,
    cc.case_number,
    cc.primary_type,
    cc.location_description
FROM chicago_crime cc
JOIN chicago_public_schools cp
	ON cc.community_area_number = cp.community_area_number
WHERE location_description LIKE '%SCHOOL%'


-- Create Views
-- Create a view that enables users to select just the school name and the icon fields from the CHICAGO PUBLIC SCHOOLS table. 
-- By providing a view, ensure that users cannot see the actual scores given to a school, just the icon associated with their score. (Very weak - Very strong)
-- Define new names for the view columns to obscure the use of scores and icons in the original table.
SELECT 
	name_of_school, 
    safety_icon, 
    family_involvement_icon, 
    environment_icon, 
    instruction_icon, 
    leaders_icon, 
    teachers_icon 
FROM chicago_public_schools 

CREATE VIEW all_the_columns AS 
SELECT name_of_school AS school_name, 
	   safety_icon AS Safety_Rating, 
	   family_involvement_icon AS Family_Rating, 
	   environment_icon AS Environment_Rating, 
	   instruction_icon AS Instruction_rating, 
	   leaders_icon AS Leaders_Rating, 
	   teachers_icon AS Teachers_rating 
FROM chicago_public_schools 


-- Execute a SQL statement that returns just the school name and leaders rating from the view
CREATE VIEW school_name_and_leaders_ratings AS 
SELECT name_of_school AS Sschool_name_and_leaders_ratingschool_name, 
	   leaders_icon AS Leaders_Rating  
FROM chicago_public_schools


-- Create stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer. 
-- Update the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID to the value in the in_Leader_Score parameter.

DELIMITER //
CREATE PROCEDURE UPDATE_LEADERS_SCORE(
		IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)

LANGUAGE SQL
MODIFIES SQL DATA

BEGIN
	UPDATE chicago_public_schools
    SET LEADERS_Score = in_Leader_Score
    WHERE school_id = in_School_ID;
    
    IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN
			UPDATE chicago_public_schools
            SET LEADERS_ICON = 'Very_weak';
	
		ELSEIF in_Leader_Score < 40 THEN
			UPDATE chicago_public_schools
            SET LEADERS_ICON = 'Weak'
            WHERE SCHOOL_ID = in_School_ID AND LEADERS_SCORE = in_Leader_Score;
		
        ELSEIF in_Leader_Score < 60 THEN
			UPDATE chicago_public_schools
            SET LEADERS_ICON = 'Average'
            WHERE SCHOOL_ID = in_School_ID AND LEADERS_SCORE = in_Leader_Score;
            
		ELSEIF in_Leader_Score < 80 THEN
			UPDATE chicago_public_schools
            SET LEADERS_ICON = 'Strong'
            WHERE SCHOOL_ID = in_School_ID AND LEADERS_SCORE = in_Leader_Score;
		
        ELSEIF in_Leader_Score < 100 THEN
			UPDATE chicago_public_schools
            SET LEADERS_ICON = 'Very_Strong'
            WHERE SCHOOL_ID = in_School_ID AND LEADERS_SCORE = in_Leader_Score;
		
        END IF;
END //
DELIMITER ; 

