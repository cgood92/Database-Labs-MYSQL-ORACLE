-- Oracle Lab #6
USE studentdb;

-- Create a fresh database.
\. ../lab5/apply_lab5_mysql.sql

-- Open log file. 
TEE apply_lab6_mysql.log
	
ALTER TABLE item
	CHANGE ITEM_RELEASE_DATE RELEASE_DATE DATE;

-- Conditionally drop table and sequence.
DROP TABLE IF EXISTS price;
	
CREATE TABLE price
	( PRICE_ID 						INT UNSIGNED PRIMARY KEY AUTO_INCREMENT	
	, ITEM_ID 							INT UNSIGNED	
	, PRICE_TYPE 					INT UNSIGNED
	, ACTIVE_FLAG 				ENUM('Y','N') 	NOT NULL
	, START_DATE 				DATE 		NOT NULL
	, END_DATE 					DATE 
	, AMOUNT 						INT
	, CREATED_BY 				INT UNSIGNED
	, CREATION_DATE 			DATE 		NOT NULL	
	, LAST_UPDATED_BY 		INT UNSIGNED
	, LAST_UPDATED_DATE 	DATE 		NOT NULL
	, CONSTRAINT fk_price_1 	FOREIGN KEY (item_id) REFERENCES item (item_id)
	, CONSTRAINT fk_price_2 	FOREIGN KEY (price_type) REFERENCES common_lookup (common_lookup_id)
	, CONSTRAINT fk_price_3 	FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
	, CONSTRAINT fk_price_4 	FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
	);
	
INSERT INTO item 
VALUES(
		NULL
		, '12345678910111'
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'DVD_FULL_SCREEN')
		, 'Iron Man 3'
		, 'IM3'
		, (SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
		, DATE_SUB(UTC_DATE(), INTERVAL 1 DAY)
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);
		
INSERT INTO item 
VALUES(
		NULL
		, '22345678910111'
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'DVD_FULL_SCREEN')
		, 'Iron Man 2'
		, 'IM2'
		, (SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
		, DATE_SUB(UTC_DATE(), INTERVAL 1 DAY)
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);

INSERT INTO item 
VALUES(
		NULL
		, '32345678910111'
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'DVD_FULL_SCREEN')
		, 'Iron Man'
		, 'IM3'
		, (SELECT   rating_agency_id
  FROM     rating_agency
  WHERE    rating = 'PG'
  AND      rating_agency = 'MPAA')
		, DATE_SUB(UTC_DATE(), INTERVAL 1 DAY)
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);
		
INSERT INTO member
VALUES(
		NULL
		, '1950791769'
		, '5555555555555555'
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'MASTER_CARD')
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'GROUP')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);

SET @member_id := last_insert_id();

INSERT INTO contact
VALUES(
		NULL
		, @member_id
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'CUSTOMER')
		, 'Harry'
		, NULL
		, 'Potter'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);
		
SET @contact_id := last_insert_id();

INSERT INTO ADDRESS
VALUES(
		NULL
		, @contact_id
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'HOME')
		, 'Provo'
		, 'Utah'
		, '84057'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);	

SET @address_id := last_insert_id();

INSERT INTO STREET_ADDRESS
VALUES(
		NULL
		, @address_id
		, '1045 Happy Lane'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);		

INSERT INTO TELEPHONE
VALUES (
	NULL
	, @contact_id
	, @address_id
	, (SELECT common_lookup_id 
	   FROM common_lookup 
	   WHERE COMMON_LOOKUP_TYPE = 'HOME')
	, '001'
	, '801'
	, '123-4567'
	, 2
	, UTC_DATE()
	, 2
	, UTC_DATE());
	   	
INSERT INTO contact
VALUES(
		NULL
		, @member_id
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'CUSTOMER')
		, 'Ginny'
		, NULL
		, 'Potter'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);	
		
SET @contact_id := last_insert_id();

INSERT INTO ADDRESS
VALUES(
		NULL
		, @contact_id
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'HOME')
		, 'Provo'
		, 'Utah'
		, '84057'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);	

SET @address_id := last_insert_id();

INSERT INTO STREET_ADDRESS
VALUES(
		NULL
		, @address_id
		, '1045 Happy Lane'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);	

INSERT INTO TELEPHONE
VALUES (
	NULL
	, @contact_id
	, @address_id
	, (SELECT common_lookup_id 
	   FROM common_lookup 
	   WHERE COMMON_LOOKUP_TYPE = 'HOME')
	, '001'
	, '801'
	, '123-4567'
	, 2
	, UTC_DATE()
	, 2
	, UTC_DATE());
	
INSERT INTO contact
VALUES(
		NULL
		, @member_id
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'CUSTOMER')
		, 'Lily'
		, 'Luna'
		, 'Potter'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);			

SET @contact_id := last_insert_id();
		
INSERT INTO ADDRESS
VALUES(
		NULL
		, @contact_id
		, (select common_lookup_id FROM common_lookup WHERE COMMON_LOOKUP_TYPE = 'HOME')
		, 'Provo'
		, 'Utah'
		, '84057'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);	
		
SET @address_id := last_insert_id();

INSERT INTO STREET_ADDRESS
VALUES(
		NULL
		, @address_id
		, '1045 Happy Lane'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);		

INSERT INTO TELEPHONE
VALUES (
	NULL
	, @contact_id
	, @address_id
	, (SELECT common_lookup_id 
	   FROM common_lookup 
	   WHERE COMMON_LOOKUP_TYPE = 'HOME')
	, '001'
	, '801'
	, '123-4567'
	, 2
	, UTC_DATE()
	, 2
	, UTC_DATE());
	
INSERT INTO Rental
VALUES(
		NULL
		, (SELECT contact_id
			FROM contact
			WHERE last_name = 'Potter'
			AND first_name = 'Harry')
		, UTC_DATE()
		, DATE_ADD(UTC_DATE(), INTERVAL 1 DAY)
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);
		
SET @rental_id := last_insert_id();
			
INSERT INTO Rental_Item
VALUES(
		NULL
		, @rental_id
		, (select item_id FROM item WHERE item_title = 'Iron Man 3')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);		

INSERT INTO Rental
VALUES(
		NULL
		, (SELECT contact_id
			FROM contact
			WHERE last_name = 'Potter'
			AND first_name = 'Ginny')
		, UTC_DATE()
		, DATE_ADD(UTC_DATE(), INTERVAL 3 DAY)
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);
		
SET @rental_id := last_insert_id();
		
INSERT INTO Rental_Item
VALUES(
		NULL
		, @rental_id
		, (select item_id FROM item WHERE ITEM_Title = 'Iron Man 2')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);
		
INSERT INTO Rental
VALUES(
		NULL
		, (SELECT contact_id
			FROM contact
			WHERE last_name = 'Potter'
			AND first_name = 'Lily')
		, UTC_DATE()
		, DATE_ADD(UTC_DATE(), INTERVAL 5 DAY)
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);
		
SET @rental_id := last_insert_id();
		
INSERT INTO Rental_Item
VALUES(
		NULL
		, @rental_id
		, (select item_id FROM item WHERE ITEM_Title = 'Iron Man')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
		);	
		

ALTER TABLE common_lookup ADD COMMON_LOOKUP_TABLE VARCHAR(30);
ALTER TABLE common_lookup ADD COMMON_LOOKUP_COLUMN VARCHAR(30);
ALTER TABLE common_lookup ADD COMMON_LOOKUP_CODE VARCHAR(30) ;


-- Affects 16 rows
UPDATE   common_lookup
SET      COMMON_LOOKUP_TABLE = common_lookup_context
,        COMMON_LOOKUP_COLUMN = common_lookup_type
WHERE    COMMON_LOOKUP_CONTEXT != 'MULTIPLE';

-- Affects 2 rows
UPDATE   common_lookup
SET      COMMON_LOOKUP_TABLE = 'MULTIPLE'
,        COMMON_LOOKUP_COLUMN = 'ADDRESS'
WHERE    COMMON_LOOKUP_CONTEXT = 'MULTIPLE';



ALTER TABLE common_lookup
MODIFY COMMON_LOOKUP_TABLE VARCHAR(30) NOT NULL
, MODIFY COMMON_LOOKUP_COLUMN VARCHAR(30) NOT NULL
, MODIFY COMMON_LOOKUP_CODE VARCHAR(30);

-- 18 rows affected
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
		 CONCAT (common_lookup_context, '_TYPE')
		END;

		
ALTER TABLE common_lookup DROP INDEX common_lookup_u1;

ALTER TABLE common_lookup
DROP COLUMN common_lookup_context;

INSERT INTO common_lookup
	VALUES (
	NULL
	, 'HOME'
	, 'Home'
	, 2
	, UTC_DATE()
	, 2
	, UTC_DATE()
	, 'TELEPHONE'
	, 'TELEPHONE_TYPE'
	, NULL
	);
INSERT INTO common_lookup
	VALUES (
	NULL
	, 'WORK'
	, 'Work'
	, 2
	, UTC_DATE()
	, 2
	, UTC_DATE()
	, 'TELEPHONE'
	, 'TELEPHONE_TYPE'
	, NULL
	);
		
CREATE UNIQUE INDEX common_lookup_u3
	ON common_lookup(COMMON_LOOKUP_TABLE, COMMON_LOOKUP_COLUMN, COMMON_LOOKUP_TYPE);
	
INSERT INTO common_lookup
VALUES (NULL
, 'YES'
, 'Yes'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'PRICE'
, 'ACTIVE_FLAG'
, 'Y');

INSERT INTO common_lookup
VALUES (NULL
, 'NO'
, 'No'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'PRICE'
, 'ACTIVE_FLAG'
, 'N');
		
INSERT INTO common_lookup
VALUES (NULL
, '1-Day RENTAL'
, '1-Day Rental'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'PRICE'
, 'PRICE_TYPE'
, '1');

		
INSERT INTO common_lookup
VALUES (NULL
, '3-Day RENTAL'
, '3-Day Rental'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'PRICE'
, 'PRICE_TYPE'
, '3');

		
INSERT INTO common_lookup
VALUES (NULL
, '5-Day RENTAL'
, '5-Day Rental'
, 2
, UTC_DATE()
, 2
, UTC_DATE()
, 'PRICE'
, 'PRICE_TYPE'
, '5');

ALTER TABLE rental_item
ADD (
rental_item_type INTEGER UNSIGNED
, rental_item_price INTEGER
);


ALTER TABLE rental_item
ADD CONSTRAINT fk_rental_item_1 FOREIGN KEY(rental_item_type)
REFERENCES common_lookup(common_lookup_id);

UPDATE   rental_item ri
SET      ri.rental_item_type =
           (SELECT   cl.common_lookup_id
            FROM     common_lookup cl
            WHERE    cl.common_lookup_code =
			CONVERT(
             (SELECT   DATEDIFF(r.return_date, r.check_out_date)
               FROM     rental r
               WHERE    r.rental_id = ri.rental_id)
			   , char(1)));

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
(SELECT   NULL        -- PRICE_ID
 , i.item_id                       -- ITEM_ID
 ,(CASE 
	WHEN pt.price_type = 1
	THEN (SELECT   cl.common_lookup_id    -- PRICE_TYPE
			FROM     common_lookup cl
			WHERE    cl.common_lookup_type = '1-DAY RENTAL')
	WHEN pt.price_type = 3
	THEN (SELECT   cl.common_lookup_id    -- PRICE_TYPE
			FROM     common_lookup cl
			WHERE    cl.common_lookup_type = '3-DAY RENTAL')
	WHEN pt.price_type = 5
	THEN (SELECT   cl.common_lookup_id    -- PRICE_TYPE
			FROM     common_lookup cl
			WHERE    cl.common_lookup_type = '5-DAY RENTAL')
	END)
 , af.active_flag                              -- ACTIVE_FLAG
 , CASE                            -- START_DATE
     WHEN DATEDIFF(UTC_DATE(), I.release_date) < 31
       THEN i.release_date
       ELSE DATE_ADD(i.release_date, INTERVAL 31 DAY)
   END
 , (CASE
		WHEN af.active_flag = 'Y' -- End Date
		THEN NULL
		ELSE DATE_ADD(i.release_date, INTERVAL 61 DAY)
	END)
  ,(CASE                   -- AMOUNT
              WHEN DATEDIFF(UTC_DATE(), i.release_date) < 31
               AND af.active_flag = 'Y'
			   THEN 
					CASE
						WHEN pt.price_type = 1 THEN 3
						WHEN pt.price_type = 3 THEN 10
						WHEN pt.price_type = 5 THEN 15
					END
			  WHEN DATEDIFF(UTC_DATE(), i.release_date) > 30
               AND af.active_flag = 'N'
			   THEN 
					CASE
						WHEN pt.price_type = 1 THEN 3
						WHEN pt.price_type = 3 THEN 10
						WHEN pt.price_type = 5 THEN 15
					END
			  WHEN DATEDIFF(UTC_DATE(), i.release_date) > 30
               AND af.active_flag = 'Y'
			   THEN 
					CASE
						WHEN pt.price_type = 1 THEN 1
						WHEN pt.price_type = 3 THEN 3
						WHEN pt.price_type = 5 THEN 5
					END
             END)
 , 1                               -- CREATED_BY
 , UTC_DATE()                         -- CREATION_DATE
 , 1                               -- LAST_UPDATED_BY
 , UTC_DATE()                         -- LAST_UPDATE_DATE
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
		   WHERE NOT (DATEDIFF(UTC_DATE(), i.release_date) < 31 AND af.active_flag = 'N')
);


-- This is the check portion for the lab
-- Should look like 
-- Type       1-Day      3-Day      5-Day      TOTAL
-- ----- ---------- ---------- ---------- ----------
-- OLD Y         51         51         51         153
-- OLD N         51         51         51         153
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
AND     DATEDIFF(UTC_DATE(), i.release_date) > 30
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
AND     DATEDIFF(UTC_DATE(), i.release_date) > 30
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
AND     DATEDIFF(UTC_DATE(), i.release_date) < 31
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
AND     DATEDIFF(UTC_DATE(), i.release_date) < 31
AND NOT (end_date IS NULL);

-- Step 9
ALTER TABLE price MODIFY price_type INT UNSIGNED NOT NULL;

-- Step 10
UPDATE   rental_item ri
SET      rental_item_price =
           (SELECT   p.amount
            FROM     price p CROSS JOIN rental r
            WHERE    p.item_id = ri.item_id
            AND      ri.rental_id = r.rental_id
            AND      r.check_out_date
                       BETWEEN IFNULL(p.start_date, UTC_DATE()) AND IFNULL(p.end_date, UTC_DATE())
            AND   p.price_type = ri.rental_item_type);
			
SELECT   ri.rental_item_id, ri.rental_item_price, p.amount
FROM     price p JOIN rental_item ri 
ON       p.item_id = ri.item_id AND p.price_type = ri.rental_item_type
JOIN     rental r ON ri.rental_id = r.rental_id
WHERE    r.check_out_date BETWEEN p.start_date AND IFNULL(p.end_date, UTC_DATE())
ORDER BY 1;

NOTEE
