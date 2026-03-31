SELECT --Dates
transaction_date,
Dayname(transaction_date) AS Day_name,
Monthname(transaction_date) AS Month_name,
Dayofmonth(transaction_date) AS Day_of_Month,
date_format(transaction_time,'HH:mm:ss') AS Purchase_time,

---Day specification according to weekday or weekend
CASE WHEN Day_name IN ('Sat','Sun') THEN 'Weekend'
ELSE 'Weekday'
END AS Day_specification,

---Transaction Time buckets according to the time of the day
CASE WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '22:00:00' AND '05:59:59' THEN '01. Night'
     WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN '02. Morning'
     WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN '03. Afternoon'
     WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '18:00:00' AND '21:59:59' THEN '04. Evening'
     END AS Time_buckets,

     ----Spend buckets according to client spend
     CASE WHEN (transaction_qty*unit_price) <= 5 THEN '01. Low'
          WHEN (transaction_qty*unit_price) BETWEEN 6 AND 10 THEN '02. Medium'
          WHEN (transaction_qty*unit_price) BETWEEN 11 AND 20 THEN '03. High'
          WHEN (transaction_qty*unit_price) BETWEEN 21 AND 30 THEN '04. Very High '
          END AS Spend_buckets,
       

--
--Cound of the IDs
      COUNT(DISTINCT transaction_id) AS Number_Of_Sales,
      COUNT (DISTINCT product_id) AS Number_of_Products,
      COUNT(DISTINCT store_id) AS Number_of_Stores,
-- Revenue     
      SUM(transaction_qty*unit_price) AS Revenue_per_day,
-- Categorical columns
store_location,
product_category,
product_detail

FROM workspace.default.bright_coffee_shop_analysis_case_study_1
GROUP BY transaction_date,
Day_name,
Month_name,
Day_of_Month,
store_location,
product_category,
product_detail,
Purchase_time,
Time_buckets,
Spend_buckets;
