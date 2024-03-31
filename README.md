# SQL PROJEKT

## ZADÁNÍ

Úkolem je připravit datové podklady, ve kterých bude vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.

Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

Výstupem by měly být dvě tabulky v databázi, ze kterých se požadovaná data dají získat. Tabulky pojmenujte t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) a t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech).

Dále připravte sadu SQL, které z vámi připravených tabulek získají datový podklad k odpovězení na vytyčené výzkumné otázky. Pozor, otázky/hypotézy mohou vaše výstupy podporovat i vyvracet! Záleží na tom, co říkají data.

### Výzkumné otázky

1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

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

#### Dodatečné tabulky:

countries - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.

economies - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.

## POSTUP

1) Vycházel jsem ze zadaných datových sad: czechia_payroll, czechia_payroll_calculation, czechia_payroll_industry_branch
czechia_payroll_unit, czechia_payroll_value_type, czechia_price, czechia_price_category, czechia_region, czechia_district, countries, economies.

2) V scriptu project_tables.sql jsem připravil primární a sekundární tabulky, z kterých jsem vycházel při vypracovávání výzkumných otázek.

3) Scripty task1.sql, task2.sql, task3.sql, task4.sql, task5.sql obsahují vypracované výzkumné otázky.

## VÝSLEDKY

### 1) Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

Analýza dostupných dat ukázala, že v některých odvětvích došlo v jednotlivých letech k poklesu. Největší pokles byl zaznamenán v oblasti peněžnictví a pojišťovnictví v roce 2013 o 8,91 %.

Nejvyšší růst mezd byl zaznamenán v roce 2008 v odvětví těžba a dobývání o 13,8 %

Celkový průměr z meziročních nárůstů mezd je u všech odvětví kladný a pohybuje se mezi hodnotami 2.49 % (peněžnictví a pojišťovnictví) a 4.53 % (Zdravotní a sociální péče).

Ve čtyřech odvětvích nedošlo ve sledovaném období k žádnému meziročnímu poklesu mezd. Konkrétně: doprava a skladování, zdravotní a sociální péče, zpracovatelský průmysl, ostatní činnosti.

### 2) Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

V roce 2006 bylo za průměrnou mzdu koupit 1282,40 kg chleba a 1432,14 l mléka.

V roce 2018 bylo za průměrnou mzdu koupit 1340,23 kg chleba a 1639,21 l mléka.

K nejvýraznějšímu zdražení chleba vzhledem k průměrné mzdě došlo v roce 2011, kdy si spotřebitel mohl koupit o 13 % méně chleba za průměrnou mzdu oproti roku 2010.

K nejvýraznějšímu zlevnění chleba vzhledem k průměrné mzdě došlo v roce 2009, kdy si spotřebitel mohl koupit o 20,54 % více chleba za průměrnou mzdu oproti roku 2008.

K nejvýraznějšímu zdražení mléka vzhledem k průměrné mzdě došlo v roce 2011, kdy si spotřebitel mohl koupit o 7 % méně mléka za průměrnou mzdu oproti roku 2010.

K nejvýraznějšímu zlevnění mléka vzhledem k průměrné mzdě došlo v roce 2009, kdy si spotřebitel mohl koupit o 18,14 % více mléka za průměrnou mzdu oproti roku 2008.


### 3) Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

Ve sledovaném období mezi lety 2006 a 2018 nejpomaleji zdražovaly banány žluté u kterých průměrný percentuální meziroční nárůst ceny činil 0,81 %.

Nejrychleji zdražovaly Papriky u kterých průměrný percentuální meziroční nárůst ceny činil 7,29 %.

V dostupných datech jsem identifikoval dvě kategorie potravin které zlevňovaly. Konkrétně cukr krystalový u kterého průměrný percentuální meziroční pokles ceny činil 1,91 % a rajčata u kterých průměrný percentuální meziroční pokles ceny činil 0,74 %.

### 4) Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

Ve sledovaném období neexistuje žádný rok u kterého by byl meziroční nárůst cen potravin o 10 % vyšší než nárůst mezd. 

Nejvíce potraviny průměrně zdražovaly vůči průměrným mzdám o 7,04 % v roce 2013 a nejvíce zlevňovali o 9.97 % v roce 2009.

### 5) Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

Nejvíce HDP vzrostlo v roce 2007 o 5,57 % a mzdy ve stejném roce vzrostli o 6,86 %, ceny potravin vzrostli o 6,34. V roce 2008 mzdy vzrostli o 7,87 % a ceny potravin o 6,41 %.

Druhý nejvyšší růst HDP č byl v roce 2015 a činil 5,4 % a mzdy ve stejném roce vzrostli o 2,54 %, ceny potravin poklesly o 0,56 %. V roce 2016 mzdy vzrostli o 3,68 % a ceny potravin poklesly o 1,12 %.

Nejvíce HDP klesalo v roce 2012 o 0,78 % a mzdy ve stejném roce vzrostli o 3 %, ceny potravin vzrostli o 6,92 %. V roce 2013 mzdy poklesly o 1,49 % a ceny potravin vzrostli o 5,55 %.

Růst HDP má určitý vliv na velikost mezd a cen potravin, ale existuje mnoho dalších faktorů, které ovlivňují tyto hodnoty.

