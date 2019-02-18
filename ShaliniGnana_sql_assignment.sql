SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY';
select @@GLOBAL.sql_mode;

#Task 1: Understanding the data in hand
#A.Describe the data in hand in your own words:
/* superstoresdb is a database comprised of related data stored across five tables as follows: cust_dimen, orders_dimen,prod_dimen, shipping_dimen and market_fact,
each comprising information of customers, orders placed, product details,shipping information and market fact for all the customers, orders and products at superstores.
Every table comprises tables -just like every table has a name, every column too has a name. This is the structure of superstoresdb. 
For example,cust_dimen table has 5 columns: Cust_id, customer_name, province, region and customer_segment.
order_dim table has 4 columns: Order_ID,Order_date,Order_Priority and Ord_id and so on. The actual data is present in the rows of the tables.
Data across the tables has different datatypes. For example, data in the orders_dimen table is of the following datatypes: string, numeric and date datatypes*/

#Task 1: B 
/* Cust_id is the primary key in cust_dimen table;
  Order_ID is the primary key in orders_dimen table;
  Prod_id is the primary key in prod_dimen table;
  Ship_id is the primary key in shipping_dimen table; 
  order_id in the orders_dimen table is a foreign key to Ship_id in shipping_dimen table;
  Cust_id in market_fact table is a foreign key to Cust_id in cust_dimens table; 
  Prod_id in the market_fact table is a foreign key to Prod_id in the prod_dimen table;
  Ord_id in the market_fact table is a foreign key to Order_ID in the orders_dimen table;
  Ship_id in the market_fact table is a foreign key to Ship_id in the shipping_dimen table;
  market_data table does not have a primary key;*/
  
 #Task 2: A. Find the total and the average sales (display total_sales and avg_sales)
 SELECT sum(Sales) as 'total_sales' FROM superstoresdb.market_fact;
 SELECT avg(Sales) as 'avg_sales' FROM superstoresdb.market_fact;
 
 #Task 2: B. Display the number of customers in each region in decreasing order of no_of_customers. 
 #The result should contain columns Region, no_of_customers
SELECT Region, count(*) as 'no_of_customers' FROM superstoresdb.cust_dimen 
group by Region order by count(*) desc;
  
#Task 2: C. Find the region having maximum customers (display the region name and max(no_of_customers))
SELECT Region, count(*) FROM superstoresdb.cust_dimen group by Region order by count(*) desc limit 1; 

#Task 2: D. Find the number and id of products sold 
#in decreasing order of products sold (display product id, no_of_products sold)
SELECT Prod_id as 'product id', sum(Order_Quantity) as 'no_of_products sold' FROM superstoresdb.market_fact 
group by Prod_id order by sum(Order_Quantity) desc;
  
#Task 2: E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and 
#the number of tables purchased (display the customer name, no_of_tables purchased)
SELECT c.Customer_name, sum(m.Order_Quantity) as 'no_of_tables_purchased'
FROM superstoresdb.cust_dimen c inner join superstoresdb.market_fact m on c.Cust_id=m.Cust_id
inner join superstoresdb.prod_dimen p on m.Prod_id=p.Prod_id 
where c.Region='ATLANTIC' and p.Product_Sub_Category='TABLES' group by c.Customer_Name,c.Cust_id;

#Task 3: A.Display the product categories in descending order of profits (display the product
#category wise profits i.e. product_category, profits)? 
SELECT p.Product_Category, m.profit FROM superstoresdb.prod_dimen p 
inner join superstoresdb.market_fact m on p.Prod_id=m.Prod_id order by m.profit desc;

#Task 3.B: Display the product category, product sub-category and the profit within each subcategory
#in three columns.
SELECT p.Product_Category, p.Product_Sub_Category, sum(m.profit) as 'Profit' FROM superstoresdb.prod_dimen p 
inner join superstoresdb.market_fact m on p.Prod_id=m.Prod_id 
group by p.Product_Sub_Category, p.Product_Category order by sum(m.profit) desc; 

#Task 3.C: Where is the least profitable product subcategory shipped the most? For the least
#profitable product sub-category, display the region-wise no_of_shipments and the
#profit made in each region in decreasing order of profits. 
# Solution: Tables is the least profitable  product subcategory as seen from the result of Task 3.B
#and has been hardcoded here. Tables have been shipped the most to Ontario.
Select c.Region, count(m.Ship_id) as 'no_of_shipments', sum(m.Profit) as 'Profit_in_each_region' 
from superstoresdb.market_fact m inner join superstoresdb.cust_dimen c inner join superstoresdb.shipping_dimen s
inner join superstoresdb.prod_dimen p where m.Cust_id=c.Cust_id and m.Ship_id=s.Ship_id 
and m.Prod_id=p.Prod_id and p.Product_Sub_Category='TABLES' group by c.Region order by sum(m.profit) desc;
