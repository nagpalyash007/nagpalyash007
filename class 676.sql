--SQL Advance Case Study
use db_SQLCaseStudies
select * from DIM_CUSTOMER
--Q1--BEGIN 
select year(t.date)year,l.State,count(c.idcustomer)cnt_cust
from DIM_LOCATION l join 
FACT_TRANSACTIONS t on t.IDLocation=l.IDLocation 
join 
DIM_CUSTOMER c on c.IDCustomer=t.IDCustomer
where year(t.date) between '2005' and getdate()  ----to take records from 2005 to till today --
group by year(t.date),l.State 
order by 1 ;

select * from FACT_TRANSACTIONS
select IDcustomer,count(idmodel) from FACT_TRANSACTIONS
group by IDCustomer

--Q1--END

--Q2--BEGIN
select distinct l.state,m.Model_Name,r.Manufacturer_Name
from DIM_LOCATION l
join FACT_TRANSACTIONS t on t.IDLocation=l.IDLocation
join DIM_MODEL m on m.IDModel=t.IDModel
join DIM_MANUFACTURER r on r.IDManufacturer=m.IDManufacturer
where l.Country='us' and
r.Manufacturer_Name='samsung'
;









--Q2--END

--Q3--BEGIN      
select l.zipcode,l.State,t.idmodel ,count(idmodel	)count_
from FACT_TRANSACTIONS t join 
DIM_LOCATION l on l.IDLocation=t.IDLocation
group  by t.IDModel,l.ZipCode,l.State
order by l.State asc,l.ZipCode desc;











--Q3--END

--Q4--BEGIN
select top 1 m.idmodel,r.manufacturer_name,min(t.totalprice) as price
from dim_manufacturer r 
join dim_model m  on m.idmanufacturer=r.idmanufacturer
join fact_transactions t on t.idmodel=m.idmodel
group by m.idmodel,r.manufacturer_name
order by min(t.totalprice);







--Q4--END

--Q5--BEGIN
select m.idmodel,m.model_name,avg(t.totalprice)average_of_model,r.manufacturer_name,sum(t.quantity)quantity_sold
from dim_manufacturer r 
join dim_model m  on m.idmanufacturer=r.idmanufacturer
join fact_transactions t on t.idmodel=m.idmodel
group by r.manufacturer_name,m.idmodel,m.model_name
order by avg(t.totalprice) desc,IDModel;













--Q5--END

--Q6--BEGIN
select c.customer_name,avg(t.totalprice)average
from dim_customer c
join fact_transactions t  on t.idcustomer=c.idcustomer
where year(t.date)='2009'  
group by c.customer_name
having avg(t.totalprice)>500;











--Q6--END
	
--Q7--BEGIN  
select  m.model_name,sum(t.quantity)sum_,year(t.date)year ,rank() over (partition by m.model_name  order by sum(t.quantity) desc)rank_
from dim_model m
join fact_transactions  t on t.idmodel=m.idmodel
where year(t.date) ='2008' 
group by  m.model_name,t.date 
intersect  --used to find any common part----
select  m.model_name,sum(t.quantity)sum_,year(t.date)year ,rank() over (partition by m.model_name  order by sum(t.quantity) desc)rank_
from dim_model m
join fact_transactions  t on t.idmodel=m.idmodel
where year(t.date) ='2009' 
group by  m.model_name,t.date 
intersect
select  m.model_name,sum(t.quantity)sum_,year(t.date)year ,rank() over (partition by m.model_name  order by sum(t.quantity) desc)rank_
from dim_model m
join fact_transactions  t on t.idmodel=m.idmodel
where year(t.date) ='2010' 
group by  m.model_name,t.date 
order by 3 desc ;
	
---conclusion no as such record found-----










--Q7--END	
--Q8--BEGIN
select manufacturer_name,totalprice,year from (select r.manufacturer_name,t.totalprice,rank() over (order by t.totalprice desc)rank,year(date)year
from fact_transactions t
join dim_model m on m.idmodel=t.idmodel
join dim_manufacturer r on r.idmanufacturer=m.idmanufacturer
where year(date)='2009' ---or year(date) = '2010'
)table_1
where table_1.rank=2
union 
select manufacturer_name,totalprice,year from (select r.manufacturer_name,t.totalprice,rank() over (order by t.totalprice desc)rank,year(date)year
from fact_transactions t
join dim_model m on m.idmodel=t.idmodel
join dim_manufacturer r on r.idmanufacturer=m.idmanufacturer
where year(date)='2010' ---and year(date) = '2010'
)table_2
where table_2.rank=2

















use dbl_
--Q8--END
--Q9--BEGIN
select r.manufacturer_name
from fact_transactions t
join dim_model m on m.idmodel=t.idmodel
join dim_manufacturer r on r.idmanufacturer=m.idmanufacturer
where  year(date)='2010' 
except --used for any uncommon part 
select r.manufacturer_name
from fact_transactions t
join dim_model m on m.idmodel=t.idmodel
join dim_manufacturer r on r.idmanufacturer=m.idmanufacturer
where  year(date)='2009';

select * from fact_















--Q9--END

--Q10--BEGIN
	
	 with cust_ as (
						select customer_name,date_,sum(avgprice)avg_p,sum(avgquantity)avg_qty,
						lead(sum(avgprice)) over (order by date_ )next  ---using lead function to get next one in separate column ----
						from(select c.customer_name,year(f.date)date_,avg(f.totalprice)avgprice,avg(f.quantity)avgquantity
						from dim_customer c join
						fact_transactions f on f.idcustomer=c.idcustomer
						group by c.customer_name,year(f.date)
						 )x	
						 group by customer_name,date_
				)

 select   date_,customer_name,
 avg_p,avg_qty,next,
 abs(avg_p-next)difference,
 abs(avg_p-next)*100/avg_p as percent_change
 from cust_ 
 order by 1,2 asc
 ;

















--Q10--END
	