select distinct incident_id, 
geolocation_coordinates[2] as latitude
,geolocation_coordinates[1] as longitude
FROM "de_project_database"."project_montgomery_police_dispatch_incidents"
where city = 'SILVER SPRING'
and initial_type !='TRAFFIC/TRANSPORTATION INCIDENT'
