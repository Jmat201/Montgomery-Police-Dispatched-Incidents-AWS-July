WITH priority_initial_type_dispatch_arrive AS (
    SELECT 
        incident_id,
        initial_type,
        ROUND(COALESCE(TRY_CAST(dispatch_arrive AS double), 0) / 60, 1) AS arrived_min,
        city
    FROM 
        "de_project_database"."montgomery_police_inc_data_parquet_tbl"
    WHERE dispatch_arrive != ''
    GROUP BY 
        incident_id, initial_type, dispatch_arrive, city
)

SELECT 
    CONCAT(city, ':', arrived_mins_group) AS initial_type_arrived_mins, 
    CASE 
        WHEN city = 'SILVER SPRING' THEN ROUND(count_incidents / 18.0 * 100, 1)
        WHEN city = 'ROCKVILLE' THEN ROUND(count_incidents / 13.0 * 100, 1)
        WHEN city = 'GAITHERSBURG' THEN ROUND(count_incidents / 8.0 * 100, 1)
        WHEN city = 'GERMANTOWN' THEN ROUND(count_incidents / 4.0 * 100, 1)
    END AS count_incidents_percentage
FROM (
    SELECT 
        city,
        CASE 
            WHEN arrived_min >= 0.1 AND arrived_min <= 5.0 THEN '0-5 mins'
            WHEN arrived_min > 5.0 AND arrived_min <= 10.0 THEN '5-10 mins'
            WHEN arrived_min > 10.0 AND arrived_min <= 15.0 THEN '10-15 mins'
            WHEN arrived_min > 15.0 AND arrived_min <= 20.0 THEN '15-20 mins'
            WHEN arrived_min > 20.0 AND arrived_min <= 30.0 THEN '20-30 mins'
            WHEN arrived_min > 30.0 AND arrived_min <= 40.0 THEN '30-40 mins'
            WHEN arrived_min > 40.0 AND arrived_min <= 50.0 THEN '40-50 mins'
            WHEN arrived_min > 50.0 THEN '50+ mins'
            ELSE 'None' 
        END AS arrived_mins_group,
        COUNT(DISTINCT incident_id) AS count_incidents
    FROM 
        priority_initial_type_dispatch_arrive
    WHERE 
        city IN ('SILVER SPRING', 'ROCKVILLE', 'GAITHERSBURG', 'GERMANTOWN') 
        AND initial_type IN ('DISTURBANCE/NUISANCE')
    GROUP BY 
        1, 2
    ORDER BY 
        1, 3 DESC
) 
WHERE 
    arrived_mins_group != 'None'
ORDER BY 
    2 DESC limit 10 ;
