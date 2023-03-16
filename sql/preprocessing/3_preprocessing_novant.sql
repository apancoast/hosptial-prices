-- Transforming novant_presbyterian_std data wide to long
-- Only 17 out of 35 payers
-- Only for codes shared with cmc in the cmc select table, created in the preprocessing_cmc script
CREATE TABLE presb_select AS
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'cash_price' AS plan, cash_price as negotiated_charge
	FROM novant_presbyterian_std
	WHERE cash_price IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'humana_medicare' AS plan, humana_medicare as negotiated_charge
	FROM novant_presbyterian_std
	WHERE humana_medicare IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'humana_ppox' AS plan, humana_ppox as negotiated_charge
	FROM novant_presbyterian_std
	WHERE humana_ppox IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'aetna_coventry' AS plan, aetna_coventry as negotiated_charge
	FROM novant_presbyterian_std
	WHERE aetna_coventry IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'aetna_coventry_mcr' AS plan, aetna_coventry_mcr as negotiated_charge
	FROM novant_presbyterian_std
	WHERE aetna_coventry_mcr IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'aetna_coventry_rental_network' AS plan, aetna_coventry_rental_network as negotiated_charge
	FROM novant_presbyterian_std
	WHERE aetna_coventry_rental_network IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'cigna_unspecified' AS plan, cigna as negotiated_charge
	FROM novant_presbyterian_std
	WHERE cigna IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'cigna_healthspring' AS plan, cigna_healthspring as negotiated_charge
	FROM novant_presbyterian_std
	WHERE cigna_healthspring IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'humana_commercial' AS plan, humana_commercial as negotiated_charge
	FROM novant_presbyterian_std
	WHERE humana_commercial IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'medcost_mbs' AS plan, medcost_mbs as negotiated_charge
	FROM novant_presbyterian_std
	WHERE medcost_mbs IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'multiplan' AS plan, multiplan as negotiated_charge
	FROM novant_presbyterian_std
	WHERE multiplan IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'primary_physician_care' AS plan, primary_physician_care as negotiated_charge
	FROM novant_presbyterian_std
	WHERE primary_physician_care IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'phcs' AS plan, phcs as negotiated_charge
	FROM novant_presbyterian_std
	WHERE phcs IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'medcost_non_mbs' AS plan, medcost_non_mbs as negotiated_charge
	FROM novant_presbyterian_std
	WHERE medcost_non_mbs IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'uhc_unspecified' AS plan, uhc as negotiated_charge
	FROM novant_presbyterian_std
	WHERE uhc IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'uhc_mcr_adv' AS plan, uhc_mcr_adv as negotiated_charge
	FROM novant_presbyterian_std
	WHERE uhc_mcr_adv IS NOT NULL
	AND cpt IN
		(SELECT code
		FROM cmc_select)
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'gross' AS plan, gross_charge as negotiated_charge
	FROM novant_presbyterian_std
	WHERE cpt IN
		(SELECT code
		FROM cmc_select);
        
-- Transforming novant_clt_ortho data wide to long
-- Only 17 out of 35 payers
-- Only for codes shared with cmc in the cmc select table, created in the preprocessing_cmc script
CREATE TABLE n_ortho_select AS
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'cash_price' AS plan, cash_price as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'humana_medicare' AS plan, humana_medicare as negotiated_charge
	FROM novant_clt_ortho
		UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'humana_ppox' AS plan, humana_ppox as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'aetna_coventry' AS plan, aetna_coventry as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'aetna_coventry_mcr' AS plan, aetna_coventry_mcr as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'aetna_coventry_rental_network' AS plan, aetna_coventry_rental_network as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'cigna_unspecified' AS plan, cigna as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'cigna_healthspring' AS plan, cigna_healthspring as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'humana_commercial' AS plan, humana_commercial as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'medcost_mbs' AS plan, medcost_mbs as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'multiplan' AS plan, multiplan as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'primary_physician_care' AS plan, primary_physician_care as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'phcs' AS plan, phcs as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'medcost_non_mbs' AS plan, medcost_non_mbs as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'uhc_unspecified' AS plan, uhc as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'uhc_mcr_adv' AS plan, uhc_mcr_adv as negotiated_charge
	FROM novant_clt_ortho
	UNION
	SELECT code AS 'procedure', cpt AS code, description, charge_type, 'gross' AS plan, gross_charge as negotiated_charge
	FROM novant_clt_ortho
        
        
-- Below queries removes codes with multiple procedure codes unique to Novant, to ensure apples-to-apples comparisons of CPT codes.
SET SESSION sql_mode = '';

CREATE TEMPORARY TABLE codes_to_keep;
SELECT code
FROM (
	SELECT code, description, plan, negotiated_charge, COUNT(DISTINCT `procedure`) AS count
	FROM presb_select
	GROUP BY code
    ) AS subquery
WHERE count = 1;

DELETE FROM presb_select
WHERE code NOT IN
	(SELECT code
    FROM codes_to_keep)
OR 
    charge_type != 'Standard Charge';

-- Need to explore how n_ortho compares before union
ALTER TABLE n_ortho_select
ADD COLUMN hospital_id INT DEFAULT 2,
ADD COLUMN tabname VARCHAR(10) DEFAULT 'ortho';

ALTER TABLE presb_select
ADD COLUMN tabname VARCHAR(10) DEFAULT 'presb';

CREATE TEMPORARY TABLE novant
SELECT *
FROM n_ortho_select
WHERE code IN
	(SELECT code
    FROM presb_select)
UNION ALL 
SELECT *
FROM presb_select
WHERE code IN
	(SELECT code
    FROM n_ortho_select);

SELECT COUNT(DISTINCT code)
FROM (
	SELECT code, description,  plan, negotiated_charge, COUNT(plan) AS count
	FROM novant
	GROUP BY code, description, plan, negotiated_charge
	ORDER BY code) AS t
WHERE count = 2;

SELECT COUNT(DISTINCT code)
FROM novant;
-- All codes are charged the same no matter which charge list.

SELECT *
FROM novant_clt_ortho
WHERE code NOT IN
	(SELECT code
    FROM novant_presbyterian_std);
    
-- only 6 codes on ortho list not on presb