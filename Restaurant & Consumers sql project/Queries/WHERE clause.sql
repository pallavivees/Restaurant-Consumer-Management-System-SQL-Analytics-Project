-- Using the WHERE clause to filter data based on specific criteria.
 
 -- 1 List all details of consumers who live in 'Cuernavaca'.
 select *from consumers where city='Cuernavaca';
 
 -- 2 Find the Consumer_ID, Age, and Occupation of consumers who are 'Students' AND are 'Smokers'.
 select consumer_id, age, occupation, smoker from consumers where occupation= 'Student' AND smoker='Yes';
 
 -- 3 List the Name, City, Alcohol_Service, and Price of restaurants that serve 'Wine & Beer' and have 'Medium' price level.
 select name, city, alcohol_service, price from restaurants where alcohol_service='Wine & Beer' and price='Medium';
 
-- 4 Find the names and cities of all restaurants that are part of a 'Franchise'.
select name, city, Franchise from restaurants where Franchise='Yes';

-- 5 Show Consumer_ID, Restaurant_ID, and Overall_Rating where rating is 'Highly Satisfactory' (value = 2).
select consumer_id, restaurant_id, overall_rating from ratings where overall_rating=2;