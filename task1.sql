
-- task 1

SELECT 
		subject
		,year
    	,category_code
    	,category_name
    	,average_value
    	      ,((average_value - LAG(average_value) 
    	      	OVER (PARTITION BY category_code ORDER BY year)) / LAG(average_value) 
    	      		OVER (PARTITION BY category_code ORDER BY year)) * 100 as avg_payroll_growth
FROM t_ludvik_krocak_project_SQL_primary_final
WHERE subject = 'payroll';
