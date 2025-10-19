--Question 1a--
--Green Taxi--
SELECT 
CASE 
WHEN STRFTIME('%Y-%m', lpep_pickup_datetime) BETWEEN ('2023-01') AND ('2023-03') THEN 'Q1'
WHEN STRFTIME('%Y-%m', lpep_pickup_datetime) BETWEEN ('2023-04') AND ('2023-06') THEN 'Q2'
WHEN STRFTIME('%Y-%m', lpep_pickup_datetime) BETWEEN ('2023-07') AND ('2023-09') THEN 'Q3'
WHEN STRFTIME('%Y-%m', lpep_pickup_datetime) BETWEEN ('2023-10') AND ('2023-12') THEN 'Q4'
ELSE 'N/A'
END AS quarters_2023,
count(*) AS no_of_trips, ROUND(SUM(total_amount),2) AS total_revenue, ROUND(AVG(trip_distance),2) AS average_mileage, ROUND(AVG(passenger_count),2) AS avg_passenger_count
FROM green_2023
GROUP BY quarters_2023
ORDER BY total_revenue DESC;

--Yellow Taxi--
SELECT 
CASE 
WHEN EXTRACT(QUARTER FROM tpep_pickup_datetime) = 1 THEN 'Q1'
WHEN EXTRACT(QUARTER FROM tpep_pickup_datetime) = 2 THEN 'Q2'
WHEN EXTRACT(QUARTER FROM tpep_pickup_datetime) = 3 THEN 'Q3'
WHEN EXTRACT(QUARTER FROM tpep_pickup_datetime) = 4 THEN 'Q4'
ELSE 'N/A'
END AS quarters_2023,
count(*) AS no_of_trips, ROUND(SUM(total_amount),2) AS total_revenue, ROUND(AVG(trip_distance),2) AS average_mileage, ROUND(AVG(passenger_count),2) AS avg_passenger_count
FROM yellow_2023
GROUP BY quarters_2023
ORDER BY total_revenue DESC;

--Quetion 1b--
--Green Taxi--
SELECT t.Borough, ROUND(SUM(total_amount),2) AS total_revenue, COUNT(*) AS no_of_trips
FROM green_2023 g 
JOIN taxi_lookup t
ON g.PULocationID = t.LocationID
GROUP BY t.Borough
ORDER BY total_revenue DESC;

--Yellow Taxi--
SELECT t.Borough, ROUND(SUM(y.total_amount),2) AS total_revenue, COUNT(*) AS no_of_trips
FROM yellow_2023 y 
JOIN taxi_lookup t
ON y.PULocationID = t.LocationID
GROUP BY t.Borough
ORDER BY total_revenue DESC;


--Question B--
--Question 1a (semi-open ended)--
WITH customer_buckets AS (
SELECT total_amount, CASE
WHEN total_amount BETWEEN 0 AND 9.99 THEN '0 - 9.99'
WHEN total_amount BETWEEN 10 AND 19.99 THEN '10 - 19.99'
WHEN total_amount BETWEEN 20 AND 49.99 THEN '20 - 49.99'
WHEN total_amount > 49.99 THEN '50+'
ELSE 'N/A'
END AS Customer_Expenditure
FROM green_2023)

SELECT Customer_Expenditure, ROUND(SUM(total_amount),2) AS total_revenue
FROM customer_buckets
GROUP BY Customer_Expenditure
ORDER BY total_revenue DESC;
