# online-retail-sql-project
SQL project: data cleaning, EDA, and insights using an online retail dataset.

----
## Replace null with "No Customer ID"

```SQL
FROM online_retail
WHERE TRIM(CustomerID) = '';

UPDATE online_retail
SET CustomerID = 'No Customer ID'
WHERE CustomerID IS NULL OR TRIM(CustomerID) = '';
```
## Delete negative and zero quantities:
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

-- Remove dublicates
DELETE FROM online_retail
WHERE rowid NOT IN (
  SELECT MIN(rowid)
  FROM online_retail
  GROUP BY InvoiceNo, StockCode, Quantity, InvoiceDate, CustomerID
);

--Create new column "TotalAmount"
ALTER TABLE online_retail ADD COLUMN TotalAmount DECIMAL(10,2);

-- Assign values to"TotalAmount"
UPDATE online_retail
SET TotalAmount = Quantity * UnitPrice;
