-- This Project relized by: Aimad SADOUK

SELECT * FROM sales_data;

select count(ORDERNUMBER) 
fROM sales_data;
-- How many total orders have been placed in the sales_data?
SELECT COUNT(ORDERNUMBER) AS total_orders 
FROM sales_data ;

-- What is the total sales revenue across all orders?
SELECT ROUND(SUM(SALES), 2) AS REVENUE
FROM sales_data;

-- What is the average quantity ordered per transaction?
SELECT AVG(QUANTITYORDERED) AS AVG_QUANTITY 
FROM sales_data;

-- Which countries have the highest total sales?
SELECT COUNTRY, 
       ROUND(SUM(SALES), 2) AS REVENUE
FROM sales_data
GROUP BY COUNTRY
ORDER BY REVENUE DESC;

-- What is the average sales amount for each product line by year?
SELECT YEAR_ID, PRODUCTLINE, 
       ROUND(AVG(SALES), 2) AVG_SALES
FROM sales_data
GROUP BY YEAR_ID, PRODUCTLINE
ORDER BY YEAR_ID DESC, AVG_SALES DESC;

-- What was the highest sales day?
SELECT ORDERDATE,
       ROUND(SUM(SALES), 2) REVENUE
FROM sales_data
GROUP BY ORDERDATE
ORDER BY ORDERDATE DESC, REVENUE DESC;

-- What is the total sales revenue categorized by deal size (Small, Medium, Large)?
SELECT DEALSIZE, 
       ROUND(SUM(SALES), 2) AS REVENUE
FROM sales_data
GROUP BY DEALSIZE
ORDER BY REVENUE DESC;

-- Who are the top 5 customers based on total sales revenue?
SELECT CUSTOMERNAME, 
       ROUND(SUM(SALES), 2) AS REVENUE
FROM sales_data
GROUP BY CUSTOMERNAME
ORDER BY 2 DESC;

-- Which product line generates the highest sales revenue?
SELECT PRODUCTLINE, 
       ROUND(SUM(SALES), 2) AS Revenue
FROM sales_data
GROUP BY PRODUCTLINE
ORDER BY Revenue DESC;

-- Which months had the highest total sales in each year?
SELECT MONTH_ID, YEAR_ID,
       ROUND(SUM(SALES), 2) AS REVENUE
FROM sales_data
GROUP BY MONTH_ID, YEAR_ID
ORDER BY REVENUE DESC;

-- What is the sales distribution across different territories?
SELECT TERRITORY, 
       ROUND(SUM(SALES), 2) AS REVENUE
FROM sales_data
GROUP BY TERRITORY
ORDER BY REVENUE DESC;

-- Which day had the highest sales in each month?
WITH RankedSales AS (
    SELECT ORDERDATE, SALES,
           ROW_NUMBER() OVER (PARTITION BY YEAR_ID, MONTH_ID ORDER BY SALES DESC) AS Rnk
    FROM sales_data
)
SELECT ORDERDATE, SALES
FROM RankedSales
WHERE Rnk = 1
ORDER BY SALES DESC;

-- Which customers have purchased products from multiple product lines?
SELECT CUSTOMERNAME
FROM sales_data
GROUP BY CUSTOMERNAME
HAVING COUNT(DISTINCT PRODUCTLINE) > 1;

-- Which city has the highest average quantity ordered?
SELECT CITY, 
       AVG(QUANTITYORDERED) AS AVG_QUANTITY
FROM sales_data
GROUP BY CITY
ORDER BY AVG_QUANTITY DESC;

-- What is the percentage contribution of each product line to total sales?
SELECT PRODUCTLINE, 
       SUM(SALES) AS REVENUE,
       (SUM(SALES) / (SELECT SUM(SALES) FROM sales_data) * 100) AS Percentage_of_total_sales
FROM sales_data
GROUP BY PRODUCTLINE
ORDER BY REVENUE DESC;

-- Which customers made purchases above the average sales amount?
SELECT CUSTOMERNAME,
       PHONE,
       ADDRESSLINE1,
       CITY
FROM sales_data
WHERE SALES > 
      (SELECT AVG(SALES) FROM sales_data);

-- What is the cumulative total sales over time?
SELECT ORDERDATE, 
       SUM(SALES) OVER (ORDER BY ORDERDATE ASC) AS cumulative_sales
FROM sales_data
ORDER BY ORDERDATE;

-- What is the moving average of sales over the last three orders?
SELECT ORDERDATE,
       SALES,
       AVG(SALES) OVER (ORDER BY ORDERDATE ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Moving_Average
FROM sales_data;

-- How does the revenue from each product line compare with a ranking?
SELECT CUSTOMERNAME,
       PRODUCTLINE,
       ROUND(SALES, 2) REVENUE,
       DENSE_RANK() OVER (PARTITION BY PRODUCTLINE ORDER BY SALES DESC) AS RNK
FROM sales_data;

-- What is the sales ranking of customers for each year within the product line 'Motorcycles'?
SELECT YEAR_ID,
       CUSTOMERNAME,
       PRODUCTLINE,
	   SALES,
       RANK() OVER (PARTITION BY YEAR_ID ORDER BY SALES DESC) AS RNK
FROM sales_data
WHERE PRODUCTLINE = 'Motorcycles';

-- Which customers have sales above the average sales value?
WITH AverageSales AS (
    SELECT AVG(SALES) AS AVG_SALES
    FROM sales_data
)
SELECT CUSTOMERNAME,
       PRODUCTLINE,
	   SALES
FROM sales_data
WHERE SALES > 
      (SELECT AVG_SALES FROM AverageSales);

-- Which customers had the highest sales for each year and product line?
SELECT CUSTOMERNAME,
       YEAR_ID,
       PRODUCTLINE,
       SALES
FROM sales_data
WHERE SALES = (
    SELECT MAX(SALES)
    FROM sales_data AS sub
    WHERE sub.YEAR_ID = sales_data.YEAR_ID
    AND sub.PRODUCTLINE = sales_data.PRODUCTLINE
);