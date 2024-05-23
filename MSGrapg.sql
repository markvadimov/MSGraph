USE MASTER
GO
DROP DATABASE IF EXISTS MSGraph
GO
CREATE DATABASE MSGraph
GO
USE MSGraph
GO

-- Создание таблицы Professor
CREATE TABLE Professor (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    department VARCHAR(255) NOT NULL
) AS NODE;

-- Создание таблицы Research
CREATE TABLE Research (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    start_year INT NOT NULL
) AS NODE;

-- Создание таблицы Student
CREATE TABLE Student (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    year INT NOT NULL
) AS NODE;

-- Вставка данных в таблицу Professor
INSERT INTO Professor (name, department) VALUES
('Dr. Alice Johnson', 'Computer Science'),
('Dr. Bob Smith', 'Physics'),
('Dr. Charlie Brown', 'Chemistry'),
('Dr. Emily White', 'Biology'),
('Dr. Frank Black', 'Mathematics'),
('Dr. Grace Green', 'Engineering'),
('Dr. Henry Blue', 'History'),
('Dr. Isabel Red', 'Economics'),
('Dr. Jack Yellow', 'Political Science'),
('Dr. Karen Purple', 'Psychology');

-- Вставка данных в таблицу Research
INSERT INTO Research (name, start_year) VALUES
('AI in Healthcare', 2022),
('Quantum Computing', 2021),
('Organic Chemistry Synthesis', 2023),
('Genetic Sequencing', 2020),
('Statistical Methods', 2019),
('Robotics and Automation', 2022),
('Medieval History Analysis', 2021),
('Global Financial Markets', 2018),
('Electoral Systems', 2017),
('Cognitive Behavioral Therapy', 2019);

-- Вставка данных в таблицу Student
INSERT INTO Student (name, year) VALUES
('John Doe', 3),
('Jane Smith', 2),
('Emily Davis', 1),
('Michael Brown', 4),
('Sarah Wilson', 2),
('David Johnson', 3),
('Laura Garcia', 1),
('James Martinez', 4),
('Emma Rodriguez', 3),
('Oliver Hernandez', 2);

CREATE TABLE Performs AS EDGE;

CREATE TABLE Participates AS EDGE;

CREATE TABLE Works AS EDGE;

	INSERT INTO Performs ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Professor WHERE ID = 1),
 (SELECT $node_id FROM Research WHERE ID = 6)),
 ((SELECT $node_id FROM Professor WHERE ID = 5),
 (SELECT $node_id FROM Research WHERE ID = 1)),
 ((SELECT $node_id FROM Professor WHERE ID = 8),
 (SELECT $node_id FROM Research WHERE ID = 7)),
 ((SELECT $node_id FROM Professor WHERE ID = 2),
 (SELECT $node_id FROM Research WHERE ID = 2)),
 ((SELECT $node_id FROM Professor WHERE ID = 3),
 (SELECT $node_id FROM Research WHERE ID = 5)),
 ((SELECT $node_id FROM Professor WHERE ID = 4),
 (SELECT $node_id FROM Research WHERE ID = 3)),
 ((SELECT $node_id FROM Professor WHERE ID = 6),
 (SELECT $node_id FROM Research WHERE ID = 4)),
 ((SELECT $node_id FROM Professor WHERE ID = 7),
 (SELECT $node_id FROM Research WHERE ID = 2)),
 ((SELECT $node_id FROM Professor WHERE ID = 1),
 (SELECT $node_id FROM Research WHERE ID = 9)),
 ((SELECT $node_id FROM Professor WHERE ID = 9),
 (SELECT $node_id FROM Research WHERE ID = 8)),
 ((SELECT $node_id FROM Professor WHERE ID = 10),
 (SELECT $node_id FROM Research WHERE ID = 10));

 INSERT INTO Participates ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Student WHERE ID = 1),
 (SELECT $node_id FROM Research WHERE ID = 6)),
 ((SELECT $node_id FROM Student WHERE ID = 5),
 (SELECT $node_id FROM Research WHERE ID = 1)),
 ((SELECT $node_id FROM Student WHERE ID = 8),
 (SELECT $node_id FROM Research WHERE ID = 7)),
 ((SELECT $node_id FROM Student WHERE ID = 2),
 (SELECT $node_id FROM Research WHERE ID = 2)),
 ((SELECT $node_id FROM Student WHERE ID = 3),
 (SELECT $node_id FROM Research WHERE ID = 5)),
 ((SELECT $node_id FROM Student WHERE ID = 4),
 (SELECT $node_id FROM Research WHERE ID = 3)),
 ((SELECT $node_id FROM Student WHERE ID = 6),
 (SELECT $node_id FROM Research WHERE ID = 4)),
 ((SELECT $node_id FROM Student WHERE ID = 7),
 (SELECT $node_id FROM Research WHERE ID = 2)),
 ((SELECT $node_id FROM Student WHERE ID = 1),
 (SELECT $node_id FROM Research WHERE ID = 9)),
 ((SELECT $node_id FROM Student WHERE ID = 9),
 (SELECT $node_id FROM Research WHERE ID = 8)),
 ((SELECT $node_id FROM Student WHERE ID = 10),
 (SELECT $node_id FROM Research WHERE ID = 10));

 INSERT INTO Works ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Professor WHERE ID = 1),
 (SELECT $node_id FROM Professor WHERE ID = 6)),
 ((SELECT $node_id FROM Professor WHERE ID = 5),
 (SELECT $node_id FROM Professor WHERE ID = 1)),
 ((SELECT $node_id FROM Professor WHERE ID = 8),
 (SELECT $node_id FROM Professor WHERE ID = 7)),
 ((SELECT $node_id FROM Professor WHERE ID = 2),
 (SELECT $node_id FROM Professor WHERE ID = 4)),
 ((SELECT $node_id FROM Professor WHERE ID = 3),
 (SELECT $node_id FROM Professor WHERE ID = 5)),
 ((SELECT $node_id FROM Professor WHERE ID = 4),
 (SELECT $node_id FROM Professor WHERE ID = 3)),
 ((SELECT $node_id FROM Professor WHERE ID = 6),
 (SELECT $node_id FROM Professor WHERE ID = 4)),
 ((SELECT $node_id FROM Professor WHERE ID = 7),
 (SELECT $node_id FROM Professor WHERE ID = 2)),
 ((SELECT $node_id FROM Professor WHERE ID = 1),
 (SELECT $node_id FROM Professor WHERE ID = 9)),
 ((SELECT $node_id FROM Professor WHERE ID = 9),
 (SELECT $node_id FROM Professor WHERE ID = 8)),
 ((SELECT $node_id FROM Professor WHERE ID = 10),
 (SELECT $node_id FROM Professor WHERE ID = 9));

SELECT P1.name, P2.name
FROM Professor AS P1
	, Works AS W
	, Professor AS P2
WHERE MATCH(P1-(W)->P2)
	AND P1.name = 'Dr. Alice Johnson';

SELECT P.name, R.name
FROM Professor AS P
	, Performs Ps
	, Research AS R
WHERE MATCH(P-(Ps)->R)
	AND P.name = 'Dr. Alice Johnson';

SELECT P.name, R.name
FROM Professor AS P
	, Performs Ps
	, Research AS R
WHERE MATCH(P-(Ps)->R)
	AND R.name = 'Quantum Computing';

SELECT S.name, R.name
FROM Student AS S
	, Participates Ps
	, Research AS R
WHERE MATCH(S-(Ps)->R)
	AND S.name = 'John Doe';

SELECT S.name, R.name
FROM Student AS S
	, Participates Ps
	, Research AS R
WHERE MATCH(S-(Ps)->R)
	AND R.name = 'Quantum Computing';

	SELECT P1.name
 , STRING_AGG(P2.name, '->') WITHIN GROUP (GRAPH PATH)
AS Coopers
FROM Professor AS P1
	, Works FOR PATH AS W
	, Professor FOR PATH AS P2
WHERE MATCH(SHORTEST_PATH(P1(-(W)->P2)+))
 AND P1.name = 'Dr. Alice Johnson';

	SELECT P1.name
 , STRING_AGG(P2.name, '->') WITHIN GROUP (GRAPH PATH)
AS Coopers
FROM Professor AS P1
	, Works FOR PATH AS W
	, Professor FOR PATH AS P2
WHERE MATCH(SHORTEST_PATH(P1(-(W)->P2){1,3}))
 AND P1.name = 'Dr. Karen Purple';

  SELECT P1.id AS IdFirst
	, P1.name AS First
	, CONCAT(N'professor (', P1.id, ')') AS [First image name]
	, P2.id AS IdSecond
	, P2.name AS Second
	, CONCAT(N'professor (', P2.id, ')') AS [Second image name]
FROM Professor AS P1
	, Works AS W
	, Professor AS P2
WHERE MATCH(P1-(W)->P2)

 SELECT P.id AS IdFirst
	, P.name AS First
	, CONCAT(N'professor (',P.id, ')') AS [First image name]
	, R.id AS IdSecond
	, R.name AS Second
	, CONCAT(N'research (', R.id, ')') AS [Second image name]
FROM Professor AS P
	, Performs Ps
	, Research AS R
WHERE MATCH(P-(Ps)->R)

 SELECT S.id AS IdFirst
	, S.name AS First
	, CONCAT(N'student (', S.id, ')') AS [First image name]
	, R.id AS IdSecond
	, R.name AS Second
	, CONCAT(N'research (', R.id, ')') AS [Second image name]
FROM Student AS S
	, Participates Ps
	, Research AS R
WHERE MATCH(S-(Ps)->R)

select @@servername