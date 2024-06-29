SELECT DISTINCT
    incident_id, 
    geolocation_coordinates[2] AS latitude,
    geolocation_coordinates[1] AS longitude
FROM 
    "de_project_database"."project_montgomery_police_dispatch_incidents"
WHERE 
    TRIM(SUBSTR(address, POSITION('BLK' IN address) + 3)) = ‘COLESVILLE RD’
