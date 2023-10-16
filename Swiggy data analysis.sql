USE sql_project_1;

SELECT * FROM swiggy;

-- QUESTIONS

-- 01 HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?

select distinct restaurant_name as high_rated_restaurants
from swiggy
where rating > 4.5;

select count(distinct restaurant_name) as high_rated_restaurants
from swiggy
where rating > 4.5;

-- 02 WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?

select city, count(distinct restaurant_name) as restaurant_count
from swiggy
group by city
order by restaurant_count desc
limit 1;

-- 03 HOW MANY RESTAURANTS SELL( HAVE WORD "PIZZA" IN THEIR NAME)?

select distinct restaurant_name as pizza_restaurants
from swiggy
where restaurant_name like '%pizza%';

select count(distinct restaurant_name) as pizza_restaurants
from swiggy 
where restaurant_name like '%Pizza%';


-- 04 WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?

select cuisine, count(*) as cuisine_count
from swiggy
group by cuisine
order by cuisine_count desc
limit 1;


-- 05 WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?

select city, avg(rating) as avg_rating 
from swiggy
group by city;

-- 06 WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?

select distinct restaurant_name, menu_category, max(price) as highest_price
from swiggy
where menu_category = 'recommended'
group by restaurant_name, menu_category;


-- 07 FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE. 

select distinct restaurant_name, cost_per_person
from swiggy
where cuisine <> 'Indian'
order by cost_per_person desc
limit 5;


/* 08 FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL    
   RESTAURANTS TOGETHER. */
   
   
select distinct restaurant_name, cost_per_person
from swiggy
where cost_per_person > (select avg(cost_per_person) from swiggy);

                            
-- 09 WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?

select distinct restaurant_name, menu_category, count(item) as no_of_items 
from swiggy
where menu_category = 'Main course'
group by restaurant_name, menu_category
order by no_of_items desc
limit 1;


-- 10 LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME

select distinct restaurant_name, 
(count(case when veg_or_nonveg = 'veg' then 1 end )*100/count(*)) as vegetarian_percentage
from swiggy
group by restaurant_name
having vegetarian_percentage = 100.00
order by restaurant_name;

-- 11 WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?

select distinct restaurant_name, avg(price) as avg_price 
from swiggy
group by restaurant_name
order by avg_price
limit 1;

-- 12 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?

select distinct restaurant_name,
count(distinct menu_category) as no_of_categories
from swiggy
group by restaurant_name
order by no_of_categories desc 
limit 5;


-- 13 WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?

select distinct restaurant_name, 
(count(case when veg_or_nonveg = 'non-veg' then 1 end )*100/count(*)) as non_vegetarian_percentage
from swiggy
group by restaurant_name
order by non_vegetarian_percentage desc
limit 1;


-- 14 Determine the Most Expensive and Least Expensive Cities for Dining:

with CityExpense as (
    select city,
        max(cost_per_person) as max_cost,
        min(cost_per_person) as min_cost
    from swiggy
    group by city
)
select city,max_cost,min_cost
from CityExpense
order by max_cost desc;

-- 15 Calculate the Rating Rank for Each Restaurant Within Its City

with RatingRankByCity as (
    select distinct
        restaurant_name,
        city,
        rating,
        dense_rank() over (partition by city order by rating desc) as rating_rank
    from swiggy
)
select
    restaurant_name,
    city,
    rating,
    rating_rank
from RatingRankByCity
where rating_rank = 1;
