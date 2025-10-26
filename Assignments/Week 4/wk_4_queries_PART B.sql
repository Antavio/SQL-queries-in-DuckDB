--Question 1--
WITH trip_duration AS (
    SELECT *,
        ROUND(EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 60.0, 2) AS minute_i,
        DATEDIFF('minute', tpep_pickup_datetime, tpep_dropoff_datetime) AS minute_ii
    FROM cleaned_yellow_2023
),
validation_checks AS (
    SELECT *,
        ROUND(EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) / 60.0, 2) AS minute_i,
        DATEDIFF('minute', tpep_pickup_datetime, tpep_dropoff_datetime) AS minute_ii
    FROM trip_duration
    WHERE (minute_i > 1 AND minute_i IS NOT NULL)
      AND (total_amount IS NOT NULL AND total_amount > 0)
      AND (trip_distance IS NOT NULL AND trip_distance > 0)
      AND (passenger_count IS NOT NULL AND passenger_count > 0)
),
ranked_trips AS (
    SELECT
        LPAD(EXTRACT(MONTH FROM tpep_pickup_datetime)::TEXT, 3, '0') AS month_number,
        MONTHNAME(tpep_pickup_datetime) AS month_name,
        VendorID,
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        trip_distance,
        minute_i AS trip_duration_minutes,
        DENSE_RANK() OVER (
            PARTITION BY EXTRACT(MONTH FROM tpep_pickup_datetime), VendorID
            ORDER BY minute_i DESC
        ) AS duration_rank
    FROM validation_checks
)

SELECT
    month_number,
    month_name,
    VendorID,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    trip_distance,
    trip_duration_minutes,
    duration_rank
FROM ranked_trips
WHERE duration_rank <= 5
ORDER BY month_number, VendorID, duration_rank;

--Question 2--
WITH data_validation AS (
    SELECT
        LPAD(EXTRACT(MONTH FROM tpep_pickup_datetime)::TEXT, 3, '0') AS month_number,
        MONTHNAME(tpep_pickup_datetime) AS month_name,
        tip_amount,
        PERCENT_RANK() OVER (
            PARTITION BY EXTRACT(MONTH FROM tpep_pickup_datetime)
            ORDER BY tip_amount DESC
        ) AS pc_rank
    FROM yellow_2023
    WHERE 
        tip_amount IS NOT NULL 
        AND tip_amount > 0
        AND tpep_pickup_datetime BETWEEN '2023-01-01' AND '2023-12-31'
)

SELECT 
    month_number,
    month_name,
    tip_amount,
    ROUND(pc_rank, 3) AS percentile_rank
FROM data_validation
WHERE pc_rank >= 0.9   -- top 10% tips for each month
ORDER BY month_number, percentile_rank;
