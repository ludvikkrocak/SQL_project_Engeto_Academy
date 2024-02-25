# SQL PROJEKT

## ZADÁNÍ

Úkolem je připravit datové podklady, ve kterých bude vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.

Jako dodatečný materiál jsem připravil i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

### Výzkumné otázky

1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na 6)cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

Dále jsem připravil dvě tabulky, ze kterých se požadovaná data dají získat.
t_ludvik_krocak_project_SQL_primary_final
t_ludvik_krocak_project_SQL_secondary_final

## ANALÝZA

### Zadané tabulky

czechia_payroll – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.

czechia_payroll_calculation – Číselník kalkulací v tabulce mezd.

czechia_payroll_industry_branch – Číselník odvětví v tabulce mezd.

czechia_payroll_unit – Číselník jednotek hodnot v tabulce mezd.

czechia_payroll_value_type – Číselník typů hodnot v tabulce mezd.

czechia_price – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.

czechia_price_category – Číselník kategorií potravin, které se vyskytují v našem přehledu.

Číselníky sdílených informací o ČR:

czechia_region – Číselník krajů České republiky dle normy CZ-NUTS 2.

czechia_district – Číselník okresů České republiky dle normy LAU.

Dodatečné tabulky:

countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.

economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.

### Vytvořené tabulky

SELECT *
FROM avg_payroll_annual_growth;

- obsahuje průměrné mzdy a percentuální meziroční nárůst průměrných mezd od roku 2000 do roku 2021.

SELECT *
FROM avg_payroll_annual_growth_by_category;

- obsahuje kódy a názvy průmyslových odvětví, průměrné mzdy a percentuální meziroční nárůst průměrných mezd každé kategorie od roku 2000 do roku 2021.

SELECT *
FROM prices_annual_growth;

- obsahuje průměrné ceny potravin a percentuální nárůst průměrných cen od roku 2006 do roku 2018.

SELECT *
FROM prices_annual_growth_by_category;

- obsahuje kódy a názvy jednotlivých kategorií potravin, jejich průměrné ceny a percentuální nárůst průměrných cen od roku 2006 do roku 2018.

SELECT *
FROM annual_price_payroll_growth;

- obsahuje průměrné ceny a percentuální meziroční nárůst průměrných cen potravin, průměrné mzdy, percentuální meziroční nárůst průměrných mezd a rozdíl mezi percentuálním meziročním nárůstem mezd a cen. Data o cenách potravin a mzdách jsem sjednotil na srovnatelné období od roku 2006 do roku 2018.

SELECT *
FROM cz_gdp_annual_growth;

- obsahuje HDP a percentuální meziroční nárůst HDP České republiky od roku 2006 do roku 2018.

SELECT *
FROM prices_payroll_gdp_grow;

- obsahuje percentuální meziroční nárůst průměrných cen potravin, percentuální meziroční nárůst průměrných mezd a percentuální meziroční nárůst HDP v letech 2006 až 2018.

SELECT *
FROM europe_economies;

- obsahuje HDP, GINI koeficient a populaci dalších evropských států od roku 2006 do roku 2018.

t_ludvik_krocak_project_SQL_primary_final

- obsauje veškerá data, která jsou potřeba pro zodpovězení výzkumných otázek.

t_ludvik_krocak_project_SQL_secondary_final

- obsahuje dodatečná data o dalších evropských státech.

## POSTUP

1) Vycházel jsem ze zadaných datových sad: czechia_payroll, czechia_payroll_calculation, czechia_payroll_industry_branch
czechia_payroll_unit, czechia_payroll_value_type, czechia_price, czechia_price_category, czechia_region, czechia_district, countries, economies

2) V scriptu base_tables.sql jsem si pripravil tabulky, které obsahují vsechny sloupce a data, která potřebuji pro zodpovězení výzkumných otázek.

3) Dále v scriptu final_script.sql jsem pospojováním připravených tabulek vytvořil dva datasety, které obsaují všechna potřebná data pro zodpovězení výzkumných otázek.

4) V scriptu final_tasks.sql jsem si dotazováním na připravené tabulky vytáhnul potřebné informace pro zodpovězení každé otázky.

## VÝSLEDKY

### 1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Analýza dostupných dat v období mezi roky 2006 a 2018 ukázala, že v každé kategorii existují roky, kdy mzdy rostou, a roky, kdy mzdy klesají. Po zprůměrování meziročních nárůstů mezd každé kategorie ve sledovaném období jsem zjistil, že průměr z meziročních nárůstů je pro každou kategorii kladný a pohybuje se mezi hodnotamy 3,36 % ve stavebnictví a 7,95 % v oboru výroby a rozvodů elektřiny, plynu, topení a klimatizací. Druhý nejvyšší průměr z meziročních nárůstů mezd byl ve sledovaném období 7,76 % v oboru zdravotních a sociálních služeb.

### 2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

V roce 2006 průměrná mzda činila 19035 Kč a bylo možné si za tuto mzdu koupit 1180,56 kg chleba nebo 1318,43 litrů mléka.
V roce 2018 průměrná mzda činila 29803 Kč a bylo možné si za tuto mzdu koupit 1229,58 kg chleba nebo 1503,88 litrů mléka.

### 3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

Na základě meziročního porovnání průměrných cen jednotlivých kategorií potravin jsem zjistil, že nejpomaleji zdražuje (přesněji - nejrychleji zlevňuje) za sledované období v letech 2006 až 2018 cukr krystalový. Průměrná cena cukru mezi těmito roky klesla o 6 Kč z 21,8 Kč/kg na 15,75 Kč/kg. Průměrná cena cukru krystal klesla o 27,5 % a má tedy nejmenší percentuální nárůst mezi kategoriemi potravin v dostupných datech.

Mezi potravinami, které zdražovaly mají nejmenší meziroční percentuální nárůst ceny banány žluté, které za sledované období zdražily o 2 Kč z průměrné ceny 27,3 Kč/kg v roce 2006 na 29,3 Kč/kg v roce 2018, což je změna o 7,38%.


### 4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

V rámci analýzy jsem identifikoval 2 roky, kdy byl nárůst cen potravin o 10% vyšší než růst mezd. Konkrétně v roce 2013 ceny potravin vzrostly 5.55%, zatímco mzdy poklesly o 6.71% a v roce 2018 ceny potravin vzrostly o 9,98 %, zatímco mzdy poklesly o 1,63 %.

### 5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

V dostupných datech jsem identifikoval 3 roky, kdy růst HDP vyšší než průměrný růst HDP + 1 standardní odchylka, což může signalizovat výraznější růst HDP. Růst HDP má částečný vliv na ceny potravin a velikost mezd, ale tyto hodnoty jsou ovlivněny i mnoha dalšími faktory (např. inflace, nezaměstanost, nabídka a poptávka a další...).
V roce 2007 byl růst HDP 5.57%, růst cen potravin 6.34%, růst mezd 6.15%.
V roce 2015 HDP vzrostlo o 5.39% a došlo k poklesu cen potravin o 0.56%, mzdy vzrostly o 0.69%.
V roce 2017 HDP vzrostlo o 5.17% a ceny potravin vzrostly o 9.98%, mzdy klesly o -1.63%.

Roky následující:
V roce 2008 rostly ceny potravin 6.40%, růst mezd 7.16%.
V roce 2016 a došlo k poklesu cen potravin o -1.12%, mzdy vzrostly o 8.77%.
V roce 2018 rostly ceny potravin o 1.94%, mzdy vzrostly o 12.75%.
