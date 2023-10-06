select * from campaign_identifier;
select * from event_identifier;
select * from events;
select * from users;
select * from page_hierarchy;


-- 2. Digital Analysis

-- How many users are there?

SELECT 
    COUNT(DISTINCT user_id) AS total_users
FROM
    users;

-- How many cookies does each user have on average?

with ct as(
select user_id, count(cookie_id) as tot_cookies
from users
group by user_id)
select ceil(avg(tot_cookies)) as avg_cookies from ct;

-- What is the unique number of visits by all users per month?

SELECT 
    MONTH(event_time) AS Month,
    COUNT(DISTINCT visit_id) AS monthly_visits
FROM
    events
GROUP BY month;

-- What is the number of events for each event type?

select a.event_name, count(1) as tot_events from
events
join 
 event_identifier as a
 on events.event_type=a.event_type
 group by a.event_name;
 
-- What is the percentage of visits which have a purchase event?

SELECT 
    a.event_name,
    ROUND(100 * COUNT(1) / (SELECT 
                    COUNT(DISTINCT visit_id)
                FROM
                    events),
            2) AS tot_events
FROM
    events
        JOIN
    event_identifier AS a ON events.event_type = a.event_type
WHERE
    a.event_name = 'Purchase';

-- What is the percentage of visits which view the checkout page but do not have a purchase event?

with cte as(
select e.*,
i.event_name,
p.page_name,
p.product_id,
case when p.page_name like '%Checkout%' then e.visit_id end as viewed_checkout,
case when p.page_name like '%Confirmation%' then e.visit_id end as purchase
from events e
join event_identifier i on e.event_type = i.event_type
join page_hierarchy p on e.page_id = p.page_id

)
select 
count(viewed_checkout) as total_viewed_checkout,
count(purchase) as total_purchased, 
round(100 *(count(viewed_checkout) - count(purchase))/count(viewed_checkout), 2) as percentage
from cte;

-- What are the top 3 pages by number of views?

SELECT 
    p.page_name, COUNT(1) AS tot_events
FROM
    events AS e
        JOIN
    page_hierarchy AS p ON e.page_id = p.page_id
        JOIN
    event_identifier AS ei ON ei.event_type = e.event_type
WHERE
    ei.event_name = 'Page view'
GROUP BY p.page_name
ORDER BY tot_events DESC
LIMIT 3;

-- What is the number of views and cart adds for each product category?

SELECT 
    p.product_category,
    SUM(CASE
        WHEN ei.event_name = 'page view' THEN 1
        ELSE 0
    END) AS views,
    SUM(CASE
        WHEN ei.event_name = 'Add to cart' THEN 1
        ELSE 0
    END) AS cart_adds
FROM
    events AS e
        JOIN
    event_identifier AS ei ON ei.event_type = e.event_type
        JOIN
    page_hierarchy AS p ON p.page_id = e.page_id
where product_category is not null
GROUP BY p.product_category;





         -- 3. Campaigns Analysis
-- Using a single SQL query - create a new output table which has the following details:

-- How many times was each product viewed?
-- How many times was each product added to cart?
-- How many times was each product added to a cart but not purchased (abandoned)?
-- How many times was each product purchased?
-- Additionally, create another table which further aggregates the data for the above points but this 
-- time for each product category instead of individual products.

create view  page as
with ct as (
select e.visit_id,p.page_name,
sum(case when ei.event_name  = 'page view'
then 1 else 0 end) as views,
sum(case when  ei.event_name  = 'Add to cart'
then 1 else 0 end) as cart_adds
from events as e
join page_hierarchy as p
on p.page_id=e.page_id
join event_identifier as ei
on ei.event_type=e.event_type
where p.product_id is not null
group by p.page_name, e.visit_id),
ct2 as (
select e.visit_id as purchase_id
from events as e
join event_identifier as ei
on ei.event_type= e.event_type
where ei.event_name= 'Purchase'),
ct3 as(
select *, 
(case when purchase_id is not null then 1 else 0 end) as purchase
from ct left join ct2
on visit_id = purchase_id)
select page_name, sum(views) as Page_Views, sum(cart_adds) as Cart_Adds, 
sum(case when cart_adds = 1 and purchase = 0 then 1 else 0
	end) as product_abandoned,
sum(case when cart_adds= 1 and purchase = 1 then 1 else 0
	end) as Purchased
from ct3
group by page_name;

with ct as (
select e.visit_id,p.product_category,
sum(case when ei.event_name  = 'page view'
then 1 else 0 end) as views,
sum(case when  ei.event_name  = 'Add to cart'
then 1 else 0 end) as cart_adds
from events as e
join page_hierarchy as p
on p.page_id=e.page_id
join event_identifier as ei
on ei.event_type=e.event_type
where p.product_id is not null
group by p.product_category, e.visit_id),
ct2 as (
select e.visit_id as purchase_id
from events as e
join event_identifier as ei
on ei.event_type= e.event_type
where ei.event_name= 'Purchase'),
ct3 as(
select *, 
(case when purchase_id is not null then 1 else 0 end) as purchase
from ct left join ct2
on visit_id = purchase_id)
select product_category, sum(views) as Page_Views, sum(cart_adds) as Cart_Adds, 
sum(case when cart_adds = 1 and purchase = 0 then 1 else 0
	end) as product_abandoned,
sum(case when cart_adds= 1 and purchase = 1 then 1 else 0
	end) as Purchased
from ct3
group by product_category;


-- Use your 2 new output tables - answer the following questions:

-- Which product had the most views, cart adds and purchases?

with ct as (
select e.visit_id,p.page_name,
sum(case when ei.event_name  = 'page view'
then 1 else 0 end) as views,
sum(case when  ei.event_name  = 'Add to cart'
then 1 else 0 end) as cart_adds
from events as e
join page_hierarchy as p
on p.page_id=e.page_id
join event_identifier as ei
on ei.event_type=e.event_type
where p.product_id is not null
group by p.page_name, e.visit_id),
ct2 as (
select e.visit_id as purchase_id
from events as e
join event_identifier as ei
on ei.event_type= e.event_type
where ei.event_name= 'Purchase'),
ct3 as(
select *, 
(case when purchase_id is not null then 1 else 0 end) as purchase
from ct left join ct2
on visit_id = purchase_id),
product as(
select page_name, sum(views) as Page_Views, sum(cart_adds) as Cart_Adds, 
sum(case when cart_adds = 1 and purchase = 0 then 1 else 0
	end) as product_abandoned,
sum(case when cart_adds= 1 and purchase = 1 then 1 else 0
	end) as Purchased
from ct3
group by page_name)
select * from product
order by page_views desc, cart_adds desc, purchased desc;


-- Which product was most likely to be abandoned?


with ct as (
select e.visit_id,p.page_name,
sum(case when ei.event_name  = 'page view'
then 1 else 0 end) as views,
sum(case when  ei.event_name  = 'Add to cart'
then 1 else 0 end) as cart_adds
from events as e
join page_hierarchy as p
on p.page_id=e.page_id
join event_identifier as ei
on ei.event_type=e.event_type
where p.product_id is not null
group by p.page_name, e.visit_id),
ct2 as (
select e.visit_id as purchase_id
from events as e
join event_identifier as ei
on ei.event_type= e.event_type
where ei.event_name= 'Purchase'),
ct3 as(
select *, 
(case when purchase_id is not null then 1 else 0 end) as purchase
from ct left join ct2
on visit_id = purchase_id),
product as(
select page_name, sum(views) as Page_Views, sum(cart_adds) as Cart_Adds, 
sum(case when cart_adds = 1 and purchase = 0 then 1 else 0
	end) as product_abandoned,
sum(case when cart_adds= 1 and purchase = 1 then 1 else 0
	end) as Purchased
from ct3
group by page_name)
select page_name,product_abandoned  from product
order by product_abandoned desc;

-- Which product had the highest view to purchase percentage?

with ct as (
select e.visit_id,p.page_name,
sum(case when ei.event_name  = 'page view'
then 1 else 0 end) as views,
sum(case when  ei.event_name  = 'Add to cart'
then 1 else 0 end) as cart_adds
from events as e
join page_hierarchy as p
on p.page_id=e.page_id
join event_identifier as ei
on ei.event_type=e.event_type
where p.product_id is not null
group by p.page_name, e.visit_id),
ct2 as (
select e.visit_id as purchase_id
from events as e
join event_identifier as ei
on ei.event_type= e.event_type
where ei.event_name= 'Purchase'),
ct3 as(
select *, 
(case when purchase_id is not null then 1 else 0 end) as purchase
from ct left join ct2
on visit_id = purchase_id),
product as(
select page_name, sum(views) as Page_Views, sum(cart_adds) as Cart_Adds, 
sum(case when cart_adds = 1 and purchase = 0 then 1 else 0
	end) as product_abandoned,
sum(case when cart_adds= 1 and purchase = 1 then 1 else 0
	end) as Purchased
from ct3
group by page_name)
SELECT 
    page_name, 
  ROUND(100 * purchased/page_views,2) AS purchase_per_view_percentage
FROM product
ORDER BY purchase_per_view_percentage DESC;


-- What is the average conversion rate from view to cart add?
-- What is the average conversion rate from cart add to purchase?

with ct as (
select e.visit_id,p.page_name,
sum(case when ei.event_name  = 'page view'
then 1 else 0 end) as views,
sum(case when  ei.event_name  = 'Add to cart'
then 1 else 0 end) as cart_adds
from events as e
join page_hierarchy as p
on p.page_id=e.page_id
join event_identifier as ei
on ei.event_type=e.event_type
where p.product_id is not null
group by p.page_name, e.visit_id),
ct2 as (
select e.visit_id as purchase_id
from events as e
join event_identifier as ei
on ei.event_type= e.event_type
where ei.event_name= 'Purchase'),
ct3 as(
select *, 
(case when purchase_id is not null then 1 else 0 end) as purchase
from ct left join ct2
on visit_id = purchase_id),
product as(
select page_name, sum(views) as Page_Views, sum(cart_adds) as Cart_Adds, 
sum(case when cart_adds = 1 and purchase = 0 then 1 else 0
	end) as product_abandoned,
sum(case when cart_adds= 1 and purchase = 1 then 1 else 0
	end) as Purchased
from ct3
group by page_name)
SELECT 
round(100*avg(cart_adds/page_views),2) as avg_viewtocartadd_coversion,
round(100 * avg(purchased/cart_adds),2) as avg_cartaddto_purchase_coversion
FROM product;

          -- 3. Campaigns Analysis

-- Generate a table that has 1 single row for every unique visit_id record and has the following columns:

-- user_id
-- visit_id
-- visit_start_time: the earliest event_time for each visit
-- page_views: count of page views for each visit
-- cart_adds: count of product cart add events for each visit
-- purchase: 1/0 flag if a purchase event exists for each visit
-- campaign_name: map the visit to a campaign if the visit_start_time falls between the start_date and end_date
-- impression: count of ad impressions for each visit
-- click: count of ad clicks for each visit
-- (Optional column) cart_products: a comma separated text value with products 
-- added to the cart sorted by the order they were added to the cart (hint: use the sequence_number)

select * from users;
with ct as(
select  e.visit_id,u.user_id,
c.campaign_name,
min(e.event_time) as earliest_entry,
sum(case when ei.event_name  = 'page view'
then 1 else 0 end) as views,
sum(case when  ei.event_name  = 'Add to cart'
then 1 else 0 end) as cart_adds,
sum(case when  ei.event_name  = 'Ad Click'
then 1 else 0 end) as ad_clicks,
sum(case when  ei.event_name  = 'Ad Impression'
then 1 else 0 end) as ad_impressions,
sum(case when  ei.event_name  = 'Purchase'
then '1' else '0' end) as purchase_event,
group_concat(case when p.product_id is not null and ei.event_name = 'Add to cart' 
then p.page_name else null end order by e.sequence_number) as cart_added_products
from events as e
join users as u 
on u.cookie_id= e.cookie_id
join event_identifier as ei
on ei.event_type=e.event_type
join campaign_identifier as c
on e.event_time between c.start_date and c.end_date
join page_hierarchy as p
on p.page_id = e.page_id
group by e.visit_id,u.user_id,c.campaign_name)
select * from ct 
where cart_added_products is not null;
