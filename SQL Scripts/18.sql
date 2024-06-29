WITH RankedResults AS (
    SELECT 
        CONCAT(initial_type, ' : ', disposition_desc) AS type_disposition,
        COUNT(DISTINCT incident_id) AS incident_count,
        ROW_NUMBER() OVER (PARTITION BY initial_type ORDER BY COUNT(DISTINCT incident_id) DESC) AS rank
    FROM 
        "de_project_database"."montgomery_police_inc_data_parquet_tbl"
    WHERE 
        city = 'SILVER SPRING' 
        AND initial_type IN ('TRAFFIC/TRANSPORTATION INCIDENT', 
                             'SUSPICIOUS CIRC, PERSONS, VEHICLE', 
                             'DISTURBANCE/NUISANCE', 
                             'CHECK WELFARE')
    GROUP BY 
        initial_type, disposition_desc
)
SELECT 
    type_disposition,
    incident_count
FROM 
    RankedResults
WHERE 
    rank <= 3
ORDER BY 
    type_disposition, incident_count DESC;
