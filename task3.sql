
-- Task 3

SELECT 
		subject
		,year
    	,category_code
    	,category_name
    	,average_value_by_category
    	,((average_value_by_category - LAG(average_value_by_category) 
    	      OVER (PARTITION BY category_code ORDER BY year)) / LAG(average_value_by_category) 
    	      	OVER (PARTITION BY category_code ORDER BY year)) * 100 as avg_price_growth_by_category
FROM t_ludvik_krocak_project_SQL_primary_final
WHERE subject = 'price';

WITH yearly_growth AS (
	SELECT 
			subject
			,year
			,category_code
			,category_name
			,((average_value_by_category - LAG(average_value_by_category) 
				OVER (PARTITION BY category_code ORDER BY year)) / LAG(average_value_by_category) 
					OVER (PARTITION BY category_code ORDER BY year)) * 100 as avg_annual_price_growth_by_category
	FROM t_ludvik_krocak_project_SQL_primary_final
	WHERE subject = 'price'
)
SELECT 
		subject
		,category_code
		,category_name
		,AVG(avg_annual_price_growth_by_category) as avg_of_annual_increases_by_category
FROM yearly_growth
GROUP BY category_code;




/*

WITH price_2006 AS (
	SELECT 
		category_code 
		,name
		,average_price AS price_2006
	FROM tbl_prices_annual_growth_by_category
	WHERE year = '2006'
),
price_2018 AS (
	SELECT 
		category_code
		,name
		,average_price AS price_2018
	FROM tbl_prices_annual_growth_by_category
	WHERE year = '2018'
)
SELECT 
	p18.category_code
	,p18.name
	,p18.price_2018
	,p06.price_2006
	,(p18.price_2018 - p06.price_2006) AS price_change
	,((p18.price_2018 - p06.price_2006) / p06.price_2006 * 100) AS percentage_change
FROM price_2018 p18
JOIN price_2006 p06 ON p18.category_code = p06.category_code
ORDER BY percentage_change;
*/