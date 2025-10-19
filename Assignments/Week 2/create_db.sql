CREATE TABLE yellow_quarter1_2025 AS
SELECT *
FROM read_parquet([
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-01.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-02.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-03.parquet'
]);

CREATE TABLE green_quarter1_2025 AS
SELECT *
FROM read_parquet([
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-01.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-02.parquet',
  'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-03.parquet'
]);