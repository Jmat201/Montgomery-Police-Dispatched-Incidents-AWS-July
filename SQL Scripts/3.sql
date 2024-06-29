
WITH RankedIncidents AS (
    SELECT 
        city,
        initial_type,
        COUNT(distinct incident_id) AS count_incidents
        ,ROW_NUMBER() OVER (PARTITION BY city ORDER BY COUNT(distinct incident_id) DESC) AS rn
    FROM 
        montgomery_police_inc_data_parquet_tbl 
        where city in ('SILVER SPRING', 'GERMANTOWN', 'GAITHERSBURG','ROCKVILLE')
    GROUP BY 
        city, initial_type
)
SELECT 
    city,
    initial_type,
    case when city = 'SILVER SPRING' then round(count_incidents/412.0*100,1)
    when city = 'ROCKVILLE' then round(count_incidents/201.0*100,1)
    when city = 'GERMANTOWN' then round(count_incidents/148.0*100,1)
    when city = 'GAITHERSBURG' then round(count_incidents/101.0*100,1) end as count_incidents_percentage
FROM 
    RankedIncidents
WHERE rn <= 3
ORDER BY 
    city,count_incidents_percentage DESC;
