-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Membership Management Queries
-- 1. List all active memberships
-- TODO: Write a query to list all active memberships
SELECT 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    ms.type AS membership_type, 
    ms.start_date AS join_date
FROM memberships ms
JOIN members m ON ms.member_id = m.member_id
WHERE ms.status = 'Active';

-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type
SELECT 
    ms.type AS membership_type, 
    AVG((strftime('%s', a.check_out_time) - strftime('%s', a.check_in_time)) / 60.0) AS avg_visit_duration_minutes
FROM attendance a
JOIN memberships ms ON a.member_id = ms.member_id
WHERE a.check_out_time IS NOT NULL
AND strftime('%s', a.check_out_time) >= strftime('%s', a.check_in_time) -- Ensure no negative durations
GROUP BY ms.type;

-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year
SELECT 
    m.member_id, 
    m.first_name, 
    m.last_name, 
    m.email, 
    ms.end_date
FROM memberships ms
JOIN members m ON ms.member_id = m.member_id
WHERE ms.end_date BETWEEN DATE('now') AND DATE('now', '+1 year')
ORDER BY ms.end_date;