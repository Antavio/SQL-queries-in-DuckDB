CREATE TABLE yellow_2023 AS
SELECT *
FROM read_parquet([
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-01.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-02.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-03.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-04.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-06.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-07.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-08.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-09.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-10.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-11.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-12.parquet'
]);


CREATE TABLE green_2023 AS
SELECT *
FROM read_parquet([
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-01.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-02.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-03.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-04.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-05.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-06.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-07.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-08.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-09.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-10.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-11.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-12.parquet'
]);

--Lookup Table
CREATE TABLE taxi_lookup AS
SELECT *
FROM read_csv(['https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv'])
