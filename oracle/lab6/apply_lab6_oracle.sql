-- Oracle Lab #6

-- Create a fresh database.
@ ../lab5/apply_lab5_oracle.sql

-- Open log file. 
SPOOL apply_lab6_oracle.log

Set ECHO off

Set FEEDBACK ON
Set NULL '<NULL>'
SET SERVEROUTPUT ON
set PAGESIZE 999
	
ALTER TABLE item
	RENAME COLUMN ITEM_RELEASE_DATE TO RELEASE_DATE;

-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'PRICE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE price CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'PRICE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE price_s1';
  END LOOP;
END;
/	
	
CREATE TABLE price
	( PRICE_ID 						NUMBER 	
	, ITEM_ID 							NUMBER 	
	, PRICE_TYPE 					NUMBER 	
	, ACTIVE_FLAG 				CHAR(1) 	CONSTRAINT nn_price_1 NOT NULL
	, START_DATE 				DATE 		CONSTRAINT nn_price_2 NOT NULL
	, END_DATE 					DATE 
	, AMOUNT 						NUMBER
	, CREATED_BY 				NUMBER 	
	, CREATION_DATE 			DATE 		CONSTRAINT nn_price_3 NOT NULL	
	, LAST_UPDATED_BY 		NUMBER 	
	, LAST_UPDATED_DATE 	DATE 		CONSTRAINT nn_price_4 NOT NULL
	, CONSTRAINT pk_price_1 PRIMARY KEY (price_id)
	, CONSTRAINT fk_price_1 	FOREIGN KEY (item_id) REFERENCES item (item_id)
	, CONSTRAINT fk_price_2 	FOREIGN KEY (price_type) REFERENCES common_lookup (common_lookup_id)
	, CONSTRAINT fk_price_3 	FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
	, CONSTRAINT fk_price_4 	FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
	, CONSTRAINT cc_price_1 CHECK (ACTIVE_FLAG IN ('Y','N')));
	
-- Create sequence.
CREATE SEQUENCE price_s1 START WITH 1001;
	
INSERT INTO item 
VALUES(
		item_s1.nextval
		, '12345678910111'
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'DVD_FULL_SCREEN')
		, 'Iron Man 3'
		, 'IM3'
		, 'PG13'
		, TRUNC(SYSDATE-1)
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);
		
INSERT INTO item 
VALUES(
		item_s1.nextval
		, '22345678910111'
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'DVD_FULL_SCREEN')
		, 'Iron Man 2'
		, 'IM2'
		, 'PG13'
		, TRUNC(SYSDATE-1)
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);

INSERT INTO item 
VALUES(
		item_s1.nextval
		, '32345678910111'
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'DVD_FULL_SCREEN')
		, 'Iron Man'
		, 'IM'
		, 'PG13'
		, TRUNC(SYSDATE-1)
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);
		
INSERT INTO member
VALUES(
		member_s1.nextval
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'GROUP')
		, '1950791769'
		, '5555555555555555'
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'MASTER_CARD')
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);

INSERT INTO contact
VALUES(
		contact_s1.nextval
		, member_s1.currval
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'CUSTOMER')
		, 'Harry'
		, NULL
		, 'Potter'
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);

INSERT INTO ADDRESS
VALUES(
		address_s1.nextval
		, contact_s1.currval
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'HOME')
		, 'Provo'
		, 'Utah'
		, '84057'
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);	

INSERT INTO STREET_ADDRESS
VALUES(
		street_address_s1.nextval
		, address_s1.currval
		, '1045 Happy Lane'
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);		

INSERT INTO TELEPHONE
VALUES (
	telephone_s1.nextval
	, contact_s1.currval
	, address_s1.currval
	, (SELECT common_lookup_id 
	   FROM common_lookup 
	   WHERE COMMON_LOOKUP_TYPE = 'HOME')
	, '001'
	, '801'
	, '123-4567'
	, 2
	, SYSDATE
	, 2
	, SYSDATE);
	   	
INSERT INTO contact
VALUES(
		contact_s1.nextval
		, member_s1.currval
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'CUSTOMER')
		, 'Ginny'
		, NULL
		, 'Potter'
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);	

INSERT INTO ADDRESS
VALUES(
		address_s1.nextval
		, contact_s1.currval
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'HOME')
		, 'Provo'
		, 'Utah'
		, '84057'
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);	

INSERT INTO STREET_ADDRESS
VALUES(
		street_address_s1.nextval
		, address_s1.currval
		, '1045 Happy Lane'
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);	

INSERT INTO TELEPHONE
VALUES (
	telephone_s1.nextval
	, contact_s1.currval
	, address_s1.currval
	, (SELECT common_lookup_id 
	   FROM common_lookup 
	   WHERE COMMON_LOOKUP_TYPE = 'HOME')
	, '001'
	, '801'
	, '123-4567'
	, 2
	, SYSDATE
	, 2
	, SYSDATE);
	
INSERT INTO contact
VALUES(
		contact_s1.nextval
		, member_s1.currval
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'CUSTOMER')
		, 'Lily'
		, 'Luna'
		, 'Potter'
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);			

INSERT INTO ADDRESS
VALUES(
		address_s1.nextval
		, contact_s1.currval
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'HOME')
		, 'Provo'
		, 'Utah'
		, '84057'
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);	

INSERT INTO STREET_ADDRESS
VALUES(
		street_address_s1.nextval
		, address_s1.currval
		, '1045 Happy Lane'
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);		

INSERT INTO TELEPHONE
VALUES (
	telephone_s1.nextval
	, contact_s1.currval
	, address_s1.currval
	, (SELECT common_lookup_id 
	   FROM common_lookup 
	   WHERE COMMON_LOOKUP_TYPE = 'HOME')
	, '001'
	, '801'
	, '123-4567'
	, 2
	, SYSDATE
	, 2
	, SYSDATE);
	
INSERT INTO Rental
VALUES(
		rental_s1.nextval
		, (SELECT contact_id
			FROM contact
			WHERE last_name = 'Potter'
			AND first_name = 'Harry')
		, SYSDATE
		, SYSDATE+1
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);
			
INSERT INTO Rental_Item
VALUES(
		rental_item_s1.nextval
		, rental_s1.currval
		, (select item_id FROM item WHERE item_title = 'Iron Man 3')
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);		

INSERT INTO Rental
VALUES(
		rental_s1.nextval
		, (SELECT contact_id
			FROM contact
			WHERE last_name = 'Potter'
			AND first_name = 'Ginny')
		, SYSDATE
		, SYSDATE+3
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);
		
INSERT INTO Rental_Item
VALUES(
		rental_item_s1.nextval
		, rental_s1.currval
		, (select item_id FROM item WHERE ITEM_Title = 'Iron Man 2')
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);

INSERT INTO Rental
VALUES(
		rental_s1.nextval
		, (SELECT contact_id
			FROM contact
			WHERE last_name = 'Potter'
			AND first_name = 'Lily')
		, SYSDATE
		, SYSDATE+5
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);
		
INSERT INTO Rental_Item
VALUES(
		rental_item_s1.nextval
		, rental_s1.currval
		, (select item_id FROM item WHERE ITEM_Title = 'Iron Man')
		, 2
		, SYSDATE
		, 2
		, SYSDATE
		);	
		
--Step #4
ALTER TABLE common_lookup
ADD
(
COMMON_LOOKUP_TABLE VARCHAR2(30)
, COMMON_LOOKUP_COLUMN VARCHAR2(30)
, COMMON_LOOKUP_CODE VARCHAR2(30) 
);

UPDATE   common_lookup
SET      COMMON_LOOKUP_TABLE = common_lookup_context
,        COMMON_LOOKUP_COLUMN = common_lookup_type
WHERE    COMMON_LOOKUP_CONTEXT != 'MULTIPLE';

UPDATE   common_lookup
SET      COMMON_LOOKUP_TABLE = 'MULTIPLE'
,        COMMON_LOOKUP_COLUMN = 'ADDRESS'
WHERE    COMMON_LOOKUP_CONTEXT = 'MULTIPLE';

ALTER TABLE common_lookup
MODIFY
(
COMMON_LOOKUP_TABLE VARCHAR2(30) CONSTRAINT nn_lookup_table NOT NULL
, COMMON_LOOKUP_COLUMN VARCHAR2(30) CONSTRAINT nn_lookup_column NOT NULL
, COMMON_LOOKUP_CODE VARCHAR2(30) 
);

DROP INDEX common_lookup_u2;

--ALTER TABLE common_lookup
--DROP COLUMN common_lookup_context;

INSERT INTO common_lookup
	VALUES (
	common_lookup_s1.nextval
	, 'HOME'
	, 'HOME'
	, 'Home'
	, 2
	, SYSDATE
	, 2
	, SYSDATE
	, 'TELEPHONE'
	, 'TELEPHONE_TYPE'
	, NULL
	);
INSERT INTO common_lookup
	VALUES (
	common_lookup_s1.nextval
	, 'WORK'
	, 'WORK'
	, 'Work'
	, 2
	, SYSDATE
	, 2
	, SYSDATE
	, 'TELEPHONE'
	, 'TELEPHONE_TYPE'
	, NULL
	);
		
CREATE UNIQUE INDEX common_lookup_u3
	ON common_lookup(COMMON_LOOKUP_TABLE, COMMON_LOOKUP_COLUMN, COMMON_LOOKUP_TYPE);
	
--Step 5
INSERT INTO common_lookup
VALUES (common_lookup_s1.nextval
, 'YES'
, 'YES'
, 'Yes'
, 2
, SYSDATE
, 2
, SYSDATE
, 'PRICE'
, 'ACTIVE_FLAG'
, 'Y');

INSERT INTO common_lookup
VALUES (common_lookup_s1.nextval
, 'NO'
, 'NO'
, 'No'
, 2
, SYSDATE
, 2
, SYSDATE
, 'PRICE'
, 'ACTIVE_FLAG'
, 'N');

--Step 6	
INSERT INTO common_lookup
VALUES (common_lookup_s1.nextval
, '1-Day RENTAL'
, '1-Day RENTAL'
, '1-Day Rental'
, 2
, SYSDATE
, 2
, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '1');

		
INSERT INTO common_lookup
VALUES (common_lookup_s1.nextval
, '3-Day RENTAL'
, '3-Day RENTAL'
, '3-Day Rental'
, 2
, SYSDATE
, 2
, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '3');

		
INSERT INTO common_lookup
VALUES (common_lookup_s1.nextval
, '5-Day RENTAL'
, '5-Day RENTAL'
, '5-Day Rental'
, 2
, SYSDATE
, 2
, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '5');

--Step 7
ALTER TABLE rental_item
ADD (
rental_item_type INTEGER
, rental_item_price INTEGER
);

--CONSTRAINT nn_item_price_1 NOT NULL

ALTER TABLE rental_item
ADD 
FOREIGN KEY (rental_item_type)
REFERENCES common_lookup(common_lookup_id)
;

UPDATE   rental_item ri
SET      ri.rental_item_type =
           (SELECT   cl.common_lookup_id
            FROM     common_lookup cl
            WHERE    cl.common_lookup_code =
			cast(
             (SELECT   r.return_date - r.check_out_date
               FROM     rental r
               WHERE    r.rental_id = ri.rental_id)
			   as varchar(1)
			   ));

--Step 4
UPDATE common_lookup
SET common_lookup_table = 
	CASE
		WHEN common_lookup_context = 'MULTIPLE' THEN
		'ADDRESS'
		ELSE
			common_lookup_context
		END
,		common_lookup_column = 
	CASE
		WHEN common_lookup_context = 'MULTIPLE' THEN
		'ADDRESS_TYPE'
		ELSE
		 common_lookup_context||'_TYPE'
		END;

INSERT INTO common_lookup
(SELECT 
 COMMON_LOOKUP_S1.NEXTVAL
, COMMON_LOOKUP_CONTEXT
, COMMON_LOOKUP_TYPE
, COMMON_LOOKUP_MEANING
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, COMMON_LOOKUP_CODE
FROM common_lookup
WHERE common_lookup_table = 'ADDRESS'
AND common_lookup_column = 'ADDRESS_TYPE');


UPDATE telephone
SET telephone_type = 
	(select common_lookup_id
	from common_lookup
	WHERE common_lookup_table = 'TELEPHONE'
	AND common_lookup_column = 'TELEPHONE_TYPE'
	AND common_lookup_type = 'HOME')
WHERE telephone_type = 	
	(select common_lookup_id
	from common_lookup
	WHERE common_lookup_table = 'ADDRESS'
	AND common_lookup_column = 'ADDRESS_TYPE'
	AND common_lookup_type = 'HOME');
	
-- --------------------------------------------------------------
-- Step 8
INSERT
INTO    price
(SELECT   price_s1.NEXTVAL         -- PRICE_ID
 , i.item_id                       -- ITEM_ID
 ,(CASE 
	WHEN pt.price_type = 1
	THEN (SELECT   cl.common_lookup_id    -- PRICE_TYPE
			FROM     common_lookup cl
			WHERE    cl.common_lookup_type = '1-Day RENTAL')
	WHEN pt.price_type = 3
	THEN (SELECT   cl.common_lookup_id    -- PRICE_TYPE
			FROM     common_lookup cl
			WHERE    cl.common_lookup_type = '3-Day RENTAL')
	WHEN pt.price_type = 5
	THEN (SELECT   cl.common_lookup_id    -- PRICE_TYPE
			FROM     common_lookup cl
			WHERE    cl.common_lookup_type = '5-Day RENTAL')
	END)
 , af.active_flag                              -- ACTIVE_FLAG
 , CASE                            -- START_DATE
     WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
       THEN i.release_date
       ELSE i.release_date + 31
   END
 , (CASE
		WHEN af.active_flag = 'Y' --End Date
		THEN NULL
		ELSE i.release_date + 31 + 30
	END)
  ,(CASE                   -- AMOUNT`
              WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
               AND af.active_flag = 'Y'
			   THEN 
					CASE
						WHEN pt.price_type = 1 THEN 3
						WHEN pt.price_type = 3 THEN 10
						WHEN pt.price_type = 5 THEN 15
					END
			  WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
               AND af.active_flag = 'N'
			   THEN 
					CASE
						WHEN pt.price_type = 1 THEN 3
						WHEN pt.price_type = 3 THEN 10
						WHEN pt.price_type = 5 THEN 15
					END
			  WHEN (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
               AND af.active_flag = 'Y'
			   THEN 
					CASE
						WHEN pt.price_type = 1 THEN 1
						WHEN pt.price_type = 3 THEN 3
						WHEN pt.price_type = 5 THEN 5
					END
             END)
 , 1                               -- CREATED_BY
 , SYSDATE                         -- CREATION_DATE
 , 1                               -- LAST_UPDATED_BY
 , SYSDATE                         -- LAST_UPDATE_DATE
 FROM   item i CROSS JOIN
          (SELECT 'Y' AS active_flag
           FROM   dual
           UNION ALL
           SELECT 'N' AS active_flag
           FROM   dual) af
                          CROSS JOIN 
          (SELECT '1' AS price_type
           FROM   dual
           UNION ALL
           SELECT '3' AS price_type
           FROM   dual
           UNION ALL
           SELECT '5' AS price_type
           FROM   dual) pt
		   WHERE NOT ((TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31 AND af.active_flag = 'N')
);


-- This is the check portion for the lab
-- Should look like 
-- Type       1-Day      3-Day      5-Day      TOTAL
-- ----- ---------- ---------- ---------- ----------
-- OLD Y         21         21         21         63
-- OLD N         21         21         21         63
-- NEW Y          3          3          3          9
-- NEW N          0          0          0          0

SELECT  'OLD Y' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y'
AND      i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND      end_date IS NULL
UNION ALL
SELECT  'OLD N' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N'
AND      i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND NOT (end_date IS NULL)
UNION ALL
SELECT  'NEW Y' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y'
AND      i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      end_date IS NULL
UNION ALL
SELECT  'NEW N' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N'
AND      i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND NOT (end_date IS NULL);

-- Step 9
ALTER TABLE price
MODIFY price_type NOT NULL;

-- Step 10
UPDATE   rental_item ri
SET      rental_item_price =
           (SELECT   p.amount
            FROM     price p CROSS JOIN rental r
            WHERE    p.item_id = ri.item_id
            AND      ri.rental_id = r.rental_id
            AND      r.check_out_date
                       BETWEEN NVL(p.start_date, SYSDATE) AND NVL(p.end_date, SYSDATE)
            AND   p.price_type = ri.rental_item_type);
			
SELECT   ri.rental_item_id, ri.rental_item_price, p.amount
FROM     price p JOIN rental_item ri 
ON       p.item_id = ri.item_id AND p.price_type = ri.rental_item_type
JOIN     rental r ON ri.rental_id = r.rental_id
WHERE    r.check_out_date BETWEEN p.start_date AND NVL(p.end_date, SYSDATE)
ORDER BY 1;

SPOOL OFF
