
-- task 1

SELECT 
		subject
		,year
    	,category_code
    	,category_name
    	,average_value_by_category
    	,((average_value_by_category - LAG(average_value_by_category) 
    	     OVER (PARTITION BY category_code ORDER BY year)) / LAG(average_value_by_category) 
    	      OVER (PARTITION BY category_code ORDER BY year)) * 100 as avg_payroll_growth_by_category
FROM t_ludvik_krocak_project_SQL_primary_final
WHERE subject = 'payroll' ;



WITH annual_increase AS (
    SELECT 
		subject
		,year
    	,category_code
    	,category_name
    	,average_value_by_category
    	,((average_value_by_category - LAG(average_value_by_category) 
    	     OVER (PARTITION BY category_code ORDER BY year)) / LAG(average_value_by_category) 
    	      OVER (PARTITION BY category_code ORDER BY year)) * 100 as payroll_increase_by_category
	FROM t_ludvik_krocak_project_SQL_primary_final
    WHERE subject = 'payroll'
),
growth AS (
	SELECT
    	category_code
    	,category_name
    	,SUM(payroll_increase_by_category) / COUNT(DISTINCT year) AS avg_payroll_growth
FROM annual_increase
GROUP BY category_code, category_name
)
SELECT 
    category_code
    ,category_name
    ,avg_payroll_growth
FROM growth;