
/*
			Tables payroll
*/

-- COMPLETE PAYROLL

CREATE TABLE tbl_avg_payroll_annual_growth AS
WITH avg_payroll AS (
  SELECT payroll_year
        ,AVG(value) as average_payroll
  FROM czechia_payroll
  INNER JOIN czechia_payroll_industry_branch
      ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
  GROUP BY payroll_year
)
SELECT payroll_year as year
      ,average_payroll
      ,((average_payroll - LAG(average_payroll) OVER (ORDER BY payroll_year)) / LAG(average_payroll) OVER (ORDER BY payroll_year)) * 100 as avg_payroll_growth
FROM avg_payroll
ORDER BY year;

SELECT *
FROM tbl_avg_payroll_annual_growth;


-- PAYROLL BY CATEGORY

CREATE TABLE tbl_avg_payroll_annual_growth_by_category AS
WITH avg_payroll AS (
  SELECT payroll_year
        ,industry_branch_code 
        ,name
        ,AVG(value) AS category_avg_payroll
  FROM czechia_payroll cp
  INNER JOIN czechia_payroll_industry_branch cpib
      ON cp.industry_branch_code = cpib.code
  GROUP BY industry_branch_code, payroll_year
)
SELECT payroll_year AS year
      ,industry_branch_code 
      ,name
      ,category_avg_payroll
      ,((category_avg_payroll - LAG(category_avg_payroll) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year)) / LAG(category_avg_payroll) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year)) * 100 AS category_payroll_growth
FROM avg_payroll
ORDER BY year, industry_branch_code;

SELECT *
FROM tbl_avg_payroll_annual_growth_by_category;


-- ------------------------------------------------------------------------------------------------------------------------------------  

/*
			Tables prices
*/

-- COMPLETE PRICES

CREATE TABLE tbl_prices_annual_growth AS
WITH avg_price AS (
  SELECT YEAR(date_from) AS year
        ,AVG(value) AS average_price
  FROM czechia_price
  WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
  GROUP BY YEAR(date_from)
)
SELECT year
      ,average_price
      ,((average_price - LAG(average_price) OVER (ORDER BY year)) / LAG(average_price) OVER (ORDER BY year)) * 100 AS price_growth
FROM avg_price
ORDER BY year

SELECT *
FROM tbl_prices_annual_growth
ORDER BY price_growth;

 
 -- PRICES BY CATEGORY
 
CREATE TABLE tbl_prices_annual_growth_by_category AS
WITH avg_price AS (
  SELECT YEAR(date_from) AS year
      ,category_code
      ,name
      ,price_value
	  ,price_unit
      ,AVG(value) AS average_price
  FROM czechia_price cp
  INNER JOIN czechia_price_category cpc
      ON cp.category_code = cpc.code
  GROUP BY year, category_code
)
SELECT year
      ,category_code
      ,name
      ,CONCAT(price_value, ' ', price_unit) AS price_unit
      ,average_price
      ,((average_price - LAG(average_price) OVER (PARTITION BY category_code ORDER BY year)) / LAG(average_price) OVER (PARTITION BY category_code ORDER BY year)) * 100 AS price_growth
FROM avg_price
ORDER BY year, category_code;


SELECT *
FROM tbl_prices_annual_growth_by_category;


-- ------------------------------------------------------------------------------------------------------------------------------------  

/*
			Tables payroll, prices, GDP
*/

-- TABLE PRICE PAYROLL GROWTH, GROWTH DIFFERENCE

CREATE TABLE tbl_annual_price_payroll_growth AS
SELECT pag.year
      ,average_price
      ,price_growth
      ,average_payroll
      ,avg_payroll_growth
      ,(price_growth - avg_payroll_growth) AS growth_difference_prc_prl
      ,(avg_payroll_growth - price_growth) AS growth_difference_prl_prc
FROM tbl_prices_annual_growth pag
INNER JOIN tbl_avg_payroll_annual_growth apag
ON pag.year = apag.year
GROUP BY year;

SELECT *
FROM tbl_annual_price_payroll_growth;

-- TABLE GDB CZECH REPUBLIC

CREATE TABLE tbl_cz_gdp_annual_growth AS
SELECT year
	  ,country
	  ,gdp
      ,((gdp - LAG(gdp) OVER (ORDER BY year)) / LAG(gdp) OVER (ORDER BY year)) * 100 AS gdp_growth
FROM economies
WHERE country LIKE '%czech%'
AND year BETWEEN 2006 AND 2018;

SELECT *
FROM tbl_cz_gdp_annual_growth;


-- TABLE PRICE PAYROLL GDP GROWTH

CREATE TABLE tbl_prices_payroll_gdp_grow AS
SELECT appg.year
	  ,average_price
      ,price_growth
      ,average_payroll
      ,avg_payroll_growth
      ,gdp
      ,gdp_growth
FROM tbl_annual_price_payroll_growth appg
INNER JOIN tbl_cz_gdp_annual_growth gdp
ON appg.year = gdp.year
GROUP BY year;

SELECT *
FROM tbl_prices_payroll_gdp_grow;

-- ------------------------------------------------------------------------------------------------------------------------------------  

/*
			Table Europe enomoies
*/

CREATE TABLE tbl_europe_economies AS
SELECT
     c.country
    ,e.year
    ,e.gdp
    ,e.gini
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
FROM tbl_europe_economies
ORDER BY country, year;
