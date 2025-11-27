-- INSERT

INSERT INTO "User" (FullName, Email, PasswordHash, Position) VALUES
('Максим Кідрук', 'maksym.kidruk@example.com', 'hash321', 'Developer'),
('Софія Андрухович', 'sofia.and@example.com', 'hash654', 'QA Engineer');

INSERT INTO Team (TeamName, Description) VALUES
('Gamma Team', 'Тестування та якість');

INSERT INTO Project (ProjectName, Description, StartDate, EndDate, TeamID) VALUES
('E-Commerce Platform', 'Інтернет-магазин для малого бізнесу', '2025-11-01', '2026-03-31', 3);

INSERT INTO Board (BoardName, ProjectID) VALUES
('Testing Board', 1),
('Marketing Board', 3);

INSERT INTO Task (Title, Description, Status, Priority, DueDate, BoardID) VALUES
('Налаштувати базу даних', 'Створити схему БД для проекту', 'Done', 'High', '2025-09-15', 1),
('Написати тести API', 'Unit та Integration тести', 'In Progress', 'High', '2025-10-20', 3);

INSERT INTO Comment (Content, UserID, TaskID) VALUES
('Апрув', 1, 4),
('Звіртеся з правками', 2, 5);

INSERT INTO Tag (TagName, Color) VALUES
('Bug', 'orange'),
('Feature', 'purple');

INSERT INTO Task_Assignee (UserID, TaskID) VALUES
(4, 4),
(5, 5),
(2, 4);

INSERT INTO Task_Tag (TaskID, TagID) VALUES
(4, 2),
(5, 4),
(1, 5);

INSERT INTO Project_User (ProjectID, UserID, Role) VALUES
(3, 4, 'Developer'),
(3, 5, 'QA Lead'),
(2, 4, 'Developer');

INSERT INTO Team_User (TeamID, UserID) VALUES
(3, 4),
(3, 5),
(1, 4);

-- SELECT 

SELECT * FROM "User";

SELECT FullName, Email, Position FROM "User";

SELECT FullName, Email 
FROM "User" 
WHERE Position = 'Developer';

SELECT Title, Description, Status, DueDate 
FROM Task 
WHERE Priority = 'High';

SELECT TaskID, Title, Status, Priority 
FROM Task 
WHERE Status = 'In Progress';

SELECT ProjectName, Description, StartDate 
FROM Project 
WHERE EndDate IS NULL;

SELECT Content, CreatedAt 
FROM Comment 
WHERE UserID = 1;

SELECT Title, DueDate, Priority 
FROM Task 
WHERE DueDate <= '2025-10-31';

SELECT COUNT(*) AS TotalTasks FROM Task;

SELECT t.Title, t.Status, tg.TagName, tg.Color
FROM Task t
JOIN Task_Tag tt ON t.TaskID = tt.TaskID
JOIN Tag tg ON tt.TagID = tg.TagID
WHERE tg.TagName = 'Backend';

SELECT u.FullName, p.ProjectName, pu.Role
FROM "User" u
JOIN Project_User pu ON u.UserID = pu.UserID
JOIN Project p ON pu.ProjectID = p.ProjectID;

SELECT TagName, Color FROM Tag;

-- UPDATE 

SELECT UserID, FullName, Email FROM "User" WHERE UserID = 1;

UPDATE "User" 
SET Email = 'anna.koval.new@example.com' 
WHERE UserID = 1;

SELECT UserID, FullName, Email FROM "User" WHERE UserID = 1;

SELECT TaskID, Title, Status FROM Task WHERE TaskID = 1;

UPDATE Task 
SET Status = 'Done' 
WHERE TaskID = 1;

SELECT TaskID, Title, Status FROM Task WHERE TaskID = 1;

SELECT TaskID, Title, Priority, DueDate FROM Task WHERE TaskID = 3;

UPDATE Task 
SET Priority = 'Low', DueDate = '2025-12-01' 
WHERE TaskID = 3;

SELECT TaskID, Title, Priority, DueDate FROM Task WHERE TaskID = 3;

SELECT ProjectID, ProjectName, Description FROM Project WHERE ProjectID = 1;

UPDATE Project 
SET Description = 'Веб-додаток для керування завданнями та проектами (оновлений опис)' 
WHERE ProjectID = 1;

SELECT ProjectID, ProjectName, Description FROM Project WHERE ProjectID = 1;

SELECT TagID, TagName, Color FROM Tag WHERE TagName = 'Frontend';

UPDATE Tag 
SET Color = 'darkblue' 
WHERE TagName = 'Frontend';

SELECT TagID, TagName, Color FROM Tag WHERE TagName = 'Frontend';

SELECT UserID, FullName, Position FROM "User" WHERE UserID = 2;

UPDATE "User" 
SET Position = 'Senior Developer' 
WHERE UserID = 2;

SELECT UserID, FullName, Position FROM "User" WHERE UserID = 2;

-- DELETE 

SELECT * FROM Comment WHERE CommentID = 3;

DELETE FROM Comment 
WHERE CommentID = 3;

SELECT * FROM Comment;

SELECT * FROM Task_Tag WHERE TaskID = 2 AND TagID = 1;

DELETE FROM Task_Tag 
WHERE TaskID = 2 AND TagID = 1;

SELECT * FROM Task_Tag;

SELECT TaskID, Title, Status FROM Task WHERE Status = 'Done';

DELETE FROM Task 
WHERE TaskID = 4 AND Status = 'Done';

SELECT TaskID, Title, Status FROM Task;

SELECT * FROM Team_User WHERE TeamID = 2 AND UserID = 3;

DELETE FROM Team_User 
WHERE TeamID = 2 AND UserID = 3;

SELECT * FROM Team_User;

INSERT INTO Tag (TagName, Color) VALUES ('TestTag', 'gray');

SELECT * FROM Tag WHERE TagName = 'TestTag';

DELETE FROM Tag 
WHERE TagName = 'TestTag';

SELECT * FROM Tag;

-- ІНШІ ПЕРЕВІРКИ

SELECT 'Users' AS TableName, COUNT(*) AS RowCount FROM "User"
UNION ALL
SELECT 'Teams', COUNT(*) FROM Team
UNION ALL
SELECT 'Projects', COUNT(*) FROM Project
UNION ALL
SELECT 'Boards', COUNT(*) FROM Board
UNION ALL
SELECT 'Tasks', COUNT(*) FROM Task
UNION ALL
SELECT 'Comments', COUNT(*) FROM Comment
UNION ALL
SELECT 'Tags', COUNT(*) FROM Tag
UNION ALL
SELECT 'Task_Assignee', COUNT(*) FROM Task_Assignee
UNION ALL
SELECT 'Task_Tag', COUNT(*) FROM Task_Tag
UNION ALL
SELECT 'Project_User', COUNT(*) FROM Project_User
UNION ALL
SELECT 'Team_User', COUNT(*) FROM Team_User;

SELECT 
    t.Title AS TaskTitle,
    t.Status,
    t.Priority,
    t.DueDate,
    u.FullName AS AssignedTo
FROM Task t
JOIN Task_Assignee ta ON t.TaskID = ta.TaskID
JOIN "User" u ON ta.UserID = u.UserID
ORDER BY t.Priority DESC, t.DueDate;

SELECT 
    p.ProjectName,
    p.StartDate,
    COUNT(t.TaskID) AS TotalTasks,
    SUM(CASE WHEN t.Status = 'Done' THEN 1 ELSE 0 END) AS CompletedTasks,
    SUM(CASE WHEN t.Status = 'In Progress' THEN 1 ELSE 0 END) AS InProgressTasks
FROM Project p
JOIN Board b ON p.ProjectID = b.ProjectID
LEFT JOIN Task t ON b.BoardID = t.BoardID
GROUP BY p.ProjectID, p.ProjectName, p.StartDate
ORDER BY TotalTasks DESC;

SELECT 
    u.FullName,
    u.Position,
    COUNT(ta.TaskID) AS AssignedTasks
FROM "User" u
LEFT JOIN Task_Assignee ta ON u.UserID = ta.UserID
GROUP BY u.UserID, u.FullName, u.Position
ORDER BY AssignedTasks DESC;

SELECT * FROM "User";
SELECT * FROM Team;
SELECT * FROM Project;
SELECT * FROM Board;
SELECT * FROM Task;
SELECT * FROM Comment;
SELECT * FROM Tag;
