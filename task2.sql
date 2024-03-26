
-- task 2

WITH price AS (
	SELECT
		subject
		,year
		,category_code
		,category_name
		,average_value_by_category AS average_price_by_category
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
SELECT DISTINCT 
    price.year
    ,price.category_name
    ,price.average_price_by_category
    ,payroll.average_payroll / price.average_price_by_category AS amount_per_payroll
FROM price
INNER JOIN payroll ON price.year = payroll.year
WHERE (price.category_name LIKE '%chleb%' OR price.category_name LIKE '%mleko%') 
	AND (price.year = 2006 OR price.year = 2018);

