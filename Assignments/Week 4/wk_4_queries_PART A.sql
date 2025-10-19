--Question 1
WITH yellow_first_cleanup AS
(
    SELECT *
    FROM yellow_2023
    WHERE (total_amount IS NOT NULL AND total_amount >0) AND (trip_distance IS NOT NULL AND trip_distance >0) AND (passenger_count IS NOT NULL AND passenger_count >0)
), 
yellow_second_cleanup AS
 (
    SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, 
    CASE WHEN UPPER(TRIM(store_and_fwd_flag)) IN ('Y','N') THEN UPPER(TRIM(store_and_fwd_flag))
    ELSE NULL
    END AS store_and_fwd_flag,
    ROUND(trip_distance,3) trip_distance,
    ROUND(total_amount,3) total_amount
    FROM yellow_first_cleanup
 ), 
 range_of_customers AS
 (
    SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, CASE
    WHEN passenger_count = 1 THEN 'Solo'
    WHEN passenger_count BETWEEN 2 AND 3 THEN 'Small Group'
    WHEN passenger_count BETWEEN 4 AND 6 THEN 'Medium Group'
    WHEN passenger_count > 6 THEN 'Large Group'
    END AS trip_size_label,
    trip_distance, total_amount, store_and_fwd_flag
    FROM yellow_second_cleanup
 )

--Main Query
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_size_label, trip_distance, total_amount, store_and_fwd_flag
FROM range_of_customers;

--Question 2
--Copy data to CSV
COPY (WITH yellow_first_cleanup AS
(
    SELECT *
    FROM yellow_2023
    WHERE (total_amount IS NOT NULL AND total_amount >0) AND (trip_distance IS NOT NULL AND trip_distance >0) AND (passenger_count IS NOT NULL AND passenger_count >0)
), 
yellow_second_cleanup AS
 (
    SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, 
    CASE WHEN UPPER(TRIM(store_and_fwd_flag)) IN ('Y','N') THEN UPPER(TRIM(store_and_fwd_flag))
    ELSE NULL
    END AS store_and_fwd_flag,
    ROUND(trip_distance,3) trip_distance,
    ROUND(total_amount,3) total_amount
    FROM yellow_first_cleanup
 ), 
 range_of_customers AS
 (
    SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, CASE
    WHEN passenger_count = 1 THEN 'Solo'
    WHEN passenger_count BETWEEN 2 AND 3 THEN 'Small Group'
    WHEN passenger_count BETWEEN 4 AND 6 THEN 'Medium Group'
    WHEN passenger_count > 6 THEN 'Large Group'
    END AS trip_size_label,
    trip_distance, total_amount, store_and_fwd_flag
    FROM yellow_second_cleanup
 )

--Main Query
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_size_label, trip_distance, total_amount, store_and_fwd_flag
FROM range_of_customers
--WHERE STRFTIME(tpep_pickup_datetime, '%Y') || '-Q' || DATE_PART('quarter', tpep_pickup_datetime) ='2023-Q1'
)

--Exporting data to a csv

TO 'cleaned_yellow_2023.csv' (HEADER, DELIMITER ',');

--Read data from CSV into a new table
DROP TABLE IF EXISTS cleaned_yellow_2023;

CREATE TABLE cleaned_yellow_2023 AS
SELECT * 
FROM read_csv('C:/Users/Antavio/Documents/Phoenix Analytics/SQL Training/duckdb/cleaned_yellow_2023.csv');

--Final Query
SELECT LPAD(EXTRACT(MONTH FROM tpep_pickup_datetime)::TEXT, 3, '0') AS month_number, MONTHNAME(tpep_pickup_datetime) month_name, SUM(total_amount) monthly_revenue,
LAG(monthly_revenue) OVER (ORDER BY month_number) previous_month_revenue
FROM cleaned_yellow_2023
GROUP BY 1,2
ORDER BY 1;

--Question 3
WITH vendor_monthly_revenue AS
(
   SELECT LPAD(EXTRACT(MONTH FROM tpep_pickup_datetime)::TEXT, 3, '0') AS month_number, MONTHNAME(tpep_pickup_datetime) month_name, VendorID,
   ROUND(SUM(total_amount),2) vendor_monthly_revenue
   FROM cleaned_yellow_2023
   GROUP BY 1,2,3
)
, totals AS (
   SELECT month_number, month_name, VendorID, vendor_monthly_revenue,
   ROUND(SUM(vendor_monthly_revenue) OVER (PARTITION BY month_number),2) AS total_monthly_revenue
   FROM vendor_monthly_revenue
)

SELECT month_number, month_name, VendorID, vendor_monthly_revenue,total_monthly_revenue,ROUND(vendor_monthly_revenue/total_monthly_revenue*100,2) AS vendor_percent
FROM totals
ORDER BY 1;