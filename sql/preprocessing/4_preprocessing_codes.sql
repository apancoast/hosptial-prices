-- create table with only codes of shared between hospitals for Power BI
CREATE TABLE codes_select AS
SELECT *
FROM cpts
WHERE concept_code IN
		(SELECT code
        FROM presb_select)
		OR
        concept_code IN
		(SELECT code
        FROM cmc_select);

-- add hcpcs codes to codes_select
INSERT INTO codes_select
SELECT *
FROM hcpcs
WHERE concept_code IN
	(SELECT code
    FROM presb_select)
AND concept_code IN
	(SELECT code
    FROM cmc_select)
AND concept_code NOT IN
	(SELECT concept_code
    FROM codes_select);
    
-- Find missing codes
SELECT DISTINCT code
FROM presb_select 
WHERE code NOT IN
	(SELECT concept_code FROM cpts)
    AND code NOT IN
	(SELECT concept_code FROM hcpcs);

SELECT DISTINCT code
FROM cmc_select 
WHERE code NOT IN
	(SELECT concept_code FROM cpts)
    AND code NOT IN
	(SELECT concept_code FROM hcpcs);
    
    -- I manually search for the two results from above in Athena and exported to CSV.
        
-- Create temp table for missing concepts
CREATE TEMPORARY TABLE missing (
  concept_id INT NOT NULL,
  concept_code VARCHAR(50) NOT NULL,
  concept_name VARCHAR(255) NOT NULL,
  Standard_Class VARCHAR(50) NOT NULL,
  domain VARCHAR(50) NOT NULL,
  vocabulary_id VARCHAR(50) NOT NULL,
  validity VARCHAR(50) NOT NULL,
  concept VARCHAR(50) NOT NULL
);

-- Import missing concepts
LOAD DATA INFILE 'D:/Data Projects/hospital prices sources/Missing/athena_search.csv'
INTO TABLE missing
FIELDS TERMINATED BY '\t'
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE missing
DROP COLUMN Standard_Class,
DROP COLUMN domain,
DROP COLUMN validity,
DROP COLUMN concept;

ALTER TABLE missing
MODIFY COLUMN vocabulary_id VARCHAR(50) AFTER concept_code;

-- Import into codes_select
INSERT INTO codes_select
SELECT *
FROM missing;