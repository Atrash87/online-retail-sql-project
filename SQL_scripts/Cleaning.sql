


SELECT COUNT(*) AS empty_or_whitespace_ids
FROM online_retail
WHERE TRIM(CustomerID) = '';

--Replace null with "No Customer ID"

UPDATE online_retail
SET CustomerID = 'No Customer ID'
WHERE CustomerID IS NULL OR TRIM(CustomerID) = '';

--Delete negative and zero quantities:
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

--Optional; Create a view table that includes the new created columns:
CREATE VIEW OnlineRetail_enriched AS
SELECT
  InvovieNo,
  StockCode,
  Description,
  Quantity,
  UnitPrice,
  (quantity * unit_price) AS TotalAmount,
  InvoiceDate,
  DATE_TRUNC('day', invoice_date) AS SaleDate,
  CustomerID,
  Country
FROM online_retail;








