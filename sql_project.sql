/*
			Task 1
*/

SELECT AVG(value) as average_value
	  ,industry_branch_code 
	  ,payroll_year 
FROM czechia_payroll
GROUP BY industry_branch_code, payroll_year
ORDER BY payroll_year;

-- ------------------------------------------------------------------------------------------------------------------------------------

/*
			Task 2
*/

-- 1) table mleko chleb price

SELECT *
FROM czechia_price;

SELECT *
FROM czechia_price_category;

CREATE TABLE mleko_chleb AS
SELECT *
FROM czechia_price_category
WHERE name LIKE '%chleb%' OR name LIKE '%mleko%';

SELECT *
FROM mleko_chleb;

CREATE TABLE price_mleko_chleb AS
SELECT value as price
	  ,category_code as code
	  ,region_code
	  ,date_from 
	  ,date_to
	  ,name
	  ,price_value
	  ,price_unit
FROM czechia_price
INNER JOIN mleko_chleb
    ON czechia_price.category_code = mleko_chleb.code;

SELECT *
FROM price_mleko_chleb
ORDER BY date_FROM DESC;

-- 2)table mleko chleb avg price

SELECT AVG(price) as average_price
      ,code
      ,date_from 
      ,date_to
      ,name
      ,price_value
      ,price_unit
      ,YEAR(date_from) as year
FROM price_mleko_chleb
WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
GROUP BY year, name;

-- 

CREATE TABLE avg_price_mleko_chleb AS
SELECT AVG(CASE WHEN YEAR(date_from) BETWEEN 2006 AND 2018 THEN price ELSE NULL END) as average_price
      ,code
      ,date_from 
      ,date_to
      ,name
      ,price_value
      ,price_unit
      ,YEAR(date_from) as year
FROM price_mleko_chleb
GROUP BY year, name;

SELECT *
FROM avg_price_mleko_chleb;

-- 3) table avg payroll

CREATE TABLE avg_payroll AS
SELECT ROUND(AVG(value), 2) as average_payroll
      ,payroll_year
FROM czechia_payroll
GROUP BY payroll_year;

SELECT *
FROM avg_payroll
ORDER BY average_payroll DESC;

-- 4) table amount payroll

CREATE TABLE amount_payroll AS
SELECT average_price
      ,name
      ,price_value
      ,price_unit
      ,year as price_year
      ,average_payroll
      ,payroll_year
      ,ROUND(average_payroll / average_price, 1) as amount_payroll
FROM avg_price_mleko_chleb
LEFT JOIN avg_payroll
    ON avg_price_mleko_chleb.year = avg_payroll.payroll_year;

SELECT *
FROM amount_payroll
ORDER BY payroll_year DESC;
   
-- ------------------------------------------------------------------------------------------------------------------------------------  

/*
			Task 3
*/

SELECT *
FROM czechia_price;

SELECT *
FROM czechia_price_category;

SELECT DISTINCT category_code
FROM czechia_price;


SELECT value as price
	  ,category_code









CREATE TABLE avg_prices_category_code AS
SELECT AVG(value) as average_price
      ,category_code
      ,date_from 
      ,date_to
      ,YEAR(date_from) as year
FROM czechia_price
WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
GROUP BY year, category_code
ORDER BY year;

SELECT *
FROM avg_prices_category_code;

SELECT average_price
	  ,category_code
	  ,name
	  ,price_value
	  ,price_unit
	  ,year
FROM avg_prices_category_code
INNER JOIN czechia_price_category
ON avg_prices_category_code.category_code = czechia_price_category.code;
	  
CREATE TABLE year_year_percentage_increase AS
WITH avg_prices AS (
  SELECT AVG(value) as average_price
        ,category_code
        ,YEAR(date_from) as year
  FROM czechia_price
  WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
  GROUP BY year, category_code
)
SELECT A.year
      ,A.category_code
      ,A.average_price
      ,B.average_price as prev_year_average_price
      ,ROUND(((A.average_price - B.average_price) / B.average_price) * 100, 2) as percentage_increase
FROM avg_prices A
LEFT JOIN avg_prices B ON A.category_code = B.category_code AND A.year = B.year + 1
ORDER BY A.year, A.category_code;


SELECT *
FROM year_year_percentage_increase;


-- ------------------------------------------------------------------------------------------------------------------------------------  

/*
			Task 4
*/

CREATE TABLE avg_food_prices AS
SELECT ROUND(AVG(value), 2) as average_price
      ,YEAR(date_from) as price_year
FROM czechia_price
WHERE YEAR(date_from) BETWEEN 2006 AND 2018 AND YEAR(date_to) BETWEEN 2006 AND 2018
GROUP BY price_year
ORDER BY price_year;

CREATE TABLE avg_payroll_year AS
SELECT ROUND(AVG(value), 2) as average_payroll
      ,payroll_year
FROM czechia_payroll
WHERE payroll_year BETWEEN 2006 AND 2018
GROUP BY payroll_year
ORDER BY payroll_year;


CREATE TABLE avg_food_payroll_year AS
SELECT average_price
	  ,price_year
	  ,average_payroll
	  ,payroll_year
FROM avg_food_prices
INNER JOIN avg_payroll_year
    ON avg_food_prices.price_year = avg_payroll_year.payroll_year;

SELECT *
FROM avg_food_payroll_year;


CREATE TABLE year_year_avg_food_payroll_growth AS
SELECT 
     price_year as year
    ,average_price
    ,average_payroll
    ,((average_price - LAG(average_price) OVER (ORDER BY price_year)) / LAG(average_price) OVER (ORDER BY price_year)) * 100 as price_growth
    ,((average_payroll - LAG(average_payroll) OVER (ORDER BY payroll_year)) / LAG(average_payroll) OVER (ORDER BY payroll_year)) * 100 as payroll_growth
FROM avg_food_payroll_year;


SELECT *
FROM year_year_avg_food_payroll_growth;

CREATE TABLE annual_food_prices_growth AS
WITH growth AS (
    SELECT 
        price_year as year,
        average_price,
        average_payroll,
        ((average_price - LAG(average_price) OVER (ORDER BY price_year)) / LAG(average_price) OVER (ORDER BY price_year)) * 100 as price_growth,
        ((average_payroll - LAG(average_payroll) OVER (ORDER BY payroll_year)) / LAG(average_payroll) OVER (ORDER BY payroll_year)) * 100 as payroll_growth
    FROM avg_food_payroll_year
)
SELECT 
    year,
    average_price,
    average_payroll,
    price_growth,
    payroll_growth,
    (price_growth - payroll_growth) as difference_annual
FROM growth;

SELECT *
FROM annual_food_prices_growth;


-- ------------------------------------------------------------------------------------------------------------------------------------  

/*
			Task 5
*/

CREATE TABLE annual_gdp_growth AS
SELECT country
	  ,year
	  ,gdp
      ,((gdp - LAG(gdp) OVER (ORDER BY year)) / LAG(gdp) OVER (ORDER BY year)) * 100 as gdp_growth
FROM economies
WHERE country LIKE '%czech%'
AND year BETWEEN 2006 AND 2018;

SELECT *
FROM annual_gdp_growth;


SELECT annual_gdp_growth.year
	  ,gdp_growth
	  ,annual_food_prices_growth.price_growth
	  ,annual_food_prices_growth.payroll_growth
FROM annual_gdp_growth
LEFT JOIN annual_food_prices_growth
    ON annual_gdp_growth.year = annual_food_prices_growth.year;

-- ------------------------------------------------------------------------------------------------------------------------------------  
   
/*
			Dalsi evropske staty
*/
   
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
FROM economies
WHERE country LIKE '%germany%';














DROP TABLE difference_annual_food_prices_growth;

SELECT *
FROM czechia_payroll_industry_branch;

SELECT *
FROM czechia_payroll
ORDER BY value DESC;


