FROM python

RUN apt-get install wget
RUN apt-get install gzip
RUN pip install pandas sqlalchemy psycopg2-binary

WORKDIR /app
COPY pipeline.py pipeline.py

ENTRYPOINT [ "python", "pipeline.py" ]
