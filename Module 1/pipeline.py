#!/usr/bin/env python
# coding: utf-8

import os
import pandas as pd
from sqlalchemy import create_engine
from time import time
import argparse


def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url

    # download the csv file
    os.system(f"wget {url} -O /app/output.csv")
    # os.system("gunzip output.gz")
    # os.system("mv output output.csv")

    # connect to postgres database
    engine = create_engine(f"postgresql://{user}:{password}@{host}:{port}/{db}")
    engine.connect()

    df_iter = pd.read_csv("output.csv", iterator=True, chunksize=50000)
    df = next(df_iter)

    # print(pd.io.sql.get_schema(df, name="green_taxi_data", con=engine))

    # df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
    # df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)

    df.head(0).to_sql(name=table_name, con=engine, if_exists="replace")
    df.to_sql(name=table_name, con=engine, if_exists="append")

    while True:
        t_start = time()

        try:
            df = next(df_iter)
            # df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
            # df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)
            df.to_sql(name=table_name, con=engine, if_exists="append")

        except StopIteration:
            break

        t_end = time()
        print("Inserted another chunk of data in %.3f seconds" % (t_end - t_start))

    print("Data import complete.")
    os.system("pip list|grep wheel")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Ingest CSV data to PostgreSQL.")
    parser.add_argument("--user", help="user name for postgres")
    parser.add_argument("--password", help="password for postgres")
    parser.add_argument("--host", help="host of postgres")
    parser.add_argument("--port", help="port of postgres")
    parser.add_argument("--db", help="database name for postgres")
    parser.add_argument("--table_name", help="table name for postgres")
    parser.add_argument("--url", help="url of the csv file")

    args = parser.parse_args()

    main(args)
