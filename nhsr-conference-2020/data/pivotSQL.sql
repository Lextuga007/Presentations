DROP TABLE #patients

CREATE TABLE #patients (
   Patient integer,
     Service varchar(5),
	 DateofBirth_sk int
);
INSERT  INTO #Patients
    VALUES  (1, 'S1', 19680103),
			(1, 'RIO', 19680103),
			(1, 'IAPT', 19680103),
			(3, 'S1', 19970509),
			(4, 'RIO', 19471209),
			(5, 'S1', 19660321),
			(6, 'IAPT', 19780131)

SELECT Patient
,DateofBirth_sk
,S1				= MAX(CASE WHEN Service = 'S1' THEN 1 ELSE 0 END)
,Rio					= MAX(CASE WHEN Service = 'RIO' THEN 1 ELSE 0 END)
,IAPT					= MAX(CASE WHEN Service = 'IAPT' THEN 1 ELSE 0 END)
FROM #patients
GROUP BY Patient
,DateofBirth_sk
ORDER BY Patient


--SELECT *
--FROM #patients

SELECT *
FROM 
(
  SELECT Patient, Service, DateofBirth_sk
  FROM #patients
) AS src
PIVOT
(
  COUNT(DateofBirth_sk)
  FOR Service IN ([S1], [RIO], [IAPT])
) AS pivt;

SELECT p.Patient
,CASE WHEN S1.Patient IS NULL THEN 0 ELSE 1 END AS S1
,CASE WHEN rio.Patient IS NULL THEN 0 ELSE 1 END AS RIO
,CASE WHEN iapt.Patient IS NULL THEN 0 ELSE 1 END AS IAPT
FROM #patients AS p
LEFT JOIN (SELECT Patient
			,Service
			FROM #patients
			WHERE Service = 'S1') AS S1 ON S1.Patient = p.Patient
LEFT JOIN (SELECT Patient
			,Service
			FROM #patients
			WHERE Service = 'RIO') AS rio ON rio.Patient = p.Patient
LEFT JOIN (SELECT Patient
			,Service
			FROM #patients
			WHERE Service = 'IAPT') AS iapt ON iapt.Patient = p.Patient
GROUP BY p.Patient
,CASE WHEN S1.Patient IS NULL THEN 0 ELSE 1 END
,CASE WHEN rio.Patient IS NULL THEN 0 ELSE 1 END
,CASE WHEN iapt.Patient IS NULL THEN 0 ELSE 1 END

