-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors
SELECT
c.class_id,
c.name AS class_name,
s.first_name || ' ' || s.last_name AS instructor_name
FROM classes c
JOIN class_schedule cs
  ON cs.class_id = c.class_id
JOIN staff s
  ON s.staff_id = cs.staff_id
  GROUP BY c.class_id, c.name
ORDER BY c.class_id
;

-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date
SELECT 
    cs.class_id,
    c.name,
    cs.start_time,
    cs.end_time,
    (c.capacity - COUNT(CASE WHEN ca.attendance_status = 'Registered' THEN ca.member_id END)) AS available_spots
FROM class_schedule cs
JOIN classes c ON c.class_id = cs.class_id
LEFT JOIN class_attendance ca 
    ON ca.schedule_id = cs.schedule_id
    AND ca.attendance_status = 'Registered'  -- Count only registered members
WHERE cs.start_time BETWEEN '2025-02-01 00:00:00' AND '2025-02-01 23:59:59'  -- Filter for the specific date
GROUP BY cs.class_id, c.name, cs.start_time, cs.end_time, c.capacity
HAVING available_spots > 0  -- Only show classes with open spots
ORDER BY cs.start_time;

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES ('7', '11', 'Registered');

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration
DELETE FROM class_attendance WHERE class_attendance_id ='15';

-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes
SELECT 
    c.class_id, 
    c.name AS class_name, 
    COUNT(ca.class_attendance_id) AS registration_count
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id
JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE ca.attendance_status = 'Registered'
GROUP BY c.class_id, c.name
ORDER BY registration_count DESC
LIMIT 3;

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member
SELECT 
    COUNT(class_attendance_id) / COUNT(DISTINCT member_id) AS avg_classes_per_member
FROM class_attendance
WHERE attendance_status = 'Registered';