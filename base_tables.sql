
/*
			Table payroll
*/

CREATE TABLE payroll_annual_growth AS
WITH avg_payroll AS (
  SELECT payroll_year
        ,industry_branch_code 
        ,name
        ,AVG(value) as average_payroll
  FROM czechia_payroll
  INNER JOIN czechia_payroll_industry_branch
      ON czechia_payroll.industry_branch_code = czechia_payroll_industry_branch.code
  GROUP BY industry_branch_code, payroll_year
),
avg_yearly_payroll AS (
  SELECT payroll_year
        ,AVG(value) as avg_yearly_payroll
  FROM czechia_payroll
  GROUP BY payroll_year
)
SELECT avg_payroll.payroll_year as year
      ,avg_payroll.industry_branch_code 
      ,avg_payroll.name
      ,avg_payroll.average_payroll
      ,((avg_payroll.average_payroll - LAG(avg_payroll.average_payroll) OVER (PARTITION BY avg_payroll.industry_branch_code ORDER BY avg_payroll.payroll_year)) / LAG(avg_payroll.average_payroll) OVER (PARTITION BY avg_payroll.industry_branch_code ORDER BY avg_payroll.payroll_year)) * 100 as payroll_growth
      ,avg_yearly_payroll.avg_yearly_payroll
FROM avg_payroll
INNER JOIN avg_yearly_payroll
      ON avg_payroll.payroll_year = avg_yearly_payroll.payroll_year
ORDER BY year, industry_branch_code;


SELECT *
FROM payroll_annual_growth;

-- DROP TABLE payroll_annual_growth
-- ------------------------------------------------------------------------------------------------------------------------------------  

/*
			Table prices
*/

CREATE TABLE prices_annual_growth AS
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
FROM prices_annual_growth;


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