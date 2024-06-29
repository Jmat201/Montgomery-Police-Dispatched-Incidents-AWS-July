SELECT 
    initial_type, 
    round((COUNT(DISTINCT incident_id) / 412.0) * 100,1)AS percentage
FROM 
montgomery_police_inc_data_parquet_tbl 
WHERE 
    city = 'SILVER SPRING'
GROUP BY 
    1
ORDER BY 
    2 DESC limit 4;
