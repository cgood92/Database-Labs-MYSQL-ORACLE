-- Oracle Lab #6

-- Create a fresh database.
@ ../lab7/apply_lab7_oracle.sql

-- Open log file. 
SPOOL apply_lab8_oracle.log

SET ECHO off

SET FEEDBACK ON
SET NULL '<NULL>'
SET SERVEROUTPUT ON
SET PAGESIZE 999
SET LINESIZE 999

-- Step 1
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'CALENDAR') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE calendar CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'CALENDAR_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE calendar_s1';
  END LOOP;
END;
/

CREATE TABLE calendar
	( CALENDAR_ID			    NUMBER
	, CALENDAR_NAME		  VARCHAR2(10)	CONSTRAINT nn_calendar_1 NOT NULL
	, CALENDAR_SHORT_NAME	VARCHAR2(3) CONSTRAINT nn_calendar_2 NOT NULL
	, START_DATE			  DATE 		    CONSTRAINT nn_calendar_3 NOT NULL
	, END_DATE		  DATE		    CONSTRAINT nn_calendar_4 NOT NULL
	, CREATED_BY				      NUMBER
	, CREATION_DATE			      DATE        CONSTRAINT nn_calendar_5 NOT NULL
	, LAST_UPDATED_BY		      NUMBER
	, LAST_UPDATE_DATE			  DATE        CONSTRAINT nn_calendar_6 NOT NULL
	, CONSTRAINT pk_calendar_1 PRIMARY KEY (calendar_id)
	, CONSTRAINT fk_calendar_7 FOREIGN KEY (created_by)			REFERENCES system_user (system_user_id)
	, CONSTRAINT fk_calendar_8 FOREIGN KEY (last_updated_by)		REFERENCES system_user (system_user_id));

-- Create sequence.
CREATE SEQUENCE calendar_s1 START WITH 1;

-- Step #2
-- Seed the table with 10 years of data.
DECLARE
  -- Create local collection data types.
  TYPE smonth IS TABLE OF VARCHAR2(3);
  TYPE lmonth IS TABLE OF VARCHAR2(9);
 
  -- Declare month arrays.
  short_month SMONTH := smonth('JAN','FEB','MAR','APR','MAY','JUN'
                              ,'JUL','AUG','SEP','OCT','NOV','DEC');
  long_month  LMONTH := lmonth('January','February','March','April','May','June'
                              ,'July','August','September','October','November','December');
 
  -- Declare base dates.
  start_date DATE := '01-JAN-09';
  end_date   DATE := '31-DEC-09';
 
  -- Declare years.
  years      NUMBER := 1;
 
BEGIN
 
  -- Loop through years and months.
  FOR i IN 1..years LOOP
    FOR j IN 1..short_month.COUNT LOOP
      INSERT INTO calendar VALUES
      ( calendar_s1.NEXTVAL
	  , long_month(j)
	  , short_month(j)
      , add_months(start_date,(j-1)+(12*(i-1)))
      , add_months(end_date,(j-1)+(12*(i-1)))
	  , 2
	  , SYSDATE
	  , 2
	  , SYSDATE);
    END LOOP;
  END LOOP;
 
END;
/


-- Step #3
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'TRANSACTION_REVERSAL') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE transaction_reversal CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'TRANSACTION_REVERSAL_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE transaction_reversal_s1';
  END LOOP;
END;
/

CREATE TABLE transaction_reversal
( 
transaction_id NUMBER
, transaction_account VARCHAR2(15)
, transaction_type NUMBER
, transaction_date DATE
, transaction_amount FLOAT
, rental_id NUMBER
, payment_method_type VARCHAR2(14)
, payment_account_number  VARCHAR2(19)
, CREATED_BY NUMBER
, CREATION_DATE DATE
, LAST_UPDATED_BY NUMBER
, LAST_UPDATE_DATE DATE
)
  ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY download
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'DOWNLOAD':'transaction_upload2.bad'
      DISCARDFILE 'DOWNLOAD':'transaction_upload2.dis'
      LOGFILE     'DOWNLOAD':'transaction_upload2.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL )
    LOCATION ('transaction_upload2.csv'))
REJECT LIMIT UNLIMITED;

INSERT INTO transaction
(SELECT transaction_s1.NEXTVAL
, transaction_account
, transaction_type
, transaction_date
, transaction_amount
, rental_id
, payment_method_type
, payment_account_number
, created_by
, creation_date
, last_updated_by
, last_update_date
FROM transaction_reversal);

-- Validation Query
COLUMN "Debit Transactions"  FORMAT A20
COLUMN "Credit Transactions" FORMAT A20
COLUMN "All Transactions"    FORMAT A20
 
-- Check current contents of the model.
SELECT   LPAD(TO_CHAR(c1.transaction_count,'99,999'),19,' ') AS "Debit Transactions"
,        LPAD(TO_CHAR(c2.transaction_count,'99,999'),19,' ') AS "Credit Transactions"
,        LPAD(TO_CHAR(c3.transaction_count,'99,999'),19,' ') AS "All Transactions"
FROM    (SELECT COUNT(*) AS transaction_count FROM TRANSACTION WHERE transaction_account = '111-111-111-111') c1 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION WHERE transaction_account = '222-222-222-222') c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) c3;

-- Debit Transactions   Credit Transactions  All Transactions
-- -------------------- -------------------- --------------------
--               4,681                1,170                5,851

-- Step #4
COLUMN "JAN" FORMAT A10
COLUMN "FEB" FORMAT A10
COLUMN "MAR" FORMAT A10
COLUMN "1Q" FORMAT A10
COLUMN "APR" FORMAT A10
COLUMN "MAY" FORMAT A10
COLUMN "JUN" FORMAT A10
COLUMN "2Q" FORMAT A10
COLUMN "JUL" FORMAT A10
COLUMN "AUG" FORMAT A10
COLUMN "SEP" FORMAT A10
COLUMN "3Q" FORMAT A10
COLUMN "OCT" FORMAT A10
COLUMN "NOV" FORMAT A10
COLUMN "DEC" FORMAT A10
COLUMN "4Q" FORMAT A10

SET LINESIZE 99999
SELECT   CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
         END AS "TRANSACTION_ACCOUNT"
,        CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 1
           WHEN t.transaction_account = '222-222-222-222' THEN 2
         END AS "SORTKEY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JAN"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "FEB"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "MAR"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(1,2,3) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "1Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "APR"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "MAY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JUN"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(4,5,6) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "2Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JUL"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "AUG"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "SEP"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(7,8,9) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "3Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "OCT"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "NOV"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "DEC"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(10,11,12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "4Q"
FROM     TRANSACTION t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id 
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE' 
GROUP BY CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
         END
,        CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 1
           WHEN t.transaction_account = '222-222-222-222' THEN 2
         END
UNION ALL
SELECT 'Total'
, 3
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "JAN"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "FEB"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "MAR"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(1,2,3) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(1,2,3) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "1Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "APR"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "MAY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "JUN"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(4,5,6) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(4,5,6) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "2Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "JUL"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "AUG"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "SEP"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(7,8,9) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(7,8,9) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "3Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "OCT"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "NOV"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "DEC"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(10,11,12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'DEBIT' THEN
					t.transaction_amount
             END)+SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(10,11,12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 AND
					cl.common_lookup_type = 'CREDIT' THEN
					t.transaction_amount * -1
             END),'99,999.00'),10,' ') AS "4Q"
FROM     TRANSACTION t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id 
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE' 
ORDER BY sortkey
;
--GROUP BY t.transaction_account;

-- Transaction     Jan        Feb        Mar        F1Q        Apr        May        Jun        F2Q     Jul           Aug        Sep        F3Q        Oct        Nov        Dec        F4Q        YTD
-- --------------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ------------
-- Debit             2,671.20   4,270.74   5,371.02  12,312.96   4,932.18   2,216.46   1,208.40   8,357.04   2,404.08   2,241.90   2,197.38   6,843.36   3,275.40   3,125.94   2,340.48   8,741.82  36,255.18
-- Credit             -690.06  -1,055.76  -1,405.56  -3,151.38  -1,192.50    -553.32    -298.92  -2,044.74    -604.20    -553.32    -581.94  -1,739.46    -874.50    -833.16    -601.02  -2,308.68  -9,244.26
-- Total             1,981.14   3,214.98   3,965.46   9,161.58   3,739.68   1,663.14     909.48   6,312.30   1,799.88   1,688.58   1,615.44   5,103.90   2,400.90   2,292.78   1,739.46   6,433.14  27,010.92		 

SPOOL OFF