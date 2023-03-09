CREATE TABLE cpts (
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

LOAD DATA INFILE 'D:/Data Projects/hospital prices sources/CPTs v5/CONCEPT.csv'
INTO TABLE cpts
FIELDS TERMINATED BY '\t'
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE cpts
DROP COLUMN domain_id,
DROP COLUMN concept_class_id,
DROP COLUMN standard_concept,
DROP COLUMN valid_start_date,
DROP COLUMN valid_end_date,
DROP COLUMN invalid_reason;

ALTER TABLE cpts MODIFY COLUMN concept_code VARCHAR(50) AFTER concept_id,
                        MODIFY COLUMN vocabulary_id VARCHAR(50) AFTER concept_code,
                        MODIFY COLUMN concept_name VARCHAR(255) AFTER vocabulary_id;
                        
DELETE FROM cpts
WHERE vocabulary_id != 'CPT4';

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

LOAD DATA INFILE 'D:/Data Projects/hospital prices sources/HCPCS/CONCEPT.csv'
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