-- Need IQR for removing outliers in PowerBI
CREATE TEMPORARY TABLE cash_diffs AS
WITH cash_prices AS (
    SELECT *
    FROM select_prices
    WHERE plan = 'cash_price'
    AND amount > 0
)
SELECT 
    hospital_id, code, plan, amount,
    ROUND(
        IFNULL(
            100 * (
                amount - (
                    SELECT SUM(amount) 
                    FROM cash_prices AS other 
                    WHERE other.hospital_id <> p.hospital_id 
                        AND other.plan = p.plan 
                        AND other.code = p.code
                )
            ) / (
                SELECT SUM(amount) 
                FROM cash_prices AS other 
                WHERE other.hospital_id <> p.hospital_id 
                    AND other.plan = p.plan 
                    AND other.code = p.code
            ),
            NULL
        ),
        2
    ) AS percent_difference
FROM cash_prices AS p
HAVING percent_difference IS NOT NULL
	AND percent_difference > 0;

SELECT *
FROM cash_diffs
WHERE code IN ('94375');

SELECT *
FROM select_prices
WHERE code IN ('94375')
AND plan IN ('cash_price', 'gross', 'phcs', 'uhc_unspecified');

-- Calculate Q1, Q3, IQR, lower limit, and upper limit of the percent_difference column
SELECT 
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'Q3',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'Q1',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'IQR',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL) - 1.5 * (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL)) AS 'Lower Limit',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) + 1.5 * (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL)) AS 'Upper Limit'
FROM cash_diffs;

