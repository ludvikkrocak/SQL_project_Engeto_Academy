
-- tbl_avg_payroll_annual_growth_by_category

(SELECT *
	FROM tbl_avg_payroll_annual_growth_by_category
WHERE category_avg_payroll = (SELECT MIN(category_avg_payroll) 
	FROM tbl_avg_payroll_annual_growth_by_category))
UNION
(SELECT *
	FROM tbl_avg_payroll_annual_growth_by_category
WHERE category_avg_payroll = (SELECT MAX(category_avg_payroll) 
FROM tbl_avg_payroll_annual_growth_by_category));


(SELECT *
	FROM tbl_avg_payroll_annual_growth_by_category
WHERE category_payroll_growth = (SELECT MIN(category_payroll_growth) 
	FROM tbl_avg_payroll_annual_growth_by_category))
UNION
(SELECT *
	FROM tbl_avg_payroll_annual_growth_by_category
WHERE category_payroll_growth = (SELECT MAX(category_payroll_growth) 
	FROM tbl_avg_payroll_annual_growth_by_category));


-- tbl_prices_annual_growth_by_category

(SELECT *
	FROM tbl_prices_annual_growth_by_category
WHERE price_growth = (SELECT MIN(price_growth) 
	FROM tbl_prices_annual_growth_by_category))
UNION
(SELECT *
	FROM tbl_prices_annual_growth_by_category
WHERE price_growth = (SELECT MAX(price_growth) 
FROM tbl_prices_annual_growth_by_category));

-- tbl_annual_price_payroll_growth

SELECT *
FROM tbl_annual_price_payroll_growth
WHERE growth_difference_prl_prc > 10;

-- tbl_cz_gdp_annual_growth

SELECT
    year
    ,country
    ,gdp
    ,((gdp - LAG(gdp) OVER (ORDER BY year)) / LAG(gdp) OVER (ORDER BY year)) * 100 AS gdp_growth_2006_2018
FROM tbl_cz_gdp_annual_growth
WHERE year = 2006 OR year = 2018;

-- tbl_prices_payroll_gdp_grow

SELECT
     gdp
    ,average_price
    ,((gdp - LAG(gdp) OVER (ORDER BY year)) / LAG(gdp) OVER (ORDER BY year)) * 100 AS gdp_growth_2006_2018
    ,((average_price - LAG(average_price) OVER (ORDER BY year)) / LAG(average_price) OVER (ORDER BY year)) * 100 AS price_growth_2006_2018
FROM tbl_prices_payroll_gdp_grow
WHERE year = 2006 OR year = 2018;

-- tbl_europe_economies

SELECT
     country
    ,year
    ,gini
    ,population 
    ,((gdp - LAG(gdp) OVER (ORDER BY year)) / LAG(gdp) OVER (ORDER BY year)) * 100 AS gdp_growth_2006_2018
    ,((gini - LAG(gini) OVER (ORDER BY year)) / LAG(gini) OVER (ORDER BY year)) * 100 AS gini_growth_2006_2018
    ,((population - LAG(population) OVER (ORDER BY year)) / LAG(population) OVER (ORDER BY year)) * 100 AS population_growth_2006_2018
FROM tbl_europe_economies
WHERE (year = 2006 OR year = 2018) AND country = 'Czech Republic';



