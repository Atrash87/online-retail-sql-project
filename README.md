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
# 2. Data analysis

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
SELECT CustomerID, SUM(UnitPrice) AS Revenue
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
```
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





