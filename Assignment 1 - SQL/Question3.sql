-- Populate tables
CREATE TABLE IF NOT EXISTS Suppliers(
    sid INTEGER NOT NULL PRIMARY KEY,
    sname TEXT NOT NULL,
    address TEXT NOT NULL
);

INSERT INTO Suppliers VALUES(1, 'Walmart', '12 Baker Street');
INSERT INTO Suppliers VALUES(2, 'Canada Suppliers', '45 Loser Street');
INSERT INTO Suppliers VALUES(3, 'SuperCenter', '1065 Military Trail');
INSERT INTO Suppliers VALUES(4, 'Food Basics', '420 Sheppard Avenue');
INSERT INTO Suppliers VALUES(5, 'Costco', '69 Markham Road');
INSERT INTO Suppliers VALUES(6, 'Tiger', '70 Markham Road');

CREATE TABLE IF NOT EXISTS Parts(
    pid INTEGER NOT NULL PRIMARY KEY,
    pname TEXT NOT NULL,
    color TEXT
);

INSERT INTO Parts VALUES(10, 'Brake', 'black');
INSERT INTO Parts VALUES(20, 'Accelerator', 'red');
INSERT INTO Parts VALUES(30, 'Wiper', 'green');
INSERT INTO Parts VALUES(40, 'Glass', 'white');
INSERT INTO Parts VALUES(50, 'Antenna', 'red');

CREATE TABLE IF NOT EXISTS Catalog(
    sid INTEGER NOT NULL,
    pid INTEGER NOT NULL,
    cost REAL NOT NULL,
    PRIMARY KEY(sid, pid),
    FOREIGN KEY(sid) REFERENCES Suppliers(sid),
    FOREIGN KEY(pid) REFERENCES Parts(pid)
);

INSERT INTO Catalog VALUES(1,20, 50);
INSERT INTO Catalog VALUES(1,50, 100);
INSERT INTO Catalog VALUES(2,40, 1000);
INSERT INTO Catalog VALUES(2,30, 950);
INSERT INTO Catalog VALUES(2,20, 50);
INSERT INTO Catalog VALUES(3,30, 20);
INSERT INTO Catalog VALUES(3,20, 20);
INSERT INTO Catalog VALUES(4,50, 120);
INSERT INTO Catalog VALUES(4,20, 100);
INSERT INTO Catalog VALUES(5,10, 50);
INSERT INTO Catalog VALUES(5,20, 87);
INSERT INTO Catalog VALUES(5,30, 45);
INSERT INTO Catalog VALUES(5,40, 242);
INSERT INTO Catalog VALUES(5,50, 900);
INSERT INTO Catalog VALUES(6,10, 50);
INSERT INTO Catalog VALUES(6,20, 87);
INSERT INTO Catalog VALUES(6,30, 45);
INSERT INTO Catalog VALUES(6,40, 242);
INSERT INTO Catalog VALUES(6,50, 900);

-- i Find the names of the suppliers who supply some red part

SELECT DISTINCT S.sname
FROM Suppliers S, Parts P, Catalog C
WHERE P.color='red' AND C.pid = P.pid AND C.sid = S.sid;

-- ii Find the sids of suppliers who supply some red or green part

SELECT DISTINCT C.sid
FROM Catalog C, Parts P
WHERE (P.color = 'red' OR P.color = 'green') AND P.pid = C.pid;

-- iii Find the sids of suppliers who supply some red part or are at 1065 Military Trail
SELECT DISTINCT C.sid
FROM Catalog as C, Parts as P
WHERE P.color = 'red' AND P.pid = C.pid
UNION
SELECT sid
FROM Suppliers
WHERE address = '1065 Military Trail';

-- iv Find the sids of suppliers who supply some red part and some green part

SELECT DISTINCT C.sid
FROM Catalog C, Parts P
WHERE P.color = 'red' AND P.pid = C.pid
INTERSECT
SELECT C.sid
FROM Catalog C, Parts P
WHERE P.color = 'green' AND P.pid = C.pid;

-- v Find the sids of suppliers who supply every part 

SELECT DISTINCT sup.sid 
FROM suppliers AS sup 
INNER JOIN Catalog AS cat 
ON sup.sid = cat.sid 
GROUP BY sup.sname 
HAVING COUNT(cat.pid)=(SELECT COUNT(pid) FROM Parts)
;


-- vi Find the sids of suppliers who supply every red part

SELECT DISTINCT cat.sid
FROM Catalog as cat
WHERE NOT EXISTS
    (SELECT pat.pid
    FROM Parts as pat
    WHERE pat.color = 'red' AND  NOT EXISTS
        (SELECT cat1.sid
        FROM Catalog as cat1
        WHERE cat1.sid = cat.sid AND cat1.pid = pat.pid));

 -- vii Find the sids of suppliers who supply every red or green part
 
SELECT DISTINCT C.sid
FROM Catalog C
WHERE NOT EXISTS
    (SELECT P.pid
    FROM Parts P
    WHERE (P.color = 'red' OR P.color = 'green') AND  NOT EXISTS
        (SELECT C1.sid
        FROM Catalog C1
        WHERE C1.sid = C.sid AND C1.pid = P.pid ));

 -- viii Find the sids of suppliers who supply every red part or every green part
SELECT DISTINCT cat.sid
FROM Catalog as cat
WHERE NOT EXISTS
    (SELECT pat.pid
    FROM Parts as pat
    WHERE pat.color = 'red' AND NOT EXISTS
        (SELECT cat1.sid
        FROM Catalog as cat1
        WHERE cat1.sid = cat.sid AND cat1.pid = pat.pid)
    )
UNION
SELECT cat.sid
FROM Catalog as cat
WHERE NOT EXISTS
    (SELECT pat.pid
    FROM Parts as pat
    WHERE pat.color = 'green' AND NOT EXISTS
        (SELECT cat1.sid
        FROM Catalog as cat1
        WHERE cat1.sid = cat.sid AND cat1.pid = pat.pid)
)
;
 
 -- ix  Find pairs of sids such that the supplier with the first sid charges more for some part thanthe supplier with the second sid 
SELECT A.sid, B.sid
FROM Catalog A, Catalog B
WHERE A.pid=B.pid AND A.sid != B.sid AND A.cost > B.cost; 
 
 -- x Find Find the pids of parts supplied by at least two different suppliers
SELECT DISTINCT A.pid
FROM Catalog A, Catalog B
WHERE A.pid=B.pid AND A.sid != B.sid;  
 
-- xi  Find the pid of the most expensive parts supplied by suppliers name Canada Suppliers

CREATE TEMP VIEW r1
AS SELECT *FROM Suppliers
NATURAL JOIN Catalog
WHERE sname = 'Canada Suppliers'
;

SELECT pid 
FROM r1 as expensive
WHERE expensive.cost=(SELECT MAX(exp.cost)
                          FROM r1 as exp)
;

DROP VIEW r1;

-- xii Find the pids of parts supplied by every supplier at less than $200 

CREATE TEMP VIEW r1 AS SELECT * FROM Catalog WHERE cost < 200;

CREATE TEMP VIEW r2 AS SELECT R1.pid, R1.sid FROM r1 AS R1 GROUP BY R1.pid HAVING COUNT(R1.sid)=(SELECT COUNT(sid) FROM Suppliers);

SELECT DISTINCT r2.pid FROM r2;

DROP VIEW r1;
DROP VIEW r2;

