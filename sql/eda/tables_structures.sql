-- Explore holsitic differences between the hospitals so that I have more context.

/* I need to understand all the cmc tables better. My questions include:

1. Is cmc_adult_min_max a summary of the same info in the other adult tables?
2. Are the peds codes the same as adult ones? Note: Atrium's Explanatory Document notes that some payers negotiate rates by age category, i.e. UHC may pay differently for the same procedure in an adult vs peds pt.
3. If not, does Novant have comparable peds codes?
*/

SELECT *
FROM cmc_adult_min_max
WHERE code NOT IN
	(SELECT code
    FROM cmc_adult_one_std)
OR
	code NOT IN
    (SELECT code
    FROM cmc_adult_zero_std);

WITH cmc_adult AS
	(SELECT DISTINCT code
    FROM cmc_adult_one_std
    UNION
    SELECT DISTINCT code
    FROM cmc_adult_zero_std)

SELECT 
	(SELECT COUNT(DISTINCT code)
    FROM cmc_adult) AS adult_codes,
COUNT(DISTINCT code) AS min_max_codes
FROM cmc_adult_min_max;

WITH cmc_adult AS
	(SELECT *
    FROM cmc_adult_one_std
    UNION
    SELECT *
    FROM cmc_adult_zero_std)
       
SELECT *
FROM cmc_adult
WHERE `procedure` = 9810415400;

-- Answer 1. Yeah, pretty sure.
SELECT COUNT(DISTINCT code)
FROM cmc_ped_std
WHERE code IN
	(SELECT code
    FROM cmc_adult_one_std)
OR
	code IN
    (SELECT code
    FROM cmc_adult_zero_std);
    
-- Answer 2. Pretty much
SELECT *
FROM novant_presbyterian_std
WHERE description LIKE '%ped%'
AND cpt != '';

SELECT DISTINCT charge_type
FROM novant_presbyterian_std;

SELECT *
FROM novant_presbyterian_std
WHERE charge_type = 'L&D Alt';