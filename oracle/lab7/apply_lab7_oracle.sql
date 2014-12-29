-- Oracle Lab #6

-- Create a fresh database.
@ ../lab6/apply_lab6_oracle.sql

-- Open log file. 
SPOOL apply_lab7_oracle.log

SET ECHO off

SET FEEDBACK ON
SET NULL '<NULL>'
SET SERVEROUTPUT ON
SET PAGESIZE 999
SET LINESIZE 999

-- Step 1
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'TRANSACTION') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE transaction CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'TRANSACTION_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE transaction_s1';
  END LOOP;
END;
/

CREATE TABLE transaction
	( TRANSACTION_ID			    NUMBER
	, TRANSACTION_ACCOUNT		  VARCHAR2(15)	CONSTRAINT nn_transaction_1 NOT NULL
	, TRANSACTION_TYPE			  NUMBER
	, TRANSACTION_DATE			  DATE 		    CONSTRAINT nn_transaction_2 NOT NULL
	, TRANSACTION_AMOUNT		  FLOAT		    CONSTRAINT nn_transaction_3 NOT NULL
	, RENTAL_ID					      NUMBER 
	, PAYMENT_METHOD_TYPE		  NUMBER 
	, PAYMENT_ACCOUNT_NUMBER	VARCHAR2(19)	CONSTRAINT nn_transaction_4 NOT NULL
	, CREATED_BY				      NUMBER
	, CREATION_DATE			      DATE        CONSTRAINT nn_transaction_5 NOT NULL
	, LAST_UPDATED_BY		      NUMBER
	, LAST_UPDATE_DATE			  DATE        CONSTRAINT nn_transaction_6 NOT NULL
	, CONSTRAINT pk_transaction_1 PRIMARY KEY (transaction_id)
	, CONSTRAINT fk_transaction_1 FOREIGN KEY (transaction_type)	REFERENCES common_lookup (common_lookup_id)
	, CONSTRAINT fk_transaction_2 FOREIGN KEY (rental_id)			REFERENCES rental (rental_id)
	, CONSTRAINT fk_transaction_3 FOREIGN KEY (payment_method_type)	REFERENCES common_lookup (common_lookup_id)
	, CONSTRAINT fk_transaction_4 FOREIGN KEY (created_by)			REFERENCES system_user (system_user_id)
	, CONSTRAINT fk_transaction_5 FOREIGN KEY (last_updated_by)		REFERENCES system_user (system_user_id));

-- Create sequence.
CREATE SEQUENCE transaction_s1 START WITH 1;

CREATE UNIQUE INDEX natural_key_transaction
ON transaction (rental_id, transaction_type, transaction_date, payment_method_type, payment_account_number);

-- Step 2

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'TRANSACTION_TYPE'
, 'CREDIT'
, 'Credit'
, 2
, SYSDATE
, 2
, SYSDATE
, 'TRANSACTION'
, 'TRANSACTION_TYPE'
, 'CR');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'TRANSACTION_TYPE'
, 'DEBIT'
, 'Debit'
, 2
, SYSDATE
, 2
, SYSDATE
, 'TRANSACTION'
, 'TRANSACTION_TYPE'
, 'DR');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'PAYMENT_METHOD_TYPE'
, 'DISCOVER_CARD'
, 'Discover Card'
, 2
, SYSDATE
, 2
, SYSDATE
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'PAYMENT_METHOD_TYPE'
, 'VISA_CARD'
, 'Visa Card'
, 2
, SYSDATE
, 2
, SYSDATE
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'PAYMENT_METHOD_TYPE'
, 'MASTER_CARD'
, 'Master Card'
, 2
, SYSDATE
, 2
, SYSDATE
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'PAYMENT_METHOD_TYPE'
, 'CASH'
, 'Cash'
, 2
, SYSDATE
, 2
, SYSDATE
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'RENTAL_ITEM_TYPE'
, '1-DAY RENTAL'
, '1-Day Rental'
, 2
, SYSDATE
, 2
, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'RENTAL_ITEM_TYPE'
, '3-DAY RENTAL'
, '3-Day Rental'
, 2
, SYSDATE
, 2
, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'RENTAL_ITEM_TYPE'
, '5-DAY RENTAL'
, '5-Day Rental'
, 2
, SYSDATE
, 2
, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '');

-- Step 3a

BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'AIRPORT') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE airport CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'AIRPORT_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE airport_s1';
  END LOOP;
END;
/

CREATE TABLE airport
( AIRPORT_ID			  NUMBER
, AIRPORT_CODE			VARCHAR2(3)  CONSTRAINT nn_airport_1 NOT NULL
, AIRPORT_CITY			VARCHAR2(30) CONSTRAINT nn_airport_2 NOT NULL
, CITY 					    VARCHAR2(30) CONSTRAINT nn_airport_3 NOT NULL
, STATE_PROVINCE		VARCHAR2(30) CONSTRAINT nn_airport_4 NOT NULL
, CREATED_BY        NUMBER
, CREATION_DATE     DATE         CONSTRAINT nn_airport_5 NOT NULL
, LAST_UPDATED_BY   NUMBER
, LAST_UPDATE_DATE  DATE         CONSTRAINT nn_airport_6 NOT NULL
, CONSTRAINT pk_airport_1 PRIMARY KEY (airport_id)
, CONSTRAINT fk_airport_1 FOREIGN KEY (created_by)		  REFERENCES system_user (system_user_id)
, CONSTRAINT fk_airport_2 FOREIGN KEY (last_updated_by)	REFERENCES system_user (system_user_id));

-- Create sequence.
CREATE SEQUENCE airport_s1 START WITH 1;

BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'ACCOUNT_LIST') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE account_list CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'ACCOUNT_LIST_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE account_list_s1';
  END LOOP;
END;
/

CREATE TABLE account_list
( ACCOUNT_LIST_ID   NUMBER
, ACCOUNT_NUMBER    VARCHAR2(10)
, CONSUMED_DATE     DATE
, CONSUMED_BY       NUMBER
, CREATED_BY        NUMBER
, CREATION_DATE     DATE      CONSTRAINT nn_account_list_5 NOT NULL
, LAST_UPDATED_BY   NUMBER
, LAST_UPDATE_DATE  DATE      CONSTRAINT nn_account_list_6 NOT NULL
, CONSTRAINT pk_account_list_1 PRIMARY KEY (account_list_id)
, CONSTRAINT fk_account_list_1 FOREIGN KEY (consumed_by)     REFERENCES system_user (system_user_id)
, CONSTRAINT fk_account_list_2 FOREIGN KEY (created_by)      REFERENCES system_user (system_user_id)
, CONSTRAINT fk_account_list_3 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id));

-- Create sequence.
CREATE SEQUENCE account_list_s1 START WITH 1;

-- Step 3b

INSERT INTO airport
VALUES
( airport_s1.NEXTVAL
, 'LAX'
, 'Los Angeles'
, 'Los Angeles'
, 'California'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO airport
VALUES
( airport_s1.NEXTVAL
, 'SLC'
, 'Salt Lake City'
, 'Provo'
, 'Utah'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO airport
VALUES
( airport_s1.NEXTVAL
, 'SLC'
, 'Salt Lake City'
, 'Spanish Fork'
, 'Utah'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO airport
VALUES
( airport_s1.NEXTVAL
, 'SFO'
, 'San Francisco'
, 'San Francisco'
, 'California'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO airport
VALUES
( airport_s1.NEXTVAL
, 'SJC'
, 'San Jose'
, 'San Jose'
, 'California'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO airport
VALUES
( airport_s1.NEXTVAL
, 'SJC'
, 'San Jose'
, 'San Carlos'
, 'California'
, 2, SYSDATE, 2, SYSDATE);

-- Step 3c

-- Create or replace seeding procedure.
CREATE OR REPLACE PROCEDURE seed_account_list IS
BEGIN
-- Set savepoint.
  SAVEPOINT all_or_none;
 
  FOR i IN (SELECT DISTINCT airport_code FROM airport) LOOP
    FOR j IN 1..50 LOOP
 
      INSERT INTO account_list
      VALUES
      ( account_list_s1.NEXTVAL
      , i.airport_code||'-'||LPAD(j,6,'0')
      , NULL
      , NULL
      , 2
      , SYSDATE
      , 2
      , SYSDATE);
    END LOOP;
  END LOOP;
 
-- Commit the writes as a group.
  COMMIT;
 
EXCEPTION
  WHEN OTHERS THEN
-- This undoes all DML statements to this point in the procedure.
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/

EXECUTE seed_account_list();

SELECT COUNT(*) AS "# Accounts"
FROM   account_list;

-- Step 3d

UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';

-- Step 3e

CREATE OR REPLACE PROCEDURE update_member_account IS
 
-- Declare a local variable.
  lv_account_number VARCHAR2(10);
 
-- Declare a SQL cursor fabricated from local variables.  
  CURSOR member_cursor IS
    SELECT   DISTINCT
             m.member_id
    ,        a.city
    ,        a.state_province
    FROM     member m INNER JOIN contact c
    ON       m.member_id = c.member_id INNER JOIN address a
    ON       c.contact_id = a.contact_id
    ORDER BY m.member_id;
 
BEGIN
 
-- Set savepoint.  
  SAVEPOINT all_or_none;
 
-- Open a local cursor.  
  FOR i IN member_cursor LOOP
 
-- Secure a unique account number as they're consumed from the list.
      SELECT al.account_number
      INTO   lv_account_number
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTR(al.account_number,1,3) = ap.airport_code
      WHERE  ap.city = i.city
      AND    ap.state_province = i.state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL
      AND    ROWNUM < 2;
 
-- Update a member with a unique account number linked to their nearest airport.
      UPDATE member
      SET    account_number = lv_account_number
      WHERE  member_id = i.member_id;
 
-- Mark consumed the last used account number.
      UPDATE account_list
      SET    consumed_by = 2
      ,      consumed_date = SYSDATE
      WHERE  account_number = lv_account_number;
 
  END LOOP;
 
-- Commit the writes as a group.
  COMMIT;
 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('You have an error in your AIRPORT table inserts.');
 
-- This undoes all DML statements to this point in the procedure.
    ROLLBACK TO SAVEPOINT all_or_none;
  WHEN OTHERS THEN
-- This undoes all DML statements to this point in the procedure.
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/

SET SERVEROUTPUT ON SIZE UNLIMITED
EXECUTE update_member_account();

-- Format the SQL statement display.
COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A10    HEADING "Last|Name"
COLUMN account_number FORMAT A10    HEADING "Account|Number"
COLUMN city           FORMAT A16    HEADING "City"
COLUMN state_province FORMAT A10    HEADING "State or|Province"
 
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

-- Step 4

-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'TRANSACTION_UPLOAD') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE transaction_upload CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'TRANSACTION_UPLOAD_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE transaction_upload_s1';
  END LOOP;
END;
/

CREATE TABLE transaction_upload
( 
account_number VARCHAR2(10)
, first_name VARCHAR2(20)
, middle_name VARCHAR2(20)
, last_name VARCHAR2(20)
, check_out_date DATE
, return_date DATE
, rental_item_type VARCHAR2(12)
, transaction_type VARCHAR2(14)
, transaction_amount NUMBER
, transaction_date DATE
, item_id	NUMBER
, payment_method_type VARCHAR2(14)
, payment_account_number  VARCHAR2(19)
)
  ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY download
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'DOWNLOAD':'transaction_upload.bad'
      DISCARDFILE 'DOWNLOAD':'transaction_upload.dis'
      LOGFILE     'DOWNLOAD':'transaction_upload.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL )
    LOCATION ('transaction_upload.csv'))
REJECT LIMIT UNLIMITED;

-- Step #5
-- Merge Statement #1
MERGE INTO rental target
  USING (SELECT   DISTINCT
                  r.rental_id
         ,        c.contact_id
         ,        tu.check_out_date
		 ,		  tu.return_date
		 , r.created_by AS created_by
		 , SYSDATE AS creation_date
		 , r.last_updated_by AS last_updated_by
		 , SYSDATE AS last_update_date
         FROM transaction_upload tu
		 INNER JOIN member m
			ON m.account_number = tu.account_number
		 INNER JOIN contact c
			ON c.first_name = tu.first_name
			AND NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
			AND c.last_name = tu.last_name
			AND c.member_id = m.member_id
		 LEFT JOIN rental r
			ON r.customer_id = c.contact_id
			AND r.check_out_date = tu.check_out_date
			AND r.return_date = tu.return_date) SOURCE
  ON (target.rental_id = SOURCE.rental_id)
  WHEN MATCHED THEN
  UPDATE SET target.last_updated_by = SOURCE.last_updated_by
  , target.last_update_date = SOURCE.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_s1.NEXTVAL
  , SOURCE.contact_id
  , SOURCE.check_out_date
  , SOURCE.return_date
  , 2
  , SYSDATE
  , 2
  , SYSDATE);
 
-- Merge Statement #2
  MERGE INTO rental_item target
  USING (
		SELECT
		ri.rental_item_id
		, r.rental_id
		, tu.item_id
		, r.created_by
		, SYSDATE AS creation_date
		, r.last_updated_by
		, SYSDATE AS last_update_date
		, cl.common_lookup_id AS rental_item_type
		, tu.transaction_amount
         FROM transaction_upload tu
		 INNER JOIN member m
			ON m.account_number = tu.account_number
		 INNER JOIN contact c
			ON c.first_name = tu.first_name
			AND NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
			AND c.last_name = tu.last_name
			AND c.member_id = m.member_id
		 INNER JOIN rental r
			ON r.customer_id = c.contact_id
			AND r.check_out_date = tu.check_out_date
			AND r.return_date = tu.return_date
		INNER JOIN common_lookup cl
			ON cl.common_lookup_type = tu.rental_item_type
		LEFT JOIN rental_item ri
			ON ri.rental_id = r.rental_id
  ) SOURCE
    ON (target.rental_item_id = SOURCE.rental_item_id)
  WHEN MATCHED THEN
  UPDATE SET target.last_updated_by = SOURCE.last_updated_by
  , target.last_update_date = SOURCE.last_update_date
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( rental_item_s1.NEXTVAL
  , SOURCE.rental_id
  , SOURCE.item_id
  , 2
  , SYSDATE
  , 2
  , SYSDATE
  , SOURCE.rental_item_type
  , CAST (SOURCE.transaction_amount AS NUMBER));
  
 
-- Merge Stateent #3
  MERGE INTO TRANSACTION target
  USING (SELECT
          t.transaction_id
        , tu.payment_account_number AS transaction_account
        , cl1.common_lookup_id AS transaction_type
        , tu.transaction_date AS transaction_date
        , SUM(tu.transaction_amount) AS transaction_amount
        , r.rental_id 
        , cl2.common_lookup_id  AS payment_method_type
        , m.credit_card_number AS payment_account_number
		 , 2 AS created_by
		 , SYSDATE AS creation_date
		 , 2 AS last_updated_by
		 , SYSDATE AS last_update_date
         FROM transaction_upload tu
		 INNER JOIN member m
			ON m.account_number = tu.account_number
		 INNER JOIN contact c
			ON c.first_name = tu.first_name
			AND NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
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
      ON  t.transaction_account = tu.payment_account_number
      AND t.transaction_type = cl1.common_lookup_id
      AND t.transaction_date = tu.transaction_date
      AND t.payment_method_type = cl2.common_lookup_id
      AND t.payment_account_number = m.credit_card_number
		GROUP BY t.transaction_id
            , r.rental_id
            , tu.payment_account_number
            , cl1.common_lookup_id
            , tu.transaction_date
            , cl2.common_lookup_id
            , m.credit_card_number) SOURCE
  ON (target.transaction_id = SOURCE.transaction_id)
  WHEN MATCHED THEN
  UPDATE SET
    transaction_account = SOURCE.transaction_account 
  , transaction_type = SOURCE.transaction_type
  , transaction_date = SOURCE.transaction_date
  , transaction_amount = SOURCE.transaction_amount
  , rental_id = SOURCE.rental_id
  , payment_method_type = SOURCE.payment_method_type
  , payment_account_number = SOURCE.payment_account_number
  , last_updated_by = 2
  , last_update_date = SYSDATE
  WHEN NOT MATCHED THEN
  INSERT VALUES
  ( transaction_s1.NEXTVAL
  , SOURCE.transaction_account 
  , SOURCE.transaction_type
  , SOURCE.transaction_date
  , SOURCE.transaction_amount
  , SOURCE.rental_id
  , SOURCE.payment_method_type
  , SOURCE.payment_account_number
  , 2
  , SYSDATE
  , 2
  , SYSDATE);
 
-- Validation Query
COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
 
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;

-- Step 6
SET LINESIZE 9999
COLUMN month      FORMAT A8 HEADING "MONTH"
COLUMN BASE_REVENUE      FORMAT 9,999,999.99 HEADING "BASE_REVENUE"
COLUMN PLUS_10      FORMAT 9,999,999.99 HEADING "PLUS_10"
COLUMN PLUS_20      FORMAT 9,999,999.99 HEADING "PLUS_20"
COLUMN PLUS_10_LESS_B      FORMAT 9,999,999.99 HEADING "PLUS_10_LESS_B"
COLUMN PLUS_20_LESS_B      FORMAT 9,999,999.99 HEADING "PLUS_20_LESS_B"

SELECT 
	CONCAT(TO_CHAR(TO_DATE(EXTRACT(MONTH FROM transaction_date), 'mm'), 'MON'), '-2009') AS MONTH
	, TO_CHAR(SUM(transaction_amount), '$9,999,999.00') AS BASE_REVENUE
	, TO_CHAR(SUM(transaction_amount)*1.10, '$9,999,999.00') AS PLUS_10
	, TO_CHAR(SUM(transaction_amount)*1.20, '$9,999,999.00') AS PLUS_20
	, TO_CHAR(SUM(transaction_amount)*1.10 - SUM(transaction_amount), '$9,999,999.00') AS PLUS_10_LESS_B
	, TO_CHAR(SUM(transaction_amount)*1.20 - SUM(transaction_amount), '$9,999,999.00') AS PLUS_20_LESS_B
FROM transaction
WHERE EXTRACT(YEAR FROM transaction_date) = 2009
GROUP BY EXTRACT(MONTH FROM transaction_date)
ORDER BY TO_DATE(month, 'MON-YYYY');
		
SPOOL OFF