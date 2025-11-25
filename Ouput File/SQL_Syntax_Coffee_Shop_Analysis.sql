SELECT
  *
FROM
  "BRIGHT_COFFEE_DB"."SALES_SCHEMA"."BRIGHT_SALES";
---------------------------------------------------------------------
--TRANSACTION_ID
--TRANSACTION_DATE
--TRANSACTION_TIME
--TRANSACTION_QTY
--STORE_ID
--STORE_LOCATION
--PRODUCT_ID
--Unit_Price
--Product_Category
--Product_Type
--Product_detail
--Time Bucket
--units by category
--Best Sellers

SELECT
    -- Date dimensions
    transaction_date,
    TO_CHAR(transaction_date, 'YYYYMM') AS month_id,
    TRIM(TO_CHAR(transaction_date, 'Mon')) AS month_name,
    DAYNAME(transaction_date) AS day_of_week,
    
    -- Time buckets (30-minute intervals)
    CASE
        WHEN transaction_time BETWEEN '06:00:00' AND '06:29:59' THEN '06:00-06:30'
        WHEN transaction_time BETWEEN '06:30:00' AND '06:59:59' THEN '06:30-07:00'
        WHEN transaction_time BETWEEN '07:00:00' AND '07:29:59' THEN '07:00-07:30'
        WHEN transaction_time BETWEEN '07:30:00' AND '07:59:59' THEN '07:30-08:00'
        WHEN transaction_time BETWEEN '08:00:00' AND '08:29:59' THEN '08:00-08:30'
        WHEN transaction_time BETWEEN '08:30:00' AND '08:59:59' THEN '08:30-09:00'
        WHEN transaction_time BETWEEN '09:00:00' AND '09:29:59' THEN '09:00-09:30'
        WHEN transaction_time BETWEEN '09:30:00' AND '09:59:59' THEN '09:30-10:00'
        WHEN transaction_time BETWEEN '10:00:00' AND '10:29:59' THEN '10:00-10:30'
        WHEN transaction_time BETWEEN '10:30:00' AND '10:59:59' THEN '10:30-11:00'
        WHEN transaction_time BETWEEN '11:00:00' AND '11:29:59' THEN '11:00-11:30'
        WHEN transaction_time BETWEEN '11:30:00' AND '11:59:59' THEN '11:30-12:00'
        WHEN transaction_time BETWEEN '12:00:00' AND '12:29:59' THEN '12:00-12:30'
        WHEN transaction_time BETWEEN '12:30:00' AND '12:59:59' THEN '12:30-13:00'
        WHEN transaction_time BETWEEN '13:00:00' AND '13:29:59' THEN '13:00-13:30'
        WHEN transaction_time BETWEEN '13:30:00' AND '13:59:59' THEN '13:30-14:00'
        WHEN transaction_time BETWEEN '14:00:00' AND '14:29:59' THEN '14:00-14:30'
        WHEN transaction_time BETWEEN '14:30:00' AND '14:59:59' THEN '14:30-15:00'
        WHEN transaction_time BETWEEN '15:00:00' AND '15:29:59' THEN '15:00-15:30'
        WHEN transaction_time BETWEEN '15:30:00' AND '15:59:59' THEN '15:30-16:00'
        WHEN transaction_time BETWEEN '16:00:00' AND '16:29:59' THEN '16:00-16:30'
        WHEN transaction_time BETWEEN '16:30:00' AND '16:59:59' THEN '16:30-17:00'
        WHEN transaction_time BETWEEN '17:00:00' AND '17:29:59' THEN '17:00-17:30'
        WHEN transaction_time BETWEEN '17:30:00' AND '17:59:59' THEN '17:30-18:00'
        WHEN transaction_time BETWEEN '18:00:00' AND '18:29:59' THEN '18:00-18:30'
        WHEN transaction_time BETWEEN '18:30:00' AND '18:59:59' THEN '18:30-19:00'
        WHEN transaction_time BETWEEN '19:00:00' AND '19:29:59' THEN '19:00-19:30'
        WHEN transaction_time BETWEEN '19:30:00' AND '19:59:59' THEN '19:30-20:00'
        ELSE '20:00+'
    END AS time_bucket_30min,
    
    -- Broader time buckets
    CASE
        WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
        ELSE 'Night'
    END AS day_part,
    
    -- Location
    store_location,
    
    -- Product dimensions
    product_category,
    product_type,
    product_detail,
    
    -- Metrics
    COUNT(DISTINCT transaction_id) AS number_of_transactions,
    SUM(transaction_qty) AS total_quantity_sold,
    ROUND(SUM(transaction_qty * REPLACE(unit_price, ',', '.')::FLOAT), 2) AS total_revenue,
    ROUND(AVG(REPLACE(unit_price, ',', '.')::FLOAT), 2) AS avg_unit_price,
    ROUND(AVG(transaction_qty), 2) AS avg_quantity_per_transaction

FROM "BRIGHT_COFFEE_DB"."SALES_SCHEMA"."BRIGHT_SALES"
GROUP BY 
    transaction_date,
    month_id,
    month_name,
    day_of_week,
    time_bucket_30min,
    day_part,
    store_location,
    product_category,
    product_type,
    product_detail
ORDER BY 
    transaction_date,
    time_bucket_30min;
