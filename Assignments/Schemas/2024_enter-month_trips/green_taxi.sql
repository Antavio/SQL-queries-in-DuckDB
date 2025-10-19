DROP TABLE IF EXISTS green_taxi_may;

CREATE TABLE green_taxi_may (
    VendorID INTEGER,
    lpep_pickup_datetime TIMESTAMP NOT NULL,
    lpep_dropoff_datetime TIMESTAMP NOT NULL,
    passenger_count INTEGER,
    trip_distance NUMERIC(10,2),
    fare_amount NUMERIC(10,2),
    tip_amount NUMERIC(10,2) DEFAULT 0,
    payment_type INTEGER
);