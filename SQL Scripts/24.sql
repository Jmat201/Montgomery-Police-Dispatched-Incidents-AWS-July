SELECT 
police_district_number,
count(distinct incident_id) count_incidents
FROM  
    "de_project_database"."montgomery_police_inc_data_parquet_tbl"
WHERE dispatch_arrive = '' and arrive_cleared = ''
group by 1
order by 2 desc
limit 8
