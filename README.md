# Restaurant-Consumer-Management-System-SQL-Analytics-Project
A SQL-based Restaurant & Consumer Management System analyzing customer behavior, restaurant performance, cuisines, and ratings. Includes schema design, ER diagram, joins, subqueries, CTEs, window functions, views, and stored procedures to generate meaningful insights and trends.

---

## 📊 Dataset Description
- **consumers.csv** – Age, city, occupation, habits  
- **restaurants.csv** – Restaurant details, price, parking, alcohol service  
- **ratings.csv** – Food, service & overall ratings  
- **restaurant_cuisines.csv** – Type of cuisine per restaurant  
- **consumer_preferences.csv** – Preferred cuisine & budget

---

## 🗄️ Database Schema
- Consumers  
- Restaurants  
- Ratings  
- Consumer Preferences  
- Restaurant Cuisines  

ER diagram included in **schema/ER Diagram.png**

---

## 🔍 Key SQL Features Covered
✔ WHERE, AND, OR filters  
✔ INNER JOIN, LEFT JOIN, subqueries  
✔ GROUP BY, HAVING, ORDER BY  
✔ CTE (WITH clause)  
✔ Window functions  
✔ Views  
✔ Stored Procedures  
✔ Ranking & analytics queries  

---

## 📈 Sample Insights

Top-rated restaurants per cuisine

Consumers who prefer Mexican cuisine but gave low ratings

Restaurants below average food rating

Age-based consumer segmentation

Cuisines preferred by low-budget students

---

## 📝 How to Run
1. Open MySQL Workbench  
2. Create database:
```sql
CREATE DATABASE retro;
USE retro;
```
3. Import all the CSV files and run them:
``` files
select * from consumer_preferences;
select * from consumers;
select * from ratings;
select * from restaurant_cuisines;
select * from restaurants;
```
4. Execute all the queries and ER diagram using relationships. 
