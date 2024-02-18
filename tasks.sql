--			Research questions

/*
			1) Do wages increase over the years in all sectors, or do they decrease in some?
*/

SELECT *
FROM avg_wages_annual_growth_by_category;

SELECT *
FROM avg_wages_annual_growth_by_category
WHERE category_payroll_growth < 0;

SELECT industry_branch_code
      ,name
      ,AVG(category_payroll_growth) as avg_over_years_payroll_growth
FROM avg_wages_annual_growth_by_category
GROUP BY industry_branch_code, name;


-- 

/*
			2) How many liters of milk and kilograms of bread can be bought for the first and last comparable period in the available price and wage data?
*/

CREATE TABLE milk_bread_amount AS
SELECT milk_bread_prices.year
	  ,milk_bread_prices.name
	  ,milk_bread_prices.average_price
	  ,milk_bread_prices.price_unit
	  ,avg_wages_annual_growth_by_category.category_avg_payroll
	  ,avg_wages_annual_growth_by_category.category_avg_payroll / milk_bread_prices.average_price AS amount_per_wage
FROM (
    SELECT year
	  	  ,name
	  	  ,average_price
	  	  ,price_unit
    FROM prices_annual_growth_by_category
    WHERE name LIKE '%chleb%' OR name LIKE '%mleko%'
) AS milk_bread_prices
INNER JOIN avg_wages_annual_growth_by_category
      ON milk_bread_prices.year = avg_wages_annual_growth_by_category.year
GROUP BY name, year;

SELECT *
FROM milk_bread_amount
WHERE year LIKE '%2006%' OR year LIKE '%2018%'

/*
			3) Which category of food is getting more expensive the slowest (has the lowest percentage year-on-year increase)?
*/

SELECT *
FROM prices_annual_growth_by_category;

SELECT category_code
      ,name
      ,AVG(price_growth) as avg_over_years_growth
FROM prices_annual_growth_by_category
GROUP BY category_code, name
ORDER BY avg_over_years_growth;




/*
			4) Is there a year in which the year-on-year increase in food prices was significantly higher than wage growth (greater than 10%)?
*/


CREATE TABLE annual_price_wages_growth AS
SELECT prices_annual_growth.year
      ,average_price
      ,price_growth
      ,average_payroll
      ,avg_payroll_growth
      ,(price_growth - avg_payroll_growth) as growth_difference
FROM prices_annual_growth
INNER JOIN avg_wages_annual_growth
ON prices_annual_growth.year = avg_wages_annual_growth.year
GROUP BY year;

SELECT *
FROM annual_price_wages_growth;


CREATE TABLE difference_annual_price_wages_growth AS
SELECT year
      ,average_price
      ,price_growth
      ,average_payroll
      ,avg_payroll_growth
      ,growth_difference
FROM (
  SELECT prices_annual_growth.year
        ,average_price
        ,price_growth
        ,average_payroll
        ,avg_payroll_growth
        ,(price_growth - avg_payroll_growth) as growth_difference
  FROM prices_annual_growth
  INNER JOIN avg_wages_annual_growth
  ON prices_annual_growth.year = avg_wages_annual_growth.year
) subquery
WHERE growth_difference > 10;

SELECT *
FROM difference_annual_price_wages_growth;

-- DROP TABLE annual_price_wages_growth;

/*
			5) Does the level of GDP affect changes in wages and food prices? In other words, if the GDP increases significantly in one year, will it be reflected in food prices or wages in the same or following year with a more significant increase?
*/

CREATE TABLE prices_wages_gdp_grow AS
SELECT annual_price_wages_growth.year
      ,price_growth
      ,avg_payroll_growth
      ,gdp_growth
FROM annual_price_wages_growth
INNER JOIN cz_gdp_annual_growth
ON annual_price_wages_growth.year = cz_gdp_annual_growth.year
GROUP BY year;

SELECT *
FROM prices_wages_gdp_grow;

SELECT year
      ,price_growth
      ,avg_payroll_growth
      ,gdp_growth
FROM prices_wages_gdp_grow
WHERE gdp_growth > (SELECT AVG(gdp_growth) + STDDEV(gdp_growth) FROM prices_wages_gdp_grow)
ORDER BY year;


