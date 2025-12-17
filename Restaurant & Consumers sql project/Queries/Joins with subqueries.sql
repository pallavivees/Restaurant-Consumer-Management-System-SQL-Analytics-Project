-- Questions JOINs with Subqueries

-- 1 Restaurants with Overall_Rating = 2
select r.Name, r.City
from restaurants r
where r.Restaurant_ID IN (
    select Restaurant_ID
    from ratings
    where Overall_Rating = 2
);

-- 2 Consumer_ID and Age of consumers who rated restaurants in San Luis Potosi
select distinct c.Consumer_ID, c.Age
from consumers c
where c.Consumer_ID IN (
    select Consumer_ID
    from ratings
    where Restaurant_ID IN (
        select Restaurant_ID
        from restaurants
        where City = 'San Luis Potosi'
    )
);

-- 3 Names of restaurants serving Mexican cuisine & rated by U1003
select distinct rs.name
from ratings r
join restaurant_cuisines rc on r.Restaurant_ID = rc.Restaurant_ID
join restaurants rs on r.Restaurant_ID = rs.Restaurant_ID
where r.Consumer_ID = 'U1003'
  and rc.Cuisine = 'Mexican';
  
-- 4 Consumers who prefer American AND have Medium budget
select distinct *
from consumers
where Consumer_ID in (
      select Consumer_ID
      from consumer_preferences
      where Preferred_Cuisine = 'American'
  ) and Budget = 'Medium' ;
  
-- 5 Restaurants with Food_Rating lower than avg Food_Rating
-- join
select distinct r.name, r.City
from restaurants r
join ratings rt on r.Restaurant_ID = rt.Restaurant_ID
where rt.Food_Rating < (
    select avg(Food_Rating)
    from ratings
);

-- suquery
SELECT Name, City
FROM restaurants
WHERE Restaurant_ID IN (
    SELECT Restaurant_ID
    FROM ratings
    GROUP BY Restaurant_ID 
    HAVING AVG(Food_Rating) < (
        SELECT AVG(Food_Rating)
        FROM ratings
    )
);

-- 6 Consumers who rated at least 1 restaurant but NOT any Italian restaurants
select c.Consumer_ID, c.Age, c.Occupation
from consumers c
where c.Consumer_ID in (select distinct Consumer_ID from ratings)
  and c.Consumer_ID not in (
      select distinct rt.Consumer_ID
      from ratings rt
      join restaurant_cuisines rc on rt.Restaurant_ID = rc.Restaurant_ID
      where rc.Cuisine = 'Italian'
  );
  
-- 7 Restaurants rated by consumers older than 30
select distinct r.name
from restaurants r
join ratings rt ON r.Restaurant_ID = rt.Restaurant_ID
join consumers c ON c.Consumer_ID = rt.Consumer_ID
where c.Age > 30;

-- 8 Mexican-preferring consumers who gave Overall_Rating = 0 somewhere
select distinct c.Consumer_ID, c.Occupation
from consumers c
where c.Consumer_ID IN (
    select Consumer_ID
    from consumer_preferences
    where Preferred_Cuisine = 'Mexican'
)
and c.Consumer_ID IN (
    select Consumer_ID
    from ratings
    where Overall_Rating = 0
);

-- 9 Pizzeria restaurants in cities where at least one Student lives
select distinct r.name, r.City
from restaurants r
join restaurant_cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
where rc.Cuisine = 'Pizzeria'
  and r.City IN (
      select distinct City
      from consumers
      where Occupation = 'Student'
  );
  
-- 10 Social Drinkers who rated restaurants with No Parking
select distinct c.Consumer_ID, c.Age
from consumers c
join ratings rt ON c.Consumer_ID = rt.Consumer_ID
join restaurants r ON rt.Restaurant_ID = r.Restaurant_ID
where c.Drink_level = 'Social Drinker' and r.Parking = 'None';