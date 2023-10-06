select * from sales;
select * from menu;
Select * from members;

select s.customer_id, sum(m.price) as price
from sales as s 
join menu as m 
on m.product_id= s.product_id
group by customer_id;
 

select customer_id, count(order_date) from sales
group by customer_id;

with cte as (
select s.customer_id, m.product_name, s.order_date,
rank() over (partition by s.customer_id order by order_date asc) as rnk
 from sales as s
join menu as m 
on m.product_id= s.product_id
)
select * from cte where rnk = 1;

select m.product_name, count(1) as cnt from 
sales as s join 
menu as m 
on m.product_id= s.product_id
group by m.product_name
order by cnt desc;

with cte as(
select s.customer_id, m.product_name, count(1) as cnt , 
dense_rank() over (partition by s.customer_id order by count(1) desc) as rnk
from sales as s
join menu as m 
on m.product_id= s.product_id
group by  s.customer_id, m.product_name)
select * from cte where rnk =1 ;

WITH member_sales_cte AS
(
SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
DENSE_RANK() OVER(PARTITION BY s.customer_id
ORDER BY s.order_date) AS rn
FROM sales AS s
JOIN members AS m
ON s.customer_id = m.customer_id
WHERE s.order_date >= m.join_date
)
SELECT s.customer_id, s.order_date, m2.product_name
FROM member_sales_cte AS s
JOIN menu AS m2
ON s.product_id = m2.product_id
WHERE rn = 1;

WITH member_sales_cte AS
(
SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
DENSE_RANK() OVER(PARTITION BY s.customer_id
ORDER BY s.order_date desc) AS rn
FROM sales AS s
JOIN members AS m
ON s.customer_id = m.customer_id
WHERE s.order_date < m.join_date
)
SELECT s.customer_id, s.order_date, m2.product_name
FROM member_sales_cte AS s
JOIN menu AS m2
ON s.product_id = m2.product_id
WHERE rn = 1;


SELECT s.customer_id, count(1) as qty, sum(m.price) as price
FROM sales AS s
JOIN menu AS m
on s.product_id= m.product_id
join members as me
ON s.customer_id = me.customer_id
WHERE s.order_date < me.join_date
group by s.customer_id;

select * from menu;

select  s.customer_id, 
sum(case when m.product_name= 'sushi' then m.price * 20 else m.price * 10  end )as points
from sales as s
join menu as m
on s.product_id= m.product_id
group by  s.customer_id;


SELECT s.customer_id,
       SUM(IF(order_date BETWEEN join_date AND DATE_ADD(join_date, INTERVAL 6 DAY), price*10*2, IF(product_name = 'sushi', price*10*2, price*10))) AS customer_points
FROM menu AS m
INNER JOIN sales AS s ON m.product_id = s.product_id
INNER JOIN members AS mem USING (customer_id)
WHERE order_date <='2021-01-31'
  AND order_date >=join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;