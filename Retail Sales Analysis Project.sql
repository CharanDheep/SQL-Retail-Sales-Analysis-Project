-- SQL RETAIL SALES ANALYSIS PROJECT -P1
CREATE DATABASE sql_project_p1;

-- SELECT DATABASE
USE  sql_project_p1;

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
transactions_id	INT PRIMARY KEY,
sale_date	DATE,
sale_time	TIME,
customer_id	INT,
gender	VARCHAR(15),
age	INT,
category VARCHAR(15),
quantiy	INT,
price_per_unit	FLOAT,
cogs	FLOAT,
total_sale FLOAT
);

-- Checking the Table
SELECT * FROM retail_sales
LIMIT 10;
-- COUNT DATA
SELECT COUNT(*) FROM retail_sales;


-- DATA CLEANING
SELECT * FROM retail_sales
WHERE 
  `transactions_id` IS NULL OR
  `sale_date` IS NULL OR
  `sale_time` IS NULL OR
  `customer_id` IS NULL OR
  `gender` IS NULL OR
  `age` IS NULL OR
  `category` IS NULL OR
  `quantiy` IS NULL OR
  `price_per_unit` IS NULL OR
  `cogs` IS NULL OR
  `total_sale` IS NULL;
  
-- DATA EXPLORATION

-- How Many Sales We had
SELECT COUNT(*) AS Total_Sales FROM retail_sales;
-- How Many Unique Customers we have
SELECT COUNT(DISTINCT `customer_id`) AS Customers FROM retail_sales;
-- How Many Unique Category we have
SELECT DISTINCT `category` AS ds_category FROM retail_sales;

-- Data Analysis and Business Key Problems

-- Write a query to retrive all columns for sales made on 2021 -10 -22
SELECT * FROM retail_sales WHERE sale_date = "2021-10-22";

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is =  4 in the month of Nov-2022
SELECT * FROM retail_sales WHERE
category = 'Clothing'
AND
quantiy >='4'
AND
DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

-- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale)
FROM retail_sales
GROUP BY category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(age),2) AS AVG_AGE
From retail_sales
Where category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT transactions_id FROM retail_sales
WHERE total_sale >1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT  gender, category, COUNT(transactions_id) FROM retail_sales
Group BY gender, category
ORDER BY category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH ranked_sales AS (
    SELECT
        YEAR(sale_date) AS Year,
        MONTH(sale_date) AS Month,
        AVG(total_sale) AS AVG_SALES,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS AVG_RANK
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT 
    Year,
    Month,
    AVG_SALES
FROM ranked_sales
WHERE AVG_RANK = 1
ORDER BY Year;

-- Write a SQL query to find the top 5 customers based on the highest total sales
SELECT * FROM retail_sales;
SELECT customer_id, SUM(total_sale) AS SUM_SALES
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM_SALES DESC
LIMIT 5;
-- OR
-- Write a SQL query to find the top 5 customers based on the highest total sales Without using Limit
WITH CTE1 AS( 
SELECT customer_id, SUM(total_sale) AS SUM_SALES,
row_number() OVER(ORDER BY SUM(total_sale) DESC) AS row_num
FROM retail_sales
GROUP BY customer_id)
SELECT * FROM CTE1 
WHERE row_num <= 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category
WITH CTE2 AS (
    SELECT 
        category, 
        COUNT(DISTINCT customer_id) AS unique_customers,
        ROW_NUMBER() OVER (PARTITION BY category) AS row_num
    FROM retail_sales
    GROUP BY category
)
SELECT category, unique_customers
FROM CTE2
WHERE row_num = 1;
 
 -- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH CTE3 AS 
(SELECT transactions_id, sale_time, quantiy,
CASE
WHEN EXTRACT( HOUR FROM sale_time) <12 THEN 'MORNING'
WHEN EXTRACT( HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN EXTRACT( HOUR FROM sale_time) > 17 THEN 'Evening' 
END AS SHIFT
FROM retail_sales
)
SELECT SHIFT, COUNT(transactions_id) FROM CTE3
GROUP BY SHIFT;

-- Project Completed 