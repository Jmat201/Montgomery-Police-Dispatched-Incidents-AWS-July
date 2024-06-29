SELECT 
    initial_type, 
    round((COUNT(DISTINCT incident_id) / 148.0) * 100,1)AS percentage
FROM 
montgomery_police_inc_data_parquet_tbl 
WHERE 
    city = 'GAITHERSBURG'
GROUP BY 
    1
ORDER BY 
    2 DESC limit 4;
