SELECT 
    initial_type, 
    round((COUNT(DISTINCT incident_id) / 101.0) * 100,1)AS percentage
FROM 
montgomery_police_inc_data_parquet_tbl 
WHERE 
    city = 'GERMANTOWN'
GROUP BY 
    1
ORDER BY 
    2 DESC limit 4;
