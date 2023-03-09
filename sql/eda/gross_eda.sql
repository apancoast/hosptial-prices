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

-- Calculate Q1, Q3, IQR, lower limit, and upper limit of the percent_difference column
SELECT 
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'Q3',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'Q1',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL) AS 'IQR',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL) - 1.5 * (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL)) AS 'Lower Limit',
    CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) + 1.5 * (CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.75 * COUNT(*) + 1), ',', -1) AS DECIMAL) - CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(percent_difference ORDER BY percent_difference SEPARATOR ','), ',', 0.25 * COUNT(*) + 1), ',', -1) AS DECIMAL)) AS 'Upper Limit'
FROM gross_diffs;