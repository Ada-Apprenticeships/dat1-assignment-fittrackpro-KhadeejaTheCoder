-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Attendance Tracking Queries

-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit
INSERT INTO attendance (member_id, location_id, check_in_time, check_out_time)
VALUES (7, 1, DATETIME('now'), '2025-02-17 11:30:00'); -- NOT NULL is on check_out_time

-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history
SELECT 
    DATE(check_in_time) AS visit_date, 
    TIME(check_in_time) AS check_in_time, 
    TIME(check_out_time) AS check_out_time
FROM attendance
WHERE member_id = 5
ORDER BY check_in_time DESC;

-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits
SELECT 
    CASE strftime('%w', check_in_time)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS visit_count
FROM attendance
GROUP BY strftime('%w', check_in_time)
ORDER BY visit_count DESC;

-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location
SELECT 
    l.name AS location_name, 
    ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT DATE(check_in_time)), 2) AS avg_daily_attendance
FROM attendance a
JOIN locations l ON a.location_id = l.location_id
GROUP BY a.location_id;