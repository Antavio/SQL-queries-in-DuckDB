DROP TABLE IF EXISTS yellow_taxi_may;

CREATE TABLE yellow_taxi_may (
    VendorID INTEGER,
    tpep_pickup_datetime TIMESTAMP NOT NULL,
    tpep_dropoff_datetime TIMESTAMP NOT NULL,
    passenger_count INTEGER,
    trip_distance NUMERIC(10,2),
    fare_amount NUMERIC(10,2),
    tip_amount NUMERIC(10,2) DEFAULT 0,
    payment_type INTEGER NOT NULL
);