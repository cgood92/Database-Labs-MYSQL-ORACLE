-- Mysql Lab #5
-- Clint Goodman

USE studentdb;

-- Create a fresh database.
\. ../lib/create_mysql_store_ri2.sql
\. ../lib/seed_mysql_store_ri2.sql

-- Open log file. 
TEE apply_lab5_mysql.txt


-- Number 1 with USING()--
-- Join member and contact --
Select member_id
	, contact_id
FROM member
Inner join contact
	using(member_id);

-- Join contact and address --
Select street_address_id
	, address_id
FROM address 
Inner join street_address
	Using(address_id);

-- Join address and street address --
Select contact_id
	, address_id
FROM contact
Inner join address
	Using(contact_id);
	
-- Join contact_ID and Telephone_ID --
Select contact_id
	, telephone_id
FROM contact
Inner join telephone
	Using(contact_id);

-- Number 2 with ON--
-- Join Contact_ID and System_user_id --
Select su.system_user_id
	, c.contact_id
FROM system_user su
Inner join contact c
	On c.created_by = su.system_user_id;

-- Join Contact_id and System_user_id--
Select su.system_user_id
	, c.contact_id
FROM system_user su
Inner join contact c
	On c.last_updated_by = su.system_user_id;
	
-- Number 3 with ON--
-- Join System_user_ID and Created_by--
Select su1.system_user_id
		, su1.created_by
		, su2.system_user_id
FROM system_user su1
Inner join system_user su2
	On su1.created_by = su2.system_user_id;
	
-- Join system_user_id and Last_updated_by--
Select su1.system_user_id
		, su1.created_by
		, su2.system_user_id
FROM system_user su1
Inner join system_user su2
	On su1.last_updated_by = su2.system_user_id;
	
-- Join rental_id and item_id--
Select r.rental_id
		, ri.rental_id
		, ri.item_id
		, i.item_id
	FROM rental r
Inner join rental_item ri
	On ri.rental_id = r.rental_id
Inner join item i
	on i.item_id = ri.item_id;
	
ALTER TABLE rental
	CHANGE COLUMN return_date return_date DATE;	
NOTEE