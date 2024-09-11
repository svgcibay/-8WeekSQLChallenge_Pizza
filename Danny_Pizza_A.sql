-------------A. Pizza Metrics------------
---1.How many pizzas were ordered?
---(distinct kullanmıyoruz)
select Count(order_id),
from customer_orders


----2.How many unique customer orders were made?
---2. Kaç adet benzersiz müşteri siparişi verildi?

select count(distinct customer_id )
	from customer_orders


---3.How many successful orders were delivered by each runner?
----3.Her bir kurye tarafından kaç başarılı sipariş teslim edildi?

select * from runner_orders


select runner_id,
		count(order_id) 	
from runner_orders
where cancellation is null 
group by 1
order by 1 ASC

---2.yol --2nd way 
select runner_id,
		Count(pickup_time)
from runner_orders
GROUP by 1
Order by 1
---4.How many of each type of pizza was delivered?
---4.Her bir pizza türünden kaç tane teslim edildi?
select * from pizza_names

select * from runner_orders
select * from customer_orders


select  Co.pizza_id,
		Count(Co.order_id),
		pizza_name
from customer_orders Co
left join runner_orders ro ON Co.order_id = ro.order_id
left join pizza_names pn ON pn.pizza_id = Co.pizza_id
where cancellation is null 
group by 1,3

---5.How many Vegetarian and Meatlovers were ordered by each customer?
---5.Her bir müşteri tarafından kaç Vejetaryen ve Meatlovers sipariş edildi?

select  Co.customer_id,
		Count(Co.order_id),
		pizza_name
from customer_orders Co
left join runner_orders ro ON Co.order_id = ro.order_id
left join pizza_names pn ON pn.pizza_id = Co.pizza_id
group by 1,3
order by 1 ASC

---6.What was the maximum number of pizzas delivered in a single order?
---6.Tek bir siparişte teslim edilen maksimum pizza sayısı ne kadardı?
select * from runner_orders
select * from customer_orders


select Co.order_id,
		Count(pizza_id)	
from customer_orders Co
left join runner_orders ro ON Co.order_id = ro.order_id
where cancellation is null
group by 1
order by 2 DESC 
--limit 1
---CTE li hali 

with tablo as (
select Co.order_id as orders,
		Count(pizza_id)	pizza_count
from customer_orders Co
left join runner_orders ro ON Co.order_id = ro.order_id
where cancellation is null
group by 1
order by 2 DESC 
)
select max(pizza_count)
from tablo



----7. For each customer, how many delivered pizzas had at least 1 change
--and how many had nochanges?
----7. Her bir müşteri için, teslim edilen pizzaların kaç tanesinde en az 1
--değişiklik yapıldı ve kaç tanesinde değişiklik yapılmadı?


--BENİM çözümüm Hocaya sor !!!
select  Distinct co.customer_id,
		Count(pizza_id),
	(CASE
		When exclusions is null And extras is null Then 'NotChanged' else 'Changed'
		end )as CHA 
from customer_orders co 
left join runner_orders ro ON Co.order_id = ro.order_id
where cancellation is null
group by 1,3
order by 1 Asc

---
select customer_id,
		sum(case 
			when exclusions is null and extras is null then 1 else 0 end ) NotChanged,
		sum(case 
			when exclusions is not null or extras is not null then 1 else 0 end ) Changed
from customer_orders co
join runner_orders ro on co.order_id = ro.order_id
where cancellation is null
GROUP by 1
order by 1


----8.How many pizzas were delivered that had both exclusions and extras?
----8.Hem exclusions hem de ekstraları olan kaç pizza teslim edildi?


select *
from customer_orders co 
join runner_orders ro on co.order_id = ro.order_id

--çözüm
select count(pizza_id) 
from customer_orders co 
join runner_orders ro on co.order_id = ro.order_id
where cancellation is null 
AND exclusions is not null
and extras is not null  
order by 1

---9.What was the total volume of pizzas ordered for each hour of the day?
---9.Hangi saatlerde kaç adet pizza satılmıştır ??
select * from customer_orders
select * from pizza_names
select * from pizza_recipes
select * from pizza_toppings
select * from runner_orders
select * from runners

									---unutma SORR !!!

select count(pizza_id),
	   EXTRACT(HOUR FROM order_time) AS hour,
       EXTRACT(MINUTE FROM order_time) AS minute
FROM customer_orders
group by hour, minute,order_time;


--order_tiime to char saatiğ aldı sadece
select 
		count(pizza_id),
		to_char(order_time , 'HH24')
from customer_orders
group by 2
order by 2

---10.What was the volume of orders for each day of the week?
---10.Haftanın her günü için sipariş hacmi ne kadardı?
select 
		count(pizza_id),
		to_char(order_time , 'DAY')
from customer_orders
group by 2
order by 2


