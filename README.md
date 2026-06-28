# SQL-Retail-Sales-Analysis
## Project Overview

### Project Title: Retail Sales Analysis


A comprehensive data analytics portfolio project focused on exploring, cleaning, and analyzing retail transaction data. This repository features production-ready SQL scripts that address real-world business challenges—covering customer segmentation, seasonality trends, shift performance analysis.

### Objective
1. **Set up a retail sales database**: Create and populate a retail sale databse with the provided sales data
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis(EDA)**:Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### Database Setup
1. **Database Creation**: The project starts by creating a database named Retail_Sales_Analysis.

```sql
-- Create DataBase
CREATE DATABASE Retail_Sales_Analysis;
USE Retail_Sales_Analysis;

```
2. **Table Creation**: A table named retail_sales is created to store  the sales data.The table  structure includes columns for transcation ID, sale date,sale time,customer ID, gender ,age, product category,quantity sold,price per unit,cost of goods sold (  COGS),and total sale amount.

```sql
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

```
3. **Loading Dataset**

```sql
-- Loading Table data into database
    
 PRINT '>> Truncating Table:retail_sales ';
 TRUNCATE TABLE retail_sales;
        
 PRINT '>> Inserting Data Into: retail_sales';
 BULK INSERT retail_sales 
 FROM 'D:\New_Folder_MySql\SQL - Retail Sales Analysis_utf.csv' 
 WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );
```
### Data Exploration & Cleaning
1. **Record Count**: Determine the total number of records in the dataset
2. **Customer Count**: Find out how many unique customer are in the dataset.
3. **Category Count**: Identify all unique product categories in the dataset.
4. **Null Value Check**: Chack for any null values in the dataset and delete records with missing data.

```sql
SELECT * FROM retail_sales
	WHERE
      transcation_id  IS NULL OR sale_date IS NULL
      OR sale_time IS NULL OR gender IS NULL
      OR category IS NULL OR quantity IS NULL
      OR cogs IS NULL OR total_sale IS NULL;

	DELETE FROM retail_sales
	WHERE
      transcation_id  IS NULL OR sale_date IS NULL
    	OR sale_time IS NULL OR gender IS NULL
    	OR category IS NULL OR quantity IS NULL
    	OR cogs IS NULL OR total_sale IS NULL;
```

### Data Anaysis & Finding

The following SQL queries were developed to answer specific business questions:

1. Write a SQL query to retrieve all column for sale made on 2022-11-05

```sql

SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05'
```
2. Write s SQL query to retrieve  all transaction where the category is 'Clothing' in the month of NOV-2022.

```sql
the month of NOV-2022
SELECT *
FROM retail_sales
WHERE category = 'clothing'
	AND sale_date >= '2022-11-01'
	AND sale_date < '2022-12-01';
```
3. Write a SQL query to retrieve all transcation where the category is 'Clothing' and the quantity sold is more than 4 in month of Nov-2022

```sql
SELECT transcation_id,category,quantity
FROM retail_sales
WHERE category='Clothing'
	AND quantity>=4
	AND sale_date>='2022-11-01'
	AND sale_date< '2022-12-01'
```
4. Write a SQL query to calculate the total sales for each category.

```sql
SELECT 
	category,
	SUM(total_sale) AS total_sale
FROM retail_sales
	GROUP BY 
		category;
```
5. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

```sql
SELECT  
	AVG(age) AS average_age
FROM retail_sales
	WHERE category='Beauty';
```
6. Write a SQL query to find total number of transaction made by each gender in each category.

```sql
SELECT
  	category,
  	gender,
  	COUNT(*) AS total_trans
FROM retail_sales
	GROUP BY
        category,
			  gender
	ORDER BY 1;
```
7. Write a SQL query to calculate the average sale for each month.Find out best selling month in each year.

```sql
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
```
8.  Write a SQL query to find the top 5 customers based on the highest total sales.

```sql
SELECT TOP 3
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
	GROUP BY customer_id
	ORDER BY total_sales DESC;
```
9. Write a SQL query to find the number of unique customers who purchased items from each category.
```sql
SELECT 
		category,
		COUNT (DISTINCT customer_id) AS nuique_customer
FROM retail_sales
	GROUP BY category
```
10. Write a SQL query to create each shift and number of orders (Example  Morning <=12,afternoon Between 12 &17,Evening >17).

```sql
WITH hourly_sale AS
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
```
### Findings

**Customer Demographics**: The dataset includes customer from various age groups,with sales distibuted across different categories such as Clothing and Beauty.
**High-value Transcation**:Several transcations had a total sale amount greater then 1000,indiacting premium purchases.
**Sales Trends**: Monthly analysis shows variations in sales,helping identify peak season.
**Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

### Reports

**Sales Summary**: A detailed report summarizing total sales,customer demographics,and category performance.
**Trend Analysis**:Insights into sales trends across different months and shifts.
**Customer Insights**: Reports on the top customers and unique customer counts per category.

### Conclusion

This project serves as a comprehensive introduction to SQL for data analyst,covering database setup,data cleaning,exploratory da analysis,and business-driven SQL queries.The findings from this project can help drive business decisions by understanding sales patterns,customer behavior and product performance.










