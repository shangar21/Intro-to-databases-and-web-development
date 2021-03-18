--- Creating Tables
CREATE TABLE IF NOT EXISTS Flights (
    flno integer PRIMARY KEY,
    'from' text NOT NULL,
    'to' text NOT NULL,
    distance integer,
    departs time,
    arrives time);

CREATE TABLE IF NOT EXISTS Aircraft (
    aid integer PRIMARY KEY,
    aname text NOT NULL,
    cruisingrange integer);

CREATE TABLE IF NOT EXISTS Certified (
    eid integer,
    aid integer);

CREATE TABLE IF NOT EXISTS Employees (
    eid integer PRIMARY KEY,
    ename text NOT NULL,
    salary integer);

-- populate Aircraft table

INSERT INTO Aircraft (aid, aname, cruisingrange) 
    VALUES (11, 'Boeing', 4000);

INSERT INTO Aircraft (aid, aname, cruisingrange)
    VALUES (12, 'Airbus', 4000);

INSERT INTO Aircraft (aid, aname, cruisingrange)
    VALUES (13, 'Bombardier', 2000);
    
INSERT INTO Aircraft (aid, aname, cruisingrange)
    VALUES (14, 'Tupolev', 3000);

INSERT INTO Aircraft (aid, aname, cruisingrange)
    VALUES (15, 'Embraer', 3001);

-- populate Employees table

INSERT INTO Employees (eid, ename, salary)
    VALUES (21, 'John Smith', 100000);

INSERT INTO Employees (eid, ename, salary)
    VALUES (22, 'Bently Vickers', 100000);

INSERT INTO Employees (eid, ename, salary)
    VALUES (23, 'Zahra Dupont', 99000);

INSERT INTO Employees (eid, ename, salary)
    VALUES (24, 'Mark Craft', 150000);

INSERT INTO Employees (eid, ename, salary)
    VALUES (25, 'Janine Hughes', 150000);
    
INSERT INTO Employees (eid, ename, salary)
    VALUES (26, 'Austen Lowry', 150000);

INSERT INTO Employees (eid, ename, salary)
    VALUES (27, 'Cohan Gomez', 140000);

INSERT INTO Employees (eid, ename, salary)
    VALUES (28, 'Tina Sims', 140000);

-- populate Certified table

INSERT INTO Certified (eid, aid)
    Values (21,12);

INSERT INTO Certified (eid, aid)
    Values (21,13);

INSERT INTO Certified (eid, aid)
    Values (21,14);

INSERT INTO Certified (eid, aid)
    Values (22,12);

INSERT INTO Certified (eid, aid)
    Values (22,14);

INSERT INTO Certified (eid, aid)
    Values (22,15);

INSERT INTO Certified (eid, aid)
    Values (23,11);

INSERT INTO Certified (eid, aid)
    Values (23,12);

INSERT INTO Certified (eid, aid)
    VALUES (24,11);
    
INSERT INTO Certified (eid, aid)
    VALUES (24,12);
    
INSERT INTO Certified (eid, aid)
    VALUES (24,13);
    
INSERT INTO Certified (eid, aid)
    VALUES (24,14);
    
INSERT INTO Certified (eid, aid)
    VALUES (24,15);
    
INSERT INTO Certified (eid, aid)
    VALUES (25,11);
    
INSERT INTO Certified (eid, aid)
    VALUES (25,12);
    
INSERT INTO Certified (eid, aid)
    VALUES (25,13);
    
INSERT INTO Certified (eid, aid)
    VALUES (25,14);
    
INSERT INTO Certified (eid, aid)
    VALUES (25,15);

INSERT INTO Certified (eid, aid)
    Values (26,13);

INSERT INTO Certified (eid, aid)
    Values (27,14);

INSERT INTO Certified (eid, aid)
    Values (28,15);

-- populate flights table
INSERT INTO Flights (flno, 'from', 'to', distance, departs, arrives)
    VALUES (31, 'Bonn', 'Madras', 3000, '10:00', '4:00');
    
INSERT INTO Flights (flno, 'from', 'to', distance, departs, arrives)
    VALUES (32, 'Toronto', 'Madrid', 2000, '10:00', '15:00');

INSERT INTO Flights (flno, 'from', 'to', distance, departs, arrives)
    VALUES (33, 'Toronto', 'Shanghai', 4000, '10:00', '15:00');

INSERT INTO Flights (flno, 'from', 'to', distance, departs, arrives)
    VALUES (34, 'Brazil', 'Tokyo', 5000, '10:00', '15:00');
    
-- i. Find the eids of pilots certied for some Boeing aircraft
SELECT eid
FROM Aircraft
NATURAL JOIN Certified
WHERE aname='Boeing';

-- ii. Find the names of pilots certified for some Boeing aircraft
SELECT ename
FROM Aircraft
NATURAL JOIN Certified
NATURAL JOIN Employees
WHERE aname='Boeing';

-- iii. Find the aids of all aircraft that can be used on non-stop flights from Bonn to Madras 
SELECT a.aid
FROM Aircraft as a, Flights as f
WHERE f.'from' = 'Bonn' AND f.'to' = 'Madras' AND a.cruisingrange>f.distance;


-- iv. Identify the flights that can be piloted by every pilot whose salary is more than $100,000.
SELECT DISTINCT fly.flno
FROM Aircraft as air, Certified as cer, Employees as emp, Flights as fly
WHERE emp.eid = cer.eid AND air.aid=cer.aid AND fly.distance<air.cruisingrange AND emp.salary>100000; 

-- v. Find the names of pilots who can operate planes with a range greater than 3,000 miles but are NOT certified on any Boeing aircraft

CREATE TEMP VIEW r1
AS SELECT eid
FROM Aircraft
NATURAL JOIN Certified
WHERE cruisingrange>3000;

CREATE TEMP VIEW r2
AS SELECT eid
FROM Aircraft
NATURAL JOIN Certified
WHERE aname='Boeing';

CREATE TEMP VIEW r3
AS SELECT eid FROM r1 
EXCEPT 
SELECT eid 
FROM r2;

CREATE TEMP VIEW r4 
AS SELECT ename
FROM r3 
NATURAL JOIN Employees; 

SELECT *FROM r4;
drop view r1;
drop view r2;
drop view r3;
drop view r4;


-- vi. Find the eids of employees who make the highest salary
SELECT eid
FROM Employees as emp1
WHERE emp1.salary= (SELECT MAX(emp2.salary)
		       FROM Employees as emp2)
;

-- vii. Find the eids of employees who make the second highest salary

CREATE TEMP VIEW r1 
AS SELECT *FROM
Employees as emp1
WHERE emp1.salary= (SELECT MAX(emp2.salary)
		       FROM Employees as emp2)
;

CREATE TEMP VIEW r2
AS SELECT *FROM Employees
EXCEPT
SELECT *FROM r1;

CREATE TEMP VIEW r3
AS SELECT eid
FROM r2 as emp3
WHERE emp3.salary= (SELECT MAX(emp4.salary)
		       FROM r2 as emp4)
; 

SELECT *FROM r3;
drop view r1;
drop view r2;
drop view r3;

-- viii. Find the eids of employees who are certified for the largest number of aircraft
CREATE TEMP VIEW largest
AS SELECT cer.eid, COUNT(cer.aid) as cntr
      FROM Certified AS cer
      GROUP BY cer.eid
;

SELECT eid
FROM largest as emp1
WHERE emp1.cntr= (SELECT MAX(emp2.cntr)
		       FROM largest as emp2)
;


-- ix. Find the eids of employees who are certified for exactly three aircraft

SELECT eid
FROM largest
WHERE cntr = 3;
drop view largest;

-- x. Find the total amount paid to employees as salaries
SELECT SUM(salary)
FROM Employees;
