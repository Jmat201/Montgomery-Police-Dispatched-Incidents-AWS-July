SELECT 
    initial_type, count(distinct incident_id)count_incidents
FROM 
    "de_project_database"."project_montgomery_police_dispatch_incidents"
WHERE 
    TRIM(SUBSTR(address, POSITION('BLK' IN address) + 3)) = 'GEORGIA AVE'
group by 1 
order by 2 desc
