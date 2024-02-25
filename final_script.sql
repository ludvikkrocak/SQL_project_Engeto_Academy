CREATE TABLE t_ludvik_krocak_project_SQL_primary_final AS
SELECT 
	   avg_payroll_annual_growth.year
      ,CONCAT(industry_branch_code, ' ; ', name) AS "category_code_&_name"
      ,avg_payroll_annual_growth.average_payroll AS average_value
      ,avg_payroll_annual_growth.avg_payroll_growth AS avg_value_growth
      ,category_avg_payroll AS category_avg_value
      ,category_payroll_growth AS category_value_growth
      ,growth_difference AS anual_growth_difference_payroll_prices
      ,gdp
      ,gdp_growth
FROM avg_payroll_annual_growth
LEFT JOIN avg_payroll_annual_growth_by_category 
ON avg_payroll_annual_growth.year = avg_payroll_annual_growth_by_category.year
LEFT JOIN annual_price_payroll_growth
	ON avg_payroll_annual_growth_by_category.year = annual_price_payroll_growth.year
LEFT JOIN prices_payroll_gdp_grow
	ON avg_payroll_annual_growth.year = prices_payroll_gdp_grow.year
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
LEFT JOIN annual_price_payroll_growth
	ON prices_annual_growth.year = annual_price_payroll_growth.year
LEFT JOIN prices_payroll_gdp_grow
	ON prices_annual_growth.year = prices_payroll_gdp_grow.year;
	

SELECT *
FROM t_ludvik_krocak_project_SQL_primary_final;


CREATE TABLE t_ludvik_krocak_project_SQL_secondary_final AS
SELECT *
FROM europe_economies

SELECT *
FROM t_ludvik_krocak_project_SQL_secondary_final;

