CREATE TABLE green_taxi_may AS
SELECT * FROM read_parquet('https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2024-05.parquet');
CREATE TABLE green_taxi_june AS
SELECT * FROM read_parquet('https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2024-06.parquet');