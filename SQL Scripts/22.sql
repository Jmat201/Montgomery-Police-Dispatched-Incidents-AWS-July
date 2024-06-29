SELECT 
count(distinct incident_id)
,initial_type
FROM  
    "de_project_database"."montgomery_police_inc_data_parquet_tbl"
WHERE dispatch_arrive = '' and arrive_cleared = ''
group by 2
order by 1 desc
limit 8
