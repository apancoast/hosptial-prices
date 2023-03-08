CREATE TABLE cpts_v2 (
  concept_id INT(11) NOT NULL,
  concept_name VARCHAR(255) NOT NULL,
  domain_id VARCHAR(50) NOT NULL,
  vocabulary_id VARCHAR(50) NOT NULL,
  concept_class_id VARCHAR(50) NOT NULL,
  standard_concept CHAR(1) NOT NULL,
  concept_code VARCHAR(50) NOT NULL,
  valid_start_date DATE NOT NULL,
  valid_end_date DATE NOT NULL,
  invalid_reason VARCHAR(50)
);

LOAD DATA INFILE 'D:/Data Projects/Atrium Dashboard/NC Hospital Prices/CPTs v5/CONCEPT.csv'
INTO TABLE cpts_v2
FIELDS TERMINATED BY '\t'
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE cpts_v2
DROP COLUMN domain_id,
DROP COLUMN concept_class_id,
DROP COLUMN standard_concept,
DROP COLUMN valid_start_date,
DROP COLUMN valid_end_date,
DROP COLUMN invalid_reason;

ALTER TABLE cpts_v2 MODIFY COLUMN concept_code VARCHAR(50) AFTER concept_id,
                        MODIFY COLUMN vocabulary_id VARCHAR(50) AFTER concept_code,
                        MODIFY COLUMN concept_name VARCHAR(255) AFTER vocabulary_id;
                        
DELETE FROM cpts_v2
WHERE vocabulary_id = 'OSM';

CREATE TABLE codes_select AS
SELECT *
FROM cpts_v2
WHERE concept_code IN
		(SELECT code
        FROM presb_select)
		OR
        concept_code IN
		(SELECT code
        FROM cmc_select)
UNION
SELECT *
FROM concept
WHERE concept_code IN
		(SELECT code
        FROM presb_select)
		OR
        concept_code IN
		(SELECT code
        FROM cmc_select);

-- import HCPCS codes
CREATE TABLE hcpcs (
  concept_id INT(11) NOT NULL,
  concept_name VARCHAR(255) NOT NULL,
  domain_id VARCHAR(50) NOT NULL,
  vocabulary_id VARCHAR(50) NOT NULL,
  concept_class_id VARCHAR(50) NOT NULL,
  standard_concept CHAR(1) NOT NULL,
  concept_code VARCHAR(50) NOT NULL,
  valid_start_date DATE NOT NULL,
  valid_end_date DATE NOT NULL,
  invalid_reason VARCHAR(50)
);

LOAD DATA INFILE 'D:/Data Projects/Atrium Dashboard/NC Hospital Prices/HCPCS/CONCEPT.csv'
INTO TABLE hcpcs
FIELDS TERMINATED BY '\t'
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DELETE FROM hcpcs
WHERE vocabulary_id != 'HCPCS';

ALTER TABLE hcpcs
DROP COLUMN domain_id,
DROP COLUMN concept_class_id,
DROP COLUMN standard_concept,
DROP COLUMN valid_start_date,
DROP COLUMN valid_end_date,
DROP COLUMN invalid_reason;

ALTER TABLE hcpcs MODIFY COLUMN concept_code VARCHAR(50) AFTER concept_id,
                        MODIFY COLUMN vocabulary_id VARCHAR(50) AFTER concept_code,
                        MODIFY COLUMN concept_name VARCHAR(255) AFTER vocabulary_id;


-- add missing codes
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
        
-- Create temp table for missing concepts
DROP TABLE missing;
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
LOAD DATA INFILE 'D:/Data Projects/Atrium Dashboard/NC Hospital Prices/Missing/athena_search.csv'
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



