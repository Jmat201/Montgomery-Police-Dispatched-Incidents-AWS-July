with priority_intial_type_dispatch_arrive as (SELECT 
    initial_type, priority
    ,ROUND(AVG(coalesce(TRY_CAST(arrive_cleared AS double),0) / 60), 2) AS Avg_dispatch_min
    ,count(distinct incident_id) count_incidents
    ,city
    ,address
FROM 
    "de_project_database"."montgomery_police_inc_data_parquet_tbl"
    where arrive_cleared !=''
GROUP BY 
    priority, initial_type,city,address)
    
select concat(initial_type,':', priority) initial_type_priority
    ,sum(ACM_Gerogia_Ave) ACM_Gerogia_Ave
    ,sum(count_Gerogia_Ave)count_inc_Gerogia_Ave

    ,sum(ACM_Rockville_Pike)ACM_Rockville_Pike
    ,sum(count_Rockville_Pike)count_inc_Rockville_Pike

    ,sum(ACM_Veirsmill_Road)ACM_Veirsmill_Road
    ,sum(count_Veirsmill_Road)count_inc_Veirsmill_Road

    ,sum(ACM_Collesville_Road)ACM_Collesville_Road
    ,sum(count_Collesville_Road)count_inc_Collesville_Road
from 

(select priority,initial_type
    , Avg_dispatch_min as ACM_Gerogia_Ave
    , 0 as ACM_Rockville_Pike
    , 0 as ACM_Veirsmill_Road
    , 0 as ACM_Collesville_Road
    , count_incidents as count_Gerogia_Ave
    , 0 as count_Rockville_Pike
    , 0 as count_Veirsmill_Road
    , 0 as count_Collesville_Road
from priority_intial_type_dispatch_arrive where 
TRIM(SUBSTR(address, POSITION('BLK' IN address) + 3)) = 'GEORGIA AVE'

UNION 

select priority,initial_type
    , 0 as ACM_Gerogia_Ave
    , Avg_dispatch_min as ACM_Rockville_Pike
    , 0 as ACM_Veirsmill_Road
    , 0 as ACM_Collesville_Road
    , 0 as count_Collesville_Road
    , count_incidents as count_Rockville_Pike
    , 0 as count_Veirsmill_Road
    , 0 as count_Collesville_Road

from priority_intial_type_dispatch_arrive where 
TRIM(SUBSTR(address, POSITION('BLK' IN address) + 3)) = 'ROCKVILLE PIKE'

UNION 
select priority,initial_type
    , 0 as ACM_Gerogia_Ave
    , 0 as ACM_Rockville_Pike
    , Avg_dispatch_min as ACM_Veirsmill_Road
    , 0 as ACM_Collesville_Road
    
    , 0 as count_Collesville_Road
    , 0 as count_Rockville_Pike
    , count_incidents as count_Veirsmill_Road
    , 0 as count_Collesville_Road
from priority_intial_type_dispatch_arrive where 
TRIM(SUBSTR(address, POSITION('BLK' IN address) + 3)) = 'VEIRS MILL RD'

UNION
select priority,initial_type
    , 0 as ACM_Gerogia_Ave
    , 0 as ACM_Rockville_Pike
    , 0 as ACM_Veirsmill_Road
    , Avg_dispatch_min as ACM_Collesville_Road
    , 0 as count_Collesville_Road
    , 0 as count_Rockville_Pike
    , 0 as count_Veirsmill_Road
    , count_incidents as count_Collesville_Road

from priority_intial_type_dispatch_arrive where 
TRIM(SUBSTR(address, POSITION('BLK' IN address) + 3)) = 'COLESVILLE RD')


group by 1 
order by 1
