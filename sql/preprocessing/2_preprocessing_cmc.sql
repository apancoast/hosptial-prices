-- Combining Desired Data
-- Create temporary table to combine all payers from CMC
CREATE TEMPORARY TABLE cmc_all AS

WITH selct_codes AS (
	SELECT DISTINCT cpt
    FROM novant_presbyterian_std
    )

SELECT `procedure`, code, rev_code, procedure_description, plans, ip_gross_charge, ip_negotiated_charge, vocabulary_id
FROM cmc_adult_zero_std
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
'PHCS PPO [23900102]',
'PRIMARY PHYSICIANS CARE PPO [23700102]',
'UHC INDIVIDUAL EXCHANGE BENEFIT PLAN [10102409]',
'UHC ONENET [10101602]',
'UHC PPO EPO CHOICE SELECT [10101302]'
) AND code IN
	(SELECT cpt
    FROM selct_codes)
UNION
SELECT `procedure`, code, rev_code, procedure_description, plans, ip_gross_charge, ip_negotiated_charge, vocabulary_id
FROM cmc_adult_one_std
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
'PHCS PPO [23900102]',
'PRIMARY PHYSICIANS CARE PPO [23700102]',
'UHC INDIVIDUAL EXCHANGE BENEFIT PLAN [10102409]',
'UHC ONENET [10101602]',
'UHC PPO EPO CHOICE SELECT [10101302]'
) AND code IN
	(SELECT cpt
    FROM selct_codes)
UNION
SELECT `procedure`, code, rev_code, procedure_description, plans, ip_gross_charge, ip_discounted_charge, vocabulary_id
FROM cmc_cash_prices
WHERE code IN
	(SELECT cpt
    FROM selct_codes);

-- This query removes codes with multiple procedure codes unique to CMC, to ensure apples-to-apples comparisons of CPT codes.
CREATE TEMPORARY TABLE codes_to_keep
SELECT code
FROM (
	SELECT code, COUNT(DISTINCT `procedure`) AS procedure_count
	FROM cmc_all
    GROUP BY code
  ) AS subquery
  WHERE procedure_count = 1;

-- Create a table to store selected records from cmc_all.
CREATE TABLE cmc_select AS
SELECT *
FROM cmc_all
WHERE code IN
	(SELECT code
    FROM codes_to_keep);

-- Standardize payer/plan names.
UPDATE cmc_select
SET plans = REPLACE(plans, 'AETNA CONNECTED NC NETWORK INDIVIDUAL [10003701]', 'aetna_connected_nc')
  , plans = REPLACE(plans, 'AETNA NC PREFERRED [10001702]', 'aetna_nc_preferred')
  , plans = REPLACE(plans, 'AETNA OP CHC PPO [10000302]', 'aetna_chc_ppo')
  , plans = REPLACE(plans, 'AETNA SIGNATURE ADMINISTRATORS [10002802]', 'aetna_sig_admins')
  , plans = REPLACE(plans, 'AETNA WHOLE HEALTH - ATRIUM HEALTH [10001903]', 'aetna_whole_health')
  , plans = REPLACE(plans, 'CIGNA NEW BUSINESS [10202702]', 'cigna_biz')
  , plans = REPLACE(plans, 'CIGNA SAR [10201402]', 'cigna_sar')
  , plans = REPLACE(plans, 'COVENTRY NATIONAL NETWORK [16200902]', 'aetna_coventry_national')
  , plans = REPLACE(plans, 'HUMANA PPO POS [10300902]', 'humana_ppo_pos')
  , plans = REPLACE(plans, 'MEDCOST PPO [19600602]', 'medcost_ppo')
  , plans = REPLACE(plans, 'MULTIPLAN [21500102]', 'multiplan')
  , plans = REPLACE(plans, 'PRIMARY PHYSICIANS CARE PPO [23700102]', 'primary_physician_care')
  , plans = REPLACE(plans, 'PHCS PPO [23900102]', 'phcs')
  , plans = REPLACE(plans, 'UHC INDIVIDUAL EXCHANGE BENEFIT PLAN [10102409]', 'uhc_ind_exg')
  , plans = REPLACE(plans, 'UHC ONENET [10101602]', 'uhc_onenet')
  , plans = REPLACE(plans, 'UHC PPO EPO CHOICE SELECT [10101302]', 'uhc_ppo_epo_choice')
  , plans = REPLACE(plans, 'Hospital Discount Cash Price', 'cash_price');