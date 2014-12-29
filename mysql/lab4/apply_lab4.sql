USE studentdb;

\. create_mysql_store_ri.sql
\. seed_mysql_store_ri.sql

TEE lab4_oracle.log


-- MEMBER 01
INSERT INTO member 
	(MEMBER_ID
		, MEMBER_TYPE
		, ACCOUNT_NUMBER
		, CREDIT_CARD_NUMBER
		, CREDIT_CARD_TYPE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'INDIVIDUAL')
		, 'B293-71445'
		, '5555-3333-1111-4444'
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'DISCOVER_CARD')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);

SET @member_id := last_insert_id();

INSERT INTO contact
	(CONTACT_ID
		, MEMBER_ID
		, CONTACT_TYPE
		, FIRST_NAME
		, MIDDLE_NAME
		, LAST_NAME
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, @member_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'CONTACT'
			AND common_lookup_type = 'CUSTOMER')
		, 'Clint'
		, 'F'
		, 'Goodman'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);

SET @contact_id := last_insert_id();

INSERT INTO address
	(ADDRESS_ID
		, CONTACT_ID
		, ADDRESS_TYPE
		, CITY
		, STATE_PROVINCE
		, POSTAL_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
	(
		NULL
		, @contact_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_type = 'HOME')
		, 'Philly'
		, 'Utah'
		, '84121'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);

SET @address_id := last_insert_id();

INSERT INTO street_address
	(STREET_ADDRESS_ID
		, ADDRESS_ID
		, STREET_ADDRESS
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
		(
			NULL
			, @address_id
			, '6777 Rossbern Cove'
			, 2
			, UTC_DATE()
			, 2
			, UTC_DATE());

-- Telephone 01
INSERT INTO telephone
	(     telephone_id
		, contact_id
		, address_id
		, telephone_type
		, country_code
		, area_code
		, telephone_number
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
	VALUES 
	(     NULL
		, @contact_id
		, @address_id
		, 1008
		, 'USA'
		, '215'
		, '453-0971'
		, 3
		, UTC_DATE()
		, 3
		, UTC_DATE());

-- MEMBER 01
INSERT INTO member 
	(MEMBER_ID
		, MEMBER_TYPE
		, ACCOUNT_NUMBER
		, CREDIT_CARD_NUMBER
		, CREDIT_CARD_TYPE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'INDIVIDUAL')
		, 'B293-71885'
		, '5555-2222-1111-4444'
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'DISCOVER_CARD')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @member_id := last_insert_id();
INSERT INTO contact
	(CONTACT_ID
		, MEMBER_ID
		, CONTACT_TYPE
		, FIRST_NAME
		, MIDDLE_NAME
		, LAST_NAME
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, @member_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'CONTACT'
			AND common_lookup_type = 'CUSTOMER')
		, 'Grant'
		, 'J'
		, 'Hopkins'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @contact_id := last_insert_id();
INSERT INTO address
	(ADDRESS_ID
		, CONTACT_ID
		, ADDRESS_TYPE
		, CITY
		, STATE_PROVINCE
		, POSTAL_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
	(
		NULL
		, @contact_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_type = 'HOME')
		, 'JK'
		, 'Idaho'
		, '83456'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @address_id := last_insert_id(); 
INSERT INTO street_address
	(STREET_ADDRESS_ID
		, ADDRESS_ID
		, STREET_ADDRESS
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
		(
			NULL
			, @address_id
			, '123 Easy'
			, 2
			, UTC_DATE()
			, 2
			, UTC_DATE());

-- Telephone 01
INSERT INTO telephone
	(     telephone_id
		, contact_id
		, address_id
		, telephone_type
		, country_code
		, area_code
		, telephone_number
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
	VALUES 
	(     NULL
		, @contact_id
		, @address_id
		, 1008
		, 'USA'
		, '215'
		, '253-0971'
		, 3
		, UTC_DATE()
		, 3
		, UTC_DATE());

-- MEMBER 01
INSERT INTO member 
	(MEMBER_ID
		, MEMBER_TYPE
		, ACCOUNT_NUMBER
		, CREDIT_CARD_NUMBER
		, CREDIT_CARD_TYPE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'INDIVIDUAL')
		, 'A293-71445'
		, '4444-3333-1111-4444'
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'DISCOVER_CARD')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @member_id := last_insert_id();
INSERT INTO contact
	(CONTACT_ID
		, MEMBER_ID
		, CONTACT_TYPE
		, FIRST_NAME
		, MIDDLE_NAME
		, LAST_NAME
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, @member_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'CONTACT'
			AND common_lookup_type = 'CUSTOMER')
		, 'Tim'
		, 'F'
		, 'Joker'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @contact_id := last_insert_id();
INSERT INTO address
	(ADDRESS_ID
		, CONTACT_ID
		, ADDRESS_TYPE
		, CITY
		, STATE_PROVINCE
		, POSTAL_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
	(
		NULL
		, @contact_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_type = 'HOME')
		, 'Weiser'
		, 'Idaho'
		, '10579'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @address_id := last_insert_id(); 
INSERT INTO street_address
	(STREET_ADDRESS_ID
		, ADDRESS_ID
		, STREET_ADDRESS
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
		(
			NULL
			, @address_id
			, '516 Crack Str'
			, 2
			, UTC_DATE()
			, 2
			, UTC_DATE());

-- Telephone 01
INSERT INTO telephone
	(     telephone_id
		, contact_id
		, address_id
		, telephone_type
		, country_code
		, area_code
		, telephone_number
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
	VALUES 
	(     NULL
		, @contact_id
		, @address_id
		, 1008
		, 'USA'
		, '215'
		, '123-4567'
		, 3
		, UTC_DATE()
		, 3
		, UTC_DATE());

-- MEMBER 01
INSERT INTO member 
	(MEMBER_ID
		, MEMBER_TYPE
		, ACCOUNT_NUMBER
		, CREDIT_CARD_NUMBER
		, CREDIT_CARD_TYPE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'INDIVIDUAL')
		, 'B293-15798'
		, '5555-3333-2222-4444'
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'DISCOVER_CARD')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @member_id := last_insert_id();
INSERT INTO contact
	(CONTACT_ID
		, MEMBER_ID
		, CONTACT_TYPE
		, FIRST_NAME
		, MIDDLE_NAME
		, LAST_NAME
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, @member_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'CONTACT'
			AND common_lookup_type = 'CUSTOMER')
		, 'Soleberg'
		, 'F'
		, 'Devin'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @contact_id := last_insert_id();
INSERT INTO address
	(ADDRESS_ID
		, CONTACT_ID
		, ADDRESS_TYPE
		, CITY
		, STATE_PROVINCE
		, POSTAL_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
	(
		NULL
		, @contact_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_type = 'HOME')
		, 'Colesville'
		, 'Wisconsin'
		, '97862'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @address_id := last_insert_id(); 
INSERT INTO street_address
	(STREET_ADDRESS_ID
		, ADDRESS_ID
		, STREET_ADDRESS
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
		(
			NULL
			, @address_id
			, '978 Cool Street'
			, 2
			, UTC_DATE()
			, 2
			, UTC_DATE());

-- Telephone 01
INSERT INTO telephone
	(     telephone_id
		, contact_id
		, address_id
		, telephone_type
		, country_code
		, area_code
		, telephone_number
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
	VALUES 
	(     NULL
		, @contact_id
		, @address_id
		, 1008
		, 'USA'
		, '215'
		, '972-4468'
		, 3
		, UTC_DATE()
		, 3
		, UTC_DATE());

-- MEMBER 01
INSERT INTO member 
	(MEMBER_ID
		, MEMBER_TYPE
		, ACCOUNT_NUMBER
		, CREDIT_CARD_NUMBER
		, CREDIT_CARD_TYPE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'INDIVIDUAL')
		, 'A223-71445'
		, '9999-3333-1111-4444'
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'DISCOVER_CARD')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @member_id := last_insert_id();
INSERT INTO contact
	(CONTACT_ID
		, MEMBER_ID
		, CONTACT_TYPE
		, FIRST_NAME
		, MIDDLE_NAME
		, LAST_NAME
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, @member_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'CONTACT'
			AND common_lookup_type = 'CUSTOMER')
		, 'Mike'
		, 'F'
		, 'Grigg'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @contact_id := last_insert_id();
INSERT INTO address
	(ADDRESS_ID
		, CONTACT_ID
		, ADDRESS_TYPE
		, CITY
		, STATE_PROVINCE
		, POSTAL_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
	(
		NULL
		, @contact_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_type = 'HOME')
		, 'Philly'
		, 'Utah'
		, '84057'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @address_id := last_insert_id(); 
INSERT INTO street_address
	(STREET_ADDRESS_ID
		, ADDRESS_ID
		, STREET_ADDRESS
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
		(
			NULL
			, @address_id
			, '123 State Hill'
			, 2
			, UTC_DATE()
			, 2
			, UTC_DATE());

-- Telephone 01
INSERT INTO telephone
	(     telephone_id
		, contact_id
		, address_id
		, telephone_type
		, country_code
		, area_code
		, telephone_number
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
	VALUES 
	(     NULL
		, @contact_id
		, @address_id
		, 1008
		, 'USA'
		, '215'
		, '646-8824'
		, 3
		, UTC_DATE()
		, 3
		, UTC_DATE());

-- MEMBER 01
INSERT INTO member 
	(MEMBER_ID
		, MEMBER_TYPE
		, ACCOUNT_NUMBER
		, CREDIT_CARD_NUMBER
		, CREDIT_CARD_TYPE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'INDIVIDUAL')
		, 'B293-71445'
		, '5555-3333-1111-7998'
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'DISCOVER_CARD')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @member_id := last_insert_id();
INSERT INTO contact
	(CONTACT_ID
		, MEMBER_ID
		, CONTACT_TYPE
		, FIRST_NAME
		, MIDDLE_NAME
		, LAST_NAME
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, @member_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'CONTACT'
			AND common_lookup_type = 'CUSTOMER')
		, 'Taylor'
		, 'A'
		, 'Ririe'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @contact_id := last_insert_id();
INSERT INTO address
	(ADDRESS_ID
		, CONTACT_ID
		, ADDRESS_TYPE
		, CITY
		, STATE_PROVINCE
		, POSTAL_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
	(
		NULL
		, @contact_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_type = 'HOME')
		, 'Denver'
		, 'Colorado'
		, '46505'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @address_id := last_insert_id(); 
INSERT INTO street_address
	(STREET_ADDRESS_ID
		, ADDRESS_ID
		, STREET_ADDRESS
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
		(
			NULL
			, @address_id
			, 'Gay Street'
			, 2
			, UTC_DATE()
			, 2
			, UTC_DATE());

-- Telephone 01
INSERT INTO telephone
	(     telephone_id
		, contact_id
		, address_id
		, telephone_type
		, country_code
		, area_code
		, telephone_number
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
	VALUES 
	(     NULL
		, @contact_id
		, @address_id
		, 1008
		, 'USA'
		, '215'
		, '369-7942'
		, 3
		, UTC_DATE()
		, 3
		, UTC_DATE());

-- MEMBER 01
INSERT INTO member 
	(MEMBER_ID
		, MEMBER_TYPE
		, ACCOUNT_NUMBER
		, CREDIT_CARD_NUMBER
		, CREDIT_CARD_TYPE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'INDIVIDUAL')
		, 'A446-71445'
		, '5555-4444-1111-4444'
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'DISCOVER_CARD')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @member_id := last_insert_id();
INSERT INTO contact
	(CONTACT_ID
		, MEMBER_ID
		, CONTACT_TYPE
		, FIRST_NAME
		, MIDDLE_NAME
		, LAST_NAME
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, @member_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'CONTACT'
			AND common_lookup_type = 'CUSTOMER')
		, 'kevin'
		, 'F'
		, 'Bergquist'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @contact_id := last_insert_id();
INSERT INTO address
	(ADDRESS_ID
		, CONTACT_ID
		, ADDRESS_TYPE
		, CITY
		, STATE_PROVINCE
		, POSTAL_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
	(
		NULL
		, @contact_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_type = 'HOME')
		, 'Louisville'
		, 'Illionois'
		, '25465'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @address_id := last_insert_id(); 
INSERT INTO street_address
	(STREET_ADDRESS_ID
		, ADDRESS_ID
		, STREET_ADDRESS
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
		(
			NULL
			, @address_id
			, 'Wow street'
			, 2
			, UTC_DATE()
			, 2
			, UTC_DATE());

-- Telephone 01
INSERT INTO telephone
	(     telephone_id
		, contact_id
		, address_id
		, telephone_type
		, country_code
		, area_code
		, telephone_number
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
	VALUES 
	(     NULL
		, @contact_id
		, @address_id
		, 1008
		, 'USA'
		, '215'
		, '115-4689'
		, 3
		, UTC_DATE()
		, 3
		, UTC_DATE());

-- MEMBER 01
INSERT INTO member 
	(MEMBER_ID
		, MEMBER_TYPE
		, ACCOUNT_NUMBER
		, CREDIT_CARD_NUMBER
		, CREDIT_CARD_TYPE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'INDIVIDUAL')
		, 'B999-71445'
		, '1234-3333-1111-4444'
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'DISCOVER_CARD')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @member_id := last_insert_id();
INSERT INTO contact
	(CONTACT_ID
		, MEMBER_ID
		, CONTACT_TYPE
		, FIRST_NAME
		, MIDDLE_NAME
		, LAST_NAME
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, @member_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'CONTACT'
			AND common_lookup_type = 'CUSTOMER')
		, 'Jimmer'
		, 'F'
		, 'Freddette'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @contact_id := last_insert_id();
INSERT INTO address
	(ADDRESS_ID
		, CONTACT_ID
		, ADDRESS_TYPE
		, CITY
		, STATE_PROVINCE
		, POSTAL_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
	(
		NULL
		, @contact_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_type = 'HOME')
		, 'Philly'
		, 'Montanna'
		, '12345'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @address_id := last_insert_id(); 
INSERT INTO street_address
	(STREET_ADDRESS_ID
		, ADDRESS_ID
		, STREET_ADDRESS
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
		(
			NULL
			, @address_id
			, 'Lovers way'
			, 2
			, UTC_DATE()
			, 2
			, UTC_DATE());

-- Telephone 01
INSERT INTO telephone
	(     telephone_id
		, contact_id
		, address_id
		, telephone_type
		, country_code
		, area_code
		, telephone_number
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
	VALUES 
	(     NULL
		, @contact_id
		, @address_id
		, 1008
		, 'USA'
		, '215'
		, '262-4682'
		, 3
		, UTC_DATE()
		, 3
		, UTC_DATE());

-- MEMBER 01
INSERT INTO member 
	(MEMBER_ID
		, MEMBER_TYPE
		, ACCOUNT_NUMBER
		, CREDIT_CARD_NUMBER
		, CREDIT_CARD_TYPE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'INDIVIDUAL')
		, 'B293-36945'
		, '5555-4444-1111-4444'
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'DISCOVER_CARD')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @member_id := last_insert_id();
INSERT INTO contact
	(CONTACT_ID
		, MEMBER_ID
		, CONTACT_TYPE
		, FIRST_NAME
		, MIDDLE_NAME
		, LAST_NAME
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, @member_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'CONTACT'
			AND common_lookup_type = 'CUSTOMER')
		, 'Lauretta'
		, 'E'
		, 'Seaman'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @contact_id := last_insert_id();
INSERT INTO address
	(ADDRESS_ID
		, CONTACT_ID
		, ADDRESS_TYPE
		, CITY
		, STATE_PROVINCE
		, POSTAL_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
	(
		NULL
		, @contact_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_type = 'HOME')
		, 'Atlanta'
		, 'Gergia'
		, '86121'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @address_id := last_insert_id(); 
INSERT INTO street_address
	(STREET_ADDRESS_ID
		, ADDRESS_ID
		, STREET_ADDRESS
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
		(
			NULL
			, @address_id
			, 'Sunshine AVe'
			, 2
			, UTC_DATE()
			, 2
			, UTC_DATE());

-- Telephone 01
INSERT INTO telephone
	(     telephone_id
		, contact_id
		, address_id
		, telephone_type
		, country_code
		, area_code
		, telephone_number
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
	VALUES 
	(     NULL
		, @contact_id
		, @address_id
		, 1008
		, 'USA'
		, '215'
		, '133-7988'
		, 3
		, UTC_DATE()
		, 3
		, UTC_DATE());

-- MEMBER 01
INSERT INTO member 
	(MEMBER_ID
		, MEMBER_TYPE
		, ACCOUNT_NUMBER
		, CREDIT_CARD_NUMBER
		, CREDIT_CARD_TYPE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'INDIVIDUAL')
		, 'B293-71335'
		, '5555-3333-2222-4444'
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'MEMBER'
			AND common_lookup_type = 'DISCOVER_CARD')
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @member_id := last_insert_id();
INSERT INTO contact
	(CONTACT_ID
		, MEMBER_ID
		, CONTACT_TYPE
		, FIRST_NAME
		, MIDDLE_NAME
		, LAST_NAME
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES (
		NULL
		, @member_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_context = 'CONTACT'
			AND common_lookup_type = 'CUSTOMER')
		, 'Jill'
		, 'F'
		, 'Meryweather'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @contact_id := last_insert_id();
INSERT INTO address
	(ADDRESS_ID
		, CONTACT_ID
		, ADDRESS_TYPE
		, CITY
		, STATE_PROVINCE
		, POSTAL_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
	(
		NULL
		, @contact_id
		, (SELECT common_lookup_id
			FROM common_lookup
			WHERE common_lookup_type = 'HOME')
		, 'Philly'
		, 'Idaho'
		, '84131'
		, 2
		, UTC_DATE()
		, 2
		, UTC_DATE()
	);
SET @address_id := last_insert_id(); 
INSERT INTO street_address
	(STREET_ADDRESS_ID
		, ADDRESS_ID
		, STREET_ADDRESS
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE)
	VALUES
		(
			NULL
			, @address_id
			, '456 Rossbern Cove'
			, 2
			, UTC_DATE()
			, 2
			, UTC_DATE());

-- Telephone 01
INSERT INTO telephone
	(     telephone_id
		, contact_id
		, address_id
		, telephone_type
		, country_code
		, area_code
		, telephone_number
		, created_by
		, creation_date
		, last_updated_by
		, last_update_date)
	VALUES 
	(     NULL
		, @contact_id
		, @address_id
		, 1008
		, 'USA'
		, '215'
		, '897-4653'
		, 3
		, UTC_DATE()
		, 3
		, UTC_DATE());

NOTEE
