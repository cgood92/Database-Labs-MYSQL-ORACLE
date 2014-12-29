COLUMN transaction_id FORMAT 99,999 HEADING "Trans|ID"
COLUMN account_number FORMAT 99,999 HEADING "Acct|#"
COLUMN transaction_type FORMAT 99,999 HEADING "Trans|Type"
COLUMN transaction_date FORMAT A9 HEADING "Trans|Date"
COLUMN transaction_amount FORMAT 99,999 HEADING "Trans|Amt"
COLUMN rental_id FORMAT 99,999 HEADING "Rent|ID"
COLUMN payment_method_type FORMAT 99,999 HEADING "Pmt|Meth"
COLUMN payment_account_number FORMAT A15 HEADING "Pmt|Acct#"
COLUMN created_by FORMAT 99,999 HEADING "CB"
COLUMN creation_date FORMAT A9 HEADING "CD"
COLUMN last_updated_by FORMAT 99,999 HEADING "LUB"
COLUMN last_update_date FORMAT A9 HEADING "LUD"
SET LINESIZE 32767
SET PAGESIZE 100

SELECT
         t.transaction_id
         , tu.account_number
         , cl1.common_lookup_id AS transaction_type
		 , tu.transaction_date
		 , tu.transaction_amount
		 , r.rental_id
		 , cl2.common_lookup_id AS payment_method_type
		 , tu.payment_account_number
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
			ON t.TRANSACTION_ACCOUNT = tu.account_number
			AND t.TRANSACTION_TYPE = cl1.common_lookup_id
			AND t.TRANSACTION_DATE = tu.transaction_date
			AND t.TRANSACTION_AMOUNT = tu.transaction_amount
			AND t.PAYMENT_METHOD_TYPE = cl2.common_lookup_id
			AND t.PAYMENT_ACCOUNT_NUMBER = tu.payment_account_number
		GROUP BY 
         t.transaction_id
         , tu.account_number
         , cl1.common_lookup_id
	 , tu.transaction_date
	 , tu.transaction_amount
	 , r.rental_id
	 , cl2.common_lookup_id
	 , tu.payment_account_number;