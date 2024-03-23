
-- task 2

WITH price AS (
	SELECT
		subject
		,year
		,category_code
		,category_name
		,average_value AS average_price
		FROM t_ludvik_krocak_project_SQL_primary_final
		WHERE subject = 'price'
),
payroll AS (
	SELECT
		subject
		,year
		,category_code
		,category_name
		,average_value AS average_payroll
	FROM t_ludvik_krocak_project_SQL_primary_final
	WHERE subject = 'payroll'
)
SELECT 
    price.year
    ,price.category_name
    ,price.average_price
    ,payroll.average_payroll / price.average_price AS amount_per_payroll
FROM price
JOIN payroll ON price.year = payroll.year
WHERE (price.category_name LIKE '%chleb%' OR price.category_name LIKE '%mleko%') AND (price.year = 2006 OR price.year = 2018);

