INSERT INTO "User" (FullName, Email, PasswordHash, Position) VALUES
('Анна Коваль', 'anna.koval@example.com', 'hash123', 'Project Manager'),
('Олег Петренко', 'oleg.petrenko@example.com', 'hash456', 'Developer'),
('Ірина Шевченко', 'iryna.shevchenko@example.com', 'hash789', 'Designer');

INSERT INTO Team (TeamName, Description) VALUES
('Alpha Team', 'Розробка основного функціоналу'),
('Beta Team', 'UI/UX дизайн та тестування');

INSERT INTO Project (ProjectName, Description, StartDate, EndDate, TeamID) VALUES
('Trello Clone', 'Веб-додаток для керування завданнями', '2025-09-01', '2025-12-31', 1),
('History Test App', 'Сайт з тестами з історії України', '2025-10-01', NULL, 2);

INSERT INTO Board (BoardName, ProjectID) VALUES
('Development Board', 1),
('Design Board', 2);

INSERT INTO Task (Title, Description, Status, Priority, DueDate, BoardID) VALUES
('Реалізувати логін', 'Створити форму авторизації', 'In Progress', 'High', '2025-10-10', 1),
('Додати тести з датами', 'Розробити тест з історичних дат', 'To Do', 'Medium', '2025-11-01', 2),
('Перевірити адаптивність', 'Перевірити верстку на мобільних пристроях', 'To Do', 'Low', '2025-11-15', 2);

INSERT INTO Comment (Content, UserID, TaskID) VALUES
('Гарна робота, продовжуйте!', 1, 1),
('Потрібно оновити кольори.', 3, 3),
('Додай ще одне поле у форму.', 2, 1);

INSERT INTO Tag (TagName, Color) VALUES
('Frontend', 'blue'),
('Backend', 'green'),
('Urgent', 'red');

INSERT INTO Task_Assignee (UserID, TaskID) VALUES
(1, 1),
(2, 1),
(3, 3);

INSERT INTO Task_Tag (TaskID, TagID) VALUES
(1, 2),
(2, 1),
(3, 3);

INSERT INTO Project_User (ProjectID, UserID, Role) VALUES
(1, 1, 'Manager'),
(1, 2, 'Developer'),
(2, 3, 'Designer');

INSERT INTO Team_User (TeamID, UserID) VALUES
(1, 1),
(1, 2),
(2, 3);
