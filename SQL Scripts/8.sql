select * from (SELECT trim(substr(address, strpos(address, 'BLK') + 3)) AS extracted_address
, count(distinct incident_id) count_incident

FROM "de_project_database"."project_montgomery_police_dispatch_incidents"
group by 1 order by 2 desc)a
where a.count_incident>=10
