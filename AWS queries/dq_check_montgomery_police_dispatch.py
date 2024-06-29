import sys
import awswrangler as wr

# this check counts the number of NULL rows in the date_created column
# if any rows are NULL, the check returns a number > 0
NULL_DQ_CHECK = f"""
SELECT 
    SUM(CASE WHEN start_time IS NULL THEN 1 ELSE 0 END) AS res_col
FROM "de_project_database"."montgomery_police_inc_data_parquet_tbl"
;
"""

# run the quality check
df = wr.athena.read_sql_query(sql=NULL_DQ_CHECK, database="de_project_database")

# exit if we get a result > 0
# else, the check was successful
if df['res_col'][0] > 0:
    sys.exit('Results returned. Quality check failed.')
else:
    print('Quality check passed.')
