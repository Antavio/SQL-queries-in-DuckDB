--Question 1
WITH yellow_first_cleanup AS
(
    SELECT *
    FROM yellow_2023
    WHERE (total_amount IS NOT NULL AND total_amount >0) AND (trip_distance IS NOT NULL AND trip_distance >0) AND (passenger_count IS NOT NULL AND passenger_count >0)
), 
yellow_second_cleanup AS
 (
    SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, UPPER(TRIM(store_and_fwd_flag)) store_and_fwd_flag,
    ROUND(trip_distance,3) trip_distance,
    ROUND(total_amount,3) total_amount
    FROM yellow_first_cleanup
    --WHERE store_and_fwd_flag IS NOT NULL
 ), 
 range_of_customers AS
 (
    SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, CASE
    WHEN passenger_count = 1 THEN 'Solo'
    WHEN passenger_count BETWEEN 2 AND 3 THEN 'Small Group'
    WHEN passenger_count IN (4,6) THEN 'Medium Group'
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
    SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, UPPER(TRIM(store_and_fwd_flag)) store_and_fwd_flag,
    ROUND(trip_distance,3) trip_distance,
    ROUND(total_amount,3) total_amount
    FROM yellow_first_cleanup
 ), 
 range_of_customers AS
 (
    SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, CASE
    WHEN passenger_count = 1 THEN 'Solo'
    WHEN passenger_count BETWEEN 2 AND 3 THEN 'Small Group'
    WHEN passenger_count IN (4,6) THEN 'Medium Group'
    WHEN passenger_count > 6 THEN 'Large Group'
    END AS trip_size_label,
    trip_distance, total_amount, store_and_fwd_flag
    FROM yellow_second_cleanup
 )

--Main Query
SELECT VendorID, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_size_label, trip_distance, total_amount, store_and_fwd_flag
FROM range_of_customers)

--Exporting data to a csv

TO 'table cleaned_yellow_2023.csv' (HEADER, DELIMITER ',');

--Read data from CSV into a new table
DROP TABLE IF EXISTS cleaned_yellow_2023;

CREATE TABLE cleaned_yellow_2023 AS
SELECT * 
FROM read_csv('C:/Users/Antavio/Documents/Phoenix Analytics/SQL Training/duckdb/table cleaned_yellow_2023.csv');

--Final Query
SELECT LPAD(EXTRACT(MONTH FROM tpep_pickup_datetime)::TEXT, 3, '0') AS month_number, MONTHNAME(tpep_pickup_datetime) month_name, SUM(total_amount) monthly_revenue,
LAG(monthly_revenue) OVER (ORDER BY month_number) previous_month_revenue
FROM cleaned_yellow_2023
GROUP BY 1,2
ORDER BY 1;

--Question 3
SELECT LPAD(EXTRACT(MONTH FROM tpep_pickup_datetime)::TEXT, 3, '0') AS month_number, MONTHNAME(tpep_pickup_datetime) month_name, VendorID, 
ROUND(SUM(SUM(total_amount)) OVER(PARTITION BY VendorID),2) vendor_revenue, ROUND(SUM(total_amount),2) monthly_revenue, ROUND(vendor_revenue * 100/monthly_revenue,2) AS vendor_percentage
FROM cleaned_yellow_2023
GROUP BY 1,2,3
ORDER BY 1;