CREATE DATABASE IF NOT EXISTS debt_analysis;
USE debt_analysis;

-- 1. Countries Table
CREATE TABLE countries (
    country_code VARCHAR(10) PRIMARY KEY,
    country_name VARCHAR(150) NOT NULL,
    region VARCHAR(100),
    income_group VARCHAR(100),
    lending_category VARCHAR(100),
    currency_unit VARCHAR(100)
);

-- 2. Indicators Table
CREATE TABLE indicators (
    series_code VARCHAR(50) PRIMARY KEY,
    indicator_name VARCHAR(255) NOT NULL,
    topic VARCHAR(255),
    periodicity VARCHAR(50)
);

-- 3. Debt Data Table (Fact Table)
CREATE TABLE debt_data (
    record_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    country_code VARCHAR(10) NOT NULL,
    series_code VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    debt_value DECIMAL(25, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_country FOREIGN KEY (country_code) REFERENCES countries(country_code),
    CONSTRAINT fk_indicator FOREIGN KEY (series_code) REFERENCES indicators(series_code),
    INDEX idx_country (country_code),
    INDEX idx_series (series_code),
    INDEX idx_year (year)
);

-- Checking row count
SELECT 'countries' AS table_name, COUNT(*) AS row_count FROM countries
UNION ALL
SELECT 'indicators', COUNT(*) FROM indicators
UNION ALL
SELECT 'debt_data', COUNT(*) FROM debt_data;

-- 1. Retrieve all distinct country names from the dataset
SELECT DISTINCT country_name
FROM countries
WHERE region != 'Aggregate Group'
ORDER BY country_name;

-- 2. Count the total number of countries available
SELECT COUNT(DISTINCT country_code) AS total_countries
FROM countries
WHERE region != 'Aggregate Group';

-- 3. Find the total number of indicators present
SELECT COUNT(DISTINCT series_code) AS total_indicators
FROM indicators;

-- 4. Display the first 10 records of the dataset
SELECT d.record_id, c.country_name, i.indicator_name, d.year, d.debt_value
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
JOIN indicators i ON d.series_code = i.series_code
LIMIT 10;

-- 5. Calculate the total global debt (real countries & debt indicators)
SELECT ROUND(SUM(d.debt_value) / 1e12, 2) AS total_global_debt_trillion_usd
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%';

-- 6. List all unique indicator names
SELECT DISTINCT indicator_name
FROM indicators
ORDER BY indicator_name;

-- 7. Find the number of records for each country
SELECT c.country_name, COUNT(d.record_id) AS record_count
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE c.region != 'Aggregate Group'
GROUP BY c.country_name
ORDER BY record_count DESC;

-- 8. Display all records where debt is greater than 1 billion USD
SELECT c.country_name, i.indicator_name, d.year, d.debt_value
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
JOIN indicators i ON d.series_code = i.series_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
  AND d.debt_value > 1000000000
ORDER BY d.debt_value DESC
LIMIT 100;

-- 9. Find the minimum, maximum, and average debt values
SELECT 
    MIN(d.debt_value) AS min_debt,
    MAX(d.debt_value) AS max_debt,
    ROUND(AVG(d.debt_value), 2) AS avg_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%';

-- 10. Count total number of records in the dataset
SELECT COUNT(*) AS total_records
FROM debt_data;

-- 11. Find the total debt for each country
SELECT c.country_name, SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY c.country_name
ORDER BY total_debt DESC;

-- 12. Display the top 10 countries with the highest total debt
SELECT c.country_name, SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY c.country_name
ORDER BY total_debt DESC
LIMIT 10;

-- 13. Find the average debt per country
SELECT c.country_name, ROUND(AVG(d.debt_value), 2) AS avg_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY c.country_name
ORDER BY avg_debt DESC;

-- 14. Calculate total debt for each indicator
SELECT i.indicator_name, SUM(d.debt_value) AS total_indicator_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
JOIN indicators i ON d.series_code = i.series_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY i.indicator_name
ORDER BY total_indicator_debt DESC;

-- 15. Identify the indicator contributing the highest total debt
SELECT i.indicator_name, SUM(d.debt_value) AS total_indicator_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
JOIN indicators i ON d.series_code = i.series_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY i.indicator_name
ORDER BY total_indicator_debt DESC
LIMIT 1;

-- 16. Find the country with the lowest total debt (excluding zero-debt countries)
SELECT c.country_name, SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY c.country_name
HAVING SUM(d.debt_value) > 0
ORDER BY total_debt ASC
LIMIT 1;

-- 17. Calculate total debt for each country and indicator combination
SELECT c.country_name, i.indicator_name, SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
JOIN indicators i ON d.series_code = i.series_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY c.country_name, i.indicator_name
ORDER BY c.country_name, total_debt DESC;

-- 18. Count how many indicators each country has
SELECT c.country_name, COUNT(DISTINCT d.series_code) AS indicator_count
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY c.country_name
ORDER BY indicator_count DESC;

-- 19. Display countries whose total debt is above the global average
WITH country_totals AS (
    SELECT c.country_name, SUM(d.debt_value) AS total_debt
    FROM debt_data d
    JOIN countries c ON d.country_code = c.country_code
    WHERE c.region != 'Aggregate Group'
      AND d.series_code LIKE 'DT.%'
    GROUP BY c.country_name
)
SELECT country_name, total_debt
FROM country_totals
WHERE total_debt > (SELECT AVG(total_debt) FROM country_totals)
ORDER BY total_debt DESC;

-- 20. Rank countries based on total debt (highest to lowest)
SELECT 
    c.country_name,
    SUM(d.debt_value) AS total_debt,
    DENSE_RANK() OVER (ORDER BY SUM(d.debt_value) DESC) AS debt_rank
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY c.country_name;

-- 21. Find the top 5 indicators contributing most to global debt
SELECT i.indicator_name, SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
JOIN indicators i ON d.series_code = i.series_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY i.indicator_name
ORDER BY total_debt DESC
LIMIT 5;

-- 22. Calculate percentage contribution of each country to total global debt
WITH country_totals AS (
    SELECT c.country_name, SUM(d.debt_value) AS total_debt
    FROM debt_data d
    JOIN countries c ON d.country_code = c.country_code
    WHERE c.region != 'Aggregate Group'
      AND d.series_code LIKE 'DT.%'
    GROUP BY c.country_name
)
SELECT 
    country_name,
    total_debt,
    ROUND((total_debt / SUM(total_debt) OVER ()) * 100, 2) AS pct_contribution
FROM country_totals
ORDER BY pct_contribution DESC;

-- 23. Identify the top 3 countries for each indicator based on debt
WITH ranked_countries AS (
    SELECT 
        i.indicator_name,
        c.country_name,
        SUM(d.debt_value) AS total_debt,
        ROW_NUMBER() OVER (PARTITION BY i.indicator_name ORDER BY SUM(d.debt_value) DESC) AS rn
    FROM debt_data d
    JOIN countries c ON d.country_code = c.country_code
    JOIN indicators i ON d.series_code = i.series_code
    WHERE c.region != 'Aggregate Group'
      AND d.series_code LIKE 'DT.%'
    GROUP BY i.indicator_name, c.country_name
)
SELECT indicator_name, country_name, total_debt, rn AS rank_in_indicator
FROM ranked_countries
WHERE rn <= 3
ORDER BY indicator_name, rn;

-- 24. Find the difference between maximum and minimum debt for each country
SELECT 
    c.country_name,
    MAX(d.debt_value) AS max_debt,
    MIN(d.debt_value) AS min_debt,
    (MAX(d.debt_value) - MIN(d.debt_value)) AS debt_range
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY c.country_name
ORDER BY debt_range DESC;

-- 25. Create a view for the top 10 countries with highest debt
CREATE OR REPLACE VIEW vw_top10_indebted_countries AS
SELECT 
    c.country_code,
    c.country_name,
    c.region,
    c.income_group,
    SUM(d.debt_value) AS total_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY c.country_code, c.country_name, c.region, c.income_group
ORDER BY total_debt DESC
LIMIT 10;

-- Verify the view:
SELECT * FROM vw_top10_indebted_countries;

-- 26. Categorize countries into High Debt, Medium Debt, and Low Debt
WITH country_totals AS (
    SELECT c.country_name, SUM(d.debt_value) AS total_debt
    FROM debt_data d
    JOIN countries c ON d.country_code = c.country_code
    WHERE c.region != 'Aggregate Group'
      AND d.series_code LIKE 'DT.%'
    GROUP BY c.country_name
)
SELECT 
    country_name,
    total_debt,
    CASE 
        WHEN total_debt >= 1000000000000 THEN 'High Debt'     -- >= 1 Trillion USD
        WHEN total_debt >= 100000000000  THEN 'Medium Debt'   -- 100B to 1T USD
        ELSE 'Low Debt'                                       -- < 100 Billion USD
    END AS debt_category
FROM country_totals
ORDER BY total_debt DESC;

-- 27. Use window functions to calculate cumulative debt per country (year-by-year)
WITH yearly_country_debt AS (
    SELECT c.country_name, d.year, SUM(d.debt_value) AS yearly_debt
    FROM debt_data d
    JOIN countries c ON d.country_code = c.country_code
    WHERE c.region != 'Aggregate Group'
      AND d.series_code LIKE 'DT.%'
    GROUP BY c.country_name, d.year
)
SELECT 
    country_name,
    year,
    yearly_debt,
    SUM(yearly_debt) OVER (PARTITION BY country_name ORDER BY year) AS cumulative_debt
FROM yearly_country_debt
ORDER BY country_name, year;

-- 28. Find indicators where average debt is higher than overall average debt
SELECT i.indicator_name, ROUND(AVG(d.debt_value), 2) AS indicator_avg_debt
FROM debt_data d
JOIN countries c ON d.country_code = c.country_code
JOIN indicators i ON d.series_code = i.series_code
WHERE c.region != 'Aggregate Group'
  AND d.series_code LIKE 'DT.%'
GROUP BY i.indicator_name
HAVING AVG(d.debt_value) > (
    SELECT AVG(d2.debt_value)
    FROM debt_data d2
    JOIN countries c2 ON d2.country_code = c2.country_code
    WHERE c2.region != 'Aggregate Group'
      AND d2.series_code LIKE 'DT.%'
)
ORDER BY indicator_avg_debt DESC;

-- 29. Identify countries contributing more than 5% of global debt
WITH country_share AS (
    SELECT 
        c.country_name,
        SUM(d.debt_value) AS total_debt,
        ROUND((SUM(d.debt_value) / SUM(SUM(d.debt_value)) OVER ()) * 100, 2) AS pct_share
    FROM debt_data d
    JOIN countries c ON d.country_code = c.country_code
    WHERE c.region != 'Aggregate Group'
      AND d.series_code LIKE 'DT.%'
    GROUP BY c.country_name
)
SELECT country_name, total_debt, pct_share
FROM country_share
WHERE pct_share > 5.00
ORDER BY pct_share DESC;

-- 30. Find the most dominant indicator (highest contribution) for each country
WITH country_indicator_rank AS (
    SELECT 
        c.country_name,
        i.indicator_name,
        SUM(d.debt_value) AS indicator_debt,
        ROW_NUMBER() OVER (PARTITION BY c.country_name ORDER BY SUM(d.debt_value) DESC) AS rn
    FROM debt_data d
    JOIN countries c ON d.country_code = c.country_code
    JOIN indicators i ON d.series_code = i.series_code
    WHERE c.region != 'Aggregate Group'
      AND d.series_code LIKE 'DT.%'
    GROUP BY c.country_name, i.indicator_name
)
SELECT country_name, indicator_name AS dominant_indicator, indicator_debt
FROM country_indicator_rank
WHERE rn = 1
ORDER BY indicator_debt DESC;