
/*
			Table payroll
*/

CREATE TABLE avg_wages_annual_growth AS
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
FROM avg_wages_annual_growth;


CREATE TABLE avg_wages_annual_growth_by_category AS
WITH avg_payroll AS (
  SELECT payroll_year
        ,industry_branch_code 
        ,name
        ,AVG(value) as category_avg_payroll
  FROM czechia_payroll
  INNER JOIN czechia_payroll_industry_branch
      ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
  GROUP BY industry_branch_code, payroll_year
)
SELECT payroll_year as year
      ,industry_branch_code 
      ,name
      ,category_avg_payroll
      ,((category_avg_payroll - LAG(category_avg_payroll) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year)) / LAG(category_avg_payroll) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year)) * 100 as category_payroll_growth
FROM avg_payroll
ORDER BY year, industry_branch_code;

SELECT *
FROM avg_wages_annual_growth_by_category;

-- DROP TABLE payroll_annual_growth
-- ------------------------------------------------------------------------------------------------------------------------------------  

/*
			Table prices
*/

CREATE TABLE prices_annual_growth AS
WITH avg_price AS (
  SELECT YEAR(date_from) as year
        ,AVG(value) as average_price
  FROM czechia_price
  WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
  GROUP BY YEAR(date_from)
)
SELECT year
      ,average_price
      ,((average_price - LAG(average_price) OVER (ORDER BY year)) / LAG(average_price) OVER (ORDER BY year)) * 100 as price_growth
FROM avg_price
ORDER BY year

  SELECT *
  FROM prices_annual_growth;

 
 
CREATE TABLE prices_annual_growth_by_category AS
WITH avg_price AS (
  SELECT YEAR(date_from) as year
      ,category_code
      ,name
      ,price_value
	  ,price_unit
      ,AVG(value) as average_price
  FROM czechia_price
  INNER JOIN czechia_price_category
      ON czechia_price.category_code = czechia_price_category.code
  GROUP BY year, category_code
)
SELECT year
      ,category_code
      ,name
      ,CONCAT(price_value, ' ', price_unit) as price_unit
      ,average_price
      ,((average_price - LAG(average_price) OVER (PARTITION BY category_code ORDER BY year)) / LAG(average_price) OVER (PARTITION BY category_code ORDER BY year)) * 100 as price_growth
FROM avg_price
ORDER BY year, category_code;


SELECT *
FROM prices_annual_growth_by_category;

-- DROP TABLE prices_annual_growth;

-- ------------------------------------------------------------------------------------------------------------------------------------  

/*
			Table GDP Czech republic
*/

CREATE TABLE cz_gdp_annual_growth AS
SELECT year
	  ,country
	  ,gdp
      ,((gdp - LAG(gdp) OVER (ORDER BY year)) / LAG(gdp) OVER (ORDER BY year)) * 100 as gdp_growth
FROM economies
WHERE country LIKE '%czech%'
AND year BETWEEN 2006 AND 2018;

SELECT *
FROM cz_gdp_annual_growth;

-- ------------------------------------------------------------------------------------------------------------------------------------  
   
/*
			Table Eurpe enomoies
*/

CREATE TABLE europe_economies AS
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
OR country LIKE '%latvia%')
AND year BETWEEN 2006 AND 2018;

SELECT *
FROM europe_economies;