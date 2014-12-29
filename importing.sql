-- Conditionally drop the table.
DROP TABLE IF EXISTS transaction_upload;
 
-- Create the new upload target table.
CREATE TABLE transaction_upload
( transaction_date   DATE
, transaction_amount FLOAT ) ENGINE=MEMORY;
 
-- Load the data from a file, don't forget the \n after the \r on Windows or it won't work.
LOAD DATA LOCAL INFILE 'C:/data/upload/transaction_upload.csv'
INTO TABLE transaction_upload
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';
 
-- Select the uploaded records.
SELECT * FROM transaction_upload;
