-- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures

-- 1 CTE: Consumers in San Luis Potosi rating Mexican restaurants with Overall_Rating = 2
with SL as (
    select Consumer_ID, Age
    from consumers
    where City = 'San Luis Potosi'
)
select SL.Consumer_ID, SL.Age, r.name
from SL
join ratings rt on SL.Consumer_ID = rt.Consumer_ID
join restaurants r on rt.Restaurant_ID = r.Restaurant_ID
join restaurant_cuisines rc on r.Restaurant_ID = rc.Restaurant_ID
where rc.Cuisine = 'Mexican'
  and rt.Overall_Rating = 2;

-- 2 Avg age per occupation (only consumers who have rated)
with RatedConsumers as (
    select distinct Consumer_ID
    from ratings
)
select c.Occupation, avg(c.Age) as Avg_Age
from consumers c
join RatedConsumers rc on c.Consumer_ID = rc.Consumer_ID
group by c.Occupation;

-- 3 Ranking ratings for Cuernavaca restaurants
with CTE as (
    select rt.Restaurant_ID, rt.Consumer_ID, rt.Overall_Rating
    from ratings rt
    join restaurants r on r.Restaurant_ID = rt.Restaurant_ID
    where r.City = 'Cuernavaca'
)
select rank() over (partition by Restaurant_ID order by Overall_Rating desc) as RatingRank
from CTE;

-- 4 Show rating + consumer’s overall average
with CTE as (
    select Consumer_ID, avg(Overall_Rating) as AvgOverall
    from ratings
    group by Consumer_ID
)
select rt.Consumer_ID, rt.Restaurant_ID, rt.Overall_Rating, CTE.AvgOverall
from ratings rt
join CTE on rt.Consumer_ID = CTE.Consumer_ID;

-- 5 Top 3 preferred cuisines for low-budget students
with StudentLow as (
    select Consumer_ID
    from consumers
    where Occupation = 'Student' and Budget = 'Low'
),
Prefs as (
    select cp.Consumer_ID, cp.Preferred_Cuisine,
           row_number() over (partition by cp.Consumer_ID order by cp.Preferred_Cuisine) as rn
    from consumer_preferences cp
    join StudentLow sl on sl.Consumer_ID = cp.Consumer_ID
)
select *from Prefs where rn <= 3;

-- 6 “Next restaurant rated” by U1008
with U as (
    select Restaurant_ID, Overall_Rating,
           lead(Overall_Rating) over (order by Restaurant_ID) as Next_Rating
    from ratings
    where Consumer_ID = 'U1008'
)
select * from U;

-- 7 View HighlyRatedMexicanRestaurants
create view HighlyRatedMexicanRestaurants as
select r.Restaurant_ID, r.name, r.City
from restaurants r
join restaurant_cuisines rc on r.Restaurant_ID = rc.Restaurant_ID
join ratings rt on r.Restaurant_ID = rt.Restaurant_ID
where rc.Cuisine = 'Mexican'
group by r.Restaurant_ID, r.name, r.City
having avg(rt.Overall_Rating) > 1.5;

-- 8 CTE to list Mexican-preferring consumers who have NOT rated highly-rated Mexican restaurants
with MexConsumers as (
    select Consumer_ID
    from consumer_preferences
    where Preferred_Cuisine = 'Mexican'
)
select mc.Consumer_ID
from MexConsumers mc
where mc.Consumer_ID not in (
    select distinct Consumer_ID
    from ratings rt
    join HighlyRatedMexicanRestaurants hr
        on rt.Restaurant_ID = hr.Restaurant_ID
);

-- 9 Stored Procedure: GetRestaurantRatingsAboveThreshold
DELIMITER //
create procedure GetRestaurantRatingsAboveThreshold(
    in restID VARCHAR(10),
    in minRating INT
)
begin
    select Consumer_ID, Overall_Rating, Food_Rating, Service_Rating
    from ratings
    where Restaurant_ID = restID
      and Overall_Rating >= minRating;
end //
DELIMITER ;

-- 10 Top 2 highest-rated restaurants per cuisine
with CTE as (
    select rc.Cuisine, r.name, r.City, rt.Overall_Rating,
           dense_rank() over (partition by rc.Cuisine order by rt.Overall_Rating desc) as rk
    from restaurant_cuisines rc
    join restaurants r on r.Restaurant_ID = rc.Restaurant_ID
    join ratings rt on rt.Restaurant_ID = r.Restaurant_ID
)
select *
from CTE
where rk <= 2;

-- 11 View ConsumerAverageRatings + CTE to find top 5
-- View:
create view ConsumerAverageRatings as
select Consumer_ID, avg(Overall_Rating) as AvgRating
from ratings
group by Consumer_ID;

-- CTE:
with Top5 as (
    select Consumer_ID, AvgRating
    from ConsumerAverageRatings
    order by AvgRating desc
    limit 5
)
select T.Consumer_ID, T.AvgRating,
       count(*) as MexicanRestaurantsRated
from Top5 T
join ratings rt on T.Consumer_ID = rt.Consumer_ID
join restaurant_cuisines rc on rt.Restaurant_ID = rc.Restaurant_ID
where rc.Cuisine = 'Mexican'
group by T.Consumer_ID, T.AvgRating;

-- 12 Stored Procedure: Consumer Segment + Restaurant Performance
DELIMITER //
create procedure GetConsumerSegmentAndRestaurantPerformance(IN cid VARCHAR(10))
begin
    select 
        r.name as Restaurant_Name,
        rt.Overall_Rating,
        avg_table.Avg_Restaurant_Rating,
        case 
            when rt.Overall_Rating > avg_table.Avg_Restaurant_Rating then 'Above Average'
            when rt.Overall_Rating = avg_table.Avg_Restaurant_Rating then 'At Average'
            else 'Below Average'
        end as Performance_Flag,
        rank() over (order by rt.Overall_Rating desc)as RankGiven
    from ratings rt
    join restaurants r on r.Restaurant_ID = rt.Restaurant_ID
    join (
        select Restaurant_ID, avg(Overall_Rating) as Avg_Restaurant_Rating
        from ratings
        group by Restaurant_ID
    ) as avg_table on avg_table.Restaurant_ID = r.Restaurant_ID
    where rt.Consumer_ID = cid;
end //
DELIMITER ;