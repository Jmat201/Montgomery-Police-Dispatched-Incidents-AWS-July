import sys
import boto3
from time import sleep

client = boto3.client('athena')

SOURCE_TABLE_NAME = 'project_montgomery_police_dispatch_incidents'
NEW_TABLE_NAME = 'montgomery_police_inc_data_parquet_tbl'
NEW_TABLE_S3_BUCKET = 's3://montgomery-police-inc-tbl-pqt/'
MY_DATABASE = 'de_project_database'
QUERY_RESULTS_S3_BUCKET = 's3://athena-query-results-bucket-may-2024-jeff/'

# SQL query with partitioning
query = f"""
CREATE TABLE {NEW_TABLE_NAME} WITH (
    external_location='{NEW_TABLE_S3_BUCKET}',
    format='PARQUET',
    write_compression='SNAPPY',
    partitioned_by = ARRAY['state']
) AS
SELECT
    incident_id,
    start_time,
    priority,
    initial_type,
    close_type,
    address,
    city,
    zip,
    police_district_number,
    sector,
    pra,
    dispatch_arrive,
    arrive_cleared,
    disposition_desc,
    geolocation_coordinates,
    row_ts,
    end_time,
    state
FROM "{MY_DATABASE}"."{SOURCE_TABLE_NAME}"
"""

# Start the query execution
queryStart = client.start_query_execution(
    QueryString=query,
    QueryExecutionContext={'Database': MY_DATABASE},
    ResultConfiguration={'OutputLocation': QUERY_RESULTS_S3_BUCKET}
)

# Poll the execution status until completion
resp = ["FAILED", "SUCCEEDED", "CANCELLED"]

while True:
    response = client.get_query_execution(QueryExecutionId=queryStart["QueryExecutionId"])
    status = response["QueryExecution"]["Status"]["State"]
    
    if status in resp:
        break
    sleep(5)

# Handle the query result
if status == 'FAILED':
    reason = response["QueryExecution"]["Status"]["StateChangeReason"]
    sys.exit(f"Query failed: {reason}")
elif status == 'SUCCEEDED':
    print("Query succeeded")
else:
    print(f"Query ended with status: {status}")

