-- MYSQL Lab #8

-- Create a fresh database.
\. ../lab7/apply_lab7_mysql.sql

-- Open log file. 
TEE apply_lab8_mysql.log

USE studentdb;
-- Step 1
-- Conditionally drop table and sequence.
DROP TABLE IF EXISTS calendar;

CREATE TABLE calendar
	( CALENDAR_ID INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
	, CALENDAR_NAME		  VARCHAR(10)	 NOT NULL
	, CALENDAR_SHORT_NAME	VARCHAR(3)  NOT NULL
	, START_DATE			  DATE 		     NOT NULL
	, END_DATE		  DATE		     NOT NULL
	, CREATED_BY				      INT UNSIGNED
	, CREATION_DATE			      DATE         NOT NULL
	, LAST_UPDATED_BY		      INT UNSIGNED
	, LAST_UPDATE_DATE			  DATE         NOT NULL
	, CONSTRAINT fk_calendar_7 FOREIGN KEY (created_by)			REFERENCES system_user (system_user_id)
	, CONSTRAINT fk_calendar_8 FOREIGN KEY (last_updated_by)		REFERENCES system_user (system_user_id));

-- Step #2
INSERT INTO calendar
VALUES (NULL, 'January', 'Jan', '2009-01-01', '2009-01-31', 2, UTC_DATE(), 2, UTC_DATE())
, (NULL, 'Febuary', 'Feb', '2009-02-01', '2009-02-28', 2, UTC_DATE(), 2, UTC_DATE())
, (NULL, 'March', 'Mar', '2009-03-01', '2009-03-31', 2, UTC_DATE(), 2, UTC_DATE())
, (NULL, 'April', 'Apr', '2009-04-01', '2009-04-30', 2, UTC_DATE(), 2, UTC_DATE())
, (NULL, 'May', 'May', '2009-05-01', '2009-05-31', 2, UTC_DATE(), 2, UTC_DATE())
, (NULL, 'June', 'Jun', '2009-06-01', '2009-06-30', 2, UTC_DATE(), 2, UTC_DATE())
, (NULL, 'July', 'Jul', '2009-07-01', '2009-07-31', 2, UTC_DATE(), 2, UTC_DATE())
, (NULL, 'August', 'Aug', '2009-08-01', '2009-08-31', 2, UTC_DATE(), 2, UTC_DATE())
, (NULL, 'September', 'Sep', '2009-09-01', '2009-09-30', 2, UTC_DATE(), 2, UTC_DATE())
, (NULL, 'October', 'Oct', '2009-10-01', '2009-10-31', 2, UTC_DATE(), 2, UTC_DATE())
, (NULL, 'November', 'Nov', '2009-11-01', '2009-11-30', 2, UTC_DATE(), 2, UTC_DATE())
, (NULL, 'December', 'Dec', '2009-12-01', '2009-12-31', 2, UTC_DATE(), 2, UTC_DATE())
;

-- Step #3
-- Conditionally drop table and sequence.
DROP TABLE IF EXISTS transaction_reversal;

CREATE TABLE transaction_reversal
( 
transaction_id INT
, transaction_account VARCHAR(15)
, transaction_type INT
, transaction_date DATE
, transaction_amount FLOAT
, rental_id INT
, payment_method_type VARCHAR(14)
, payment_account_number  VARCHAR(19)
, CREATED_BY INT
, CREATION_DATE DATE
, LAST_UPDATED_BY INT
, LAST_UPDATE_DATE DATE
) ENGINE=MEMORY;

LOAD DATA LOCAL INFILE 'c:/Data/Download/transaction_upload2_mysql.csv'
INTO TABLE transaction_reversal
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

INSERT INTO transaction
(SELECT NULL
, transaction_account
,(SELECT common_lookup_id from common_lookup cl
  WHERE cl.common_lookup_type = 'Credit'
  AND   cl.common_lookup_column = 'TRANSACTION_TYPE'
  AND   cl.common_lookup_table = 'TRANSACTION')
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
SELECT 'SELECT record counts' AS "Statement";
SELECT   LPAD(FORMAT(c1.transaction_count,0),19,' ') AS "Debit Transactions"
,        LPAD(FORMAT(c2.transaction_count,0),19,' ') AS "Credit Transactions"
,        LPAD(FORMAT(c3.transaction_count,0),19,' ') AS "All Transactions"
FROM    (SELECT COUNT(*) AS transaction_count FROM TRANSACTION WHERE transaction_account = '111-111-111-111') c1 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION WHERE transaction_account = '222-222-222-222') c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) c3;

-- +---------------------+---------------------+---------------------+
-- | Debit Transactions  | Credit Transactions | All Transactions    |
-- +---------------------+---------------------+---------------------+
-- |               4,372 |               1,093 |               5,465 |
-- +---------------------+---------------------+---------------------+

-- Step #4
SELECT   CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
         END AS "TRANSACTION_ACCOUNT"
,        CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 1
           WHEN t.transaction_account = '222-222-222-222' THEN 2
         END AS "SORTKEY"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "JAN"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "FEB"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "MAR"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(1,2,3) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "1Q"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "APR"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "MAY"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "JUN"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(4,5,6) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "2Q"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "JUL"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "AUG"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "SEP"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(7,8,9) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "3Q"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "OCT"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "NOV"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "DEC"
,        LPAD(CONCAT('$',FORMAT
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN(10,11,12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2)),14,' ') AS "4Q"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "YTD"
FROM     TRANSACTION t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id 
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE' 
GROUP BY CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
         END
UNION ALL
SELECT 'Total'
, 3 AS transaction
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "JAN"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "FEB"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "MAR"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "1Q"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "APR"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "MAY"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "JUN"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "2Q"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "JUL"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "AUG"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "SEP"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "3Q"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "OCT"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "NOV"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "DEC"
,        LPAD(CONCAT('$',FORMAT
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
             END),2)),14,' ') AS "4Q"
,        LPAD(FORMAT
        (SUM(CASE
               WHEN EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),2),10,' ') AS "YTD"
FROM     TRANSACTION t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id 
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE' 
ORDER BY sortkey
;

-- +-------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+--------------+
-- | Transaction | Jan        | Feb        | Mar        | F1Q        | Apr        | May        | Jun        | F2Q        | Jul        | Aug        | Sep        | F3Q        | Oct        | Nov        | Dec        | F4Q        | YTD          |
-- +-------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+--------------+
-- | Debit       |   2,957.40 |   4,022.70 |   5,654.04 |  12,634.14 |   4,595.10 |   2,219.64 |   1,300.62 |   8,115.36 |   2,413.62 |   2,149.68 |   2,162.40 |   6,725.70 |   3,291.30 |   3,246.78 |   2,299.14 |   8,837.22 |    36,312.42 |
-- | Credit      |    -750.48 |    -992.16 |  -1,437.36 |  -3,180.00 |  -1,217.94 |    -546.96 |    -302.10 |  -2,067.00 |    -597.84 |    -537.42 |    -604.20 |  -1,739.46 |    -829.98 |    -829.98 |    -594.66 |  -2,254.62 |    -9,241.08 |
-- | Total       |   2,206.92 |   3,030.54 |   4,216.68 |   9,454.14 |   3,377.16 |   1,672.68 |     998.52 |   6,048.36 |   1,815.78 |   1,612.26 |   1,558.20 |   4,986.24 |   2,461.32 |   2,416.80 |   1,704.48 |   6,582.60 |    27,071.34 |
-- +-------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+------------+--------------+
			
NOTEE