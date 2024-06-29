SELECT distinct incident_id, initial_type, priority, city, zip, sector,dispatch_arrive,arrive_cleared, pra, disposition_desc,state
FROM  
    "de_project_database"."montgomery_police_inc_data_parquet_tbl" a
WHERE 
    city = 'SILVER SPRING' 
    AND initial_type = 'SEXUAL ASSAULT - OCCURRED EARLIER' 
    AND priority = '3'
