
# Introduction

Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

# Problem Statement
Danny wants to use the data to answer a few simple questions to identify which pizza is the hot selling, mostly used toppings and extras in the pizza, customers purchase behaviour, especially about their order patterns, how much money they’ve spent and also which menu items are their favourite.
Apart from that he wants to get some insights about the runners to incentivize them based on their perfomance and also calculate the delivery costs for each order.
Having this deeper connection with his customers and runners will help him deliver a better and more personalised experience for his loyal customers.


# Datasets
For this case study there is a total of 5 datasets which you will need to combine to solve all of the questions.

* Users:For this case study there is a total of 5 datasets which you will need to combine to solve all of the questions.
* Events: Customer visits are logged in this events table at a cookie_id level and the event_type and page_id values can be used to join onto relevant satellite tables to obtain further information about each event.
* Event Identifier: The event_identifier table shows the types of events which are captured by Clique Bait’s digital data systems.
* Campaign Identifier: This table shows information for the 3 campaigns that Clique Bait has ran on their website so far in 2020.
* Page Hierarchy: This table lists all of the pages on the Clique Bait website which are tagged and have data passing through from user interaction events.

# Data Cleaning
Before starting the analysis some of the tables needs to be cleaned. Let's start with the Customer_order Table

The Extras and Exclusion column are having null and NaN values
which i will replace with blank values


<img width="309" alt="Screenshot 2023-10-09 200811" src="https://github.com/Roshan-P9/Pizza_runner_case_study/assets/129484442/0696baff-91ef-46d8-902a-b958af393089">


After replacing all the null and NaN values with
blank values the table is now ready to be used in our queries

<img width="465" alt="q1" src="https://github.com/Roshan-P9/Pizza_runner_case_study/assets/129484442/3389d341-e832-4cb9-98ea-d7f4da49d32a">

Runner_orders Table e is also having null and NaN values which need to be replaced with
blank values.
As you can also see that Distance column Is having data km but we need to
remove the units to make some calculations.
We will also remove minutes from the duration column.

<img width="458" alt="Screenshot 2023-10-09 200753" src="https://github.com/Roshan-P9/Pizza_runner_case_study/assets/129484442/0f729465-3b3e-49bd-b911-25f2e0c9f2bf">
<br>`
<br>`
<br>`
<br>`
<img width="370" alt="Screenshot 2023-10-09 201739" src="https://github.com/Roshan-P9/Pizza_runner_case_study/assets/129484442/f758e4f1-12d4-44de-9165-fbf0705c0af6">

After replacing all the null and NaN values with
blank values the table is now ready to be used in
our queries


 <img width="378" alt="Q2" src="https://github.com/Roshan-P9/Pizza_runner_case_study/assets/129484442/d4642e74-895f-4a62-a474-28994c065d3e">
<br>`
<br>`
<br>`
<br>`
<img width="462" alt="Screenshot 2023-10-09 201250" src="https://github.com/Roshan-P9/Pizza_runner_case_study/assets/129484442/eaa77d3a-6e91-4879-9c9f-f8bc034653a0">


# Case Study questions

This case study has LOTS of questions - they are broken up by area of focus including:

Pizza Metrics
Runner and Customer Experience
Ingredient Optimisation
Pricing and Ratings
Bonus DML Challenges (DML = Data Manipulation Language)
Each of the following case study questions can be answered using a single SQL statement.

Again, there are many questions in this case study - please feel free to pick and choose which ones you’d like to try!

Before you start writing your SQL queries however - you might want to investigate the data, you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables!

##  Pizza Metrics

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?




##  Runner and Customer Experience

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

## Ingredient Optimisation

1. What are the standard ingredients for each pizza?
2. What was the most commonly added extra?
3. What was the most common exclusion?
4. Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

## Pricing and Ratings

1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

## Bonus Questions
If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?




Click [here]([https://github.com/Roshan-P9/Pizza_runner_case_study/blob/main/pizza_runner%20challenge.sql](https://github.com/Roshan-P9/8-week-SQL-Challenege/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/Pizza%20runner%20solution.sql)https://github.com/Roshan-P9/8-week-SQL-Challenege/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/Pizza%20runner%20solution.sql) to view the solution solution of the case study!


