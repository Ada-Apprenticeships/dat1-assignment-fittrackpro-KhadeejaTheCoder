-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members
SELECT *
From members;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information
UPDATE members
SET phone_number = '236-4589', email = 'updatedemail@email.com'
WHERE member_id = 4;

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
SELECT COUNT(*)
FROM members;

-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations
SELECT m.member_id, m.first_name, m.last_name, COUNT(ca.class_attendance_id) AS registration_count
FROM members m
JOIN class_attendance ca ON m.member_id = ca.member_id
WHERE ca.attendance_status = 'Registered'
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count DESC
LIMIT 1;

-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations
SELECT m.member_id, m.first_name, m.last_name, COUNT(ca.class_attendance_id) AS registration_count
FROM members m
JOIN class_attendance ca ON m.member_id = ca.member_id
WHERE ca.attendance_status = 'Registered'
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count 
LIMIT 1;

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class

SELECT 
    ROUND((COUNT(DISTINCT member_id) * 100.0 / (SELECT COUNT(*) FROM members)), 2) || '%' AS attendance_percentage
FROM class_attendance
WHERE attendance_status = 'Attended';