WITH priority_initial_type_dispatch_arrive AS (
    SELECT 
        incident_id,
        initial_type,
        ROUND(COALESCE(TRY_CAST(arrive_cleared AS double), 0) / 60, 1) AS cleared_min,
        city
    FROM 
        "de_project_database"."montgomery_police_inc_data_parquet_tbl"
    WHERE arrive_cleared !=''
    GROUP BY 
        incident_id, initial_type,arrive_cleared, city
)

SELECT 
    CONCAT( city, ':', cleared_mins_group) AS initial_type_cleared_mins, 
        CASE 
        WHEN city = 'SILVER SPRING' THEN ROUND(count_incidents / 17.0 * 100, 1)
        WHEN city = 'ROCKVILLE' THEN ROUND(count_incidents / 10.0 * 100, 1)
        WHEN city = 'GAITHERSBURG' THEN ROUND(count_incidents / 6.0 * 100, 1)
        WHEN city = 'GERMANTOWN' THEN ROUND(count_incidents / 5.0 * 100, 1)
    END AS count_incidents_percentage

FROM (
    SELECT 
        city,
        CASE 
            WHEN cleared_min >= 0.1 AND cleared_min <= 5.0 THEN '0-5 mins'
            WHEN cleared_min > 5.0 AND cleared_min <= 10.0 THEN '5-10 mins'
            WHEN cleared_min > 10.0 AND cleared_min <= 15.0 THEN '10-15 mins'
            WHEN cleared_min > 15.0 AND cleared_min <= 20.0 THEN '15-20 mins'
            WHEN cleared_min > 20.0 AND cleared_min <= 30.0 THEN '20-30 mins'
            WHEN cleared_min > 30.0 AND cleared_min <= 40.0 THEN '30-40 mins'
            WHEN cleared_min > 40.0 AND cleared_min <= 50.0 THEN '40-50 mins'
            WHEN cleared_min > 50.0 THEN '50+ mins'
            ELSE 'None' 
        END AS cleared_mins_group,
        COUNT(DISTINCT incident_id) AS count_incidents
    FROM 
        priority_initial_type_dispatch_arrive
    WHERE 
        city IN ('SILVER SPRING', 'ROCKVILLE', 'GAITHERSBURG', 'GERMANTOWN') 
        AND initial_type IN ('CHECK WELFARE')
    GROUP BY 
        1,2
    ORDER BY 
        1,3 DESC
) 
WHERE 
    cleared_mins_group != 'None'
    order by 2 desc limit 10
