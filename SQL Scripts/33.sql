SELECT distinct incident_id, initial_type, priority, city, zip, sector,dispatch_arrive,arrive_cleared, pra, disposition_desc,state FROM  
    "de_project_database"."montgomery_police_inc_data_parquet_tbl"
WHERE
    city = 'GAITHERSBURG' 
    AND initial_type = 'NOISE - NOISE - OTHER COMPLAINTS' 
    AND priority = '3'
