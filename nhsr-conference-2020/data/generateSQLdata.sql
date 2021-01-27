--create 34 lines
IF OBJECT_ID('tempdb..#TestData') IS NOT NULL DROP TABLE #TestData

;WITH NumberSequence AS
(
    SELECT 1 AS Number
        UNION ALL
    SELECT Number + 1
        FROM NumberSequence
        WHERE Number < 34
)
SELECT DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 3650), '1999-01-01') AS dob,
Number AS subjects
INTO #TestData
FROM NumberSequence;

--repeat the subjects 3 times 
IF OBJECT_ID('tempdb..#SampleData') IS NOT NULL DROP TABLE #SampleData;

SELECT * 
INTO #SampleData
FROM #TestData

UNION ALL

SELECT * 
FROM #TestData

UNION ALL

SELECT * 
FROM #TestData
ORDER BY subjects;

ALTER TABLE #SampleData ADD rowID int IDENTITY(1, 1) ;

--Delete 3 dobs by selecting 3 random rows
IF OBJECT_ID('tempdb..#Sample') IS NOT NULL DROP TABLE #Sample;

SELECT Top 3 newID() AS randomID 
,rowID
INTO #Sample
FROM #SampleData
ORDER BY randomID

UPDATE #SampleData SET dob = NULL WHERE rowID IN (SELECT rowID FROM #Sample)

--Fill down in SQL
--https://stackoverflow.com/questions/3465847/sql-how-to-fill-empty-cells-with-previous-row-value
WITH    CustCTE
          AS (SELECT    subjects,
                        dob,
                        ROW_NUMBER() OVER (PARTITION BY subjects ORDER BY dob) AS RowNum
              FROM      #SampleData),

/* CleanCust - A recursive CTE. This runs down the list of values for each subject, 
checking the dob column, if it is null it gets the previous non NULL value.*/
        CleanCust
          AS (SELECT    subjects,
                        ISNULL(dob, 0) AS dob, /* Ensure we start with no NULL values for each dob */
                        RowNum
              FROM      CustCte AS cur
              WHERE     RowNum = 1
              UNION ALL
              SELECT    Curr.subjects,
                        ISNULL(curr.dob, prev.dob) AS dob,
                        Curr.RowNum
              FROM      CustCte AS curr
              INNER JOIN CleanCust AS prev ON curr.subjects = prev.subjects
                                           AND curr.RowNum = prev.RowNum + 1)

/* Update the base table using the result set from the recursive CTE */
    UPDATE #SampleData
    SET dob = src.dob
    FROM    #SampleData
    INNER JOIN CleanCust AS src ON #SampleData.subjects = src.subjects

--View data

SELECT *
FROM #SampleData

SELECT *
FROM #Sample;

