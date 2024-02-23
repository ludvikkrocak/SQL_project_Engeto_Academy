SELECT *
FROM avg_wages_annual_growth;

SELECT *
FROM avg_wages_annual_growth_by_category;

SELECT *
FROM prices_annual_growth;

SELECT *
FROM difference_annual_price_wages_growth;

SELECT *
FROM prices_annual_growth_by_category
GROUP BY category_code ;

SELECT *
FROM prices_wages_gdp_grow;

CREATE TABLE t_ludvik_krocak_project_SQL_primary_final AS
SELECT 
	   avg_wages_annual_growth.year
      ,CONCAT(industry_branch_code, ' ; ', name) AS "category_code_&_name"
      ,avg_wages_annual_growth.average_payroll AS average_value
      ,avg_wages_annual_growth.avg_payroll_growth AS avg_value_growth
      ,category_avg_payroll AS category_avg_value
      ,category_payroll_growth AS category_value_growth
      ,growth_difference AS anual_growth_difference_payroll_prices
      ,gdp
      ,gdp_growth
FROM avg_wages_annual_growth
LEFT JOIN avg_wages_annual_growth_by_category 
ON avg_wages_annual_growth.year = avg_wages_annual_growth_by_category.year
LEFT JOIN difference_annual_price_wages_growth
	ON avg_wages_annual_growth_by_category.year = difference_annual_price_wages_growth.year
LEFT JOIN prices_wages_gdp_grow
	ON avg_wages_annual_growth.year = prices_wages_gdp_grow.year
UNION ALL
SELECT 
	   prices_annual_growth.year
	  ,CONCAT(category_code, ' ; ', name) AS "category_code_&_name"
	  ,prices_annual_growth.average_price AS average_value
	  ,prices_annual_growth.price_growth AS avg_value_growth
	  ,prices_annual_growth_by_category.average_price AS category_avg_value
	  ,prices_annual_growth_by_category.price_growth AS category_value_growth
	  ,growth_difference AS anual_growth_difference_payroll_prices
	  ,gdp
	  ,gdp_growth
FROM prices_annual_growth
LEFT JOIN prices_annual_growth_by_category
	ON prices_annual_growth.year = prices_annual_growth_by_category.year
LEFT JOIN difference_annual_price_wages_growth
	ON prices_annual_growth.year = difference_annual_price_wages_growth.year
LEFT JOIN prices_wages_gdp_grow
	ON prices_annual_growth.year = prices_wages_gdp_grow.year;
	

SELECT *
FROM t_ludvik_krocak_project_SQL_primary_final;

CREATE TABLE t_ludvik_krocak_project_SQL_secondary_final AS
SELECT country
	  ,year
	  ,gdp
	  ,gini
	  ,population
FROM economies
WHERE (country LIKE '%germany%'
OR country LIKE '%poland%'
OR country LIKE '%czech%'
OR country LIKE '%slovakia%'
OR country LIKE '%austria%'
OR country LIKE '%england%'
OR country LIKE '%italy%'
OR country LIKE '%spain%'
OR country LIKE '%croatia%'
OR country LIKE '%sweden%'
OR country LIKE '%bulgaria%'
OR country LIKE '%latvia%'
OR country LIKE '%france%')
AND year BETWEEN 2006 AND 2018;

SELECT *
FROM t_ludvik_krocak_project_SQL_secondary_final;