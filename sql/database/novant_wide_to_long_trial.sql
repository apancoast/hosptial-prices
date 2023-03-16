-- Create a new table to hold the long-format data
CREATE TABLE novant_long (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(255),
  cpt VARCHAR(255),
  description VARCHAR(255),
  charge_type VARCHAR(255),
  plan VARCHAR(255),
  negotiated_charge DECIMAL(10, 2)
);

ALTER TABLE novant_presbyterian_std
DROP COLUMN min_negotiated_charge,
DROP COLUMN max_negotiated_charge;

SET SESSION group_concat_max_len = 1000000;

-- Get the list of columns to include in the long-format table
SET @cols = (
  SELECT GROUP_CONCAT(COLUMN_NAME ORDER BY ORDINAL_POSITION)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_NAME = 'novant_presbyterian_std'
    AND COLUMN_NAME NOT IN ('code', 'description', 'cpt', 'charge_type')
);

SELECT @cols;


-- gernerate the SQL code for each column and insert the data into the new table

SET @sql = CONCAT(
  'INSERT INTO novant_long (code, cpt, description, charge_type, plan, negotiated_charge) ',
  'SELECT code, cpt, description, charge_type, ',
  'UNNEST((',
  '  SELECT ARRAY(', REPLACE(@cols, ',', ', '), ')',
  '  FROM novant_presbyterian_std',
  '  WHERE code = t.code AND cpt = t.cpt AND description = t.description AND charge_type = t.charge_type',
  ')) AS plan, ',
  'UNNEST((',
  '  SELECT ARRAY(', REPLACE(@cols, ',', ', '), ')',
  '  FROM novant_presbyterian_std',
  '  WHERE code = t.code AND cpt = t.cpt AND description = t.description AND charge_type = t.charge_type',
  ')) AS negotiated_charge '
  'FROM novant_presbyterian_std t'
);

SELECT @sql;

-- Execute the SQL code to insert the data into the new table
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;