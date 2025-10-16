# online-retail-sql-project
SQL project: data cleaning, EDA, and insights using an online retail dataset.

----
# Data Cleaning
## Replace null with "No Customer ID"

```SQL
FROM online_retail
WHERE TRIM(CustomerID) = '';

UPDATE online_retail
SET CustomerID = 'No Customer ID'
WHERE CustomerID IS NULL OR TRIM(CustomerID) = '';
```
## Standardize text & Delete (negativ & zero quantities):
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

## Remove dublicates
```SQL
DELETE FROM online_retail
WHERE rowid NOT IN (
  SELECT MIN(rowid)
  FROM online_retail
  GROUP BY InvoiceNo, StockCode, Quantity, InvoiceDate, CustomerID
);
```
## Create new column "TotalAmount"

```SQL
ALTER TABLE online_retail ADD COLUMN TotalAmount DECIMAL(10,2);

-- Assign values to"TotalAmount"
UPDATE online_retail
SET TotalAmount = Quantity * UnitPrice;
```
---
# Data analysis

## 1. Sales analysis
- Total amount = 10631960.06 £
```SQL
SELECT ROUND(SUM(TotalAmount), 2) AS total_revenue
FROM online_retail;
```
- Average Order Value = 532.66 £
```SQL
SELECT ROUND(SUM(TotalAmount)/COUNT(DISTINCT InvoiceNo), 2) AS avg_order_value
FROM online_retail;
```
- Top 10 Invoices by Revenue
  ```SQL
  SELECT InvoiceNo, ROUND(SUM(TotalAmount), 2) AS invoice_total
FROM online_retail
GROUP BY InvoiceNo
ORDER BY invoice_total DESC
LIMIT 10;
```
----
![Top 10 Invoices by Revenue](/Figures/Top_10_Invoices_by_Total_Amount.png)
