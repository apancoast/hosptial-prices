SELECT *
FROM select_prices
WHERE code IN
	(SELECT concept_code
    FROM codes_select
    WHERE category LIKE '%Surgical%');


SELECT DISTINCT category
FROM codes_select
WHERE concept_code IN
	(SELECT code
    FROM select_prices
    WHERE plan = 'gross'
		AND amount IS NOT NULL
		AND hospital_id = 2)
ORDER BY category;

CREATE TEMPORARY TABLE gross_diffs AS
WITH gross_prices AS (
    SELECT *
    FROM select_prices
    WHERE plan = 'gross'
)
SELECT 
    hospital_id, code, plan, amount,
    ROUND(
        IFNULL(
            100 * (
                amount - (
                    SELECT SUM(amount) 
                    FROM gross_prices AS other 
                    WHERE other.hospital_id <> p.hospital_id 
                        AND other.plan = p.plan 
                        AND other.code = p.code
                )
            ) / (
                SELECT SUM(amount) 
                FROM gross_prices AS other 
                WHERE other.hospital_id <> p.hospital_id 
                    AND other.plan = p.plan 
                    AND other.code = p.code
            ),
            NULL
        ),
        2
    ) AS percent_difference
FROM gross_prices AS p
HAVING percent_difference IS NOT NULL
	AND percent_difference > 0;
    
CREATE TEMPORARY TABLE gross_diffs_2 AS -- because i'm lazy rn
WITH gross_prices AS (
    SELECT *
    FROM select_prices
    WHERE plan = 'gross'
)
SELECT 
    hospital_id, code, plan, amount,
    ROUND(
        IFNULL(
            100 * (
                amount - (
                    SELECT SUM(amount) 
                    FROM gross_prices AS other 
                    WHERE other.hospital_id <> p.hospital_id 
                        AND other.plan = p.plan 
                        AND other.code = p.code
                )
            ) / (
                SELECT SUM(amount) 
                FROM gross_prices AS other 
                WHERE other.hospital_id <> p.hospital_id 
                    AND other.plan = p.plan 
                    AND other.code = p.code
            ),
            NULL
        ),
        2
    ) AS percent_difference
FROM gross_prices AS p
HAVING percent_difference IS NOT NULL
	AND percent_difference > 0;

-- Calculate Q1 and Q3 of the percent_difference column
SELECT 
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'Q1',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'Q3'
FROM gross_diffs;

-- Calculate Q1 and Q3 of the percent_difference column
SELECT 
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'Q3',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'Q1',
    SUM(Q3 - Q1) AS IQR
FROM gross_diffs;

-- Calculate Q1, Q3, IQR, lower limit, and upper limit of the percent_difference column
SELECT 
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'Q3',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'Q1',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'IQR',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL) - 1.5 * (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL)) AS 'Lower Limit',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) + 1.5 * (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL)) AS 'Upper Limit'
FROM gross_diffs;



SELECT *
FROM select_prices
WHERE code = 'A9527'
AND plan = 'gross';