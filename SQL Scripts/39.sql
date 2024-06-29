WITH RankedResults AS (
    SELECT 
        CONCAT(priority, ' : ', initial_type) AS priority_initial_type,
        COUNT(DISTINCT incident_id) AS incident_count,
        ROW_NUMBER() OVER (PARTITION BY priority, initial_type ORDER BY COUNT(DISTINCT incident_id) DESC) AS rank
    FROM 
        "de_project_database"."montgomery_police_inc_data_parquet_tbl"
    WHERE 
        city = 'SILVER SPRING'
        AND initial_type IN ('TRAFFIC/TRANSPORTATION INCIDENT', 
                             'SUSPICIOUS CIRC, PERSONS, VEHICLE', 
                             'DISTURBANCE/NUISANCE', 
                             'CHECK WELFARE')
    GROUP BY 
        priority, initial_type
)
SELECT 
    priority_initial_type,
    round((incident_count / 148.0) * 100,1) AS percentage
FROM 
    RankedResults
WHERE 
    rank <= 3
ORDER BY 
    priority_initial_type, percentage DESC;
