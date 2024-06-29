SELECT initial_type, 
    round((COUNT(DISTINCT incident_id) / 1157.0) * 100,1)AS percentage
from montgomery_police_inc_data_parquet_tbl 
GROUP BY 
    1
ORDER BY 
    2 DESC limit 10;
