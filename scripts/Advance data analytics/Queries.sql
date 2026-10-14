-- Change over time Analysis

SELECT 
year(ordeR_date) as order_year,
month(order_date) as order_month,
sum(sales_amount) as total_sales,
count(customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by year(ordeR_date),month(order_date)
Order by year(ordeR_date),month(order_date);


-- Performance Analysis

with yearly_sales as
(
SELECT 
year(f.order_date) as order_year,
p.product_name as product_name,
sum(f.sales_amount) as current_sales
from gold.dim_products p
left join gold.fact_sales f
on p.product_key = f.product_key
where f.order_date is not null
group by year(f.order_date),
p.product_name
)
select 
order_year,
product_name,
current_sales,
avg(current_sales) over(partition by product_name) as avg_sales,
current_sales - avg(current_sales) over(partition by product_name)  as diff_avg,
case
 when current_sales - avg(current_sales) over(partition by product_name) < 0 then 'Below Avg'
 when current_sales - avg(current_sales) over(partition by product_name) > 0 then 'Above Avg'
 else 'Avg'
end  as avg_change,
lag(current_sales) over(partition by product_name order by order_year) as py_sales,
current_sales - lag(current_sales) over(partition by product_name order by order_year) as diff_py,
case
 when current_sales - lag(current_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
 when current_sales - lag(current_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
 else ' No change'
end as py_change
from yearly_sales
order by product_name,order_year;


-- Part to whole Analysis

with category_sales as (
SELECT
p.Category as category,
sum(f.sales_amount) as total_sales
from gold.dim_products p
left join gold.fact_sales f
on p.product_key = f.product_key
group by
p.category
)
select category,
total_sales,
sum(total_sales) over() as overall_sales,
ROUND((cast(total_sales as float) / sum(total_sales) over()) * 100 ,2) as perc_of_contribution
from category_sales
where total_sales is not null
Order by total_sales desc

