with priority_intial_type_dispatch_arrive as (SELECT 
    initial_type, priority
    ,ROUND(AVG(coalesce(TRY_CAST(dispatch_arrive AS double),0) / 60), 2) AS Avg_dispatch_min
    ,count(distinct incident_id) count_incidents
    ,city
FROM 
    "de_project_database"."montgomery_police_inc_data_parquet_tbl"
WHERE dispatch_arrive !=''
GROUP BY 
    priority, initial_type,city)
    
select concat(initial_type,':', priority) initial_type_priority
    ,sum(ADM_SILVER_SPRING) ADM_SILVER_SPRING
    ,sum(count_silver_spring)count_inc_silver_spring

    ,sum(ADM_ROCKVILLE)ADM_ROCKVILLE
    ,sum(count_rockville)count_inc_rockville

    ,sum(ADM_GAITHERSBURG)ADM_GAITHERSBURG
    ,sum(count_gaithersburg)count_inc_gaithersburg

    ,sum(ADM_GERMANTOWN)ADM_GERMANTOWN
    ,sum(count_germantown)count_inc_germantown
from 

(select priority,initial_type
    , Avg_dispatch_min as ADM_SILVER_SPRING
    , 0 as ADM_ROCKVILLE
    , 0 as ADM_GAITHERSBURG
    , 0 as ADM_GERMANTOWN
    , count_incidents as count_silver_spring
    , 0 as count_rockville
    , 0 as count_gaithersburg
    , 0 as count_germantown
from priority_intial_type_dispatch_arrive where 
city = 'SILVER SPRING'

UNION 

select priority,initial_type
    , 0 as ADM_SILVER_SPRING
    , Avg_dispatch_min as ADM_ROCKVILLE
    , 0 as ADM_GAITHERSBURG
    , 0 as ADM_GERMANTOWN
    , 0 as count_germantown
    , count_incidents as count_rockville
    , 0 as count_gaithersburg
    , 0 as count_germantown

from priority_intial_type_dispatch_arrive where 
city = 'ROCKVILLE'

UNION 
select priority,initial_type
    , 0 as ADM_SILVER_SPRING
    , 0 as ADM_ROCKVILLE
    , Avg_dispatch_min as ADM_GAITHERSBURG
    , 0 as ADM_GERMANTOWN
    , 0 as count_germantown
    , 0 as count_rockville
    , count_incidents as count_gaithersburg
    , 0 as count_germantown
from priority_intial_type_dispatch_arrive where 
city = 'GAITHERSBURG'

UNION
select priority,initial_type
    , 0 as ADM_SILVER_SPRING
    , 0 as ADM_ROCKVILLE
    , 0 as ADM_GAITHERSBURG
    , Avg_dispatch_min as ADM_GERMANTOWN
    , 0 as count_germantown
    , 0 as count_rockville
    , 0 as count_gaithersburg
    , count_incidents as count_germantown

from priority_intial_type_dispatch_arrive where 
city = 'GERMANTOWN')

where concat( initial_type,':', priority) in 
('ADMINISTRATIVE (DOCUMENT, LOST OR FOUND PROPERTY, MESSAGES,:4'
,'ALARMRB - ALARM COMMERCIAL BURGLARY/INTRUSION:1'
,'ALARMRB - COMMERCIAL HOLDUP/DURESS/PANIC:1'
,'ALARMRB - RESIDENTIAL BURGLARY/INTRUSION:1'
,'ALARMRB - RESIDENTIAL HOLDUP/DURESS/PANIC:1'
,'ANIMAL COMPL:1'
,'ASSAULT - OCCURRED EARLIER:3'
,'ASSAULT JUST OCCURRED - ROUTINE:1'
,'ASSAULT:0'
,'ASSIST OTHER AGENCY:2'
,'ASSIST/STANDBY:1'
,'CHECK WELFARE:1'
,'DISTURBANCE/NUISANCE:1'
,'DISTURBANCE/NUISANCE:2'
,'DOMESTIC DISTURBANCE/VIOLENCE - OCCURRED EARLIER:3'
,'DOMESTIC DISTURBANCE/VIOLENCE:0'
,'DOMESTIC DISTURBANCE/VIOLENCE:1'
,'DOMESTIC VIOLENCE:1'
,'FRAUD/DECEPTION - OCCURRED EARLIER:4'
,'HARASSMENT, STALKING, THREATS - OCCURRED EARLIER:3'
,'HARASSMENT, STALKING, THREATS:1'
,'MENTAL DISORDER:1'
,'MISSING, RUNAWAY, FOUND PERSON:1'
,'NOISE - NOISE - OTHER COMPLAINTS:3'
,'PARKING OFFENSE:4'
,'RESCUE WITH FRS:1'
,'SEXUAL ASSAULT - OCCURRED EARLIER:3'
,'SUSICIOUS CIRCUMSTANCE, PERSON, VEHICLE - OCCURRED EARLIER:3'
,'SUSPICIOUS CIRC, PERSONS, VEHICLE:1'
,'THEFT/LARCENY - OCCURRED EARLIER:4'
,'THEFT/LARCENY FROM AUTO:2'
,'THEFT/LARCENY:2')

group by 1 
order by 1
