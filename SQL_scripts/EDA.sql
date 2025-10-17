--Overview
--Total Records
SELECT COUNT(*) AS total_records FROM online_retail;

--Unique Customers, Products, Countries
SELECT
  COUNT(DISTINCT CustomerID) AS unique_customers,
  COUNT(DISTINCT StockCode) AS unique_products,
  COUNT(DISTINCT Country) AS unique_countries
FROM online_retail;

--Time Range
SELECT
  MIN(InvoiceDate) AS first_transaction,
  MAX(InvoiceDate) AS last_transaction
FROM online_retail;


--Sales analysis

--Total Revenue
SELECT ROUND(SUM(TotalAmount), 2) AS total_revenue
FROM online_retail;

--Average Order Value
SELECT
  ROUND(SUM(TotalAmount) / COUNT(DISTINCT InvoiceNo), 2) AS avg_order_value
FROM online_retail;

--Top 10 Invoices by Revenue
SELECT
  InvoiceNo,
  ROUND(SUM(TotalAmount), 2) AS invoice_total
FROM online_retail
GROUP BY InvoiceNo
ORDER BY invoice_total DESC
LIMIT 10;


--Customer analysis

--Top customers by revenue
SELECT CustomerID, SUM(UnitPrice) AS Revenue
FROM Online_Retail
GROUP BY CustomerID
ORDER BY Revenue DESC
LIMIT 10;

--Top sales by country
SELECT Country, sum(t.TotalAmount)  AS TotalSales
FROM Online_Retail t 
GROUP BY Country
ORDER BY TotalSales DESC
limit(10);

--Customers with Missing ID total sales
SELECT
  CustomerID,
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM online_retail
WHERE CustomerID = 'No Customer ID'
GROUP BY CustomerID;

-- Product Analysis

-- TOp selling product
SELECT Description, SUM(Quantity) AS TotalSold
FROM Online_Retail
GROUP BY Description
ORDER BY TotalSold DESC
LIMIT 10;

--Top 10 Products by Revenue
SELECT
  Description,
  ROUND(SUM(TotalAmount), 2) AS total_revenue
FROM online_retail
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;

--Least sold product
SELECT
  Description,
  SUM(Quantity) AS total_quantity_sold
FROM online_retail
GROUP BY Description
HAVING SUM(Quantity) > 0
ORDER BY total_quantity_sold ASC
LIMIT 10;

-- Country insights
--Top 10 Countries by Revenue
SELECT
  Country,
  ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM online_retail
GROUP BY Country
ORDER BY total_revenue DESC
LIMIT 10;

--Average Order Value per Country
SELECT
  Country,
  ROUND(SUM(TotalAmount) / COUNT(DISTINCT InvoiceNo), 2) AS avg_order_value
FROM online_retail
GROUP BY Country
ORDER BY avg_order_value DESC;



--Time-Based analysis
--Sales per Month
SELECT
  YearMonth as Month,
  ROUND(SUM(TotalAmount), 2) AS monthly_sales
FROM online_retail
GROUP BY YearMonth
ORDER BY YearMonth;



--Advanced analysis

--RFM segmentation (Recency, Frequency, Monetary)

```SQl
  WITH customer_summary AS (
  SELECT 
    CustomerID,
    MAX(date(InvoiceDate)) AS last_purchase,
    COUNT(DISTINCT InvoiceNo) AS frequency,
    SUM(Quantity * UnitPrice) AS monetary
  FROM online_retail
  WHERE CustomerID IS NOT NULL
  GROUP BY CustomerID
)
SELECT
  CustomerID,
  CAST(julianday('2011-12-10') - julianday(last_purchase) AS INTEGER) AS recency_days,
  frequency,
  monetary
FROM customer_summary
ORDER BY monetary DESC
LIMIT 70;
```
-- Customer retention over time

```Sql
WITH first_purchase AS (
  SELECT 
    CustomerID,
    MIN(YearMonth) AS cohort_month
  FROM Online_Retail
  WHERE CustomerID IS NOT NULL
  GROUP BY CustomerID
),
customer_monthly AS (
  SELECT 
    CustomerID,
    YearMonth AS order_month
  FROM Online_Retail
  WHERE CustomerID IS NOT NULL
  GROUP BY CustomerID, YearMonth
)
SELECT
  f.cohort_month,
  c.order_month,
  COUNT(DISTINCT c.CustomerID) AS active_customers
FROM first_purchase f
JOIN customer_monthly c 
  ON f.CustomerID = c.CustomerID
GROUP BY f.cohort_month, c.order_month
ORDER BY f.cohort_month, c.order_month;
```












