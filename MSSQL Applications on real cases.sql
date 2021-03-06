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
------------------------ or -

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
WHERE POS.POSITION = 'PLANLAMA SEFİ'

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

SELECT V.DEPARTMENT, AVG(V.WORKINGTIME) FROM
(
SELECT D.DEPARTMENT,
CASE
	WHEN OUTDATE IS NOT NULL THEN DATEDIFF(MONTH,INDATE,OUTDATE)
	ELSE DATEDIFF(MONTH,INDATE,GETDATE())
END WORKINGTIME

FROM PERSON P
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
)V
GROUP BY V.DEPARTMENT
------------------------------------------------------------------------------------

SELECT P.NAME_ + ' ' + P.SURNAME AS PERSON,POS.POSITION,
P2.NAME_ + ' ' + P2.SURNAME AS MANAGER, POS2.POSITION AS MANAGERPOSITION

FROM PERSON P  
JOIN POSITION POS ON POS.ID = P.POSITIONID
JOIN PERSON P2 ON P.MANAGERID = P2.ID
JOIN POSITION POS2 ON POS2.ID = P2.POSITIONID

-----VALIDATION

SELECT P.NAME_ + ' ' + P.SURNAME AS PERSON,POS.POSITION,
P2.NAME_ + ' ' + P2.SURNAME AS MANAGER, POS2.POSITION AS MANAGERPOSITION

FROM PERSON P  
JOIN POSITION POS ON POS.ID = P.POSITIONID
JOIN PERSON P2 ON P.MANAGERID = P2.ID
JOIN POSITION POS2 ON POS2.ID = P2.POSITIONID
WHERE P.NAME_ + ' ' + P.SURNAME  IN ('Bünyamin OKTAYOĞLU', 'Emre ÜNNÜ', 'Birgül SAYIALİOĞLU', 'Edanur KURDOGLU')

-------------------------------------------------------------------------------------
SELECT * FROM CUSTOMERS
WHERE BIRTHDATE >= '19900101' AND BIRTHDATE <= '19951231'

-- 2. 
SELECT * FROM CUSTOMERS
WHERE BIRTHDATE BETWEEN '19900101' AND '19951231'

-- 3.
SELECT * FROM CUSTOMERS
WHERE YEAR(BIRTHDATE) >= 1990 AND YEAR(BIRTHDATE) <= 1995

-- 4.
SELECT * FROM CUSTOMERS
WHERE YEAR(BIRTHDATE) BETWEEN 1990 AND 1995

-- 5.
SELECT * FROM CUSTOMERS
WHERE DATEPART(YEAR, BIRTHDATE) >= 1990 AND DATEPART(YEAR, BIRTHDATE) <= 1995

-- 6.
SELECT * FROM CUSTOMERS
WHERE DATEPART(YEAR, BIRTHDATE) BETWEEN 1990 AND 1995

-------------------------------------------------------------------------------------
SELECT C.* , CI.CITY 
FROM CUSTOMERS C
JOIN CITIES CI ON C.CITYID = CI.ID
WHERE CI.CITY = 'İSTANBUL'

--SUBQUERY
SELECT C.CUSTOMERNAME,  
(SELECT CT.CITY FROM CITIES CT WHERE CT.ID = C.CITYID)
FROM CUSTOMERS C
WHERE (SELECT CT.CITY FROM CITIES CT WHERE CT.ID = C.CITYID) = 'İSTANBUL'

-- 2.
SELECT C.*,
(SELECT CT.CITY FROM CITIES CT WHERE CT.ID = C.CITYID)
FROM CUSTOMERS C 
WHERE C.CITYID = 34

-- 3.
SELECT C.*,
(SELECT CT.CITY FROM CITIES CT WHERE CT.ID = C.CITYID)
FROM CUSTOMERS C 
WHERE C.CITYID IN (SELECT CT.ID FROM CITIES CT WHERE CT.CITY = 'İSTANBUL')

-------------------------------------------------------------------------------------
SELECT CT.CITY, COUNT(C.ID) AS CUSTOMER_COUNT
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
GROUP BY CT.CITY


--SUBQUERY 2. YOL
SELECT CT.CITY,
(SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE C.CITYID = CT.ID) AS CUSTOMER_COUNT
FROM CITIES CT


SELECT CT.CITY, COUNT(C.ID) AS CUSTOMER_COUNT 
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
GROUP BY CT.CITY
ORDER BY CT.CITY

SELECT CT.CITY,
(SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE CT.ID = C.CITYID) AS CUSTOMER_COUNT
FROM CITIES CT
WHERE (SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE CT.ID = C.CITYID) > 0
ORDER BY CT.CITY
----------------------------------------------------------------------------------------

SELECT CT.CITY, COUNT(C.ID) AS CUSTOMER_COUNT
FROM CUSTOMERS C
RIGHT JOIN CITIES CT ON CT.ID = C.CITYID
GROUP BY CT.CITY
ORDER BY CT.CITY

SELECT CT.CITY, 
(SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE CT.ID = C.CITYID) AS CUSTOMER_COUNT
FROM CITIES CT
ORDER BY CT.CITY
---------------------------------------------------------------------------------------

SELECT CT.CITY, COUNT(C.ID) AS CUSTOMER_COUNT
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
GROUP BY CT.CITY
HAVING COUNT(C.ID) > 10
ORDER BY COUNT(C.ID) DESC

--  SUBQUERY

SELECT CT.CITY,
(SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE C.CITYID = CT.ID) AS CUSTOMER_COUNT
FROM CITIES CT
WHERE (SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE C.CITYID = CT.ID) > 10
ORDER BY (SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE C.CITYID = CT.ID) DESC
----------------------------------------------------------------------------------------
SELECT CT.CITY, C.GENDER, COUNT(C.ID) AS CUSTOMER_COUNT 
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
GROUP BY CT.CITY, C.GENDER
ORDER BY CT.CITY, C.GENDER

----------------------------------------------------------------------------------------

SELECT CT.CITY,
(SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE CT.ID = C.CITYID) AS TOTAL_COUNT,
(SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE CT.ID = C.CITYID AND C.GENDER = 'E') AS MALE_COUNT,
(SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE CT.ID = C.CITYID AND C.GENDER = 'K') AS FEMALE_COUNT
FROM CITIES CT
----------------------------------------------------------------------------------------

SELECT CT.CITY, COUNT(C.ID) AS CUSTOMER_COUNT
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
GROUP BY CT.CITY
HAVING COUNT(C.ID) > 10
ORDER BY COUNT(C.ID) DESC

-- 2. SUBQUERY

SELECT CT.CITY,
(SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE C.CITYID = CT.ID) AS CUSTOMER_COUNT
FROM CITIES CT
WHERE (SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE C.CITYID = CT.ID) > 10
ORDER BY (SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE C.CITYID = CT.ID) DESC
----------------------------------------------------------------------------------------
SELECT CT.CITY, C.GENDER, COUNT(C.ID) AS CUSTOMER_COUNT 
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
GROUP BY CT.CITY, C.GENDER
ORDER BY CT.CITY, C.GENDER
----------------------------------------------------------------------------------------
SELECT CT.CITY,
(SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE CT.ID = C.CITYID) AS TOTAL_COUNT,
(SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE CT.ID = C.CITYID AND C.GENDER = 'E') AS MALE_COUNT,
(SELECT COUNT(C.ID) FROM CUSTOMERS C WHERE CT.ID = C.CITYID AND C.GENDER = 'K') AS FEMALE_COUNT
FROM CITIES CT
----------------------------------------------------------------------------------------

-- If we could use Agegroup variable, it'd turn out to be;

SELECT AGEGROUP, COUNT(CUSTOMERS.ID) FROM 
CUSTOMERS
GROUP BY AGEGROUP
ORDER BY AGEGROUP

-- Let's get this result with dynamic view without using Agegroup variable.
SELECT 
CASE
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 20 AND 35 THEN '20-35 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 56 AND 65 THEN '56-65 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) > 65 THEN '65 YAŞ ÜSTÜ'

END AGEGROUP2,
COUNT(*) AS CUSTOMER_COUNT

FROM CUSTOMERS 
GROUP BY 
CASE
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 20 AND 35 THEN '20-35 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 56 AND 65 THEN '56-65 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) > 65 THEN '65 YAŞ ÜSTÜ'
END
ORDER BY AGEGROUP2

-- VİEW ! 


SELECT AGEGROUP2, COUNT(KLM.ID) AS CUSTOMER_COUNT FROM
(
SELECT *,
CASE
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 20 AND 35 THEN '20-35 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 56 AND 65 THEN '56-65 YAŞ ARASI'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) > 65 THEN '65 YAŞ ÜSTÜ'

END AGEGROUP2
FROM CUSTOMERS
) KLM			-- NAME OF THE VİEW

GROUP BY AGEGROUP2
ORDER BY AGEGROUP2


SELECT GS.AGEGROUP2, COUNT(GS.ID) AS CUSTOMER_COUNT, AVG(DATEDIFF(YEAR,BIRTHDATE,GETDATE())) AS MEAN_OF_AGE  FROM
(
SELECT  * ,
CASE
	WHEN DATEDIFF(YEAR,BIRTHDATE, GETDATE()) BETWEEN 20 AND 35 THEN '20-35 YAŞ'
	WHEN DATEDIFF(YEAR,BIRTHDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 YAŞ'
	WHEN DATEDIFF(YEAR,BIRTHDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 YAŞ'
	WHEN DATEDIFF(YEAR,BIRTHDATE, GETDATE()) BETWEEN 56 AND 65 THEN '56-65 YAŞ'
	WHEN DATEDIFF(YEAR,BIRTHDATE, GETDATE()) > 65 THEN '65 YAŞ ÜSTÜ'

END AGEGROUP2
FROM CUSTOMERS
) GS
GROUP BY GS.AGEGROUP2
ORDER BY GS.AGEGROUP2
----------------------------------------------------------------------------------------
SELECT C.*, CT.CITY, DT.DISTRICT
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
JOIN DISTRICT DT ON DT.ID = C.DISTRICTID
WHERE CT.CITY = 'İSTANBUL' AND DT.DISTRICT != 'KADIKÖY'

-- SUBQUERY1
SELECT C.*, 
(SELECT CT.CITY FROM CITIES CT WHERE CT.ID = C.CITYID) AS CITY_,
(SELECT DT.DISTRICT FROM DISTRICT DT WHERE DT.ID =C.DISTRICTID) AS DISTRICT_
FROM CUSTOMERS C
WHERE C.CITYID IN (SELECT ID FROM CITIES CT WHERE CT.CITY = 'İSTANBUL')
AND C.DISTRICTID NOT IN (SELECT ID FROM DISTRICT DT WHERE DT.DISTRICT ='KADIKÖY')

-- SUBQUERY2
SELECT C.*,
(SELECT CT.CITY FROM CITIES CT WHERE CT.ID = C.CITYID) AS CITY,
(SELECT DT.DISTRICT FROM DISTRICT DT WHERE DT.ID = C.DISTRICTID) AS DISTRICT
FROM CUSTOMERS C 
WHERE (SELECT CT.CITY FROM CITIES CT WHERE CT.ID = C.CITYID) = 'İSTANBUL' 
AND (SELECT DT.DISTRICT FROM DISTRICT DT WHERE DT.ID = C.DISTRICTID) NOT IN ('KADIKÖY')
----------------------------------------------------------------------------------------
DELETE FROM CITIES WHERE CITY = 'ANKARA'

SELECT * 
FROM CUSTOMERS C
LEFT JOIN CITIES CT ON CT.ID = C.CITYID
WHERE C.CITYID = 6

SELECT *
FROM CUSTOMERS C
LEFT JOIN CITIES CT ON CT.ID = C.CITYID
WHERE CT.CITY IS NULL
----------------------------------------------------------------------------------------
SET IDENTITY_INSERT CITIES ON  
 
INSERT INTO CITIES
(ID, CITY)
VALUES
(34,'İSTANBUL')

INSERT INTO CITIES
(ID, CITY)
VALUES
(06, 'ANKARA')

SELECT * FROM CITIES

SELECT *, LEFT(TELNR1, 5) AS OPERATOR_1,
LEFT(TELNR2,5) AS OPERATOR_2
FROM CUSTOMERS

--2.
SELECT *, SUBSTRING(TELNR1,1,5) AS OPERATOR_1,
SUBSTRING(TELNR2,1,5) AS OPERATOR_2
FROM CUSTOMERS
----------------------------------------------------------------------------------------
-- Starts with 50 pr 55 -> X  , 54 -> Y, 53 -> Z

SELECT VI.CUSTOMERNAME, VI.TELNR1,VI.TELNR2,

	  TELNR1_X_OPERATORCOUNT + TELNR2_X_OPERATORCOUNT AS X__OPERATORCOUNT,
	  TELNR1_Y_OPERATORCOUNT + TELNR2_Y_OPERATORCOUNT AS Y__OPERATORCOUNT,
	  TELNR1_Z_OPERATORCOUNT + TELNR2_Z_OPERATORCOUNT AS Z__OPERATORCOUNT

FROM
(
SELECT
CASE
	WHEN TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 1
	ELSE 0
END TELNR1_X_OPERATORCOUNT,

CASE
	WHEN TELNR1 LIKE '(54%' THEN 1
	ELSE 0
END TELNR1_Y_OPERATORCOUNT,

CASE	
	WHEN TELNR1 LIKE '(53%' THEN 1 
	ELSE 0
END TELNR1_Z_OPERATORCOUNT,

CASE
	WHEN TELNR2 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 1
	ELSE 0
END TELNR2_X_OPERATORCOUNT,

CASE
	WHEN TELNR2 LIKE '(54%' THEN 1
	ELSE 0
END TELNR2_Y_OPERATORCOUNT,

CASE	
	WHEN TELNR2 LIKE '(53%' THEN 1 
	ELSE 0
END TELNR2_Z_OPERATORCOUNT,
*
FROM CUSTOMERS
)VI


-- SUM OF X,Y,Z OPERATORS

SELECT SUM(TELNR1_X_OPERATORCOUNT + TELNR2_X_OPERATORCOUNT) AS X_OPERATORCOUNT,
	   SUM(TELNR1_Y_OPERATORCOUNT + TELNR2_Y_OPERATORCOUNT) AS Y_OPERATORCOUNT,
	   SUM(TELNR1_Z_OPERATORCOUNT + TELNR2_Z_OPERATORCOUNT) AS Z_OPERATORCOUNT

FROM
(
SELECT
CASE
	WHEN TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 1
	ELSE 0
END TELNR1_X_OPERATORCOUNT,

CASE
	WHEN TELNR1 LIKE '(54%' THEN 1
	ELSE 0
END TELNR1_Y_OPERATORCOUNT,

CASE	
	WHEN TELNR1 LIKE '(53%' THEN 1 
	ELSE 0
END TELNR1_Z_OPERATORCOUNT,

CASE
	WHEN TELNR2 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 1
	ELSE 0
END TELNR2_X_OPERATORCOUNT,

CASE
	WHEN TELNR2 LIKE '(54%' THEN 1
	ELSE 0
END TELNR2_Y_OPERATORCOUNT,

CASE	
	WHEN TELNR2 LIKE '(53%' THEN 1 
	ELSE 0
END TELNR2_Z_OPERATORCOUNT
FROM CUSTOMERS
)VI_


SELECT TELNR1, TELNR2,
CASE
	WHEN TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 1
	ELSE 0
END TELNR1_X_OPERATOR,

CASE
	WHEN TELNR1 LIKE '(54%' THEN 1
	ELSE 0
END TELNR1_Y_OPERATOR,

CASE
	WHEN TELNR1 LIKE '(53%' THEN 1
	ELSE 0
END TELNR1_Z_OPERATOR,


CASE
	WHEN TELNR2 LIKE '(50%' OR TELNR2 LIKE '(55%' THEN 1
	ELSE 0
END TELNR2_X_OPERATOR,

CASE
	WHEN TELNR2 LIKE '(54%' THEN 1
	ELSE 0
END TELNR2_Y_OPERATOR,

CASE
	WHEN TELNR2 LIKE '(53%' THEN 1
	ELSE 0
END TELNR2_Z_OPERATOR

FROM CUSTOMERS

-------------------------------------
SELECT CUSTOMERNAME, TELNR1, TELNR2, 
GS.TELNR1_X_OPERATOR + GS.TELNR2_X_OPERATOR AS TELNR1_X_COUNT,
GS.TELNR1_Y_OPERATOR + GS.TELNR2_Y_OPERATOR AS TELNR1_Y_COUNT,
GS.TELNR1_Z_OPERATOR + GS.TELNR2_Z_OPERATOR AS TELNR1_Z_COUNT

FROM
(
SELECT *,
CASE
	WHEN TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 1
	ELSE 0
END TELNR1_X_OPERATOR,

CASE
	WHEN TELNR1 LIKE '(54%' THEN 1
	ELSE 0
END TELNR1_Y_OPERATOR,

CASE
	WHEN TELNR1 LIKE '(53%' THEN 1
	ELSE 0
END TELNR1_Z_OPERATOR,


CASE
	WHEN TELNR2 LIKE '(50%' OR TELNR2 LIKE '(55%' THEN 1
	ELSE 0
END TELNR2_X_OPERATOR,

CASE
	WHEN TELNR2 LIKE '(54%' THEN 1
	ELSE 0
END TELNR2_Y_OPERATOR,

CASE
	WHEN TELNR2 LIKE '(53%' THEN 1
	ELSE 0
END TELNR2_Z_OPERATOR

FROM CUSTOMERS
) GS
-------------------------------------
--TOTAL SUM

SELECT 
SUM(GS.TELNR1_X_OPERATOR + GS.TELNR2_X_OPERATOR) AS X_OPERATORCOUNT,
SUM(GS.TELNR1_Y_OPERATOR + GS.TELNR2_Y_OPERATOR) AS Y_OPERATORCOUNT,
SUM(GS.TELNR1_Z_OPERATOR + GS.TELNR2_Z_OPERATOR) AS Z_OPERATORCOUNT

FROM
(
SELECT *,
CASE
	WHEN TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 1
	ELSE 0
END TELNR1_X_OPERATOR,

CASE
	WHEN TELNR1 LIKE '(54%' THEN 1
	ELSE 0
END TELNR1_Y_OPERATOR,

CASE
	WHEN TELNR1 LIKE '(53%' THEN 1
	ELSE 0
END TELNR1_Z_OPERATOR,


CASE
	WHEN TELNR2 LIKE '(50%' OR TELNR2 LIKE '(55%' THEN 1
	ELSE 0
END TELNR2_X_OPERATOR,

CASE
	WHEN TELNR2 LIKE '(54%' THEN 1
	ELSE 0
END TELNR2_Y_OPERATOR,

CASE
	WHEN TELNR2 LIKE '(53%' THEN 1
	ELSE 0
END TELNR2_Z_OPERATOR

FROM CUSTOMERS
) GS
----------------------------------------------------------------------------------------
SELECT CT.CITY, D.DISTRICT, COUNT(C.ID) AS CUSTOMER_COUNT
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
JOIN DISTRICT D ON D.ID = C.DISTRICTID
GROUP BY CT.CITY, D.DISTRICT
ORDER BY CT.CITY, COUNT(C.ID) DESC

----------------------------------------------------------------------------------------
SELECT CUSTOMERNAME, DATENAME(DW, BIRTHDATE) AS BIRTHDAY_
FROM CUSTOMERS	


#IN GERMAN
SET LANGUAGE GERMAN
SELECT CUSTOMERNAME, DATENAME(DW,BIRTHDATE) AS GEBURTSTAG
FROM CUSTOMERS
----------------------------------------------------------------------------------------
SELECT * FROM CUSTOMERS
WHERE MONTH(BIRTHDATE) = 07 AND DAY(BIRTHDATE) = 19

SELECT *
FROM CUSTOMERS
WHERE DATEPART(MONTH,BIRTHDATE) = 7 AND DATEPART(DAY, BIRTHDATE) = 19

SELECT *
FROM CUSTOMERS
WHERE DATEPART(MONTH,BIRTHDATE) = MONTH(GETDATE()) AND DATEPART(DAY,BIRTHDATE) = DAY(GETDATE())

SELECT *
FROM CUSTOMERS
WHERE DATEPART(MONTH,BIRTHDATE) = DATEPART(MONTH,GETDATE()) AND DATEPART(DAY,BIRTHDATE) = DATEPART(DAY,GETDATE())
-----------------------------------------------------------------------------------------
SELECT DISTINCT(YEAR(P.INDATE)) AS YEAR_,
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'E' AND YEAR(INDATE) = YEAR(P.INDATE)) AS MALE_PERSON ,
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'K' AND YEAR(INDATE) = YEAR(P.INDATE)) AS FEMALE_PERSON
FROM PERSON P 
ORDER BY 1


SELECT DISTINCT
CASE
	WHEN P.GENDER = 'E' THEN 'ERKEK' ELSE 'KADIN'
END GENDER,
(SELECT COUNT(ID) FROM PERSON WHERE GENDER = P.GENDER AND YEAR(INDATE) = 2015)  AS _2015_,
(SELECT COUNT(ID) FROM PERSON WHERE GENDER = P.GENDER AND YEAR(INDATE) = 2016)  AS _2016_,
(SELECT COUNT(ID) FROM PERSON WHERE GENDER = P.GENDER AND YEAR(INDATE) = 2017)  AS _2017_,
(SELECT COUNT(ID) FROM PERSON WHERE GENDER = P.GENDER AND YEAR(INDATE) = 2018)  AS _2018_,
(SELECT COUNT(ID) FROM PERSON WHERE GENDER = P.GENDER AND YEAR(INDATE) = 2019)  AS _2019_
FROM PERSON P


SELECT DISTINCT P.GENDER,
(SELECT COUNT(ID) FROM PERSON WHERE P.GENDER = GENDER AND YEAR(INDATE) = 2015) AS _2015_,
(SELECT COUNT(ID) FROM PERSON WHERE P.GENDER = GENDER AND YEAR(INDATE) = 2016) AS _2016_,
(SELECT COUNT(ID) FROM PERSON WHERE P.GENDER = GENDER AND YEAR(INDATE) = 2017) AS _2017_,
(SELECT COUNT(ID) FROM PERSON WHERE P.GENDER = GENDER AND YEAR(INDATE) = 2018) AS _2018_,
(SELECT COUNT(ID) FROM PERSON WHERE P.GENDER = GENDER AND YEAR(INDATE) = 2019) AS _2019_
FROM PERSON P
------------------------------------------------------------------------------------------

SELECT U.USERNAME_,U.NAMESURNAME, U.EMAIL, U.TELNR1, U.TELNR2, COUNT(A.ID) AS ADRES_SAYISI
FROM USER_ U
JOIN ADDRES A ON U.ID = A.USERID
JOIN CITY C ON C.ID = A.CITYID
JOIN TOWN T ON T.ID = A.TOWNID
JOIN DISTRICT D ON D.ID = A.DISTRICTID
WHERE U.ID = 1
GROUP BY U.USERNAME_,U.NAMESURNAME, U.EMAIL, U.TELNR1, U.TELNR2
------------------------------------------------------------------------------------------
SELECT U.USERNAME_,U.NAMESURNAME, U.EMAIL, U.TELNR1, U.TELNR2, COUNT(A.ID) AS ADRES_SAYISI
FROM USER_ U
JOIN ADDRES A ON U.ID = A.USERID
JOIN CITY C ON C.ID = A.CITYID
JOIN TOWN T ON T.ID = A.TOWNID
JOIN DISTRICT D ON D.ID = A.DISTRICTID
GROUP BY U.USERNAME_,U.NAMESURNAME, U.EMAIL, U.TELNR1, U.TELNR2

--- 2.
SELECT U.NAMESURNAME, COUNT(A.ADDRESSTYPE) AS [KAC_ADRES?]
FROM USER_ U
JOIN ADDRES A ON U.ID = A.USERID
GROUP BY U.NAMESURNAME

--- 3.
SELECT U.ID, U.NAMESURNAME, COUNT(A.ADDRESSTEXT)
FROM USER_ U 
JOIN ADDRES A ON U.ID = A.USERID
JOIN CITY C ON C.ID = A.CITYID
JOIN TOWN T ON T.ID = A.TOWNID
JOIN DISTRICT D ON D.ID = A.DISTRICTID
GROUP BY U.ID, U.NAMESURNAME
-------------------------------------------------------------------------------------------

SELECT U.USERNAME_,U.NAMESURNAME, U.EMAIL, U.TELNR1, U.TELNR2, COUNT(A.ID) AS ADRES_SAYISI
FROM USER_ U
JOIN ADDRES A ON U.ID = A.USERID
JOIN CITY C ON C.ID = A.CITYID
JOIN TOWN T ON T.ID = A.TOWNID
JOIN DISTRICT D ON D.ID = A.DISTRICTID
GROUP BY U.USERNAME_,U.NAMESURNAME, U.EMAIL, U.TELNR1, U.TELNR2
HAVING COUNT(A.ID) = 1
--------------------------------------------------------------------------------------------------
SELECT C.CITY, COUNT(U.ID) AS KULLANICI
FROM USER_ U
JOIN ADDRES A ON U.ID = A.USERID
JOIN CITY C ON C.ID = A.CITYID
JOIN TOWN T ON T.ID = A.TOWNID
JOIN DISTRICT D ON D.ID = A.DISTRICTID
GROUP BY C.CITY
ORDER BY 2 DESC
--------------------------------------------------------------------------------------------------
SELECT U.ID, U.USERNAME_,U.NAMESURNAME, U.EMAIL, U.TELNR1, U.TELNR2, COUNT(A.ID) AS ADRES_SAYISI,
COUNT(DISTINCT C.CITY) AS SEHIR_SAYISI
FROM USER_ U
JOIN ADDRES A ON U.ID = A.USERID
JOIN CITY C ON C.ID = A.CITYID
JOIN TOWN T ON T.ID = A.TOWNID
JOIN DISTRICT D ON D.ID = A.DISTRICTID
GROUP BY U.ID, U.USERNAME_,U.NAMESURNAME, U.EMAIL, U.TELNR1, U.TELNR2

-- VALIDATION
SELECT * FROM ADDRES WHERE USERID = '4460'

-- 2. 
SELECT U.ID, U.NAMESURNAME, COUNT(A.ID) AS ADRES_SAYISI, COUNT(DISTINCT C.CITY) AS SEHİR_SAYISI 
FROM USER_ U
JOIN ADDRES A ON U.ID = A.USERID
JOIN CITY C ON C.ID = A.CITYID
JOIN TOWN T ON T.ID = A.TOWNID
JOIN DISTRICT D ON D.ID = A.DISTRICTID
GROUP BY U.ID, U.NAMESURNAME
------------------------------------------------------------------------------------------------
SELECT U.ID, U.USERNAME_,U.NAMESURNAME, U.EMAIL, U.TELNR1, U.TELNR2, COUNT(A.ID) AS ADRES_SAYISI,
COUNT(DISTINCT C.CITY) AS SEHIR_SAYISI
FROM USER_ U
JOIN ADDRES A ON U.ID = A.USERID
JOIN CITY C ON C.ID = A.CITYID
JOIN TOWN T ON T.ID = A.TOWNID
JOIN DISTRICT D ON D.ID = A.DISTRICTID
GROUP BY U.ID, U.USERNAME_,U.NAMESURNAME, U.EMAIL, U.TELNR1, U.TELNR2
HAVING COUNT(A.ID) <> COUNT(DISTINCT C.CITY)

-- 2. 
SELECT U.ID, U.NAMESURNAME, COUNT(DISTINCT A.ADDRESSTYPE) AS ADRES_SA, COUNT(DISTINCT C.CITY) AS SEHİR_SA
FROM USER_ U
JOIN ADDRES A ON U.ID = A.USERID
JOIN CITY C ON C.ID = A.CITYID
JOIN TOWN T ON T.ID = A.TOWNID
JOIN DISTRICT D ON D.ID = A.DISTRICTID
GROUP BY U.ID, U.NAMESURNAME
HAVING COUNT(DISTINCT A.ADDRESSTYPE) != COUNT(DISTINCT C.CITY)
--------------------------------------------------------------------------------------------------
SELECT U.ID, U.NAMESURNAME, COUNT(B.ID)
FROM USER_ U
JOIN BASKET B ON U.ID = B.USERID
GROUP BY U.ID, U.NAMESURNAME

--SUBQUERY
SELECT U.ID, U.NAMESURNAME,
(SELECT COUNT(*) FROM BASKET WHERE BASKET.USERID = U.ID)
FROM USER_ U
WHERE (SELECT COUNT(*) FROM BASKET WHERE BASKET.USERID = U.ID) > 0
-------------------------------------------------------------------------------------------------
SELECT U.ID, U.NAMESURNAME,
(SELECT COUNT(B.ID) FROM BASKET B WHERE B.USERID = U.ID) AS BASKET_COUNT,
(SELECT MAX(B.CREATEDDATE) FROM BASKET B WHERE B.USERID = U.ID ) AS MAX_DATE,
(SELECT MIN(B.CREATEDDATE) FROM BASKET B WHERE B.USERID = U.ID ) AS MIN_DATE,
(SELECT SUM(BD.TOTAL) FROM BASKETDETAIL BD WHERE BD.BASKETID IN (SELECT ID FROM BASKET B WHERE B.USERID = U.ID)) AS TOTAL,
(SELECT COUNT(*) FROM BASKETDETAIL BD WHERE BD.BASKETID IN (SELECT ID FROM BASKET B WHERE B.USERID = U.ID)) AS ITEMCOUNT_
FROM USER_ U
WHERE (SELECT COUNT(B.ID) FROM BASKET B WHERE B.USERID = U.ID) > 0

# Validation
SELECT ID FROM BASKET B WHERE B.USERID = 144
SELECT SUM(TOTAL) FROM BASKETDETAIL WHERE BASKETID IN (248, 943)

SELECT * FROM BASKETDETAIL WHERE BASKETID IN (SELECT ID FROM BASKET B WHERE B.USERID = 144)

-- with JOIN 
SELECT U.ID, U.NAMESURNAME, COUNT(B.ID) AS BASKET_COUNT, MAX(B.CREATEDDATE) AS MAX_DATE, MIN(B.CREATEDDATE) AS MIN_DATE, 
SUM(BD.TOTAL) AS TOTAL
FROM USER_ U
JOIN BASKET B ON U.ID = B.USERID
JOIN BASKETDETAIL BD ON BD.BASKETID= B.ID
GROUP BY U.ID, U.NAMESURNAME
-------------------------------------------------------------------------------------------------
SELECT  U.ID, U.NAMESURNAME,
(SELECT COUNT(B.ID) FROM BASKET B WHERE B.USERID = U.ID) AS BASKET_COUNT,
(SELECT MAX(B.CREATEDDATE) FROM BASKET B WHERE B.USERID = U.ID) AS MAX_DATE,
(SELECT MIN(B.CREATEDDATE) FROM BASKET B WHERE B.USERID = U.ID) AS MIN_DATE,
(SELECT SUM(TOTAL) FROM BASKETDETAIL BD WHERE BD.BASKETID IN (SELECT ID FROM BASKET B WHERE B.USERID = U.ID)) AS TOTAL
FROM USER_ U
WHERE (SELECT COUNT(B.ID) FROM BASKET B WHERE B.USERID = U.ID) > 0
ORDER BY TOTAL DESC

-- with join 
SELECT U.ID, U.NAMESURNAME, COUNT(B.ID) AS BASKET_COUNT, MAX(B.CREATEDDATE) AS MAX_DATE, MIN(B.CREATEDDATE) AS MIN_DATE, 
SUM(BD.TOTAL) AS TOTAL
FROM USER_ U
JOIN BASKET B ON U.ID = B.USERID
JOIN BASKETDETAIL BD ON BD.BASKETID= B.ID
GROUP BY U.ID, U.NAMESURNAME
ORDER BY TOTAL DESC
-------------------------------------------------------------------------------------------------
SELECT  U.ID, U.NAMESURNAME,
(SELECT COUNT(B.ID) FROM BASKET B WHERE B.USERID = U.ID) AS BASKET_COUNT,
(SELECT MAX(B.CREATEDDATE) FROM BASKET B WHERE B.USERID = U.ID) AS MAX_DATE,
(SELECT MIN(B.CREATEDDATE) FROM BASKET B WHERE B.USERID = U.ID) AS MIN_DATE,
(SELECT SUM(TOTAL) FROM BASKETDETAIL BD WHERE BD.BASKETID IN (SELECT ID FROM BASKET B WHERE B.USERID = U.ID)) AS TOTAL,
(SELECT ITEMNAME FROM ITEM I WHERE I.ID IN
	(SELECT TOP 1  ITEMID FROM BASKETDETAIL BD WHERE BD.BASKETID IN(SELECT ID FROM BASKET B WHERE B.USERID = U.ID) ORDER BY BD.DATE_ DESC)
) AS LAST_ITEM_NAME
FROM USER_ U
WHERE (SELECT COUNT(B.ID) FROM BASKET B WHERE B.USERID = U.ID) > 0


-- VALIDATION
SELECT U.ID, U.NAMESURNAME, BD.DATE_, I.ITEMNAME
FROM USER_ U
JOIN BASKET B ON B.USERID = U.ID
JOIN BASKETDETAIL BD ON BD.BASKETID = B.ID
JOIN ITEM I ON I.ID = BD.ITEMID

WHERE U.ID = 67
ORDER BY BD.DATE_
-------------------------------------------------------------------------------------------------
SELECT V.SALARY_COMP, COUNT(V.ID) AS CUSTOMERCOUNT FROM
(
SELECT *,
CASE
	WHEN GENDER = 'E' AND SALARY >= 5800 THEN 'ABOVE_AVERAGE_SALARY_MALE'
	WHEN GENDER = 'K' AND SALARY >= 5800 THEN 'ABOVE_AVERAGE_SALARY_FEMALE'
	WHEN GENDER = 'E' AND SALARY <= 5800 THEN 'BELOW_AVERAGE_SALARY_MALE'
	WHEN GENDER = 'K' AND SALARY <= 5800 THEN 'BELOW_AVERAGE_SALARY_FEMALE'
END SALARY_COMP
FROM PERSON
)V
GROUP BY V.SALARY_COMP
-------------------------------------------------------------------------------------------------
-- WORKING
SELECT
CASE
	WHEN OUTDATE IS NULL THEN 'STILL_WORKING' ELSE 'LEFT_THE_JOB'
END WORKING_STATUS,
GENDER,
COUNT(ID) AS PERSONCOUNT
FROM PERSON 
GROUP BY CASE
	WHEN OUTDATE IS NULL THEN 'STILL_WORKING' ELSE 'LEFT_THE_JOB'
END, GENDER
ORDER BY GENDER

--- GENDER
SELECT DISTINCT P.GENDER,
(SELECT COUNT(ID) FROM PERSON WHERE P.GENDER = GENDER AND OUTDATE IS NULL) AS STILL_WORKING,
(SELECT COUNT(ID) FROM PERSON WHERE P.GENDER = GENDER AND OUTDATE IS NOT NULL) AS LEFT_THE_JOB
FROM PERSON P
ORDER BY P.GENDER
--------------------------------------------------------------------------------------------------
SELECT CITY, SUM(LINETOTAL) TOTALSALES 
FROM SALEORDERS
GROUP BY CITY
ORDER BY CITY
--------------------------------------------------------------------------------------------------
SELECT CITY, MONTH_, SUM(LINETOTAL) AS TOTALSALE
FROM SALEORDERS
GROUP BY CITY, MONTH_
ORDER BY CITY, MONTH_
--------------------------------------------------------------------------------------------------
SELECT CITY, DAYOFWEEK_, SUM(LINETOTAL) AS TOTALSALES
FROM SALEORDERS
GROUP BY CITY, DAYOFWEEK_
ORDER BY CITY, DAYOFWEEK_

UPDATE SALEORDERS
SET DAYOFWEEK_  = '01.PZT' WHERE DAYOFWEEK_ = 'Monday'

UPDATE SALEORDERS
SET DAYOFWEEK_  = '02.SAL' WHERE DAYOFWEEK_ = 'Tuesday'

UPDATE SALEORDERS
SET DAYOFWEEK_  = '03.ÇAR' WHERE DAYOFWEEK_ = 'Wednesday'

UPDATE SALEORDERS
SET DAYOFWEEK_  = '04.PER' WHERE DAYOFWEEK_ = 'Thursday'

UPDATE SALEORDERS
SET DAYOFWEEK_  = '05.CUM' WHERE DAYOFWEEK_ = 'Friday'

UPDATE SALEORDERS
SET DAYOFWEEK_  = '06.CMT' WHERE DAYOFWEEK_ = 'Saturday'

UPDATE SALEORDERS
SET DAYOFWEEK_  = '07.PAZ' WHERE DAYOFWEEK_ = 'Sunday'
--------------------------------------------------------------------------------------------------
SELECT DISTINCT S.CITY,

(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '01.PZT' AND S.CITY = CITY) AS MONDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '02.SAL' AND S.CITY = CITY) AS TUESDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '03.ÇAR' AND S.CITY = CITY) AS WEDNESDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '04.PER' AND S.CITY = CITY) AS THURSDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '05.CUM' AND S.CITY = CITY) AS FRIDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '06.CMT' AND S.CITY = CITY) AS SATURDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '07.PAZ' AND S.CITY = CITY) AS SUNDAY

FROM SALEORDERS S
ORDER BY CITY
--------------------------------------------------------------------------------------------------
SELECT DISTINCT S.CITY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '01.OCK') AS JANUARY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '02.ŞUB') AS FEBRUARY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '03.MAR') AS MARCH,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '04.NİS') AS APRIL,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '05.MAY') AS MAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '06.HAZ') AS JUNE,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '07.TEM') AS JULY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '08.AGU') AS AUGUST,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '09.EYL') AS SEPTEMBER,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '10.EKI') AS OCTOBER,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '11.KAS') AS NOVEMBER,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE S.CITY = CITY AND MONTH_ = '12.ARA') AS DECEMBER
FROM SALEORDERS S
ORDER BY S.CITY
--------------------------------------------------------------------------------------------------
SELECT DISTINCT S.CITY,

(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '01.PZT' AND S.CITY = CITY) AS MONDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '02.SAL' AND S.CITY = CITY) AS TUESDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '03.ÇAR' AND S.CITY = CITY) AS WEDNESDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '04.PER' AND S.CITY = CITY) AS THURSDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '05.CUM' AND S.CITY = CITY) AS FRIDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '06.CMT' AND S.CITY = CITY) AS SATURDAY,
(SELECT SUM(LINETOTAL) FROM SALEORDERS WHERE DAYOFWEEK_ = '07.PAZ' AND S.CITY = CITY) AS SUNDAY

FROM SALEORDERS S
ORDER BY CITY
--------------------------------------------------------------------------------------------------
SELECT S.CITY, S1.CATEGORY1, SUM(S1.TOTALSALE) AS TOTALSALEE
FROM SALEORDERS S
CROSS APPLY(SELECT TOP 5 CATEGORY1, SUM(LINETOTAL) AS TOTALSALE FROM SALEORDERS WHERE S.CITY = CITY GROUP BY CATEGORY1 ORDER BY TOTALSALE DESC)S1
GROUP BY S.CITY, S1.CATEGORY1
ORDER BY S.CITY, TOTALSALEE DESC


SELECT  S.CITY, S1.CATEGORY1, SUM(S1.TOTALSALE) AS TOTAL_SALE
FROM SALEORDERS S
CROSS APPLY(SELECT TOP 5 SO.CATEGORY1, SUM(SO.LINETOTAL) AS TOTALSALE FROM SALEORDERS SO WHERE SO.CITY = S.CITY GROUP BY SO.CATEGORY1 ORDER BY TOTALSALE DESC)S1
GROUP BY S.CITY, S1.CATEGORY1
ORDER BY S.CITY, TOTAL_SALE DESC
--------------------------------------------------------------------------------------------------
SELECT TOP 100 ORD.ID, U.USERNAME_, U.NAMESURNAME, U.TELNR1, U.TELNR2, C.COUNTRY, CT.CITY, T.TOWN, A.ADDRESSTEXT, ORD.ORDERID,I.ITEMCODE, I.ITEMNAME,I.BRAND,
I.CATEGORY1, I.CATEGORY2, I.CATEGORY3, I.CATEGORY4, ORD.AMOUNT, ORD.UNITPRICE, ORD.LINETOTAL, CONVERT(DATE,O.DATE_) AS ORDERDATE, 
CONVERT(TIME,O.DATE_) AS ORDERTIME, YEAR(O.DATE_) YEAR_, MONTH(O.DATE_) MONTH_, DATENAME(DW,O.DATE_) AS DAYOFWEEK_

FROM ORDERS O
JOIN USERS U ON U.ID = O.USERID
JOIN ADDRESS A ON A.ID = O.ADDRESSID
JOIN COUNTRIES C ON C.ID = A.COUNTRYID
JOIN CITIES CT ON CT.ID = A.CITYID
JOIN TOWNS T ON T.ID = A.TOWNID
JOIN ORDERDETAILS ORD ON O.ID = ORD.ORDERID
JOIN ITEMS I ON I.ID = ORD.ITEMID
ORDER BY ORD.ID
--------------------------------------------------------------------------------------------------

SELECT TOP 1000 OD.ID, U.USERNAME_, U.NAMESURNAME, U.TELNR1, U.TELNR2, C.COUNTRY, CT.CITY, T.TOWN, ADR.ADDRESSTEXT, O.ID, ITM.ITEMCODE, ITM.ITEMNAME, ITM.BRAND,
ITM.CATEGORY1,ITM.CATEGORY2, ITM.CATEGORY3, ITM.CATEGORY4, OD.AMOUNT,OD.UNITPRICE, OD.LINETOTAL, CONVERT(DATE,O.DATE_) AS ORDERDATE, CONVERT(TIME, O.DATE_) AS ORDERTIME,
YEAR(O.DATE_) AS YEAR_, DATENAME(MONTH,O.DATE_) AS MONTH_, DATENAME(DW,O.DATE_) AS DAYOFWEEK_
FROM ORDERS O
JOIN USERS U ON U.ID = O.USERID
JOIN ADDRESS ADR ON ADR.ID = O.ADDRESSID
JOIN COUNTRIES C ON C.ID = ADR.COUNTRYID
JOIN CITIES CT ON  CT.ID = ADR.CITYID
JOIN TOWNS T ON T.ID = ADR.TOWNID
JOIN ORDERDETAILS OD ON OD.ORDERID = O.ID
JOIN ITEMS ITM ON ITM.ID = OD.ITEMID
--------------------------------------------------------------------------------------------------
SELECT * FROM CITIES   
CREATE TABLE CITIES2(
ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
COUNTRYID INT,
CITY VARCHAR(50))

SELECT * FROM CITIES
SELECT * FROM CITIES2

INSERT INTO CITIES2 
(COUNTRYID, CITY)
SELECT COUNTRYID, CITY
FROM CITIES
--------------------------------------------------------------------------------------------------
