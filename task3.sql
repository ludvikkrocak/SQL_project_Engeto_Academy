
-- Task 3

WITH yearly_growth AS (
	SELECT 
			subject
			,year
			,category_code
			,category_name
			,((average_value_by_category - LAG(average_value_by_category) 
				OVER (PARTITION BY category_code ORDER BY year)) / LAG(average_value_by_category) 
					OVER (PARTITION BY category_code ORDER BY year)) * 100 AS avg_annual_price_growth_by_category
	FROM t_ludvik_krocak_project_SQL_primary_final
	WHERE subject = 'price'
)
SELECT 
		subject
		,category_code
		,category_name
		,AVG(avg_annual_price_growth_by_category) AS avg_of_annual_increases_by_category
FROM yearly_growth
GROUP BY category_code
ORDER BY avg_of_annual_increases_by_category;
