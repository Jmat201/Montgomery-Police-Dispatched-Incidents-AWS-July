select city,count(distinct incident_id) count_incidents
from montgomery_police_inc_data_parquet_tbl
group by 1
order by count_incidents desc;
