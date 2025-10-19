--ASSIGNMENT 3B--
--Question 1--
--Green Taxi--
SELECT t.Borough, ROUND(SUM(total_amount),2) AS total_revenue
FROM green_2023 g 
JOIN taxi_lookup t
ON g.DOLocationID = t.LocationID
GROUP BY t.Borough
ORDER BY total_revenue DESC;

--Yellow Taxi--
SELECT t.Borough, ROUND(SUM(total_amount),2) AS total_revenue
FROM yellow_2023 g 
JOIN taxi_lookup t
ON g.PULocationID = t.LocationID
GROUP BY t.Borough
ORDER BY total_revenue DESC;

--Question 2--
--Green Taxi--
SELECT t.Zone, COUNT(*) AS no_of_trips
FROM green_2023 g 
JOIN taxi_lookup t
ON g.DOLocationID = t.LocationID
GROUP BY t.Zone
ORDER BY no_of_trips DESC
LIMIT 5;

--Yellow Taxi--
SELECT t.Zone, COUNT(*) AS no_of_trips
FROM yellow_2023 y 
JOIN taxi_lookup t
ON y.DOLocationID = t.LocationID
GROUP BY t.Zone
ORDER BY no_of_trips DESC
LIMIT 5;

--Question 3--
--Green Taxi--
SELECT
CASE
WHEN payment_type = 1 THEN 'Credit card'
WHEN payment_type = 2 THEN 'Cash'
ELSE 'Other'
END AS payment_method, COUNT(*) AS no_of_trips
FROM green_2023
GROUP BY payment_method
ORDER BY no_of_trips DESC;

--Yellow Taxi--
WITH payment_matrix AS (
SELECT  payment_type,
CASE
WHEN payment_type = 1 THEN 'Credit card'
WHEN payment_type = 2 THEN 'Cash'
ELSE 'Other'
END AS payment_method
FROM yellow_2023 )

SELECT payment_method, COUNT(*) AS no_of_trips
FROM payment_matrix
GROUP BY payment_method;

--Question 4A--
--Green Taxi--
SELECT DISTINCT t.Zone
FROM green_2023 g 
JOIN taxi_lookup t
ON g.DOLocationID = t.LocationID
ORDER BY t.Zone;

--Yellow Taxi--
SELECT DISTINCT t.Zone
FROM yellow_2023 y 
JOIN taxi_lookup t
ON y.DOLocationID = t.LocationID
ORDER BY t.Zone;

--Question 4B--
--Yellow Taxi pickup zones ONLY--
SELECT t.Zone
FROM yellow_2023 y 
JOIN taxi_lookup t
ON y.PULocationID = t.LocationID
EXCEPT
SELECT t.Zone
FROM green_2023 g 
JOIN taxi_lookup t
ON g.PULocationID = t.LocationID
ORDER BY t.Zone;

--Question 5--
--Yellow Taxi--
WITH average_fare_CTE AS (
SELECT CAST(tpep_pickup_datetime AS DATE) AS pickup_date, ROUND(AVG(total_amount),2) AS avg_fare_amnt
FROM yellow_2023
GROUP By pickup_date
),
daily_revenue AS (
    SELECT CAST(tpep_pickup_datetime AS DATE) AS pickup_date, ROUND(SUM(total_amount),2) AS total_revenue
    FROM yellow_2023
    GROUP By pickup_date
)

SELECT a.pickup_date, total_revenue, avg_fare_amnt
FROM average_fare_CTE a
JOIN daily_revenue b
    ON a.pickup_date = b.pickup_date
WHERE total_revenue > avg_fare_amnt
ORDER BY total_revenue DESC
LIMIT 50;


--Question 5B--
WITH daily_avg AS(
    SELECT EXTRACT(DAY FROM tpep_pickup_datetime) AS trip_day,
    STRFTIME('%Y-%m', tpep_pickup_datetime) AS tripMonth,
    ROUND(AVG(total_amount),2) AS daily_revenue
    FROM yellow_2023
    GROUP BY trip_day, tripMonth
),

ranked_days AS(
    SELECT tripMonth, trip_day, daily_revenue,
    RANK() OVER (PARTITION BY tripMonth ORDER BY daily_revenue DESC) AS day_rank
FROM daily_avg
WHERE tripMonth >= '2023-01' AND tripMonth < '2024-01'
)
SELECT tripMonth, trip_day, daily_revenue, day_rank
FROM ranked_days
WHERE day_rank <=5
ORDER BY tripMonth, day_rank;

