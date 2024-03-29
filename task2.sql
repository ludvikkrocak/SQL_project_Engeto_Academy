
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

CREATE VIEW tbl_milk_bread_all AS
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
WHERE (price.category_name LIKE '%chleb%' OR price.category_name LIKE '%mleko%') ;

SELECT * FROM tbl_milk_bread_all ;

SELECT 
		year
    	,category_name
    	,amount_per_payroll
    	,((amount_per_payroll - LAG(amount_per_payroll) 
    	     OVER (PARTITION BY category_name ORDER BY year)) / LAG(amount_per_payroll) 
    	      OVER (PARTITION BY category_name ORDER BY year)) * 100 as percentage_amount_change
FROM tbl_milk_bread_all;