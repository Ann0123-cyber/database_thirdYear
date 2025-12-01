-- ====================================================================
-- ЛАБОРАТОРНА РОБОТА 3 (Маніпулювання даними SQL (OLTP))
-- ====================================================================


DELETE FROM "User" WHERE FullName IN ('Богдан Франко', 'Марія Омельченко');
DELETE FROM Team WHERE TeamName = 'Innovation Lab';
DELETE FROM Project WHERE ProjectName = 'New AI Feature';
DELETE FROM Tag WHERE TagName IN ('ML', 'Documentation');
-- Кінець блоку безпечного видалення.


-- 1. INSERT (ДОДАВАННЯ НОВИХ ДАНИХ)
-- Додаємо двох НОВИХ користувачів (UserID 9, 10), щоб не дублювати існуючих.
INSERT INTO "User" (FullName, Email, PasswordHash, Position) VALUES
('Богдан Франко', 'bohdan.franko@example.com', 'hash999', 'Junior Developer'), -- UserID 9 (передбачувано)
('Марія Омельченко', 'mariia.o@example.com', 'hash888', 'Technical Writer'); -- UserID 10 (передбачувано)

-- Додаємо НОВУ команду та проект
INSERT INTO Team (TeamName, Description) VALUES
('Innovation Lab', 'Дослідження та нові технології'); -- TeamID 5 (передбачувано)

-- Використовуємо CTE та підзапити для гарантованої послідовності ID:
WITH NewProject AS (
    INSERT INTO Project (ProjectName, Description, StartDate, EndDate, TeamID) VALUES
    ('New AI Feature', 'Проект інтеграції ML-функціоналу', '2026-03-01', NULL, (SELECT TeamID FROM Team WHERE TeamName = 'Innovation Lab'))
    RETURNING ProjectID
)
, NewBoards AS (
    INSERT INTO Board (BoardName, ProjectID)
    SELECT 'Research Board', ProjectID FROM NewProject
    UNION ALL
    SELECT 'Implementation Board', ProjectID FROM NewProject
    RETURNING BoardID, BoardName
)
, NewTasks AS (
    INSERT INTO Task (Title, Description, Status, Priority, DueDate, BoardID)
    SELECT 'Розробити ML-модель', 'Тренування та оптимізація моделі', 'To Do', 'High', '2026-04-15'::DATE, (SELECT BoardID FROM NewBoards WHERE BoardName = 'Implementation Board')
    UNION ALL
    SELECT 'Написати технічний опис', 'Створення документації для нової фічі', 'To Do', 'Low', '2026-04-30'::DATE, (SELECT BoardID FROM NewBoards WHERE BoardName = 'Research Board')
    RETURNING TaskID
)
-- Вставляємо коментарі для нових завдань
INSERT INTO Comment (Content, UserID, TaskID) VALUES
('Потрібен новий API ключ', 1, (SELECT TaskID FROM Task WHERE Title = 'Розробити ML-модель')),
('Перевірте, чи відповідає ТЗ', 4, (SELECT TaskID FROM Task WHERE Title = 'Написати технічний опис'));

-- Додаємо НОВІ теги
INSERT INTO Tag (TagName, Color) VALUES
('ML', 'pink'),
('Documentation', 'grey');

-- Встановлюємо зв'язки для нових об'єктів
INSERT INTO Task_Assignee (UserID, TaskID) VALUES
((SELECT UserID FROM "User" WHERE FullName = 'Богдан Франко'), (SELECT TaskID FROM Task WHERE Title = 'Розробити ML-модель')),
((SELECT UserID FROM "User" WHERE FullName = 'Олег Петренко'), (SELECT TaskID FROM Task WHERE Title = 'Розробити ML-модель'));

INSERT INTO Task_Tag (TaskID, TagID) VALUES
((SELECT TaskID FROM Task WHERE Title = 'Розробити ML-модель'), (SELECT TagID FROM Tag WHERE TagName = 'ML')),
((SELECT TaskID FROM Task WHERE Title = 'Написати технічний опис'), (SELECT TagID FROM Tag WHERE TagName = 'Documentation'));

INSERT INTO Project_User (ProjectID, UserID, Role) VALUES
((SELECT ProjectID FROM Project WHERE ProjectName = 'New AI Feature'), (SELECT UserID FROM "User" WHERE FullName = 'Богдан Франко'), 'Developer'),
((SELECT ProjectID FROM Project WHERE ProjectName = 'New AI Feature'), (SELECT UserID FROM "User" WHERE FullName = 'Марія Омельченко'), 'Technical Writer');

INSERT INTO Team_User (TeamID, UserID) VALUES
((SELECT TeamID FROM Team WHERE TeamName = 'Innovation Lab'), (SELECT UserID FROM "User" WHERE FullName = 'Богдан Франко')),
((SELECT TeamID FROM Team WHERE TeamName = 'Innovation Lab'), (SELECT UserID FROM "User" WHERE FullName = 'Марія Омельченко'));


-----------------------------------------------------------------------
-- 2. SELECT (ПЕРЕВІРКА ТА ФІЛЬТРАЦІЯ)
-----------------------------------------------------------------------

-- 2.1 Проста вибірка всіх даних
SELECT * FROM "User";
SELECT * FROM Task;

-- 2.2 Вибірка конкретних стовпців з фільтром
SELECT FullName, Email
FROM "User"
WHERE Position = 'Developer' OR Position = 'Junior Developer'; -- Розширено, щоб включити Junior

-- 2.3 Вибірка завдань з високим пріоритетом 
SELECT Title, Description, Status, DueDate
FROM Task
WHERE Priority = 'High';

-- 2.4 Вибірка активних завдань
SELECT TaskID, Title, Status, Priority
FROM Task
WHERE Status = 'In Progress';

-- 2.5 Вибірка проектів без дати завершення
SELECT ProjectName, Description, StartDate
FROM Project
WHERE EndDate IS NULL;

-- 2.6 Вибірка завдань, термін яких до 31.10.2025 
SELECT Title, DueDate, Priority
FROM Task
WHERE DueDate <= '2025-10-31'::DATE;

-----------------------------------------------------------------------
-- 3. UPDATE (ЗМІНА ІСНУЮЧИХ ДАНИХ)
-----------------------------------------------------------------------

-- 3.1 Оновлення Email Анни Коваль (UserID 1)
UPDATE "User"
SET Email = 'anna.koval.new@example.com'
WHERE UserID = 1;

-- 3.2 Зміна статусу завдання 1 ('Реалізувати логін') на 'Done' (З коду подруги, для демонстрації завершення)
UPDATE Task
SET Status = 'Done'
WHERE TaskID = 1;

-- 3.3 Оновлення пріоритету та дати завдання 3 ('Провести A/B тестування')
UPDATE Task
SET Priority = 'Low', DueDate = '2025-12-01'::DATE
WHERE TaskID = 3;

-- 3.4 Оновлення опису проекту 1 ('Trello Clone')
UPDATE Project
SET Description = 'Веб-додаток для керування завданнями та проектами (оновлений опис)'
WHERE ProjectID = 1;

-- 3.5 Оновлення кольору тегу 'Frontend'
UPDATE Tag
SET Color = 'darkblue'
WHERE TagName = 'Frontend';

-- 3.6 Оновлення позиції Олега Петренка (UserID 2)
UPDATE "User"
SET Position = 'Senior Developer'
WHERE UserID = 2;

-----------------------------------------------------------------------
-- 4. DELETE (ВИДАЛЕННЯ ІСНУЮЧИХ ДАНИХ)
-----------------------------------------------------------------------

-- 4.1 Видалення останнього доданого коментаря
DELETE FROM Comment
WHERE CommentID = (SELECT MAX(CommentID) FROM Comment);

-- 4.2 Видалення зв'язку 'Frontend' (TagID 1) із завдання 4 ('Додати тести з датами') 
DELETE FROM Task_Tag
WHERE TaskID = 4 AND TagID = 1;

-- 4.3 Видалення завдання 'Написати технічний опис'
DELETE FROM Task
WHERE Title = 'Написати технічний опис';

-- 4.4 Видалення зв'язку Team-User для користувача 3 (Ірина) з TeamID 2 (Beta Team) 
DELETE FROM Team_User
WHERE TeamID = 2 AND UserID = 3;

-- 4.5 Видалення тимчасового тегу
INSERT INTO Tag (TagName, Color) VALUES ('TestTag', 'gray');
DELETE FROM Tag
WHERE TagName = 'TestTag';

-----------------------------------------------------------------------
-- 5. ПЕРЕВІРКА КІНЦЕВОГО СТАНУ (АГРЕГАЦІЯ)
-----------------------------------------------------------------------

-- Підрахунок рядків у всіх таблицях
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