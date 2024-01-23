select * from green_taxi_trips;

select count(*) from green_taxi_trips;

select * from zone_lookup;

select count(*) from zone_lookup;

-- Q. 3
-- How many taxi trips were totally made on September 18th 2019
-- Tip: started and finished on 2019-09-18.
-- Remember that lpep_pickup_datetime and lpep_dropoff_datetime columns are in the format
-- timestamp (date and hour+min+sec) and not in date.
select count(*) from green_taxi_trips
where 
    date(lpep_pickup_datetime) = '2019-09-18' 
and date(lpep_dropoff_datetime) = '2019-09-18';


-- Q. 4
select date(lpep_pickup_datetime)
from green_taxi_trips 
where trip_distance = (select max(trip_distance) from green_taxi_trips);

-- Q. 5
-- Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown
-- Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?

select "Borough", sum(total_amount) as total
from green_taxi_trips a join zone_lookup b on a."PULocationID" = b."LocationID"
where date(lpep_pickup_datetime) = '2019-09-18'
and b."Borough" != 'Unknown'
group by "Borough"
having sum(total_amount) > 50000;

-- Q. 6
-- For the passengers picked up in September 2019 in the zone name Astoria, which was the 
-- drop off zone that had the largest tip? We want the name of the zone, not the id.
select a.lpep_pickup_datetime, a.tip_amount, b."Zone"as "Pick up zone", c."Zone" as "Drop off zone" 
from green_taxi_trips a 
join zone_lookup b on a."PULocationID" = b."LocationID"
join zone_lookup c on a."DOLocationID" = c."LocationID"
where 
	b."Zone" = 'Astoria'
and EXTRACT(MONTH FROM lpep_pickup_datetime) = 9
and EXTRACT(YEAR FROM lpep_pickup_datetime) = 2019
and tip_amount = 
      (select max(a.tip_amount)
from green_taxi_trips a 
join zone_lookup b on a."PULocationID" = b."LocationID"
where 
	b."Zone" = 'Astoria'
and EXTRACT(MONTH FROM lpep_pickup_datetime) = 9
and EXTRACT(YEAR FROM lpep_pickup_datetime) = 2019);