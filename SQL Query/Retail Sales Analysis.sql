CREATE DATABASE Retail_Sales_Analysis;
USE Retail_Sales_Analysis;

-- Create Table

DROP TABLE IF EXISTS retail_sales
CREATE TABLE retail_sales
			(
				transcation_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15) ,
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
				);

-- Loading Table data into database
    
 PRINT '>> Truncating Table:retail_sales ';
 TRUNCATE TABLE retail_sales;
        
 PRINT '>> Inserting Data Into: retail_sales';
 BULK INSERT retail_sales 
 FROM 'D:\New_Folder_MySql\SQL - Retail Sales Analysis_utf.csv' 
 WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );


-- Checking for NULL in clolumn
SELECT * FROM retail_sales
	WHERE transcation_id  IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
-- Delete the null values 

DELETE FROM retail_sales
	WHERE transcation_id  IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration

	-- How many salses we have?
	SELECT COUNT(*) AS  total_sale FROM retail_sales
	-- How many  uniquecustomer we have?
	SELECT COUNT(DISTINCT customer_id) AS  customer_number FROM retail_sales ;

	-- How nmany unique category we have?
	SELECT DISTINCT category as category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers

-- Write a SQL query to retrieve all column for sale made on 2022-11-05

SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05'


--Write s SQL query to retrieve  all transaction where the category is 'clothing' in the month of NOV-2022
SELECT *
FROM retail_sales
WHERE category = 'clothing'
	AND sale_date >= '2022-11-01'
	AND sale_date < '2022-12-01';

-- Write a SQL query to retrieve all transcation where the category is 'Clothing' and the quantity sold is more than 4 in month of Nov-2022
SELECT transcation_id,category,quantity
FROM retail_sales
WHERE category='Clothing'
	AND quantity>=4
	AND sale_date>='2022-11-01'
	AND sale_date< '2022-12-01'

--Write a SQL query to calculate the total sales for each category
SELECT 
	category,
	SUM(total_sale) AS total_sale
FROM retail_sales
	GROUP BY 
		category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT  
	AVG(age) AS average_age
FROM retail_sales
	WHERE category='Beauty';

-- Write a SQL query to find all transaction where the total_sale is greater than 1000

SELECT * 
FROM retail_sales
	WHERE total_sale>1000

-- Write a SQL query to find total number of transaction made by each gender in each category
SELECT
	category,
	gender,
	COUNT(*) AS total_trans
FROM retail_sales
	GROUP 
		 BY category,
			  gender
	ORDER BY 1;


-- Write a SQL query to calculate the average sale for each month.Find out best selling month in each year
SELECT year,
       month,
       avg_sale
FROM
(
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(
            PARTITION BY YEAR(sale_date) 
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
		GROUP BY YEAR(sale_date), MONTH(sale_date)
) t
WHERE rank = 1;


-- Write a SQL query to find the top 5 customers based on the highest total sales

SELECT TOP 3
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
	GROUP BY customer_id
	ORDER BY total_sales DESC;
	   
-- Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
		category,
		COUNT (DISTINCT customer_id) AS nuique_customer
FROM retail_sales
	GROUP BY category

   
-- Write a SQL query to create each shift and number of orders (Example  Morning <=12,afternoon Between 12 &17,Evening >17)
WITH hourly_sale
AS
(
	SELECT *,
		CASE 
			WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
			WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift_time
	FROM retail_sales
)

SELECT
	shift_time,
	COUNT(*) AS total_orders

FROM hourly_sale
	GROUP BY shift_time
 	

-- End of the Project