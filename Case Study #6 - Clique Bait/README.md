
# Introduction

Clique Bait is not like your regular online seafood store - the founder and CEO Danny, was also a part of a digital data analytics team and wanted to expand his knowledge into the seafood industry!

In this case study - you are required to support Danny’s vision and analyse his dataset and come up with creative solutions to calculate funnel fallout rates for the Clique Bait online store.

# Problem Statement
Danny wants to use the data to answer a few simple questions about his campaign success customers purchase behaviour, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.


# Datasets
For this case study there is a total of 5 datasets which you will need to combine to solve all of the questions.

* Users:For this case study there is a total of 5 datasets which you will need to combine to solve all of the questions.
* Events: Customer visits are logged in this events table at a cookie_id level and the event_type and page_id values can be used to join onto relevant satellite tables to obtain further information about each event.
* Event Identifier: The event_identifier table shows the types of events which are captured by Clique Bait’s digital data systems.
* Campaign Identifier: This table shows information for the 3 campaigns that Clique Bait has ran on their website so far in 2020.
* Page Hierarchy: This table lists all of the pages on the Clique Bait website which are tagged and have data passing through from user interaction events.

# Case Study questions

## Digital Analysis


1. How many users are there?
2. How many cookies does each user have on average?
3. What is the unique number of visits by all users per month?
4. What is the number of events for each event type?
5. What is the percentage of visits which have a purchase event?
6. What is the percentage of visits which view the checkout page but do not have a purchase event?
7. What are the top 3 pages by number of views?
8. What is the number of views and cart adds for each product category?
9. What are the top 3 products by purchases?


## Product Funnel Analysis

Using a single SQL query - create a new output table which has the following details:

* How many times was each product viewed?
* How many times was each product added to cart?
* How many times was each product added to a cart but not purchased (abandoned)?
* How many times was each product purchased?
* Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.

Use your 2 new output tables - answer the following questions:

1. Which product had the most views, cart adds and purchases?
2. Which product was most likely to be abandoned?
3. Which product had the highest view to purchase percentage?
4. What is the average conversion rate from view to cart add?
5. What is the average conversion rate from cart add to purchase?

## Campign Analysis

Generate a table that has 1 single row for every unique visit_id record and has the following columns:

* user_id
* visit_id
* visit_start_time: the earliest event_time for each visit
* page_views: count of page views for each visit
* cart_adds: count of product cart add events for each visit
* purchase: 1/0 flag if a purchase event exists for each visit
* campaign_name: map the visit to a campaign if the visit_start_time falls between the start_date and end_date
* impression: count of ad impressions for each visit
* click: count of ad clicks for each visit
* (Optional column) cart_products: a comma separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the sequence_number)



Click [here] (https://github.com/Roshan-P9/8-week-SQL-Challenege/blob/main/Case%20Study%20%236%20-%20Clique%20Bait/clique%20bait%20solution.sql) to view the solution solution of the case study!


