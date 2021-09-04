SELECT D.DEPARTMENT, 
CASE
	WHEN P.GENDER = 'E' THEN 'MALE'
	ELSE 'FEMALE'
END GENDER_,
 COUNT(P.ID) AS PERSON_COUNT 
FROM PERSON P
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
GROUP BY D.DEPARTMENT, P.GENDER,P.OUTDATE
HAVING OUTDATE IS NULL
ORDER BY D.DEPARTMENT

------------------------ or

SELECT D.DEPARTMENT, 
CASE 
	WHEN GENDER = 'E' THEN 'ERKEK'
	ELSE 'KADIN'
END GENDER,
COUNT(P.ID) AS PERSONCOUNT
FROM PERSON P
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
JOIN POSITION POS ON POS.ID = P.POSITIONID
WHERE P.OUTDATE IS NULL
GROUP BY D.DEPARTMENT, P.GENDER
ORDER BY D.DEPARTMENT, P.GENDER

------------------------ or
SELECT D.DEPARTMENT, P.GENDER, COUNT(P.ID) AS PERSON_COUNT 
FROM PERSON P
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
GROUP BY D.DEPARTMENT, P.GENDER,P.OUTDATE
HAVING OUTDATE IS NULL
ORDER BY D.DEPARTMENT

------------------------------------------------------------------------------------


SELECT D.DEPARTMENT,
(SELECT COUNT(P.ID) FROM PERSON P WHERE D.ID = P.DEPARTMENTID AND P.GENDER = 'E'
AND P.OUTDATE IS NULL) AS MALE_PERSONCOUNT,
(SELECT COUNT(P.ID) FROM PERSON P WHERE D.ID = P.DEPARTMENTID AND P.GENDER = 'K' 
AND P.OUTDATE IS NULL) AS FEMALE_PERSONCOUNT
FROM DEPARTMENT D
ORDER BY D.DEPARTMENT


------------------------------------------------------------------------------------

SELECT POS.POSITION, MIN(P.SALARY) AS MIN_SALARY, MAX(P.SALARY) AS MAX_SALARY, ROUND(AVG(SALARY),0) AS AVG_SALARY 
FROM PERSON P
JOIN POSITION POS ON POS.ID = P.POSITIONID
WHERE POS.POSITION = 'PLANLAMA ÞEFÝ'
GROUP BY POS.POSITION


SELECT POS.POSITION, MIN(P.SALARY) AS MIN_SALARY, MAX(P.SALARY) AS MAX_SALARY, ROUND(AVG(P.SALARY),0) AS AVG_SALARY
FROM PERSON P
JOIN POSITION POS ON POS.ID = P.POSITIONID
GROUP BY POS.POSITION
HAVING POS.POSITION = 'PLANLAMA ÞEFÝ' 

-- SUBQUERY

SELECT POS.POSITION,
(SELECT MIN(P.SALARY) FROM PERSON P WHERE POS.ID = P.POSITIONID) AS MIN_SALARY,
(SELECT MAX(P.SALARY) FROM PERSON P WHERE POS.ID = P.POSITIONID) AS MAX_SALARY,
(SELECT ROUND(AVG(P.SALARY),0) FROM PERSON P WHERE POS.ID = P.POSITIONID) AS AVG_SALARY
FROM POSITION POS
WHERE POS.POSITION = 'PLANLAMA ÞEFÝ'

------------------------------------------------------------------------------------

SELECT PS.POSITION, COUNT(P.ID) AS PERSONCOUNT, ROUND(AVG(P.SALARY),0) AS AVG_SALARY 
FROM PERSON P
JOIN POSITION PS ON PS.ID = P.POSITIONID
GROUP BY PS.POSITION,P.OUTDATE
HAVING P.OUTDATE IS NULL

--2.
SELECT PS.POSITION, COUNT(P.ID) AS PERSONCOUNT, ROUND(AVG(P.SALARY),0) AS AVG_SALARY 
FROM PERSON P
JOIN POSITION PS ON PS.ID = P.POSITIONID
WHERE P.OUTDATE IS NULL
GROUP BY PS.POSITION

--3. SUBQUERY

SELECT PS.POSITION,
(SELECT COUNT(P.ID) FROM PERSON P WHERE PS.ID = P.POSITIONID AND P.OUTDATE IS NULL) AS PERSON_COUNT,
(SELECT ROUND(AVG(P.SALARY),0) FROM PERSON P WHERE PS.ID = P.POSITIONID AND P.OUTDATE IS NULL) AS AVG_SALARY
FROM POSITION PS
ORDER BY PS.POSITION


-------------------------------------------------------------------------------------

SELECT DISTINCT(YEAR(P.INDATE)) AS YEAR_,
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'E' AND YEAR(INDATE) = YEAR(P.INDATE)) AS MALE_PERSON ,
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'K' AND YEAR(INDATE) = YEAR(P.INDATE)) AS FEMALE_PERSON
FROM PERSON P 
ORDER BY 1



--- ## NUMBER OF MALE AND FEMALE RECRUITMENTS BY MONTH AND YEARS

SELECT DISTINCT YEAR(P.INDATE) AS YEAR_ , MONTH(P.INDATE) AS MONTH_,
(SELECT COUNT(ID) FROM PERSON WHERE YEAR(P.INDATE) = YEAR(INDATE) AND MONTH(P.INDATE) = MONTH(INDATE) AND GENDER = 'E') AS MALECOUNT,
(SELECT COUNT(ID) FROM PERSON WHERE YEAR(P.INDATE) = YEAR(INDATE) AND MONTH(P.INDATE) = MONTH(INDATE) AND GENDER = 'K') AS FEMALECOUNT
FROM PERSON P
ORDER BY YEAR_


--- # LEFT THE JOB / STILL WORKING BY YEARS
SELECT DISTINCT YEAR(P.INDATE) AS YEAR_,
(SELECT COUNT(ID) FROM PERSON WHERE YEAR(P.INDATE) = YEAR(INDATE) AND OUTDATE IS NULL AND GENDER = 'E') AS WORKING_MALE_COUNT_BY_YEARS,
(SELECT COUNT(ID) FROM PERSON WHERE YEAR(P.INDATE) = YEAR(INDATE) AND OUTDATE IS NULL AND GENDER = 'K') AS WORKING_FEMALE_COUNT_BY_YEARS,
(SELECT COUNT(ID) FROM PERSON WHERE YEAR(P.INDATE) = YEAR(INDATE) AND OUTDATE IS NOT NULL AND GENDER = 'E') AS LEFTJOB_MALE_COUNT_BY_YEARS,
(SELECT COUNT(ID) FROM PERSON WHERE YEAR(P.INDATE) = YEAR(INDATE) AND OUTDATE IS NOT NULL AND GENDER = 'K') AS LEFTJOB_FEMALE_COUNT_BY_YEARS
FROM PERSON P
ORDER BY YEAR_

--- # According to Q1, Q2, Q3 AND Q4, how many people were recruited on a yearly basis?

SELECT DISTINCT YEAR(V.INDATE) AS YEAR_, V.QUARTERS, COUNT(ID) AS PERSON_COUNT
FROM
(
SELECT *,
CASE
	WHEN MONTH(INDATE) BETWEEN 1 AND 3 THEN 'Q1'
	WHEN MONTH(INDATE) BETWEEN 4 AND 6 THEN 'Q2'
	WHEN MONTH(INDATE) BETWEEN 7 AND 9 THEN 'Q3'
	WHEN MONTH(INDATE) BETWEEN 10 AND 12 THEN 'Q4'
END QUARTERS
FROM PERSON P
)V
GROUP BY YEAR(V.INDATE), V.QUARTERS
ORDER BY YEAR_, QUARTERS

--VALIDATION Recruitment based on Years
SELECT DISTINCT YEAR(P.INDATE) AS YEAR_,
(SELECT COUNT(ID) FROM PERSON WHERE YEAR(P.INDATE) = YEAR(INDATE)) AS PERSON_COUNT
FROM PERSON P
ORDER BY YEAR_

-------------------------------------------------------------------------------------


SELECT NAME_ + ' ' + SURNAME AS PERSON, INDATE, OUTDATE,
CASE
	WHEN OUTDATE IS NOT NULL THEN DATEDIFF(MONTH,INDATE,OUTDATE)
	ELSE DATEDIFF(MONTH,INDATE,GETDATE())
END WORKINGTIME
FROM PERSON

-- CONCAT İLE BİRLEŞTİRME
SELECT CONCAT(NAME_,' ',SURNAME) AS PERSON, INDATE, OUTDATE,

CASE
	WHEN OUTDATE IS NOT NULL THEN DATEDIFF(MONTH,INDATE,OUTDATE)
	ELSE DATEDIFF(MONTH,INDATE,GETDATE())
END WORKINGTIME
FROM PERSON



----- 2. with UNION

SELECT NAME_ + ' ' + SURNAME AS PERSON, INDATE,OUTDATE, DATEDIFF(MONTH,INDATE,GETDATE()) AS WORKINGTIME
FROM PERSON 
WHERE OUTDATE IS NULL

UNION ALL

SELECT NAME_ + ' ' + SURNAME AS PERSON, INDATE,OUTDATE, DATEDIFF(MONTH,INDATE,OUTDATE) AS WORKINGTIME
FROM PERSON 
WHERE OUTDATE IS NOT NULL


----  LEFT THE JOB / STILL WORKING

SELECT NAME_ + ' ' + SURNAME AS PERSON, INDATE, OUTDATE, DATEDIFF(MONTH,INDATE,OUTDATE) AS WORKINGTIME,
'LEFT THE JOB' AS WORKINGSTATUS
FROM PERSON 
WHERE OUTDATE IS NOT NULL
UNION ALL
SELECT NAME_ + ' ' + SURNAME AS PERSON, INDATE, OUTDATE, DATEDIFF(MONTH,INDATE,GETDATE()) AS WORKINGTIME,
'STILL WORKING' AS WORKINGSTATUS
FROM PERSON 
WHERE OUTDATE IS NULL


-------------------------------------------------------------------------------------



SELECT  LEFT(NAME_,1) + '.' +  LEFT(SURNAME,1)+ '.',
COUNT(*) AS PERSONCOUNT
FROM PERSON
GROUP BY LEFT(NAME_,1) + '.' +  LEFT(SURNAME,1)+ '.'
ORDER BY COUNT(*) DESC


--- OR 

SELECT DISTINCT LEFT(NAME_,1) + '.' + LEFT(SURNAME,1) + '.' AS SHORTNAME, COUNT(ID) AS PERSON_COUNT
FROM PERSON
GROUP BY LEFT(NAME_,1) + '.' + LEFT(SURNAME,1) + '.'
ORDER BY PERSON_COUNT DESC


--- OR  WITH SUBSTRING

SELECT DISTINCT SUBSTRING(NAME_,1,1) + '.' + SUBSTRING(SURNAME,1,1) + '.', COUNT(ID) AS CUSTOMER_COUNT
FROM PERSON
GROUP BY SUBSTRING(NAME_,1,1) + '.' + SUBSTRING(SURNAME,1,1) + '.'
ORDER BY CUSTOMER_COUNT DESC


-------------------------------------------------------------------------------------

SELECT D.DEPARTMENT, ROUND(AVG(P.SALARY),0) 
FROM PERSON P
JOIN POSITION PS ON PS.ID = P.POSITIONID
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
GROUP BY D.DEPARTMENT
HAVING AVG(P.SALARY) > 5500
ORDER BY D.DEPARTMENT


-- 2. SUBQUERY
SELECT D.DEPARTMENT,
(SELECT ROUND(AVG(P.SALARY),0) FROM PERSON P WHERE D.ID = P.DEPARTMENTID) AS AVG_SALARY
FROM DEPARTMENT D 
WHERE (SELECT ROUND(AVG(P.SALARY),0) FROM PERSON P WHERE D.ID = P.DEPARTMENTID) > 5500
ORDER BY D.DEPARTMENT

-- 3. DYNAMIC VIEW
SELECT * FROM
(
SELECT D.DEPARTMENT, ROUND(AVG(P.SALARY),0) AS AVG_SALARY
FROM PERSON P
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
GROUP BY D.DEPARTMENT
) V WHERE AVG_SALARY > 5500
ORDER BY V.DEPARTMENT

-------------------------------------------------------------------------------------

