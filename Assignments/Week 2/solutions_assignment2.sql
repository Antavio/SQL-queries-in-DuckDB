--Return 10 Sample rows
SELECT tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count, trip_distance, total_amount
FROM yellow_quarter1_2025
ORDER BY trip_distance DESC
LIMIT 10;

--Count of January Trips
SELECT COUNT(*) AS jan_trips
FROM yellow_quarter1_2025
WHERE tpep_pickup_datetime >= '2025-01-01 00:00:00' AND tpep_dropoff_datetime < '2025-01-31 23:59:59';

--Data Quality check for trips with NULL or 0 in passenger_count field
--In rows
SELECT  tpep_pickup_datetime, passenger_count AS invalid_passenger_count_trips
FROM yellow_quarter1_2025
WHERE passenger_count IS NULL OR passenger_count = 0;
--Count of instances
SELECT COUNT(*) AS invalid_passenger_count_trips
FROM yellow_quarter1_2025
WHERE passenger_count IS NULL OR passenger_count = 0;

--Busiest 10 days across the quater
SELECT DATE_TRUNC('day', tpep_pickup_datetime) AS trip_day, COUNT(*) AS trips
FROM yellow_quarter1_2025
GROUP BY trip_day
ORDER BY trips DESC
LIMIT 10;

--Rank monthly revenue perf
SELECT DATE_PART('month', tpep_pickup_datetime) AS month, SUM(total_amount) AS total_revenue
FROM yellow_quarter1_2025
GROUP BY month
ORDER BY total_revenue DESC;

--Working hours with the best tips
SELECT CONCAT(LPAD(EXTRACT(HOUR FROM tpep_dropoff_datetime)::VARCHAR, 2, '0'), '00 HRS') AS hour_label,
       COUNT(*) AS trips,
       AVG(tip_amount) AS avg_tip_amount
FROM yellow_quarter1_2025
WHERE total_amount > 0
GROUP BY hour_label
ORDER BY avg_tip_amount DESC;
