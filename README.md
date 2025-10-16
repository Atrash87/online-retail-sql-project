# online-retail-sql-project
**SQL project**: data cleaning, EDA, and insights using an online retail dataset.
## The row Data can be found in the following link:
https://archive.ics.uci.edu/dataset/352/online+retail

## Dataset Information
This is a transactional data set which contains all the transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail.The company mainly sells unique all-occasion gifts. Many customers of the company are wholesalers.

---
# 1. Data Cleaning
## 1.1 Replace null with "No Customer ID"

```SQL
FROM online_retail
WHERE TRIM(CustomerID) = '';

UPDATE online_retail
SET CustomerID = 'No Customer ID'
WHERE CustomerID IS NULL OR TRIM(CustomerID) = '';
```
## 1.2 Standardize text & Delete (negativ & zero quantities):
```SQL
DELETE FROM online_retail WHERE Quantity <= 0;

--Delete negative and zero UnitPrice:
DELETE FROM online_retail WHERE UnitPrice <= 0;

--Trim and Standardize Text
UPDATE online_retail
SET Description = TRIM(Description),
    Country = TRIM(Country);

--Lower case Standardized Text
UPDATE online_retail
SET
    Description = LOWER(TRIM(Description)),
    Country = LOWER(TRIM(Country));
```

## 1.3 Remove dublicates
```SQL
DELETE FROM online_retail
WHERE rowid NOT IN (
  SELECT MIN(rowid)
  FROM online_retail
  GROUP BY InvoiceNo, StockCode, Quantity, InvoiceDate, CustomerID
);
```
## 1.4 Create new column "TotalAmount"

```SQL
ALTER TABLE online_retail ADD COLUMN TotalAmount DECIMAL(10,2);

-- Assign values to"TotalAmount"
UPDATE online_retail
SET TotalAmount = Quantity * UnitPrice;
```
---
# 2. Exploratory Data analysis (EDA)

## 2.1 Sales analysis
- **Total amount** = 10631960.06 £
```SQL
SELECT ROUND(SUM(TotalAmount), 2) AS total_revenue
FROM online_retail;
```
- **Average Order Value** = 532.66 £
```SQL
SELECT ROUND(SUM(TotalAmount)/COUNT(DISTINCT InvoiceNo), 2) AS avg_order_value
FROM online_retail;
```
- **Top 10 Invoices by Revenue**

```SQL
SELECT InvoiceNo, ROUND(SUM(TotalAmount), 2) AS invoice_total
FROM online_retail
GROUP BY InvoiceNo
ORDER BY invoice_total DESC
LIMIT 10;
```

![Top 10 Invoices by total amount](/Figures/Top_10_Invoices_by_Total_Amount.png)

## 2.2 Customer analysis
- **Top Customers by Revenue**
```sql
SELECT CustomerID, SUM(TotalAmount) AS Revenue
FROM online_retail
GROUP BY CustomerID
ORDER BY Revenue DESC
LIMIT 10;
```
![Top 10 customers by Revenue](/Figures/Top_10_Customers_by_Revenue.png)

- **Top Countries by Sales**
```SQL
SELECT Country, SUM(TotalAmount) AS TotalSales
FROM online_retail
GROUP BY Country
ORDER BY TotalSales DESC
LIMIT 10;
```
![Top Countries by Sales](/Figures/Top_10_Countries_by_Total_Sales.png)

## 2.3 Product analysis
- **Top-Selling Products by Quantity**
```SQL
SELECT Description, SUM(Quantity) AS TotalSold
FROM online_retail
GROUP BY Description
ORDER BY TotalSold DESC
LIMIT 10;
```
![Top-Selling Products by Quantity](/Figures/Top_selling_product.png)

- **Top Products by Revenue**
```SQl
SELECT Description, ROUND(SUM(TotalAmount),2) AS total_revenue
FROM online_retail
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;
```
![Top Products by Revenue](/Figures/Top_10_Products_by_Total_Revenue.png)

## 2.4 Time based analysis
```SQL
--Sales per Month
SELECT
  YearMonth as Month,
  ROUND(SUM(TotalAmount), 2) AS monthly_sales
FROM online_retail
GROUP BY YearMonth
ORDER BY YearMonth;
```
![Sales per Month](/Figures/Monthly_Sales_Trend.png)

# 3. Advanced analysis
## 3.1 RFM segmentation (Recency, Frequency, Monetary)**

```SQL
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

![RFM segmentation](/Figures/RFM.png)

## 3.2 Customer Retention Over Time
```SQL
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
![Customer Retention Over Time](/Figures/Customer_Retention_by_Cohort_(Monthly).png)





