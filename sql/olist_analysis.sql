--1. CREATE THE DATABASE:

--CREATE DATABASE olist_bi
USE olist_bi;
GO
--2. EXPORT FLAT FILES (CSV)
--3. TRANSFORM NVARCHAR VALUES TO NUMERICAL VALUES

ALTER TABLE olist_order_payments_dataset
ALTER COLUMN payment_value DECIMAL(10,2);

ALTER TABLE olist_order_items_dataset
ALTER COLUMN price DECIMAL(10,2);

ALTER TABLE olist_order_items_dataset
ALTER COLUMN freight_value DECIMAL(10,2);

--4. NOW THE DATA IS SET UP TO START MAKING CONSULTS:

SELECT * FROM olist_orders_dataset
SELECT * FROM olist_products_dataset
SELECT * FROM olist_order_items_dataset
SELECT * FROM olist_order_payments_dataset
SELECT * FROM olist_customers_dataset
SELECT * FROM olist_order_reviews_dataset
SELECT * FROM olist_geolocation_dataset
SELECT * FROM olist_sellers_dataset
SELECT * FROM product_category_name_translation

--5. BASIC KPI'S: 
--Total number of orders, unique customers, sellers and total revenue:

SELECT COUNT(O.order_id) AS Total_Orders,
COUNT(DISTINCT O.customer_id) AS Total_Customers,
COUNT(DISTINCT I.seller_id) AS Total_Sellers,
CONCAT(SUM(P.payment_value),' R$') AS Total_Revenue
FROM olist_orders_dataset AS O
INNER JOIN olist_order_items_dataset AS I
	ON O.order_id=I.order_id
INNER JOIN olist_order_payments_dataset AS P
	ON O.order_id=P.order_id

--Monthly orders evolution:

SELECT FORMAT (order_approved_at, 'yyyy-MM') AS Month,
	   COUNT (order_id) AS Orders_Evolution
FROM olist_orders_dataset
WHERE order_approved_at IS NOT NULL
	AND YEAR (order_approved_at) >=2017
GROUP BY FORMAT (order_approved_at, 'yyyy-MM')
ORDER BY Month

--Monthly revenue evolution:

SELECT FORMAT (order_approved_at, 'yyyy-MM') AS Month,
CONCAT(SUM(P.payment_value),' R$') AS Total_Revenue
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
	ON O.order_id=P.order_id
WHERE order_approved_at IS NOT NULL
	AND YEAR (order_approved_at) >=2017
GROUP BY FORMAT (order_approved_at, 'yyyy-MM')
ORDER BY Month

--Average ticket by order:

SELECT CONCAT(FORMAT(AVG(order_total), 'N2'), ' R$') AS Average_Ticket
FROM ( SELECT order_id,
SUM(payment_value) AS order_total
FROM olist_order_payments_dataset
GROUP BY order_id) t;

--Number of active customers by month:

SELECT FORMAT(order_approved_at, 'yyyy-MM') AS Month,
    COUNT(DISTINCT customer_id) AS Active_Customers
FROM olist_orders_dataset
WHERE order_approved_at IS NOT NULL
AND YEAR (order_approved_at) >=2017
GROUP BY FORMAT(order_approved_at, 'yyyy-MM')
ORDER BY Month;

--6. CUSTOMERS:
--Top 10 customers by revenue:

SELECT TOP 10
C.customer_unique_id, 
CONCAT (SUM (P.payment_value),' R$') AS Total_Revenue
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
	ON O.order_id= P.order_id
INNER JOIN olist_customers_dataset AS C
	ON O.customer_id=C.customer_id
GROUP BY C.customer_unique_id
ORDER BY SUM (P.payment_value) DESC

-- Top 10 average revenue by customer:

SELECT TOP 10 C.customer_unique_id,
CONCAT (FORMAT(AVG (P.payment_value),'N2'),' R$' ) AS Average_Revenue
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
	ON O.order_id= P.order_id
INNER JOIN olist_customers_dataset AS C
	ON O.customer_id=C.customer_id
GROUP BY C.customer_unique_id

--7. PRODUCTS AND CATEGORIES:
-- Revenue by product category:

SELECT PR.product_category_name, 
CONCAT(FORMAT(SUM(PA.payment_value), 'N2'), ' R$') AS Revenue
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS PA
	ON O.order_id=PA.order_id
INNER JOIN olist_order_items_dataset AS I
	ON O.order_id=I.order_id
INNER JOIN olist_products_dataset AS PR
	ON I.product_id=PR.product_id
WHERE PR.product_category_name IS NOT NULL
AND YEAR (O.order_approved_at) >=2017
GROUP BY PR.product_category_name
ORDER BY SUM(PA.payment_value) DESC

--Orders number by category:

SELECT PR.product_category_name,
COUNT(O.order_id) AS Total_Orders
FROM olist_orders_dataset AS O
INNER JOIN olist_order_items_dataset AS I
	ON O.order_id=I.order_id
INNER JOIN olist_products_dataset AS PR
	ON I.product_id=PR.product_id
WHERE PR.product_category_name IS NOT NULL
AND YEAR(O.order_approved_at) >= 2017
GROUP BY PR.product_category_name
ORDER BY Total_Orders DESC

--Average price by category:

SELECT PR.product_category_name, 
CONCAT(FORMAT(AVG(I.price),'N2'), ' R$') AS Average_Price
FROM olist_order_items_dataset AS I
INNER JOIN olist_products_dataset AS PR
	ON I.product_id=PR.product_id
WHERE PR.product_category_name IS NOT NULL
GROUP BY PR.product_category_name
ORDER BY AVG(I.price) DESC

--Top 10 categories by revenue:

SELECT TOP 10 PR.product_category_name, 
CONCAT(FORMAT(SUM(PA.payment_value), 'N2'), ' R$') AS Revenue
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS PA
	ON O.order_id=PA.order_id
INNER JOIN olist_order_items_dataset AS I
	ON O.order_id=I.order_id
INNER JOIN olist_products_dataset AS PR
	ON I.product_id=PR.product_id
WHERE PR.product_category_name IS NOT NULL
AND YEAR (O.order_approved_at) >=2017
GROUP BY PR.product_category_name
ORDER BY SUM(PA.payment_value) DESC

--8. SELLERS:
--Total revenue and orders number by seller:

SELECT S.seller_id,
CONCAT(FORMAT(SUM(P.payment_value),'N2'), ' R$') AS Total_Revenue,
COUNT(DISTINCT O.order_id) AS Orders_Number
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
	ON O.order_id=P.order_id
INNER JOIN olist_order_items_dataset AS I
	ON O.order_id=I.order_id
INNER JOIN olist_sellers_dataset AS S
	ON I.seller_id=S.seller_id
WHERE order_approved_at IS NOT NULL
AND YEAR (order_approved_at) >=2017
GROUP BY S.seller_id
ORDER BY SUM(P.payment_value) DESC

--Top 10 sellers by revenue:

SELECT TOP 10 S.seller_id,
CONCAT(FORMAT(SUM(P.payment_value),'N2'), ' R$') AS Total_Revenue
FROM olist_orders_dataset AS O
INNER JOIN olist_order_payments_dataset AS P
	ON O.order_id=P.order_id
INNER JOIN olist_order_items_dataset AS I
	ON O.order_id=I.order_id
INNER JOIN olist_sellers_dataset AS S
	ON I.seller_id=S.seller_id
WHERE order_approved_at IS NOT NULL
AND YEAR (order_approved_at) >=2017
GROUP BY S.seller_id
ORDER BY SUM(P.payment_value) DESC

--Total number of products sold per seller:

SELECT S.seller_id, COUNT(product_id) AS Products_sold
FROM olist_order_items_dataset AS I
INNER JOIN olist_sellers_dataset AS S
	ON I.seller_id=S.seller_id
GROUP BY S.seller_id
ORDER BY COUNT(product_id) DESC

--EXPERIENCE AND LOGISTICS
--Average delivery time:

SELECT AVG(DATEDIFF(day, order_approved_at, order_delivered_customer_date))
AS Avg_Delivery_Time_Days
FROM olist_orders_dataset
WHERE order_approved_at IS NOT NULL
AND order_status='delivered'
AND order_delivered_customer_date IS NOT NULL

--Orders late delivered percentage

SELECT  CONCAT(FORMAT(100.0 * 
SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
THEN 1 
ELSE 0 
END) / COUNT(order_id),'N2'),' %') AS Late_Delivery_Percentage
FROM olist_orders_dataset
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL

--Relationship between delay and average rating

SELECT CASE WHEN O.order_delivered_customer_date > O.order_estimated_delivery_date THEN 'Late'
        ELSE 'On Time'
		END AS Delivery_Status, AVG(R.review_score) AS Average_Rating
FROM olist_orders_dataset AS O
INNER JOIN olist_order_reviews_dataset AS R
    ON O.order_id = R.order_id
WHERE O.order_status = 'delivered'
AND O.order_delivered_customer_date IS NOT NULL
AND O.order_estimated_delivery_date IS NOT NULL
AND R.review_score IS NOT NULL
GROUP BY CASE WHEN O.order_delivered_customer_date > O.order_estimated_delivery_date THEN 'Late'
        ELSE 'On Time' END
ORDER BY Delivery_Status