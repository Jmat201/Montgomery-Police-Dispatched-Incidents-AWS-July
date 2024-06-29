WITH RankedIncidents AS (
    SELECT 
        city,
        initial_type,
        COUNT(distinct incident_id) AS count_incidents,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY COUNT(distinct incident_id) DESC) AS rn
    FROM 
        montgomery_police_inc_data_parquet_tbl 
        where city in ('SILVER SPRING', 'GERMANTOWN', 'GAITHERSBURG','ROCKVILLE')
    GROUP BY 
        city, initial_type
)
SELECT 
    city,
    initial_type,
    count_incidents
FROM 
    RankedIncidents
WHERE 
    rn <= 3
ORDER BY 
    city, count_incidents DESC;
