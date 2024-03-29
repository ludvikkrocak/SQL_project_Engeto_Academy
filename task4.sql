
-- Task 4

CREATE VIEW tbl_price_payroll_annual_growth AS
WITH payroll AS (
	SELECT 
		subject
		,year
    	,average_value
    	,((average_value - LAG(average_value) 
    	     OVER (ORDER BY year)) / LAG(average_value) 
    	      	OVER (ORDER BY year)) * 100 as avg_payroll_growth
FROM t_ludvik_krocak_project_SQL_primary_final
WHERE subject = 'payroll'
GROUP BY year
),
price AS (
	SELECT 
		subject
		,year
    	,average_value
    	,((average_value - LAG(average_value) 
    	     OVER (ORDER BY year)) / LAG(average_value) 
    	      	OVER (ORDER BY year)) * 100 as avg_price_growth
FROM t_ludvik_krocak_project_SQL_primary_final
WHERE subject = 'price'
GROUP BY year
)
SELECT 
    price.year
    ,payroll.avg_payroll_growth
    ,price.avg_price_growth
    ,(avg_price_growth - avg_payroll_growth) AS price_payroll_difference
FROM price
JOIN payroll ON price.year = payroll.year;

SELECT * FROM tbl_pric
e_payroll_annual_growth;
