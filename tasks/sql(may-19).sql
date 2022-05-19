--1.	Find all the customers who did not make any sales from last two months. 
select cust_name
from customer_retail
where cust_id not in (select distinct(cust_id)
                        from sales_retail
                        where to_char( sales_date,'mm') in (to_char(sysdate,'mm') ,
                        (to_char(sysdate,'mm')-1)));
                        
                        
                        
select * from sales_retail;
select * from customer_retail;
select to_char(sysdate,'mm') from dual;
--2.Find top 10 customers in terms of sales in the current year
select cust_name ,c.cus_rank
from (select cust_name, dense_rank() over(order by  sum(amount)desc)cus_rank
    from customer_retail c,sales_retail s
    where c.cust_id=s.cust_id and to_char(sales_date,'yy')=to_char(sysdate,'yy')-1
    group by cust_name) c
where c.cus_rank <10;
--3.	How many different cities from which we have our customers
select distinct(cust_city)
from customer_retail;
--4.Find customers who are from the same city as Customer ‘TIM’
select cust_name,cust_city
from customer_retail
where cust_name not in 'tim' and cust_city=(select cust_city
                    from customer_retail
                    where cust_name like 'tim');

--5.Find how many different customers we got yesterday
select cust_name
from customer_retail
where cust_id in (select distinct(cust_id)
                    from sales_retail
                    where to_char(sales_date,'dd')=to_char(sysdate,'dd')-1);

--6.	Find the date in the current month which gave the least total sales amount. For example on 1-Jan-13 we sold for 3000 Rs, 
--and on 2-Jan-13 we sold total of 8000 (In this case the answer should be 1-Jan-13)
select distinct(to_char(sales_date,'d-mm')),amount
from sales_retail
where (to_char(sales_date,'mm'), amount) in(select to_char(sales_date,'mm'),min(amount)
                                            from sales_retail
                                            where to_char(sales_date,'mm')=to_char(sysdate,'mm')
                                            group by to_char(sales_date,'mm'));

--7.Create a view which gives Customer_Name, Month and total revenue we got
create view view_cust2 as
select  cust_name,to_char(sales_date,'mon')as month_data ,sum(amount)as revenue
from customer_retail c,sales_retail s
where c.cust_id=s.cust_id
group by cust_name,to_char(sales_date,'mon');

select * from view_cust2;

--8.Create a view which gives customer_name, city, year, revenue we got
create view view_cust3 as
select cust_name,cust_city,to_char(sales_date,'yy') as year,sum(amount)as revenue
from customer_retail c,sales_retail s
where c.cust_id=s.cust_id
group by cust_name,to_char(sales_date,'yy'),cust_city;

select * from view_cust3;

--9.	Create an index (non cluster index) on cust_nm column in Customer table
create index index_custnm
on customer_retail(cust_name);

--10. Find the customer who has most number of transactions.
SELECT CUST_NAME,NO_OF_SALES
FROM (SELECT CUST_NAME,COUNT(SALES_ID)NO_OF_SALES,DENSE_RANK() OVER
            (ORDER BY COUNT(SALES_ID) DESC)R
            FROM CUSTOMER_RETAIL C,SALES_RETAIL S
            WHERE C.CUST_ID = S.CUST_ID
            GROUP BY CUST_NAME)
WHERE R=1;

--11. Display the citywise current year YTD and previous year YTD.
--City_name Current_YTD Prev_YTD

SELECT CUST_CITY, COUNT(CASE WHEN TO_CHAR(SYSDATE,'YY')=TO_CHAR(SALES_DATE,'YY') THEN (SALES_ID)
                    END ) CURRENT_YEAR,
                  COUNT(CASE WHEN TO_CHAR(SYSDATE,'YY')-1=TO_CHAR(SALES_DATE,'YY') THEN (SALES_ID)
                    END ) PRE_YEAR
FROM CUSTOMER_RETAIL C,SALES_RETAIL S
WHERE C.CUST_ID = S.CUST_ID
GROUP BY CUST_CITY;

--12. Display cities that have more number of customers than the city ‘HYD’.
SELECT CUST_CITY
FROM CUSTOMER_RETAIL
GROUP BY CUST_CITY
HAVING COUNT(CUST_ID) > (SELECT COUNT(CUST_ID)
                            FROM CUSTOMER_RETAIL
                            WHERE CUST_CITY='hyd');

--13. Display citywise number of customers and number of transactions in the current year.
SELECT CUST_CITY,COUNT(C.CUST_ID),COUNT(SALES_ID)
FROM CUSTOMER_RETAIL C,SALES_RETAIL S
WHERE C.CUST_ID = S.CUST_ID AND TO_CHAR(SYSDATE,'YY')-1=TO_CHAR(SALES_DATE,'YY')
GROUP BY CUST_CITY;















