SELECT 
	CONCAT(TO_CHAR(TO_DATE(EXTRACT(MONTH FROM transaction_date), 'mm'), 'MON'), '-2009') AS MONTH
	, TO_CHAR(SUM(transaction_amount), '$9,999,999.00') AS BASE_REVENUE
	, TO_CHAR(SUM(transaction_amount)*1.10, '$9,999,999.00') AS PLUS_10
	, TO_CHAR(SUM(transaction_amount)*1.20, '$9,999,999.00') AS PLUS_20
	, TO_CHAR(SUM(transaction_amount)*1.10 - SUM(transaction_amount), '$9,999,999.00') AS PLUS_10_LESS_B
	, TO_CHAR(SUM(transaction_amount)*1.20 - SUM(transaction_amount), '$9,999,999.00') AS PLUS_20_LESS_B
FROM transaction_upload
WHERE EXTRACT(YEAR FROM transaction_date) = 2009
GROUP BY EXTRACT(MONTH FROM transaction_date)
ORDER BY TO_DATE(month, 'MON');