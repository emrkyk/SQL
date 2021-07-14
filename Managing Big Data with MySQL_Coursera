# ---- "Managing Big Data with MySQL"  course on Coursera   ---- #


### Counts distinct dates in the database for each month in each year ===
SELECT EXTRACT(YEAR FROM saledate) AS Year_Num, EXTRACT(MONTH FROM saledate) AS Month_Num, 
       COUNT(DISTINCT saledate) AS Date_Count
FROM trnsact
GROUP BY Year_Num, Month_Num
ORDER BY Year_Num ASC, Month_Num ASC;


SELECT EXTRACT(YEAR FROM saledate) AS Year_Num, EXTRACT(MONTH FROM saledate) AS Month_Num, COUNT(DISTINCT saledate) AS Date_Count,
       CASE WHEN (Month_Num = 8 AND Year_Num = 2005) THEN 'Exclude'
       ELSE 'Include'
       END AS Exclusion
FROM trnsact
WHERE Exclusion = 'Include'
GROUP BY Year_Num, Month_Num
ORDER BY Year_Num ASC, Month_Num ASC;




SELECT TOP 10 SUM(CASE WHEN EXTRACT(MONTH from saledate) IN (6,7,8) THEN sprice 
                  END) AS sum_sprice, sku
FROM trnsact
WHERE stype = 'P'
GROUP BY sku
ORDER BY sum_sprice DESC;



### Finding the days with sale by store, year, month ---

SELECT store, EXTRACT(YEAR FROM saledate) AS Year_Num, EXTRACT(MONTH FROM saledate) AS Month_Num, 
       COUNT(DISTINCT saledate) AS days_with_sale
FROM trnsact
GROUP BY store, Year_Num, Month_Num
ORDER BY days_with_sale ASC;
/* Verified that there are few stores that had 1 day with a sale in a month,
   there were also few stores that had less than the total number of days in a month with a sale. */

### Calculating average daily revenue of the above ---

SELECT store, EXTRACT(YEAR FROM saledate) AS Year_Num, EXTRACT(MONTH FROM saledate) 
       AS Month_Num, COUNT(DISTINCT saledate) AS days_with_sale, 
       SUM(sprice)/COUNT(DISTINCT saledate) AS average_daily_revenue
FROM trnsact
WHERE stype = 'P'
GROUP BY store, Year_Num, Month_Num
ORDER BY average_daily_revenue DESC;




SELECT t.store AS t_store, EXTRACT(YEAR FROM t.saledate) AS Year_Num, EXTRACT(MONTH FROM t.saledate) 
       AS Month_Num, COUNT(DISTINCT t.saledate) AS days_with_sale, 
       SUM(t.sprice)/COUNT(DISTINCT t.saledate) AS average_daily_revenue,
       CASE WHEN (Month_Num = 8 AND Year_Num = 2005) THEN 'Exclude'
            WHEN days_with_sale < 20 THEN 'Exclude'
       ELSE 'Include'
       END AS Exclusion
FROM trnsact t
WHERE t.stype = 'P'
GROUP BY t_store, Year_Num, Month_Num
ORDER BY days_with_sale ASC;

   
SELECT t.store AS t_store, EXTRACT(YEAR FROM t.saledate) AS Year_Num, EXTRACT(MONTH FROM t.saledate) 
       AS Month_Num, COUNT(DISTINCT t.saledate) AS days_with_sale, 
       SUM(t.sprice)/COUNT(DISTINCT t.saledate) AS average_daily_revenue,
       CASE WHEN (Month_Num = 8 AND Year_Num = 2005) THEN 'Exclude'
            WHEN days_with_sale < 20 THEN 'Exclude'
       ELSE 'Include'
       END AS Exclusion
FROM trnsact t
WHERE t.stype = 'P'
GROUP BY t_store, Year_Num, Month_Num
HAVING Exclusion = 'Include'
ORDER BY days_with_sale ASC;



SELECT CASE WHEN msa_high >= 50 AND msa_high <= 60 THEN 'low'
               WHEN msa_high > 60 AND msa_high <= 70 THEN 'medium'
               WHEN msa_high > 70 THEN 'high' END AS hs_edu_level, store
FROM store_msa
ORDER BY msa_high ASC;


SELECT t.store AS t_store, EXTRACT(YEAR FROM t.saledate) AS Year_Num, EXTRACT(MONTH FROM t.saledate) 
       AS Month_Num, COUNT(DISTINCT t.saledate) AS days_with_sale, 
       SUM(t.sprice)/COUNT(DISTINCT t.saledate) AS average_daily_revenue,
       store_edu_level.hs_edu_level,
       CASE WHEN (Month_Num = 8 AND Year_Num = 2005) THEN 'Exclude'
            WHEN days_with_sale < 20 THEN 'Exclude'
       ELSE 'Include'
       END AS Exclusion
FROM trnsact t JOIN (SELECT CASE WHEN msa_high >= 50 AND msa_high <= 60 THEN 'low'
                     WHEN msa_high > 60 AND msa_high <= 70 THEN 'medium'
                     WHEN msa_high > 70 THEN 'high' END AS hs_edu_level, store
                     FROM store_msa) AS store_edu_level
                 ON t.store = store_edu_level.store
WHERE t.stype = 'P'
GROUP BY t_store, Year_Num, Month_Num, store_edu_level.hs_edu_level
HAVING Exclusion = 'Include'
ORDER BY days_with_sale ASC;


SELECT tbl.hs_edu_level, SUM(tbl.sum_sprice)/SUM(tbl.days_with_sale) AS avg_daily_revenue
FROM(SELECT t.store as t_store, EXTRACT(YEAR FROM t.saledate) AS Year_Num, EXTRACT(MONTH FROM t.saledate) 
             AS Month_Num, COUNT(DISTINCT t.saledate) AS days_with_sale, 
             SUM(t.sprice) AS sum_sprice,
             store_edu_level.hs_edu_level,
             CASE WHEN (Month_Num = 8 AND Year_Num = 2005) THEN 'Exclude'
                  WHEN days_with_sale < 20 THEN 'Exclude'
             ELSE 'Include'
             END AS Exclusion
      FROM trnsact t JOIN (SELECT CASE WHEN msa_high >= 50 AND msa_high <= 60 THEN 'low'
                           WHEN msa_high > 60 AND msa_high <= 70 THEN 'medium'
                           WHEN msa_high > 70 THEN 'high' END AS hs_edu_level, store
                           FROM store_msa) AS store_edu_level
                       ON t.store = store_edu_level.store
      WHERE t.stype = 'P'
      GROUP BY t_store, Year_Num, Month_Num, store_edu_level.hs_edu_level
      HAVING Exclusion = 'Include') AS tbl
GROUP BY hs_edu_level;



SELECT tbl.msa_income, SUM(tbl.sum_sprice)/SUM(tbl.days_with_sale) AS avg_daily_revenue
      FROM(SELECT t.store as t_store, EXTRACT(YEAR FROM t.saledate) AS Year_Num, EXTRACT(MONTH FROM t.saledate) 
                   AS Month_Num, COUNT(DISTINCT t.saledate) AS days_with_sale, 
                   SUM(t.sprice) AS sum_sprice,
                   Top_Income_Stores.msa_income,
                   CASE WHEN (Month_Num = 8 AND Year_Num = 2005) THEN 'Exclude'
                        WHEN days_with_sale < 20 THEN 'Exclude'
                   ELSE 'Include'
                   END AS Exclusion
            FROM trnsact t JOIN (SELECT store, msa_income 
                           FROM store_msa
                           ) AS Top_Income_Stores
                       ON t.store = Top_Income_Stores.store
      WHERE t.stype = 'P'
      GROUP BY t_store, Year_Num, Month_Num, Top_Income_Stores.msa_income
      HAVING Exclusion = 'Include') AS tbl
GROUP BY msa_income
ORDER BY msa_income DESC;

### Finding the brand of SKU with greatest standard deviation of sale price excluding SKUs with <100 transactions

SELECT Top_10_sku.sku, i.brand, Top_10_sku.stddev_sprice, Top_10_sku.num
FROM (SELECT TOP 10 sku, STDDEV_SAMP(sprice) AS stddev_sprice,
      COUNT(*) AS num
      FROM trnsact
      WHERE stype = 'P'
      GROUP BY sku
      HAVING num > 100
      ORDER BY stddev_sprice DESC) AS Top_10_sku
JOIN skuinfo i
  ON Top_10_sku.sku = i.sku
ORDER BY Top_10_sku.stddev_sprice DESC;
# OUTPUT
# sku,     brand,   stddev, num
# 2762683, HART SCH, 175.8, 106

SELECT *
FROM trnsact
WHERE sku = 2762683
ORDER BY sprice DESC;

SELECT *
FROM skuinfo
WHERE sku = 2762683;



SELECT filtered_data.Year_Num, filtered_data.Month_Num, 
       SUM(filtered_data.days_with_sale) AS sum_sale_days,
       SUM(filtered_data.sum_daily_revenue) AS total_daily_revenue,
       total_daily_revenue/sum_sale_days AS avg_daily_revenue_by_store
FROM (SELECT t.store AS t_store, EXTRACT(YEAR FROM t.saledate) AS Year_Num, 
             EXTRACT(MONTH FROM t.saledate) 
             AS Month_Num, COUNT(DISTINCT t.saledate) AS days_with_sale, 
             SUM(t.sprice) AS sum_daily_revenue,
             CASE WHEN (Month_Num = 8 AND Year_Num = 2005) THEN 'Exclude'
                  WHEN days_with_sale < 20 THEN 'Exclude'
             ELSE 'Include'
             END AS Exclusion
      FROM trnsact t
      WHERE t.stype = 'P'
      GROUP BY t_store, Year_Num, Month_Num
      HAVING Exclusion = 'Include') AS filtered_data
GROUP BY Year_Num, Month_Num
ORDER BY avg_daily_revenue_by_store DESC;

### Which department, in which city and state of what store, had the greatest percentage of increase in average daily sales revenue from November to December?
   
SELECT store, city, state, deptdesc, 
       COUNT(DISTINCT saledate) AS days_with_sale,
       SUM(CASE WHEN Month_Num = 11 THEN sprice END) AS Nov_Sales,
       SUM(CASE WHEN Month_Num = 12 THEN sprice END) AS Dec_Sales,
       ((Dec_Sales - Nov_Sales) / Nov_Sales) * 100 AS Pct_Change
FROM (SELECT s.sku, d.deptdesc
      FROM deptinfo d JOIN skuinfo s
        ON s.dept = d.dept) AS dept_sku JOIN 
     (SELECT t.store, s.city, s.state, t.sku, t.sprice, t.saledate, 
             EXTRACT(YEAR FROM t.saledate) AS Year_Num, 
             EXTRACT(MONTH FROM t.saledate) AS Month_Num, 
             CASE WHEN (Month_Num NOT IN (11,12)) THEN 'Exclude'
             ELSE 'Include'
             END AS Exclusion
      FROM trnsact t JOIN strinfo s
        ON s.store = t.store
      WHERE t.stype = 'P' AND Exclusion = 'Include') AS trnsact_store 
  ON dept_sku.sku = trnsact_store.sku
GROUP BY store, city, state, deptdesc
HAVING Nov_Sales IS NOT NULL AND Dec_Sales IS NOT NULL AND days_with_sale > 20 --Tweak to adjust exclusion of bad data
ORDER BY pct_change DESC;

### What is the city and state of the store that had the greatest decrease in  average daily revenue from August to September? */

SELECT store, city, state, 
       COUNT(DISTINCT saledate) AS days_with_sale,
       SUM(CASE WHEN Month_Num = 8 THEN sprice END) AS Aug_Sales,
       SUM(CASE WHEN Month_Num = 9 THEN sprice END) AS Sep_Sales,
       ((Sep_Sales - Aug_Sales) / Aug_Sales) * 100 AS Pct_Change
FROM (SELECT t.store, s.city, s.state, t.sku, t.sprice, t.saledate, 
             EXTRACT(YEAR FROM t.saledate) AS Year_Num, 
             EXTRACT(MONTH FROM t.saledate) AS Month_Num, 
             CASE WHEN (Month_Num NOT IN (8,9)) THEN 'Exclude'
             ELSE 'Include'
             END AS Exclusion
      FROM trnsact t JOIN strinfo s
        ON s.store = t.store
      WHERE t.stype = 'P' AND Exclusion = 'Include') AS trnsact_store 
GROUP BY store, city, state
HAVING Aug_Sales IS NOT NULL AND Sep_Sales IS NOT NULL AND days_with_sale > 20 --Tweak to adjust exclusion of bad data
ORDER BY pct_change ASC;

### Extracting the month with the greatest revenue

SELECT t.store AS t_store, EXTRACT(YEAR FROM t.saledate) AS Year_Num, 
       EXTRACT(MONTH FROM t.saledate) AS Month_Num, 
       COUNT(DISTINCT t.saledate) AS days_with_sale, 
       SUM(t.sprice)/COUNT(DISTINCT t.saledate) AS average_daily_revenue,
       RANK() OVER (PARTITION BY t_store ORDER BY average_daily_revenue DESC) AS Month_Ranking,
       CASE WHEN (Month_Num = 8 AND Year_Num = 2005) THEN 'Exclude'
            WHEN days_with_sale < 20 THEN 'Exclude'
       ELSE 'Include'
       END AS Exclusion
QUALIFY Month_Ranking = 1
FROM trnsact t
WHERE t.stype = 'P'
GROUP BY t_store, Year_Num, Month_Num
HAVING Exclusion = 'Include'
ORDER BY Month_Ranking ASC;

### Calculating the total number of stores had their lowest sales in each month

SELECT month_num, count(*) AS num_stores, SUM(total_revenue)/SUM(days_with_sale), SUM(total_revenue)
FROM (SELECT t.store AS t_store, EXTRACT(YEAR FROM t.saledate) AS Year_Num, 
             EXTRACT(MONTH FROM t.saledate) AS Month_Num, 
             COUNT(DISTINCT t.saledate) AS days_with_sale, 
             SUM(t.sprice)/days_with_sale AS avg_daily_revenue,
             SUM(t.sprice) AS total_revenue,
             RANK() OVER (PARTITION BY t_store ORDER BY total_revenue ASC) 
             AS Month_Ranking,
             CASE WHEN (Month_Num = 8 AND Year_Num = 2005) THEN 'Exclude'
                  WHEN days_with_sale < 20 THEN 'Exclude'
             ELSE 'Include'
             END AS Exclusion
      QUALIFY Month_Ranking = 1
      FROM trnsact t
      WHERE t.stype = 'P'
      GROUP BY t_store, Year_Num, Month_Num
      HAVING Exclusion = 'Include'
      ) AS month_of_max_sum_revenue
GROUP BY month_num
ORDER BY month_num ASC;


### Counts of Distinct sku in skuinfo, skstinfo, trnsact 

SELECT COUNT(DISTINCT sku)
FROM skuinfo;
...1564178 ... {also note that there are no duplicate sku in this table becasue
                count(sku) provides the same 1564178}

SELECT COUNT(DISTINCT sku)
FROM skstinfo;
...760212

SELECT COUNT(DISTINCT sku)
FROM trnsact;
...714499

### Counts of Distinct sku in table pairs using inner joins === skuinfo/skstinfo, skuinfo/trnsact, skstinfo/trnsact ===

SELECT COUNT(DISTINCT si.sku)
FROM skuinfo si LEFT JOIN trnsact t
  ON si.sku = t.sku
WHERE t.sku IS NULL;
...849679


### Identify whether store + sku pair is unique in trnsact or skstinfo table ===

SELECT store, sku, COUNT(*) AS Total_Instances
FROM trnsact
GROUP BY store, sku
ORDER BY Total_Instances DESC;
...36099491 rows; Total_Instances >> 1 for many

SELECT store, sku, COUNT(*) AS Total_Instances
FROM skstinfo
GROUP BY store, sku
ORDER BY Total_Instances DESC;
...36099491 rows; Total_Instances = 1 for all


### Count distinct stores from strinfo, store_msa, skstinfo, trnsact tables 

SELECT COUNT(DISTINCT store)
FROM strinfo;
...453

SELECT COUNT(DISTINCT store)
FROM store_msa;
...333

SELECT COUNT(DISTINCT store)
FROM skstinfo;
...357

SELECT COUNT(DISTINCT store)
FROM trnsact;
...332

### Finding common features in table produced when outer joining skstinfo and trnsact When an sku is in trnsact but not in skstinfo

SELECT *
FROM skstinfo r RIGHT JOIN trnsact t
  ON t.sku = r.sku AND t.store = r.store
WHERE r.sku IS NULL;
