-- table of all cmc codes that have a novant match
CREATE TEMPORARY TABLE select_cmc_cash
SELECT DISTINCT c.*
FROM cmc_cash_prices c
INNER JOIN novant_presbyterian_std n ON c.code = n.cpt;

-- in order to compare as equally as possible, I am going to remove those CPTs from CMC and Pres's charge lists
SELECT COUNT(DISTINCT code) AS row_count
FROM (
    SELECT code, COUNT(code) AS count
    FROM select_cmc_cash
    GROUP BY code
    HAVING count > 1
) AS subquery;

-- let's remove those
CREATE TEMPORARY TABLE temp_cmc_cash
SELECT DISTINCT c.*
FROM cmc_cash_prices c
INNER JOIN novant_presbyterian_std n ON c.code = n.cpt
WHERE c.code NOT IN (
  SELECT code
  FROM (
    SELECT code, COUNT(code) AS count
    FROM cmc_cash_prices
    GROUP BY code
  ) t
  WHERE t.count > 1
);

-- now I want to bring in some of the insurance prices to CMC's table
CREATE TEMPORARY TABLE select_codes
SELECT DISTINCT code
FROM temp_cmc_cash;

SELECT DISTINCT payer, plans
FROM cmc_adult_one_std
WHERE code IN
	(SELECT *
    FROM select_codes)
ORDER BY payer;
    
SELECT DISTINCT payer, plans
FROM cmc_adult_zero_std
WHERE code IN
	(SELECT *
    FROM select_codes)
ORDER BY payer;

-- are the prices of plans per payer really different? They are.
SELECT *
FROM cmc_adult_one_std
WHERE code IN
	(SELECT *
    FROM select_codes)
AND payer LIKE "MEDCOST%";

-- getting just the codes I want, then I'll handle payers later
CREATE TEMPORARY TABLE cmc_adult_one
SELECT *
FROM cmc_adult_one_std
WHERE code IN
	(SELECT *
    FROM select_codes);

CREATE TEMPORARY TABLE cmc_adult_zero
SELECT *
FROM cmc_adult_zero_std
WHERE code IN
	(SELECT *
    FROM select_codes);
    
CREATE TEMPORARY TABLE cmc_adult_payers -- I'm only interested in IP charges
SELECT `procedure`, code_type, code, rev_code, procedure_description, quantity, payer, plans, ip_gross_charge, ip_negotiated_charge, tabname, vocabulary_id
FROM cmc_adult_zero
WHERE plans IN (
'AETNA CONNECTED NC NETWORK INDIVIDUAL [10003701]',
'AETNA NC PREFERRED [10001702]',
'AETNA OP CHC PPO [10000302]',
'AETNA SIGNATURE ADMINISTRATORS [10002802]',
'AETNA WHOLE HEALTH - ATRIUM HEALTH [10001903]',
'CIGNA NEW BUSINESS [10202702]',
'CIGNA SAR [10201402]',
'COVENTRY NATIONAL NETWORK [16200902]',
'HUMANA PPO POS [10300902]',
'MEDCOST PPO [19600602]',
'MULTIPLAN [21500102]',
'NC MEDICAID Carolina Complete Health',
'PHCS PPO [23900102]',
'PRIMARY PHYSICIANS CARE PPO [23700102]',
'UHC INDIVIDUAL EXCHANGE BENEFIT PLAN [10102409]',
'UHC ONENET [10101602]',
'UHC PPO EPO CHOICE SELECT [10101302]'
)
UNION
SELECT `procedure`, code_type, code, rev_code, procedure_description, quantity, payer, plans, ip_gross_charge, ip_negotiated_charge, tabname, vocabulary_id
FROM cmc_adult_one
WHERE plans IN (
'AETNA CONNECTED NC NETWORK INDIVIDUAL [10003701]',
'AETNA NC PREFERRED [10001702]',
'AETNA OP CHC PPO [10000302]',
'AETNA SIGNATURE ADMINISTRATORS [10002802]',
'AETNA WHOLE HEALTH - ATRIUM HEALTH [10001903]',
'CIGNA NEW BUSINESS [10202702]',
'CIGNA SAR [10201402]',
'COVENTRY NATIONAL NETWORK [16200902]',
'HUMANA PPO POS [10300902]',
'MEDCOST PPO [19600602]',
'MULTIPLAN [21500102]',
'NC MEDICAID Carolina Complete Health',
'PHCS PPO [23900102]',
'PRIMARY PHYSICIANS CARE PPO [23700102]',
'UHC INDIVIDUAL EXCHANGE BENEFIT PLAN [10102409]',
'UHC ONENET [10101602]',
'UHC PPO EPO CHOICE SELECT [10101302]'
);

DELETE FROM cmc_adult_payers 
WHERE ip_gross_charge IS NULL;

-- DROP TEMPORARY TABLES cmc_adult_payers;
DROP TEMPORARY TABLES cmc_adult_one, cmc_adult_zero;

CREATE TEMPORARY TABLE select_novant
SELECT *
FROM novant_presbyterian_std 
WHERE cpt IN
	(SELECT *
    FROM select_codes)
AND gross_charge IS NOT NULL;

-- looking at payers

ALTER TABLE cmc_adult_payers
ADD COLUMN aetna_connected_nc DECIMAL(10,2),
ADD COLUMN aetna_nc_preferred DECIMAL(10,2),
ADD COLUMN aetna_chc_ppo DECIMAL(10,2),
ADD COLUMN aetna_sig_admins DECIMAL(10,2),
ADD COLUMN aetna_whole_health DECIMAL(10,2),
ADD COLUMN cigna_biz DECIMAL(10,2),
ADD COLUMN cigna_sar DECIMAL(10,2),
ADD COLUMN aetna_coventry_national DECIMAL(10,2),
ADD COLUMN humana_ppo_pos DECIMAL(10,2),
ADD COLUMN medcost_ppo DECIMAL(10,2),
ADD COLUMN multiplan DECIMAL(10,2),
ADD COLUMN carolina_complete DECIMAL(10,2),
ADD COLUMN primary_physician_care DECIMAL(10,2),
ADD COLUMN phcs DECIMAL(10,2),
ADD COLUMN uhc_ind_exg DECIMAL(10,2),
ADD COLUMN uhc_onenet DECIMAL(10,2),
ADD COLUMN uhc_ppo_epo_choice DECIMAL(10,2);

UPDATE cmc_adult_payers
SET
  aetna_connected_nc = IF(plans = 'AETNA CONNECTED NC NETWORK INDIVIDUAL [10003701]', ip_negotiated_charge, NULL),
  aetna_nc_preferred = IF(plans = 'AETNA NC PREFERRED [10001702]', ip_negotiated_charge, NULL),
  aetna_chc_ppo = IF(plans = 'AETNA OP CHC PPO [10000302]', ip_negotiated_charge, NULL),
  aetna_sig_admins = IF(plans = 'AETNA SIGNATURE ADMINISTRATORS [10002802]', ip_negotiated_charge, NULL),
  aetna_whole_health = IF(plans = 'AETNA WHOLE HEALTH - ATRIUM HEALTH [10001903]', ip_negotiated_charge, NULL),
  cigna_biz = IF(plans = 'CIGNA NEW BUSINESS [10202702]', ip_negotiated_charge, NULL),
  cigna_sar = IF(plans = 'CIGNA SAR [10201402]', ip_negotiated_charge, NULL),
  aetna_coventry_national = IF(plans = 'COVENTRY NATIONAL NETWORK [16200902]', ip_negotiated_charge, NULL),
  humana_ppo_pos = IF(plans = 'HUMANA PPO POS [10300902]', ip_negotiated_charge, NULL),
  medcost_ppo = IF(plans = 'MEDCOST PPO [19600602]', ip_negotiated_charge, NULL),
  multiplan = IF(plans = 'MULTIPLAN [21500102]', ip_negotiated_charge, NULL),
  carolina_complete = IF(plans = 'NC MEDICAID Carolina Complete Health', ip_negotiated_charge, NULL),
  primary_physician_care = IF(plans = 'PRIMARY PHYSICIANS CARE PPO [23700102]', ip_negotiated_charge, NULL),
  phcs = IF(plans = 'PHCS PPO [23900102]', ip_negotiated_charge, NULL),
  uhc_ind_exg = IF(plans = 'UHC INDIVIDUAL EXCHANGE BENEFIT PLAN [101]',  ip_negotiated_charge, NULL),
  uhc_onenet = IF(plans = 'UHC ONENET [10101602]',  ip_negotiated_charge, NULL),
  uhc_ppo_epo_choice = IF(plans = 'UHC PPO EPO CHOICE SELECT [10101302]',  ip_negotiated_charge, NULL);
  
ALTER TABLE cmc_adult_payers 
DROP COLUMN payer,
DROP COLUMN plans,
DROP COLUMN ip_negotiated_charge,
DROP COLUMN tabname;

CREATE TABLE cmc_adult_payers
SELECT `procedure`, code_type, code, rev_code, procedure_description, quantity, ip_gross_charge, vocabulary_id,
    MAX(aetna_connected_nc) AS aetna_connected_nc,
    MAX(aetna_nc_preferred) AS aetna_nc_preferred,
    MAX(aetna_chc_ppo) AS aetna_chc_ppo,
    MAX(aetna_sig_admins) AS aetna_sig_admins,
    MAX(aetna_whole_health) AS aetna_whole_health,
    MAX(cigna_biz) AS cigna_biz,
    MAX(cigna_sar) AS cigna_sar,
    MAX(aetna_coventry_national) AS aetna_coventry_national,
    MAX(humana_ppo_pos) AS humana_ppo_pos,
    MAX(medcost_ppo) AS medcost_ppo,
    MAX(multiplan) AS multiplan,
    MAX(carolina_complete) AS carolina_complete,
    MAX(primary_physician_care) AS primary_physician_care,
    MAX(phcs) AS phcs,
    MAX(uhc_ind_exg) AS uhc_ind_exg,
    MAX(uhc_onenet) AS uhc_onenet,
    MAX(uhc_ppo_epo_choice) AS uhc_ppo_epo_choice
FROM cmc_adult_payers
GROUP BY `procedure`, code_type, code, rev_code, procedure_description, quantity, ip_gross_charge, vocabulary_id;