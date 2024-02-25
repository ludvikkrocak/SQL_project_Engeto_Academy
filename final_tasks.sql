

/*
			1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
*/


SELECT *
FROM avg_payroll_annual_growth_by_category;


/*
			2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
*/

CREATE TABLE milk_bread_amount AS
SELECT milk_bread_prices.year
	  ,milk_bread_prices.name
	  ,milk_bread_prices.average_price
	  ,milk_bread_prices.price_unit
	  ,avg_payroll_annual_growth.average_payroll
	  ,avg_payroll_annual_growth.average_payroll / milk_bread_prices.average_price AS amount_per_payroll
FROM (
    SELECT year
	  	  ,name
	  	  ,average_price
	  	  ,price_unit
    FROM prices_annual_growth_by_category
    WHERE name LIKE '%chleb%' OR name LIKE '%mleko%'
) AS milk_bread_prices
INNER JOIN avg_payroll_annual_growth
      ON milk_bread_prices.year = avg_payroll_annual_growth.year
GROUP BY name, year;

SELECT *
FROM milk_bread_amount
WHERE year LIKE '%2006%' OR year LIKE '%2018%';


/*
			3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
*/

WITH price_2006 AS (
	SELECT 
		category_code 
		,name
		,average_price AS price_2006
	FROM prices_annual_growth_by_category
	WHERE year = '2006'
),
price_2018 AS (
	SELECT 
		category_code
		,name
		,average_price AS price_2018
	FROM prices_annual_growth_by_category
	WHERE year = '2018'
)
SELECT 
	p18.category_code
	,p18.name
	,p18.price_2018
	,p06.price_2006
	,(p18.price_2018 - p06.price_2006) AS price_change
	,((p18.price_2018 - p06.price_2006) / p06.price_2006 * 100) AS percentage_change
FROM price_2018 p18
JOIN price_2006 p06 ON p18.category_code = p06.category_code
ORDER BY percentage_change;



/*
			4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
*/

SELECT *
FROM annual_price_payroll_growth
WHERE growth_difference > 10;


/*
			5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
*/


SELECT year
      ,price_growth
      ,avg_payroll_growth
      ,gdp_growth
FROM prices_payroll_gdp_grow
WHERE gdp_growth > (SELECT AVG(gdp_growth) + STDDEV(gdp_growth)
FROM prices_payroll_gdp_grow)
ORDER BY year;

SELECT p.year
      ,p.price_growth
      ,p.avg_payroll_growth
      ,p.gdp_growth
      ,p.next_year
      ,o.price_growth AS next_price_growth
      ,o.avg_payroll_growth AS next_avg_payroll_growth
FROM (
    SELECT year
          ,price_growth
          ,avg_payroll_growth
          ,gdp_growth
          ,year + 1 AS next_year
    FROM prices_payroll_gdp_grow
) AS p
INNER JOIN annual_price_payroll_growth AS o ON p.next_year = o.year
WHERE p.gdp_growth > (SELECT AVG(gdp_growth) + STDDEV(gdp_growth)
FROM prices_payroll_gdp_grow
)
ORDER BY p.year;


