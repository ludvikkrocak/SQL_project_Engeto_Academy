
-- task 1

-- annual increases in average paroll

CREATE VIEW tbl_year_on_year_increases_average_payroll AS
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

SELECT * FROM tbl_year_on_year_increases_average_payroll ;

SELECT
		year
		,category_name
		,avg_payroll_growth_by_category
FROM tbl_year_on_year_increases_average_payroll
WHERE avg_payroll_growth_by_category <= 0;

SELECT 
		subject
		,year
    	,category_name
    	,avg_payroll_growth_by_category
	FROM tbl_year_on_year_increases_average_payroll
	WHERE avg_payroll_growth_by_category = (SELECT MAX(avg_payroll_growth_by_category)
	FROM tbl_year_on_year_increases_average_payroll)
UNION
SELECT 
		subject
		,year
    	,category_name
    	,avg_payroll_growth_by_category
	FROM tbl_year_on_year_increases_average_payroll
	WHERE avg_payroll_growth_by_category = (SELECT MIN(avg_payroll_growth_by_category)
	FROM tbl_year_on_year_increases_average_payroll);


-- average of annual payroll increases

WITH annual_increase AS (
    SELECT 
			subject
			,year
    		,category_code
    		,category_name
    		,average_value_by_category	
    		,avg_payroll_growth_by_category
    FROM tbl_year_on_year_increases_average_payroll
    WHERE subject = 'payroll'
),
growth AS (
	SELECT
    	category_code
    	,category_name
    	,SUM(avg_payroll_growth_by_category) / COUNT(DISTINCT year) AS avg_payroll_growth
FROM annual_increase
GROUP BY category_code, category_name
)
SELECT 
    category_code
    ,category_name
    ,avg_payroll_growth
FROM growth
ORDER BY avg_payroll_growth DESC;


-- sectors where there was no decrease in payroll

SELECT 
    category_name
FROM 
    (SELECT 
        	category_name
        	,AVG(CASE 
            	WHEN avg_payroll_growth_by_category < 0 THEN 1
            	ELSE 0 
            	END) as negative_growth_occurrences
    FROM 
        (SELECT 
            	category_name
            	,avg_payroll_growth_by_category
        FROM tbl_year_on_year_increases_average_payroll
        WHERE subject = 'payroll') as subquery
    GROUP BY category_name) as subquery2
WHERE negative_growth_occurrences = 0;



