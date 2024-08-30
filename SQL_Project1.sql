--Data Cleaning 
SELECT * FROM retail_sales
WHERE 
transactions_id IS NULL
OR 
sale_date IS NULL
OR 
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
age IS NULL
OR 
category IS NULL
OR 
quantiy IS NULL
OR 
price_per_unit IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;


DELETE FROM retail_sales
WHERE 
transactions_id IS NULL
OR 
sale_date IS NULL
OR 
sale_time IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
age IS NULL
OR 
category IS NULL
OR 
quantiy IS NULL
OR 
price_per_unit IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;

--Data Exploration

--How many sales we have 
SELECT COUNT(*) as total_sales
FROM retail_sales;

--Number of Customers
SELECT COUNT(DISTINCT(customer_id))as unique_customer
FROM retail_sales;

-- Distinct Category
SELECT COUNT(DISTINCT (category))
FROM retail_sales;

--Data Exploration 
--How many sales do we have ?
SELECT COUNT(DISTINCT(transactions_id))as Total_sales
FROM retail_sales;
-- How many unique customers we have ?
SELECT COUNT(DISTINCT(customer_id))as Total_sales
FROM retail_sales;


--Data Analysis & Business Key Problems & Answers

-- Q1.Write a SQL query t0 retrieve all columns for sales made on 2022-11-05 
SELECT * 
FROM retail_sales 
WHERE sale_date='2022-11-05';

-- Q2.Write a SQl query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
SELECT * 
FROM retail_sales
WHERE category='Clothing' AND
quantiy >=4 AND
TO_CHAR(sale_date,'YYYY-MM')='2022-11';

-- Q3.Write a SQL query t0 calculate the total sales(total_sales) for each category
SELECT category ,SUM(total_sale) AS Total_Sales 
FROM retail_sales 
GROUP BY category;

-- Q4.Write a SQL query t0 retreive the average age of customers who purchased items from the 'Beauty ' category .
SELECT ROUND(AVG(age),2) 
FROM retail_sales 
WHERE category = 'Beauty';

-- Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM retail_sales
WHERE total_sale >1000;

-- Q6.Write a SQL query to find the total number of transactions (transaction_id) made bu each gender in each category.
SELECT gender,category,COUNT(transactions_id)
FROM retail_sales
GROUP BY gender,category;

-- Q7.Write a SQL query to calculate the average sale of each month. FInd out best selling month in each year.
SELECT 
	year ,
	month,
	avg_sale
FROM (
SELECT
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale) DESC )AS rank
FROM retail_sales
GROUP BY 1,2
)
WHERE rank =1;



-- Q8.Write a SQL query to find the top 5 customers based on the highest sales
SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q9.Write a SQL query to find the number of unique customers who purcahsed items from each category .
SELECT 
category,
COUNT (DISTINCT(customer_id))
FROM retail_sales
GROUP BY category;

-- Q10.Write a SQL query to create each shift and number of order[Example Morning <=12 , Afternoon Between 12 and 17 , Evening >17]


WITH hourly_sale
AS
(
SELECT * ,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN'Morning'
		WHEN  EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT shift,
	   COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift;