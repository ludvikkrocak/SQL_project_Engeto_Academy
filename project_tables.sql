
CREATE VIEW tbl_payroll AS
SELECT
		'payroll' AS subject
		,payroll_year AS year
    	,industry_branch_code AS category_code
    	,name AS category_name
    	,AVG(value) AS average_value
FROM czechia_payroll
INNER JOIN czechia_payroll_industry_branch
      ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
GROUP BY industry_branch_code, year, name
ORDER BY year;

SELECT * FROM tbl_payroll

-- ---------------------------------------------------------------------------------------------------



CREATE VIEW tbl_price AS
SELECT
		'price' AS subject
		,YEAR(date_from) AS year
		,category_code
		,CONCAT(name, '   ', price_unit) AS category_name
		,AVG(value) AS average_value
FROM czechia_price
INNER JOIN czechia_price_category
      ON czechia_price.category_code = czechia_price_category.code
WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
GROUP BY year, category_code, name
ORDER BY year;


-- ------------------------------------------------------------------------------------

CREATE VIEW tbl_gdp AS
SELECT
		year
		,country 
		,GDP
FROM economies e
WHERE country LIKE '%czech%' AND year BETWEEN 2006 AND 2018
ORDER BY year;


-- ----------------------------------

CREATE TABLE t_ludvik_krocak_project_SQL_primary_final
SELECT 
		tp.subject
		,tp.year
		,tp.category_code
		,tp.category_name
		,tp.average_value
		,tg.country
		,tg.GDP
FROM tbl_payroll tp
INNER JOIN tbl_gdp tg
	ON tp.year = tg.year
UNION ALL
SELECT 
	   prc.subject
	  ,prc.year
	  ,prc.category_code
	  ,prc.category_name
	  ,prc.average_value
	  ,tg.country
	  ,tg.GDP
FROM tbl_price prc
INNER JOIN tbl_gdp tg
	ON prc.year = tg.year
GROUP BY year, category_code, category_name, average_value, gdp;


SELECT * FROM t_ludvik_krocak_project_SQL_primary_final;


CREATE TABLE t_ludvik_krocak_project_SQL_secondary_final AS
SELECT
     c.country
    ,year
    ,gdp
    ,gini
    ,e.population
    ,median_age_2018 
FROM
    economies AS e
INNER JOIN
    countries AS c ON e.country = c.country
WHERE
    c.country IN (
        'Germany', 'Poland', 'Czech Republic', 'Slovakia', 'Austria',
        'United Kingdom', 'Italy', 'Spain', 'Croatia', 'Sweden',
        'Bulgaria', 'Latvia', 'France'
    )
    AND e.year BETWEEN 2006 AND 2018;


SELECT *
FROM t_ludvik_krocak_project_SQL_secondary_final
ORDER BY country, year;

