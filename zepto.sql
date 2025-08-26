drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountpercent numeric(5,2),
availablequantity integer,
discountedsellingprice numeric(8,2),
weightingms integer,
outofstock boolean,
quantity integer
);

select count(*) from zepto;
select * from zepto
where name is null
or
category is null
or
mrp is null
or
discountpercent is null
or
availablequantity is null
or
discountedsellingprice is null
or
weightingms is null
or
outofstock is null
or
quantity is null


select distinct category
from zepto
order by category


select outofstock,count(sku_id)
from zepto
group by outofstock;


--product names which occur multiple times
select name,count(sku_id) as "number of sku's"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;

--data cleaning
select * from zepto
where mrp = 0
or
discountedsellingprice = 0

delete from zepto
where mrp =0;

--converting paise to rupees
update zepto
set mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;
select mrp,discountedsellingprice from zepto

--top 10 best value proucts based on discount percent
select distinct name,discountpercent,mrp
from zepto
group by name,discountpercent,mrp
order by discountpercent desc
limit 10;

--what are the products with high mrp but out of stock
--select max(mrp) from zepto;
select name,mrp
from zepto
where outofstock =  true and mrp >300
order by mrp

--calculate estimated revenue for each category
select category,sum(discountedsellingprice * quantity) as total_revenue
from zepto
group by category
order by total_revenue

--find all the products where mrp is greater than 500 rupees and discount is less than 10%
select name,mrp
from zepto
where mrp > 500 and discountpercent < 10
order by mrp desc

--Identify the top 5 categories offering the highest average discount percentage
select category,round(avg(discountpercent),2) as average
from zepto
group by category,discountpercent
order by average desc

--find the price per gram for products above 100g and sort by best value.
select name,discountedsellingprice,weightingms,
round(discountedsellingprice/weightingms,2) as pricepergram
from zepto
where weightingms >=100
order by pricepergram desc

--Group the products into categories like low,medium,bulk
select name,quantity,weightingms ,
case when quantity < 500 then 'low'
      when quantity < 1000 then 'Medium'
else 'bulk'
end as quantity_category
from zepto

--What is the total inventory weight per category
select category,sum(weightingms * availablequantity) as weight_per_category
from zepto
group by category
order by weight_per_category desc
