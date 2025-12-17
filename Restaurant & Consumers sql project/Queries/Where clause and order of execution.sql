-- Questions Emphasizing WHERE Clause and Order of Execution

-- 1 Students who rated more than 2 restaurants
select Consumer_ID, count(Restaurant_ID) as Total_Rated
from ratings
where Consumer_ID in (
    select Consumer_ID from consumers where Occupation = 'Student'
)
group by Consumer_ID
having count(Restaurant_ID) > 2;

-- 2 Engagement Score = Age DIV 10
select consumer_id, Transportation_Method, age,floor(age/10) as engagement_score from consumers
where floor(age/10)=2 and Transportation_Method='public';

-- 3 Avg Overall_Rating for restaurants in Cuernavaca > 1
select r.name, r.city, avg_table.avg_rating
from restaurants r
join (
    select Restaurant_ID, avg(Overall_Rating) as Avg_Rating
    from ratings group by Restaurant_ID
) as avg_table on r.Restaurant_ID = avg_table.Restaurant_ID
where r.City = 'Cuernavaca' and avg_table.Avg_Rating > 1.0;

-- 4 Married consumers whose Food_Rating = Service_Rating and Overall_Rating = 2
select distinct c.Consumer_ID, c.Age, c.Marital_Status
from consumers c
join ratings rt on c.Consumer_ID = rt.Consumer_ID
where c.Marital_Status = 'Married'
  and rt.Overall_Rating = 2
  and rt.Food_Rating = rt.Service_Rating;

-- 5 Employed consumers who gave Food_Rating = 0 to Cuidad Victoria restaurants
select distinct c.Consumer_ID, c.Age, r.name
from consumers c
join ratings rt on c.Consumer_ID = rt.Consumer_ID
join restaurants r on rt.Restaurant_ID = r.Restaurant_ID
where c.Occupation = 'Employed'
  and rt.Food_Rating = 0
  and r.City = 'Ciudad Victoria';