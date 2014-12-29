-- MYSQL Lab #7
USE studentdb;

-- Create a fresh database.
\. ../lab6/apply_lab6_mysql.sql

-- Open log file. 
TEE apply_lab7_mysql.log

-- Conditionally drop 'transaction' table and sequence.
DROP TABLE IF EXISTS transaction;
	
-- STEP #1 -------------------------------------------------------------------------------------- 
CREATE TABLE transaction
	( TRANSACTION_ID			    INT UNSIGNED PRIMARY KEY AUTO_INCREMENT	
	, TRANSACTION_ACCOUNT		  VARCHAR(15)	NOT NULL
	, TRANSACTION_TYPE			  INT UNSIGNED
	, TRANSACTION_DATE			  DATE 		    NOT NULL
	, TRANSACTION_AMOUNT		  FLOAT		    NOT NULL
	, RENTAL_ID					      INT UNSIGNED
	, PAYMENT_METHOD_TYPE		  INT UNSIGNED
	, PAYMENT_ACCOUNT_INT	VARCHAR(19)	NOT NULL
	, CREATED_BY				      INT UNSIGNED
	, CREATION_DATE			      DATE        NOT NULL
	, LAST_UPDATED_BY		      INT UNSIGNED
	, LAST_UPDATE_DATE			  DATE        NOT NULL
	, CONSTRAINT fk_transaction_1 FOREIGN KEY (transaction_type)	REFERENCES common_lookup (common_lookup_id)
	, CONSTRAINT fk_transaction_2 FOREIGN KEY (rental_id)			REFERENCES rental (rental_id)
	, CONSTRAINT fk_transaction_3 FOREIGN KEY (payment_method_type)	REFERENCES common_lookup (common_lookup_id)
	, CONSTRAINT fk_transaction_4 FOREIGN KEY (created_by)			REFERENCES system_user (system_user_id)
	, CONSTRAINT fk_transaction_5 FOREIGN KEY (last_updated_by)		REFERENCES system_user (system_user_id));

	CREATE UNIQUE INDEX natural_key_transaction
ON transaction (rental_id, transaction_type, transaction_date, payment_method_type, payment_account_INT);


-- STEP #2 -------------------------------------------------------------------------------------- 

INSERT INTO common_lookup
VALUES
( NULL
, 'CREDIT'
, 'Credit'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'TRANSACTION'
, 'TRANSACTION_TYPE'
, 'CR');

INSERT INTO common_lookup
VALUES
( NULL
, 'DEBIT'
, 'Debit'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'TRANSACTION'
, 'TRANSACTION_TYPE'
, 'DR');

INSERT INTO common_lookup
VALUES
( NULL
, 'DISCOVER_CARD'
, 'Discover Card'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( NULL
, 'VISA_CARD'
, 'Visa Card'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( NULL
, 'MASTER_CARD'
, 'Master Card'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( NULL
, 'CASH'
, 'Cash'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( NULL
, '1-DAY RENTAL'
, '1-Day Rental'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( NULL
, '3-DAY RENTAL'
, '3-Day Rental'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( NULL
, '5-DAY RENTAL'
, '5-Day Rental'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '');

-- STEP #3 -------------------------------------------------------------------------------------- 
-- Part A
-- Conditionally drop 'airport' table and sequence.
DROP TABLE IF EXISTS airport;

CREATE TABLE airport
( AIRPORT_ID			  INT UNSIGNED PRIMARY KEY AUTO_INCREMENT	
, AIRPORT_CODE			VARCHAR(3)  NOT NULL
, AIRPORT_CITY			VARCHAR(30) NOT NULL
, CITY 					    VARCHAR(30) NOT NULL
, STATE_PROVINCE		VARCHAR(30) NOT NULL
, CREATED_BY        INT UNSIGNED
, CREATION_DATE     DATE         NOT NULL
, LAST_UPDATED_BY   INT UNSIGNED
, LAST_UPDATE_DATE  DATE         NOT NULL
, CONSTRAINT fk_airport_1 FOREIGN KEY (created_by)		  REFERENCES system_user (system_user_id)
, CONSTRAINT fk_airport_2 FOREIGN KEY (last_updated_by)	REFERENCES system_user (system_user_id));

-- Conditionally drop 'account_list' table and sequence.
DROP TABLE IF EXISTS account_list;

CREATE TABLE account_list
( ACCOUNT_LIST_ID   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT	
, ACCOUNT_INT    VARCHAR(10) NOT NULL
, CONSUMED_DATE     DATE
, CONSUMED_BY       INT UNSIGNED
, CREATED_BY        INT UNSIGNED
, CREATION_DATE     DATE      NOT NULL
, LAST_UPDATED_BY   INT UNSIGNED
, LAST_UPDATE_DATE  DATE      NOT NULL
, CONSTRAINT fk_account_list_1 FOREIGN KEY (consumed_by)     REFERENCES system_user (system_user_id)
, CONSTRAINT fk_account_list_2 FOREIGN KEY (created_by)      REFERENCES system_user (system_user_id)
, CONSTRAINT fk_account_list_3 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id));


-- Part B 

INSERT INTO airport
VALUES
( NULL
, 'LAX'
, 'Los Angeles'
, 'Los Angeles'
, 'California'
, 2, UTC_DATE(), 2, UTC_DATE());

INSERT INTO airport
VALUES
( NULL
, 'SLC'
, 'Salt Lake City'
, 'Provo'
, 'Utah'
, 2, UTC_DATE(), 2, UTC_DATE());

INSERT INTO airport
VALUES
( NULL
, 'SLC'
, 'Salt Lake City'
, 'Spanish Fork'
, 'Utah'
, 2, UTC_DATE(), 2, UTC_DATE());

INSERT INTO airport
VALUES
( NULL
, 'SFO'
, 'San Francisco'
, 'San Francisco'
, 'California'
, 2, UTC_DATE(), 2, UTC_DATE());

INSERT INTO airport
VALUES
( NULL
, 'SJC'
, 'San Jose'
, 'San Jose'
, 'California'
, 2, UTC_DATE(), 2, UTC_DATE());

INSERT INTO airport
VALUES
( NULL
, 'SJC'
, 'San Jose'
, 'San Carlos'
, 'California'
, 2, UTC_DATE(), 2, UTC_DATE());

-- Part C
-- Conditionally drop the procedure.
SELECT 'DROP PROCEDURE seed_account_list' AS "Statement";
DROP PROCEDURE IF EXISTS seed_account_list;
-- Create procedure to insert automatic INTed rows.
SELECT 'CREATE PROCEDURE seed_account_list' AS "Statement";
-- Reset delimiter to write a procedure.
DELIMITER $$
CREATE PROCEDURE seed_account_list() MODIFIES SQL DATA
BEGIN
/* Declare local variable for call parameters. */
DECLARE lv_key CHAR(3);
/* Declare local control loop variables. */
DECLARE lv_key_min INT DEFAULT 0;
DECLARE lv_key_max INT DEFAULT 50;
/* Declare a local variable for a subsequent handler. */
DECLARE duplicate_key INT DEFAULT 0;
DECLARE fetched INT DEFAULT 0;
/* Declare a SQL cursor fabricated from local variables. */
DECLARE parameter_cursor CURSOR FOR
SELECT DISTINCT airport_code FROM airport;
/* Declare a duplicate key handler */
DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;
/* Declare a not found record handler to close a cursor loop. */
DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;
/* Start transaction context. */
START TRANSACTION;
/* Set savepoint. */
SAVEPOINT all_or_none;
/* Open a local cursor. */
OPEN parameter_cursor;
cursor_parameter: LOOP
FETCH parameter_cursor
INTO lv_key;
/* Place the catch handler for no more rows found
immediately after the fetch operation. */
IF fetched = 1 THEN LEAVE cursor_parameter; END IF;
seed: WHILE (lv_key_min < lv_key_max) DO
SET lv_key_min = lv_key_min + 1;
INSERT INTO account_list
VALUES
( NULL
, CONCAT(lv_key,'-',LPAD(lv_key_min,6,'0'))
, NULL
, NULL
, 2
, UTC_DATE()
, 2
, UTC_DATE());
END WHILE;
/* Reset nested low range variable. */
SET lv_key_min = 0;
END LOOP cursor_parameter;
CLOSE parameter_cursor;
/* This acts as an exception handling block. */
IF duplicate_key = 1 THEN
/* This undoes all DML statements to this point in the procedure. */
ROLLBACK TO SAVEPOINT all_or_none;
END IF;
/* Commit the writes as a group. */
COMMIT;
END;
$$
-- Reset delimiter to the default.
DELIMITER ;

CALL seed_account_list();
SELECT COUNT(*) AS "# Accounts"
FROM account_list;

-- Part D 
UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';

-- Step E 
-- Conditionally drop the procedure.
SELECT 'DROP PROCEDURE update_member_account' AS "Statement";
DROP PROCEDURE IF EXISTS update_member_account;
 
-- Create procedure to insert automatic INTed rows.
SELECT 'CREATE PROCEDURE update_member_account' AS "Statement";
 
-- Reset delimiter to write a procedure.
DELIMITER $$
 
CREATE PROCEDURE update_member_account() MODIFIES SQL DATA
BEGIN
 
  /* Declare local variable for call parameters. */
  DECLARE lv_member_id      INT UNSIGNED;
  DECLARE lv_city           CHAR(30);
  DECLARE lv_state_province CHAR(30);
  DECLARE lv_account_INT CHAR(10);
 
  /* Declare a local variable for a subsequent handler. */
  DECLARE duplicate_key INT DEFAULT 0;
  DECLARE fetched INT DEFAULT 0;
 
  /* Declare a SQL cursor fabricated from local variables. */  
  DECLARE member_cursor CURSOR FOR
    SELECT   DISTINCT
             m.member_id
    ,        a.city
    ,        a.state_province
    FROM     member m INNER JOIN contact c
    ON       m.member_id = c.member_id INNER JOIN address a
    ON       c.contact_id = a.contact_id
    ORDER BY m.member_id;
 
  /* Declare a duplicate key handler */
  DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_key = 1;
 
  /* Declare a not found record handler to close a cursor loop. */
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fetched = 1;
 
  /* Start transaction context. */
  START TRANSACTION;
 
  /* Set savepoint. */  
  SAVEPOINT all_or_none;
 
  /* Open a local cursor. */  
  OPEN member_cursor;
  cursor_member: LOOP
 
    FETCH member_cursor
    INTO  lv_member_id
    ,     lv_city
    ,     lv_state_province;
 
    /* Place the catch handler for no more rows found
       immediately after the fetch operation.          */
    IF fetched = 1 THEN LEAVE cursor_member; END IF;
 
      /* Secure a unique account INT as they're consumed from the list. */
      SELECT al.account_INT
      INTO   lv_account_INT
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTRING(al.account_INT,1,3) = ap.airport_code
      WHERE  ap.city = lv_city
      AND    ap.state_province = lv_state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL LIMIT 1;
 
      /* Update a member with a unique account INT linked to their nearest airport. */
      UPDATE member
      SET    account_number = lv_account_INT
      WHERE  member_id = lv_member_id;
 
      /* Mark consumed the last used account INT. */      
      UPDATE account_list
      SET    consumed_by = 2
      ,      consumed_date = UTC_DATE()
      WHERE  account_INT = lv_account_INT;
 
  END LOOP cursor_member;
  CLOSE member_cursor;
 
    /* This acts as an exception handling block. */  
  IF duplicate_key = 1 THEN
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
 
  END IF;
 
  /* Commit the writes as a group. */
  COMMIT;
 
END;
$$
 
-- Reset delimiter to the default.
DELIMITER ;

SELECT 'CALL update_member_account' AS "Statement";
CALL update_member_account();

-- Query distinct members and addresses.
SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city
,        a.state_province
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id
ORDER BY 1;

-- Validation
-- +-----------+-----------+----------------+--------------+----------------+
-- | member_id | last_name | account_INT | city         | state_province |
-- +-----------+-----------+----------------+--------------+----------------+
-- |         1 | Winn      | SJC-000001     | San Jose     | California     |
-- |         2 | Vizquel   | SJC-000002     | San Jose     | California     |
-- |         3 | Sweeney   | SJC-000003     | San Jose     | California     |
-- |         4 | Clinton   | SLC-000001     | Provo        | Utah           |
-- |         5 | Moss      | SLC-000002     | Provo        | Utah           |
-- |         6 | Gretelz   | SLC-000003     | Provo        | Utah           |
-- |         7 | Royal     | SLC-000004     | Provo        | Utah           |
-- |         8 | Smith     | SLC-000005     | Spanish Fork | Utah           |
-- +-----------+-----------+----------------+--------------+----------------+

-- Step #4 
-- Conditionally drop 'transaction_upload' table and sequence.
DROP TABLE IF EXISTS TRANSACTION_UPLOAD;
 
-- Create external import table in memory only - disappears after rebooting the mysqld service.
CREATE TABLE transaction_upload
( 
account_INT VARCHAR(10)
, first_name VARCHAR(20)
, middle_name VARCHAR(20)
, last_name VARCHAR(20)
, check_out_date DATE
, return_date DATE
, rental_item_type VARCHAR(12)
, transaction_type VARCHAR(14)
, transaction_amount FLOAT(2)
, transaction_date DATE
, item_id	INT
, payment_method_type VARCHAR(14)
, payment_account_INT  VARCHAR(19)
) ENGINE=MEMORY;

-- Hints for tuning merge performance
-- Hint #1
CREATE INDEX tu_rental
 ON transaction_upload (account_INT, first_name, last_name, check_out_date, return_date);

 -- Hint #2 
 ALTER TABLE rental_item
ADD CONSTRAINT natural_key 
UNIQUE INDEX (rental_item_id, rental_id, item_id, rental_item_type, rental_item_price);

-- Hint #3
ALTER TABLE member
ADD CONSTRAINT member_u1
UNIQUE INDEX member_key (account_number, credit_card_number, credit_card_type, member_type);

LOAD DATA LOCAL INFILE 'c:/Data/Download/transaction_upload_mysql.csv'
INTO TABLE transaction_upload
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

-- Hint #1 for mysql
SELECT 'UPDATE transaction_upload' AS 'Update';
UPDATE transaction_upload
SET    middle_name = NULL
WHERE  middle_name = '';

-- Step #5
-- Merge Statement #1
-- Should return 4,372 rows
REPLACE INTO rental
 (SELECT   DISTINCT
                  r.rental_id
         ,        c.contact_id
         ,        tu.check_out_date
		 ,		  tu.return_date
		 , IFNULL(r.created_by, '2') AS created_by
		 , UTC_DATE() AS creation_date
		 , IFNULL(r.last_updated_by, '2') AS last_updated_by
		 , UTC_DATE() AS last_update_date
         FROM transaction_upload tu
		 INNER JOIN member m
			ON m.account_number = tu.account_INT
		 INNER JOIN contact c
			ON c.first_name = tu.first_name
			AND IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
			AND c.last_name = tu.last_name
			AND c.member_id = m.member_id
		 LEFT JOIN rental r
			ON r.customer_id = c.contact_id
			AND r.check_out_date = tu.check_out_date
			AND r.return_date = tu.return_date);
 
-- Merge Statement #2
  REPLACE INTO rental_item
  (
		SELECT 
		ri.rental_item_id
		, r.rental_id
		, tu.item_id
		 , IFNULL(r.created_by, '2') AS created_by
		 , UTC_DATE() AS creation_date
		 , IFNULL(r.last_updated_by, '2') AS last_updated_by
		 , UTC_DATE() AS last_update_date
		, cl.common_lookup_id AS rental_item_type
		, tu.transaction_amount
         FROM transaction_upload tu
		 INNER JOIN member m
			ON m.account_number = tu.account_INT
		 INNER JOIN contact c
			ON c.first_name = tu.first_name
			AND IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
			AND c.last_name = tu.last_name
			AND c.member_id = m.member_id
		 INNER JOIN rental r
			ON r.customer_id = c.contact_id
			AND r.check_out_date = tu.check_out_date
			AND r.return_date = tu.return_date
		INNER JOIN common_lookup cl
			ON cl.common_lookup_type = tu.rental_item_type
			AND cl.common_lookup_table = 'RENTAL_ITEM'
			AND cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
		LEFT JOIN rental_item ri
			ON ri.rental_id = r.rental_id);
  
 
-- Merge Statement #3
  REPLACE INTO TRANSACTION
  (SELECT
         t.transaction_id
         , tu.payment_account_INT AS transaction_account
         , cl1.common_lookup_id AS transaction_type
		 , tu.transaction_date
		 , SUM(tu.transaction_amount) AS transaction_amount
		 , r.rental_id
		 , cl2.common_lookup_id AS payment_method_type
		 , m.credit_card_number AS payment_account_number
		 , IFNULL(t.created_by, '2') AS created_by
		 , UTC_DATE() AS creation_date
		 , IFNULL(t.last_updated_by, '2') AS last_updated_by
		 , UTC_DATE() AS last_update_date
         FROM transaction_upload tu
		 INNER JOIN member m
			ON m.account_number = tu.account_INT
		 INNER JOIN contact c
			ON c.first_name = tu.first_name
			AND IFNULL(c.middle_name,'x') = IFNULL(tu.middle_name,'x')
			AND c.last_name = tu.last_name
			AND c.member_id = m.member_id
		 INNER JOIN rental r
			ON r.customer_id = c.contact_id
			AND r.check_out_date = tu.check_out_date
			AND r.return_date = tu.return_date
		INNER JOIN common_lookup cl1
			ON cl1.common_lookup_table = 'TRANSACTION'
			AND cl1.common_lookup_column = 'TRANSACTION_TYPE'
			AND cl1.common_lookup_type = tu.transaction_type
		INNER JOIN common_lookup cl2
			ON cl2.common_lookup_table = 'TRANSACTION'
			AND cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
			AND cl2.common_lookup_type = tu.payment_method_type
		LEFT JOIN transaction t
      ON  t.transaction_account = tu.payment_account_INT
      AND t.transaction_type = cl1.common_lookup_id
      AND t.transaction_date = tu.transaction_date
      AND t.payment_method_type = cl2.common_lookup_id
      AND t.payment_account_INT = m.credit_card_number
		GROUP BY t.transaction_id
            , r.rental_id
            , tu.payment_account_INT
            , cl1.common_lookup_id
            , tu.transaction_date
            , cl2.common_lookup_id
            , m.credit_card_number);
 
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;
		
-- +--------------+-------------------+-------------------+
-- | rental_count | rental_item_count | transaction_count |
-- +--------------+-------------------+-------------------+
-- |         4380 |             11532 |              4372 | 
-- +--------------+-------------------+-------------------+

-- Step 6
SELECT 
	DATE_FORMAT(transaction_date, '%b-%Y') AS MONTH
	, LPAD(CONCAT('$',FORMAT(SUM(transaction_amount),2)),14,' ') AS BASE_REVENUE
	, LPAD(CONCAT('$',FORMAT(SUM(transaction_amount)*1.10,2)),14,' ') AS PLUS_10
	, LPAD(CONCAT('$',FORMAT(SUM(transaction_amount)*1.20,2)),14,' ') AS PLUS_20
	, LPAD(CONCAT('$',FORMAT(SUM(transaction_amount)*1.10 - SUM(transaction_amount),2)),14,' ') AS PLUS_10_LESS_B
	, LPAD(CONCAT('$',FORMAT(SUM(transaction_amount)*1.20 - SUM(transaction_amount),2)),14,' ') AS PLUS_20_LESS_B
FROM transaction_upload
WHERE EXTRACT(YEAR FROM transaction_date) = 2009
GROUP BY DATE_FORMAT(transaction_date, '%m-%Y')
ORDER BY transaction_date ASC;

-- +----------+------------+------------+------------+------------+------------+
-- | MON-YEAR | BASE       | 10_PLUS    | 20_PLUS    | 10_DIFF    | 20_DIFF    |
-- +----------+------------+------------+------------+------------+------------+
-- | JAN-2009 |  $2,957.40 |  $3,253.14 |  $3,548.88 |    $295.74 |    $591.48 |
-- | FEB-2009 |  $4,022.70 |  $4,424.97 |  $4,827.24 |    $402.27 |    $804.54 |
-- | MAR-2009 |  $5,654.04 |  $6,219.44 |  $6,784.85 |    $565.40 |  $1,130.81 |
-- | APR-2009 |  $4,595.10 |  $5,054.61 |  $5,514.12 |    $459.51 |    $919.02 |
-- | MAY-2009 |  $2,219.64 |  $2,441.60 |  $2,663.57 |    $221.96 |    $443.93 |
-- | JUN-2009 |  $1,300.62 |  $1,430.68 |  $1,560.74 |    $130.06 |    $260.12 |
-- | JUL-2009 |  $2,413.62 |  $2,654.98 |  $2,896.34 |    $241.36 |    $482.72 |
-- | AUG-2009 |  $2,149.68 |  $2,364.65 |  $2,579.62 |    $214.97 |    $429.94 |
-- | SEP-2009 |  $2,162.40 |  $2,378.64 |  $2,594.88 |    $216.24 |    $432.48 |
-- | OCT-2009 |  $3,291.30 |  $3,620.43 |  $3,949.56 |    $329.13 |    $658.26 |
-- | NOV-2009 |  $3,246.78 |  $3,571.46 |  $3,896.14 |    $324.68 |    $649.36 |
-- | DEC-2009 |  $2,299.14 |  $2,529.05 |  $2,758.97 |    $229.91 |    $459.83 |
-- +----------+------------+------------+------------+------------+------------+
				
NOTEE