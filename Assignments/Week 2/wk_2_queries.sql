--PART A QUESTIONS
--Trips in January 2025
--Green Taxi
SELECT COUNT(*) AS jan_2025_trips_green
FROM green_quarter1_2025
WHERE STRFTIME('%Y-%m', lpep_dropoff_datetime) = '2025-01';



--Yellow Taxi
SELECT COUNT(*) AS jan_2025_trips_yellow
FROM yellow_quarter1_2025
WHERE STRFTIME('%Y-%m', tpep_dropoff_datetime) = '2025-01';

--Trips with NULL or zero passenger count--
--Green Taxi
SELECT COUNT(*) AS jan_2025_trips_green
FROM green_quarter1_2025
WHERE passenger_count IS NULL OR passenger_count=0;

--Yellow Taxi
SELECT COUNT(*) AS jan_2025_trips_yellow
FROM yellow_quarter1_2025
WHERE passenger_count IS NULL OR passenger_count=0;

--PART B QUESTIONS
--Question 1
--Green Taxi
SELECT DATE_TRUNC('DAY', lpep_pickup_datetime) AS tripDate, COUNT(*) AS no_of_trips
FROM green_quarter1_2025
GROUP BY tripDate
ORDER BY no_of_trips DESC
LIMIT 10;

--Yellow Taxi
SELECT DATE_TRUNC('DAY', tpep_pickup_datetime) AS tripDate, COUNT(*) AS no_of_trips
FROM yellow_quarter1_2025
GROUP BY tripDate
ORDER BY no_of_trips DESC
LIMIT 10;

--Question2
--With skewed results
--Green Taxi
SELECT DATE_TRUNC('MONTH', lpep_pickup_datetime) AS tripMonth, SUM(total_amount) AS total_revenue
FROM green_quarter1_2025
GROUP BY tripMonth
ORDER BY total_revenue DESC;

--Yellow Taxi
SELECT DATE_TRUNC('MONTH', tpep_pickup_datetime) AS tripMonth, SUM(total_amount) AS total_revenue
FROM yellow_quarter1_2025
GROUP BY tripMonth
ORDER BY total_revenue DESC;

-- Cleaned up results
--Green Taxi
SELECT DATE_TRUNC('MONTH', lpep_pickup_datetime) AS tripMonth, ROUND(SUM(total_amount),2) AS total_revenue
FROM green_quarter1_2025
WHERE STRFTIME('%Y-%m', lpep_pickup_datetime) IN ('2025-01','2025-02','2025-03')
GROUP BY tripMonth
ORDER BY total_revenue DESC;

--Yellow Taxi
SELECT DATE_TRUNC('MONTH', tpep_pickup_datetime) AS tripMonth, ROUND(SUM(total_amount),2) AS total_revenue
FROM yellow_quarter1_2025
WHERE STRFTIME('%Y-%m', tpep_pickup_datetime) IN ('2025-01','2025-02','2025-03')
GROUP BY tripMonth
ORDER BY total_revenue DESC;

--Question3
--Green Taxi
SELECT RPAD(STRFTIME('%H', lpep_pickup_datetime), 4 ,'0') || ' HRS' AS hour_label, COUNT(*) AS trips, ROUND(AVG(total_amount),2) AS avg_tip_rate
FROM green_quarter1_2025
GROUP BY hour_label
ORDER BY avg_tip_rate DESC;

--Yellow Taxi
SELECT RPAD(STRFTIME('%H', tpep_pickup_datetime), 4 ,'0') || ' HRS' AS hour_label, COUNT(*) AS trips, ROUND(AVG(tip_amount),2) AS avg_tip_rate
FROM yellow_quarter1_2025
WHERE total_amount > 0
GROUP BY hour_label
ORDER BY avg_tip_rate DESC;