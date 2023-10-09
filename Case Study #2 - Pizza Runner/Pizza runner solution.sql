-- A. Pizza Metrics

-- 1.	How many pizzas were ordered?

SELECT 
    COUNT(1) AS Total_orders
FROM
    customer_orders;

-- 2.	How many unique customer orders were made?

SELECT 
    COUNT(DISTINCT customer_id) AS total_customers
FROM
    customer_orders;

-- 3.	How many successful orders were delivered by each runner?

SELECT 
    runner_id, COUNT(1) AS total_deliveries
FROM
    runner_orders
WHERE
    distance != ''
GROUP BY runner_id;

-- 4.	How many of each type of pizza was delivered?

SELECT 
    pizza_name, COUNT(1) AS total_orders_deliverd
FROM
    customer_orders AS c
        JOIN
    runner_orders AS r ON r.order_id = c.order_id
        JOIN
    pizza_names AS p ON p.pizza_id = c.pizza_id
WHERE
    r.distance != ''
GROUP BY pizza_name;

-- 5.	How many Vegetarian and Meatlovers were ordered by each customer?

SELECT 
    c.customer_id, p.pizza_name, COUNT(1) AS total_orders
FROM
    customer_orders AS c
        JOIN
    pizza_names AS p ON p.pizza_id = c.pizza_id
GROUP BY c.customer_id , p.pizza_name
ORDER BY c.customer_id;

-- 6.	What was the maximum number of pizzas delivered in a single order?

SELECT 
    r.order_id, COUNT(1) AS total_orders_deliverd
FROM
    customer_orders AS c
        JOIN
    runner_orders AS r ON r.order_id = c.order_id
WHERE
    r.distance != ''
GROUP BY r.order_id
ORDER BY total_orders_deliverd DESC
LIMIT 1;

-- 7.	For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT 
  c.customer_id
  ,SUM(
    CASE WHEN c.exclusions != '' OR c.extras != '' THEN 1
    ELSE 0
    END) AS at_least_1_change,
  SUM(
    CASE WHEN c.exclusions = '' AND c.extras = '' THEN 1 
    ELSE 0
    END) AS no_change
FROM customer_orders AS c
JOIN runner_orders AS r
  ON c.order_id = r.order_id
WHERE r.duration != ''
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- 8.	How many pizzas were delivered that had both exclusions and extras?
SELECT 
    c.customer_id,
    SUM(CASE
        WHEN c.exclusions != '' AND c.extras != '' THEN 1
        ELSE 0
    END) AS at_least_1_change
FROM
    customer_orders AS c
        JOIN
    runner_orders AS r ON c.order_id = r.order_id
WHERE
    r.duration != ''
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- 9.	What was the total volume of pizzas ordered for each hour of the day?

SELECT 
    DATE(order_time) AS Dt,
    HOUR(order_time) AS Hr,
    COUNT(1) AS total_orders
FROM
    customer_orders
GROUP BY Dt , Hr;

-- 10.	What was the volume of orders for each day of the week?

WITH orders_by_day AS (
SELECT
	COUNT(order_id) AS order_count,
	WEEKDAY(order_time) AS day
FROM customer_orders
GROUP BY day
ORDER BY day
)

SELECT	
	order_count,
    CASE 
	WHEN day = 0 THEN 'Monday'
		WHEN day = 1 THEN 'Tuesday'
	WHEN day = 2 THEN 'Wednesday'
	WHEN day = 3 THEN 'Thursday'
	WHEN day = 4 THEN 'Friday'
	WHEN day = 5 THEN 'Saturday'
	WHEN day = 6 THEN 'Sunday'
   END AS day
FROM orders_by_day;

-- B. Runner and Customer Experience

-- 1.	How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT 
    EXTRACT(WEEK FROM registration_date + 3) AS week_of_year,
    COUNT(1) AS total_signups
FROM
    runners
GROUP BY week_of_year;

-- 2.	What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT 
    r.runner_id,
    AVG(MINUTE(TIMEDIFF(r.pickup_time, c.order_time))) AS time_mins
FROM
    customer_orders AS c
        LEFT JOIN
    runner_orders AS r ON c.order_id = r.order_id
GROUP BY r.runner_id;

-- 3.	Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT 
    c.order_id,
    MINUTE(TIMEDIFF(r.pickup_time, c.order_time)) AS prep_time,
    COUNT(1) AS tot_pizzas
FROM
    customer_orders AS c
        JOIN
    runner_orders AS r ON r.order_id = c.order_id
WHERE
    r.distance <> ''
GROUP BY c.order_id , prep_time;


-- 4.	What was the average distance travelled for each customer?

SELECT 
    c.customer_id, ROUND(AVG(distance), 2) AS avg_distance
FROM
    customer_orders AS c
        JOIN
    runner_orders AS r ON r.order_id = c.order_id
WHERE
    distance <> ''
GROUP BY c.customer_id;

-- 5.	What was the difference between the longest and shortest delivery times for all orders?

SELECT 
    MAX(duration) - MIN(duration) AS time_diff
FROM
    runner_orders
WHERE
    distance <> '';

-- 6.	What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT 
    order_id,
    runner_id,
    ROUND(AVG(distance / (duration / 60)), 2) AS speed
FROM
    runner_orders
WHERE
    distance <> ''
GROUP BY order_id , runner_id;

-- 7.	What is the successful delivery percentage for each runner?

SELECT 
    runner_id,
    ROUND(100 * SUM(CASE
                WHEN cancellation = '' THEN 1
                ELSE 0
            END) / COUNT(1),
            2) AS delivery_percent
FROM
    runner_orders
GROUP BY runner_id;

-- C. Ingredient Optimisation

-- 1.	What are the standard ingredients for each pizza?

SELECT 
    p.pizza_name, GROUP_CONCAT(t.topping_name) AS ingredients
FROM
    pizza_names AS p
        JOIN
    pizza_recipes_temp AS r ON r.pizza_id = p.pizza_id
        JOIN
    pizza_toppings AS t ON t.topping_id = r.toppings
GROUP BY p.pizza_name;

-- 2.	What was the most commonly added extra?

with ct as
(
select t.topping_name as most_common_extras, count(1)  as count_extras
from cust_orders_extras as c
join pizza_toppings as t
on t.topping_id= c.extras
where c.extras <> ''
group by t.topping_name
order by count_extras desc
limit 1)
select most_common_extras from ct;

-- 3.	What was the most common exclusion?

with ct as
(
select t.topping_name as most_common_exclusions, count(1)  as count_exclusions
from cust_orders_exclusions as c
join pizza_toppings as t
on t.topping_id= c.exclusions
where c.exclusions <> ''
group by t.topping_name
order by count_exclusions desc
limit 1)

select most_common_exclusions from ct;

-- 4.	Generate an order item for each record in the customers_orders table in the format of one of the following:
-- o	Meat Lovers
-- o	Meat Lovers - Exclude Beef
-- o	Meat Lovers - Extra Bacon
-- o	Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

with ct as(
select c.order_id, c.customer_id, p.pizza_name,
c.exclusions,c.extras,t.topping_name as minus,
b.topping_name as plus from customer_orders as c
join pizza_names as p
on p.pizza_id= c.pizza_id
left join pizza_toppings as t
on c.exclusions = t.topping_id
left join pizza_toppings as b
on c.extras=b.topping_id)
select order_id, case when pizza_name is not null and minus is null and plus is null then pizza_name 
when pizza_name is not null and minus is not null and plus is not null then concat(pizza_name, " - ", "Exclude ", minus, " - ", "Extra ", plus)
when pizza_name is not null and minus is not null and plus is  null then concat(pizza_name, " - ", "Exclude ", minus)
when pizza_name is not null and minus is null and plus is not null then concat(pizza_name, " - ", "Extra ", plus)
end  as order_item
from ct;

-- 5.	Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table 
-- and add a 2x in front of any relevant ingredients
-- o	For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
-- 6.	What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

SELECT 
    t.topping_name, COUNT(1) AS qty
FROM
    pizza_recipes_temp AS r
        JOIN
    pizza_toppings AS t ON t.topping_id = r.toppings
        JOIN
    customer_orders AS c ON c.pizza_id = r.pizza_id
        JOIN
    runner_orders AS ro ON ro.order_id = c.order_id
WHERE
    distance <> ''
GROUP BY t.topping_name
ORDER BY qty DESC;

-- D. Pricing and Ratings

-- 1.	If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes
--  - how much money has Pizza Runner made so far if there are no delivery fees?

with ct as 
(
select p.pizza_name,
 sum(case
when p.pizza_name = 'Meatlovers' then 12
else 10 end )  as price 
from customer_orders as c
join runner_orders as r
on r.order_id = c.order_id
join pizza_names as p 
on p.pizza_id = c.pizza_id
where r.distance <> ''
group by p.pizza_name)
select sum(price) as revenue from ct;

-- 2.-- 	What if there was an additional $1 charge for any pizza extras?
-- o	Add cheese is $1 extra

with ct as 
(
select p.pizza_name,
 sum(case
when p.pizza_name = 'Meatlovers' then 12
when pizza_name = 'Vegetarian' then 10 end )  as price,
sum(case
when c.extras != ''  then 1 
else 0 end )as e_price
from customer_orders as c
join runner_orders as r
on r.order_id = c.order_id
join pizza_names as p 
on p.pizza_id = c.pizza_id
where r.distance <> ''
group by p.pizza_name),
tot as(
select e_price+price as total  from ct)
select sum(total) as total_revenue from tot;

-- 3.	The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
-- how would you design an additional table for this new dataset
--  - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

create table customer_ratings; 

insert into customer_ratings 
values (1,5),(2,4),(3,3),(4,3),(5,3),(6,1),(7,5),(8,4),(9,3),(10,5);

select	 * from customer_ratings; 

-- 4.	Using your newly generated table - can you join all of the information together to form a table
--  which has the following information for successful deliveries?
-- o	customer_id
-- o	order_id
-- o	runner_id
-- o	rating
-- o	order_time
-- o	pickup_time
-- o	Time between order and pickup
-- o	Delivery duration
-- o	Average speed
-- o	Total number of pizzas

SELECT 
    c.customer_id,
    c.order_id,
    r.runner_id,
    rt.rating,
    c.order_time,
    r.pickup_time,
    MINUTE(TIMEDIFF(c.order_time, r.pickup_time)) AS order_pickup_time,
    r.duration,
    ROUND(AVG(60 * r.distance / r.duration), 1) AS avg_speed,
    COUNT(1) AS pizza_count
FROM
    customer_orders AS c
        JOIN
    runner_orders AS r ON r.order_id = c.order_id
        JOIN
    customer_ratings AS rt ON rt.order_id = c.order_id
WHERE
    r.distance <> ''
GROUP BY c.customer_id , c.order_id , r.runner_id , rt.rating , c.order_time , r.pickup_time , order_pickup_time , r.duration
ORDER BY c.order_id;

-- 5.	If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras 
-- and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?


SET @total_price_pizza = 138;
select @total_price_pizza - round((sum(distance) * 0.3),2) as final_price
from runner_orders;

select * from cust_orders_extras;
select * from cust_orders_exclusions
