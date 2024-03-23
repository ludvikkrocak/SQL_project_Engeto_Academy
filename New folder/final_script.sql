
CREATE TABLE t_ludvik_krocak_project_SQL_primary_final AS
SELECT 
	   tbl_avg_payroll_annual_growth.year
      ,CONCAT(industry_branch_code, ' ; ', name) AS "category_code_&_name"
      ,tbl_avg_payroll_annual_growth.average_payroll AS average_value
      ,tbl_avg_payroll_annual_growth.avg_payroll_growth AS avg_value_growth
      ,category_avg_payroll AS category_avg_value
      ,category_payroll_growth AS category_value_growth
      ,growth_difference_prc_prl AS anual_growth_difference_payroll_prices
      ,gdp
      ,gdp_growth
FROM tbl_avg_payroll_annual_growth
LEFT JOIN tbl_avg_payroll_annual_growth_by_category 
ON tbl_avg_payroll_annual_growth.year = tbl_avg_payroll_annual_growth_by_category.year
LEFT JOIN tbl_annual_price_payroll_growth
	ON tbl_avg_payroll_annual_growth_by_category.year = tbl_annual_price_payroll_growth.year
LEFT JOIN tbl_prices_payroll_gdp_grow
	ON tbl_avg_payroll_annual_growth.year = tbl_prices_payroll_gdp_grow.year
UNION ALL
SELECT 
	   tbl_prices_annual_growth.year
	  ,CONCAT(category_code, ' ; ', name) AS "category_code_&_name"
	  ,tbl_prices_annual_growth.average_price AS average_value
	  ,tbl_prices_annual_growth.price_growth AS avg_value_growth
	  ,tbl_prices_annual_growth_by_category.average_price AS category_avg_value
	  ,tbl_prices_annual_growth_by_category.price_growth AS category_value_growth
	  ,growth_difference_prc_prl AS anual_growth_difference_payroll_prices
	  ,gdp
	  ,gdp_growth
FROM tbl_prices_annual_growth
LEFT JOIN tbl_prices_annual_growth_by_category
	ON tbl_prices_annual_growth.year = tbl_prices_annual_growth_by_category.year
LEFT JOIN tbl_annual_price_payroll_growth
	ON tbl_prices_annual_growth.year = tbl_annual_price_payroll_growth.year
LEFT JOIN tbl_prices_payroll_gdp_grow
	ON tbl_prices_annual_growth.year = tbl_prices_payroll_gdp_grow.year;
	

SELECT *
FROM t_ludvik_krocak_project_SQL_primary_final;


CREATE TABLE t_ludvik_krocak_project_SQL_secondary_final AS
SELECT *
FROM tbl_europe_economies

SELECT *
FROM t_ludvik_krocak_project_SQL_secondary_final;


DROP TABLE t_ludvik_krocak_project_SQL_secondary_final