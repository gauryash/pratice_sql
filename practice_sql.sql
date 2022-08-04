Dataset_link=https://techtfq.com/s/Olympics_data.zip
site_link= https://techtfq.com/blog/practice-writing-sql-queries-using-real-dataset

SQL Queries:

1. How many olympics games have been held?

Problem Statement: Write a SQL query to find the total no of Olympic Games held as per the dataset.

code - select count(distinct(games)) from olympic_table

2. List down all Olympics games held so far.

Problem Statement: Write a SQL query to list down all the Olympic Games held so far.

code - select distinct year , season, city from olympic_table order by year

3. Mention the total no of nations who participated in each olympics game?

Problem Statement: SQL query to fetch total no of countries participated in each olympic games.

code - select games,count(distinct(noc)) as total_countries 
from olympic_table
group by games
order by total_countries

4. Which year saw the highest and lowest no of countries participating in olympics

Problem Statement: Write a SQL query to return the Olympic Games which had the highest participating countries and the 
lowest participating countries.

5. Which nation has participated in all of the olympic games

Problem Statement: SQL query to return the list of countries who have been part of every Olympics games.

code- (select region_game.region,count(distinct(region_game.games)) as freq from (select noc_region.noc,noc_region.region,olympic_table.games
from olympic_table
right join noc_region on olympic_table.noc=noc_region.noc) AS region_game  
group by region_game.region
order by 2 desc
limit 4)

6. Identify the sport which was played in all summer olympics.

Problem Statement: SQL query to fetch the list of all sports which have been part of every olympics.

code - with q1 as

(select sport ,count( distinct(games)) as freq_games from olympic_table
 where season = 'Summer'
 group by sport
 order by 2 desc),

q2 as

(select count (distinct games) as total_games
 from olympic_table
 where season ='Summer'
 order by 1)

select * from q1
join q2 on q1.freq_games=q2.total_games

7. Which Sports were just played only once in the olympics.

Problem Statement: Using SQL query, Identify the sport which were just played once in all of olympics.

code - with q1 as (
select sport, count(distinct(games)) as freq from olympic_table
group by sport
order by freq ),

q2 as (
select min(freq) as min_val from q1)

select * from q1
join q2 on q1.freq=q2.min_val

8. Fetch the total no of sports played in each olympic games.

Problem Statement: Write SQL query to fetch the total no of sports played in each olympics.

code - select games,count(distinct(sport)) as no_of_sports
from olympic_table
group by games
order by no_of_sports desc

9. Fetch oldest athletes to win a gold medal

Problem Statement: SQL Query to fetch the details of the oldest athletes to win a gold medal at the olympics.

code -  with q1 as 
(select name,sex,age,team,sport,medal,year from olympic_table
where medal = 'Gold'
order by age desc),
q2 as
(select distinct(age) from olympic_table

order by age desc)

select * from q1
join q2 on q1.age=q2.age

10. Find the Ratio of male and female athletes participated in all olympic games.

Problem Statement: Write a SQL query to get the ratio of male and female participants

code- with male_count as 
(select count(sex) as male_count,games from olympic_table
where sex='M'
group by games),

female_count as 
(select count(sex) as female_count,games from olympic_table
where sex='F'
group by games)

select * from male_count
join female_count on male_count.games=female_count.games

11. Fetch the top 5 athletes who have won the most gold medals.

Problem Statement: SQL query to fetch the top 5 athletes who have won the most gold medals. 

code - select name , team , count(medal) as medal from olympic_table
where medal ='Gold'
group by name,team
order by medal desc

12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

Problem Statement: SQL Query to fetch the top 5 athletes who have won the most medals (Medals include gold, silver and bronze).

with q1 as 
(select name , team , count(medal) as Total_medal from olympic_table
 where medal in ('Gold','Silver','Bronze')
group by name,team
order by Total_medal desc),

q2 as (
    select * , dense_rank() over(order by total_medal desc ) as rank
    from q1)
select * from q2
where rank <=5;


13. Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.

Problem Statement: Write a SQL query to fetch the top 5 most successful countries in olympics. (Success is defined by no of medals won).
with q1 as(
    select noc_region.region,count(medal) as total_medal
    from olympic_table
    join noc_region on olympic_table.noc=noc_region.noc
    where medal in ('Gold','Silver','Bronze')
    group by noc_region.region
    order by total_medal desc),

q2 as (
    select * , dense_rank() over(order by total_medal desc)
    from q1)
select * from q2
where dense_rank <=5;

14. List down total gold, silver and bronze medals won by each country.

Problem Statement: Write a SQL query to list down the  total gold, silver and bronze medals won by each country.
with gold as 
(select noc_region.region,count(medal) as gold from olympic_table
join noc_region on olympic_table.noc=noc_region.noc
where medal ='Gold'
group by noc_region.region
order by gold desc),

silver as (
    select noc_region.region,count(medal) as silver from olympic_table
    join noc_region on olympic_table.noc=noc_region.noc
    where medal ='Silver'
    group by noc_region.region
    order by silver desc
),
bronze as (
    select noc_region.region,count(medal) as bronze from olympic_table
    join noc_region on olympic_table.noc=noc_region.noc
    where medal ='Bronze'
    group by noc_region.region
    order by bronze desc
)

select * from ((gold
left join silver on gold.region=silver.region)
left join bronze on gold.region=bronze.region)
order by gold desc

15. List down total gold, silver and bronze medals won by each country corresponding to each olympic games.

Problem Statement: Write a SQL query to list down the  total gold, silver and bronze medals won by each country corresponding to each olympic games.
