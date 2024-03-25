
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
WHERE subject = 'payroll';
