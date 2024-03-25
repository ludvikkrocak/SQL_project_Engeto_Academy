
CREATE VIEW tbl_payroll_by_category AS
SELECT
		'payroll' AS subject
		,payroll_year AS year
    	,industry_branch_code AS category_code
    	,name AS category_name
    	,AVG(value) AS average_value_by_category
FROM czechia_payroll
INNER JOIN czechia_payroll_industry_branch
      ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
GROUP BY industry_branch_code, year, name
ORDER BY year;

CREATE VIEW tbl_payroll AS
SELECT
		payroll_year AS year
		,AVG(value) AS average_value
FROM czechia_payroll
GROUP BY year
ORDER BY year;

-- ---------------------------------------------------------------------------------------------------
SELECT * FROM tbl_payroll_by_category;

SELECT * FROM tbl_price_by_category

-- ---------------------------------------------------------------------------------------------------

CREATE VIEW tbl_price_by_category AS
SELECT
		'price' AS subject
		,YEAR(date_from) AS year
		,category_code
		,CONCAT(name, '   ', price_unit) AS category_name
		,AVG(value) AS average_value_by_category
FROM czechia_price
INNER JOIN czechia_price_category
      ON czechia_price.category_code = czechia_price_category.code
WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
GROUP BY year, category_code, name
ORDER BY year;

CREATE VIEW tbl_price AS
SELECT
		YEAR(date_from) AS year
		,AVG(value) AS average_value
FROM czechia_price
WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
GROUP BY year
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
    ,tp.average_value_by_category
    ,tbl_payroll.average_value
    ,tg.country
    ,tg.GDP
FROM tbl_payroll_by_category tp
INNER JOIN tbl_gdp tg
    ON tp.year = tg.year
LEFT JOIN tbl_payroll 
    ON tp.year = tbl_payroll.year
UNION ALL
SELECT 
    prc.subject
    ,prc.year
    ,prc.category_code
    ,prc.category_name
    ,prc.average_value_by_category
    ,tbl_price.average_value
    ,tg.country
    ,tg.GDP
FROM tbl_price_by_category prc
INNER JOIN tbl_gdp tg
    ON prc.year = tg.year
LEFT JOIN tbl_price 
    ON prc.year = tbl_price.year;

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

