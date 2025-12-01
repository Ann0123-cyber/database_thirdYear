-- ====================================================================
-- ЛАБОРАТОРНА РОБОТА 4 (Аналітичні SQL-запити (OLAP))
-- ====================================================================

-- 1.1 COUNT + GROUP BY: Підрахунок завдань за проектом
-- Опис: Рахує загальну кількість завдань, призначених кожному проекту. 
SELECT
    p.ProjectName,
    COUNT(t.TaskID) AS TotalTasks
FROM Project p
JOIN Board b ON p.ProjectID = b.ProjectID
LEFT JOIN Task t ON b.BoardID = t.BoardID
GROUP BY p.ProjectName;


-- 1.2 SUM: Загальна кількість виконаних завдань
-- Опис: Обчислює загальну кількість завдань зі статусом 'Done' у всій системі.
SELECT
    SUM(CASE WHEN t.Status = 'Done' THEN 1 ELSE 0 END) AS TotalCompletedTasks
FROM Task t;


-- 1.3 AVG: Середня тривалість завершених проектів (у днях)
-- Опис: Обчислює середню тривалість проектів (у днях) для тих, що мають дату завершення.
SELECT
    -- (EndDate - StartDate) дає інтервал. Ми беремо AVG від цього інтервалу, приводимо до числа днів.
    AVG((EndDate - StartDate)) AS AvgProjectDurationDays 
FROM Project
WHERE EndDate IS NOT NULL;


-- 1.4 MIN: Найближча дата виконання для активних завдань
-- Опис: Знаходить найранішу дату завершення (DueDate) серед усіх завдань зі статусом 'In Progress'.
SELECT
    MIN(t.DueDate) AS EarliestDueDate
FROM Task t
WHERE t.Status = 'In Progress';


-- 1.5 MAX: Час останнього коментаря
-- Опис: Знаходить найновіший час серед усіх коментарів у системі.
SELECT
    MAX(c.CreatedAt) AS LastCommentTime
FROM Comment c;


-- 2.1 INNER JOIN: Показати зв'язані завдання та теги
-- Опис: Повертає лише ті рядки, де завдання і тег фактично зв'язані у таблиці Task_Tag. 
SELECT
    t.Title AS TaskTitle,
    tg.TagName
FROM Task t
JOIN Task_Tag tt ON t.TaskID = tt.TaskID
JOIN Tag tg ON tt.TagID = tg.TagID;


-- 2.2 LEFT JOIN: Усі команди та їхні учасники
-- Опис: Повертає всі команди (ліва таблиця), навіть якщо вони не мають жодного призначеного користувача
SELECT
    t.TeamName,
    u.FullName AS MemberName
FROM Team t
LEFT JOIN Team_User tu ON t.TeamID = tu.TeamID
LEFT JOIN "User" u ON tu.UserID = u.UserID;


-- 2.3 RIGHT JOIN: Усі користувачі та їхні команди
-- Опис: Повертає всіх користувачів (права таблиця), навіть якщо вони не призначені жодній команді.
SELECT
    u.FullName,
    t.TeamName
FROM Team_User tu
RIGHT JOIN "User" u ON tu.UserID = u.UserID
LEFT JOIN Team t ON tu.TeamID = t.TeamID;


-- 3.1 Підзапит у SELECT: Кількість дошок на проект
-- Опис: Вибирає назву проекту та використовує підзапит у стовпці SELECT для обчислення кількості дошок (BoardsCount), які належать цьому проекту.
SELECT
    p.ProjectName,
    p.StartDate,
    (
        SELECT COUNT(b.BoardID)
        FROM Board b
        WHERE b.ProjectID = p.ProjectID
    ) AS BoardsCount
FROM Project p;


-- 3.2 Підзапит у WHERE: Користувачі конкретного проекту
-- Опис: Знаходить ProjectID для проекту 'E-Commerce Platform', а потім вибирає всіх користувачів, які є учасниками цього проекту.
SELECT
    FullName,
    Position
FROM "User"
WHERE UserID IN (
    SELECT UserID
    FROM Project_User
    WHERE ProjectID = (SELECT ProjectID FROM Project WHERE ProjectName = 'E-Commerce Platform')
);


-- 3.3 Підзапит у HAVING: Посади з кількістю співробітників вище середнього
-- Опис: Спочатку обчислює середню кількість співробітників на посаду. Потім HAVING фільтрує групи (Position), залишаючи лише ті, де фактична кількість співробітників перевищує цю середню.
SELECT
    u.Position,
    COUNT(u.UserID) AS EmployeesInPosition
FROM "User" u
GROUP BY u.Position
HAVING COUNT(u.UserID) > (
    SELECT AVG(EmployeeCount)
    FROM (
        SELECT COUNT(UserID) AS EmployeeCount FROM "User" GROUP BY Position
    ) AS AvgPos
);
