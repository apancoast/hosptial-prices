LOAD DATA INFILE 'D:/Data Projects/Atrium Dashboard/NC Hospital Prices/price.csv'
	INTO Table prices
	FIELDS TERMINATED BY ','
    ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE cpts 
  MODIFY COLUMN concept_id DOUBLE;

LOAD DATA INFILE 'D:/Data Projects/Atrium Dashboard/NC Hospital Prices/CPTs/CONCEPT.csv'
INTO Table cpts
FIELDS TERMINATED BY '\t'
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(concept_id,concept_name,@dummy, vocabulary_id,@dummy,@dummy,concept_code,@dummy, @dummy, @dummy);

INSERT INTO codes (concept_id, concept_code, vocabulary_id, concept_name) SELECT * FROM concept;

INSERT INTO codes (concept_id, concept_code, vocabulary_id, concept_name)
SELECT *
FROM cpts
WHERE cpts.concept_id IN
	(SELECT concept_id
    FROM prices);
