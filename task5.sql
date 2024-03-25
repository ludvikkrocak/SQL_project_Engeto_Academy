
-- Task 5

SELECT 
		tbl1.year
		,avg_payroll_growth
		,avg_price_growth
		,GDP		
		,((GDP - LAG(GDP) 
    	     OVER (ORDER BY year)) / LAG(GDP) 
    	      	OVER (ORDER BY year)) * 100 as gdp_growth  	      		
FROM tbl_payroll_price_annual_growth tbl1
INNER JOIN t_ludvik_krocak_project_sql_primary_final tbl2
	ON tbl1.year = tbl2.year
GROUP BY year;
