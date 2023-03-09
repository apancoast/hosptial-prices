CREATE TABLE select_hospitals (
  hospital_id FLOAT(2) NOT NULL,
  name VARCHAR(100),
  
  PRIMARY KEY (hospital_id)
);

INSERT INTO select_hospitals
VALUES 
(1, 'Atrium Health Carolinas Medical Center'),
(2, 'Novant Health Presbyterian Medical Center');

-- Create prices table with hospital_id, code, plan, amount of all codes I'm currently interested in
CREATE TABLE select_prices (
  hospital_id FLOAT(2) NOT NULL,
  code VARCHAR(10) NOT NULL,
  plan VARCHAR(255) NOT NULL,
  amount DOUBLE(20,2),
  FOREIGN KEY (hospital_id) REFERENCES select_hospitals(hospital_id)
);

CREATE TEMPORARY TABLE temp_cmc
SELECT code, plans AS plan, ip_negotiated_charge AS amount
FROM cmc_select
WHERE code IN
	(SELECT code
    FROM presb_select)
UNION
SELECT DISTINCT code, 'gross' AS plan, ip_gross_charge AS amount
FROM cmc_select
WHERE code IN
	(SELECT code
    FROM presb_select);

ALTER TABLE temp_cmc ADD COLUMN hospital_id INT DEFAULT 1;

ALTER TABLE presb_select ADD COLUMN hospital_id INT DEFAULT 2;

INSERT INTO select_prices
SELECT hospital_id, code, plan, amount
FROM temp_cmc
UNION
SELECT hospital_id, code, plan, negotiated_charge AS amount
FROM presb_select;