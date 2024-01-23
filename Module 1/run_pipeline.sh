docker run --network=module1_pipeline_net --rm \
  data_ingest:v001 \
  --user=root \
  --password=secret \
  --host=ny_taxi_db \
  --port=5432 \
  --db=ny_taxi \
  --table_name=green_taxi_trips \
  --url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz

docker run --network=module1_pipeline_net --rm \
  data_ingest:v001 \
  --user=root \
  --password=secret \
  --host=ny_taxi_db \
  --port=5432 \
  --db=ny_taxi \
  --table_name=zone_lookup \
  --url=https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv
  