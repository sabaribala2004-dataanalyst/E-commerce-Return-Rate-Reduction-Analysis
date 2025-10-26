CREATE TABLE ecommerce_returns (
  order_id TEXT PRIMARY KEY,
  customer_id TEXT,
  product_id TEXT,
  category TEXT,
  supplier TEXT,
  region TEXT,
  marketing_channel TEXT,
  order_date DATE,
  price NUMERIC(12,2),
  quantity INTEGER,
  customer_age INTEGER,
  payment_type TEXT,
  shipping_time_days INTEGER,
  delivery_issue TEXT,
  return_flag SMALLINT,
  return_reason TEXT
);

DROP TABLE ecommerce_returns

----Load Dataset
COPY ecommerce_returns
FROM 'C:\Program Files\PostgreSQL\18\ecommerce_returns_mixed.csv'
WITH CSV HEADER;

-- Quick data validation
SELECT COUNT(*) FROM ecommerce_returns;

----Remove exact duplicate rows
DELETE FROM ecommerce_returns a
USING ecommerce_returns b
WHERE a.ctid < b.ctid
  AND a.Order_ID = b.Order_ID
  AND a.Product_ID = b.Product_ID
  AND a.Order_Date = b.Order_Date;

----Standardize delivery issue flags  
UPDATE ecommerce_returns
SET Delivery_Issue = UPPER(TRIM(Delivery_Issue));

---Add helpful indexes for faster analysis
CREATE INDEX idx_orders_date ON ecommerce_returns(Order_Date);
CREATE INDEX idx_product ON ecommerce_returns(Product_ID);
CREATE INDEX idx_category ON ecommerce_returns(Category);
CREATE INDEX idx_region ON ecommerce_returns(Region);
CREATE INDEX idx_marketing ON ecommerce_returns(Marketing_Channel);

---Overall Return Rate
SELECT
  COUNT(*) AS total_orders,
  SUM(Return_Flag) AS total_returns,
  ROUND( SUM(Return_Flag)::decimal / NULLIF(COUNT(*),0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns;


-----Return % by Category  
SELECT
  Category,
  COUNT(*) AS total_orders,
  SUM(Return_Flag) AS total_returns,
  ROUND( SUM(Return_Flag)::decimal / NULLIF(COUNT(*),0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns
GROUP BY Category
ORDER BY return_rate_pct DESC;

------Return % by Supplier
SELECT 
  Supplier,
  COUNT(*) AS Total_Orders,
  SUM(Return_Flag) AS Returned_Orders,
  ROUND(SUM(Return_Flag) * 100.0 / COUNT(*), 2) AS Return_Percentage
FROM ecommerce_returns
GROUP BY Supplier
ORDER BY Return_Percentage DESC;

------Return % by Region
SELECT
  Region,
  COUNT(*) AS total_orders,
  SUM(Return_Flag) AS total_returns,
  ROUND( SUM(Return_Flag)::decimal / NULLIF(COUNT(*),0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns
GROUP BY Region
ORDER BY return_rate_pct DESC;

------Return % by  marketing channel
  Marketing_Channel,
  COUNT(*) AS total_orders,
  SUM(Return_Flag) AS total_returns,
  ROUND( SUM(Return_Flag)::decimal / NULLIF(COUNT(*),0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns
GROUP BY Marketing_Channel
ORDER BY return_rate_pct DESC;

----Top return reasons
SELECT Return_Reason, COUNT(*) AS reason_count,
       ROUND( COUNT(*)::decimal / (SELECT COUNT(*) FROM ecommerce_returns WHERE Return_Flag=1) * 100, 2) AS percent_of_returns
FROM ecommerce_returns
WHERE Return_Flag=1 GROUP BY Return_Reason ORDER BY reason_count DESC;

------Shipping time vs returns (average shipping days by return status)
SELECT
Return_Flag,
  COUNT(*) AS n,
  ROUND(AVG(Shipping_Time_days)::numeric,2) AS avg_shipping_days
FROM ecommerce_returns
GROUP BY Return_Flag;

----Delivery issues effect
SELECT
  Delivery_Issue,
  COUNT(*) AS total_orders,
  SUM(Return_Flag) AS total_returns,
  ROUND( SUM(Return_Flag)::decimal / NULLIF(COUNT(*),0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns
GROUP BY Delivery_Issue
ORDER BY return_rate_pct DESC;

-- Create convenient SQL views for Power BI
CREATE OR REPLACE VIEW vw_return_overall AS
SELECT
  COUNT(*) AS total_orders,
  SUM(Return_Flag) AS total_returns,
  ROUND( SUM(Return_Flag)::decimal / NULLIF(COUNT(*),0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns;

-- Category summary view
CREATE OR REPLACE VIEW vw_return_by_category AS
SELECT
  Category,
  COUNT(*) AS total_orders,
  SUM(Return_Flag) AS total_returns,
  ROUND( SUM(Return_Flag)::decimal / NULLIF(COUNT(*),0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns
GROUP BY Category;

-- 🔹 Direct calculation of product-wise return rate
CREATE OR REPLACE VIEW vw_high_risk_products AS
SELECT
  product_id,
  category,
  region,
  marketing_channel,
  COUNT(*) AS total_orders,
  SUM(return_flag) AS total_returns,
  ROUND(SUM(return_flag)::DECIMAL / NULLIF(COUNT(*), 0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns
GROUP BY product_id, category, region, marketing_channel
HAVING
  SUM(return_flag) >= 1     -- change this if your dataset is small (try 1 or 2 first)
  AND ROUND(SUM(return_flag)::DECIMAL / NULLIF(COUNT(*), 0) * 100, 2) > 20   -- reduce to 20% for testing
ORDER BY return_rate_pct DESC;

---Overall Return Rate
SELECT 
  COUNT(*) AS total_orders,
  SUM(return_flag) AS total_returns,
  ROUND(SUM(return_flag)::DECIMAL / COUNT(*) * 100, 2) AS overall_return_rate
FROM ecommerce_returns;

-- Top 10 High Risk Products
SELECT
    category,
    region,
    marketing_channel,
    COUNT(*) AS total_orders,
    SUM(return_flag) AS total_returns,
    ROUND(SUM(return_flag)::DECIMAL / NULLIF(COUNT(*), 0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns
GROUP BY category, region, marketing_channel
HAVING COUNT(*) > 1                      -- only products with more than 1 order
   AND ROUND(SUM(return_flag)::DECIMAL / NULLIF(COUNT(*), 0) * 100, 2) > 5  -- return rate > 20%
ORDER BY return_rate_pct DESC
LIMIT 10;  -- top 10 risky products

-- Combined View: Delivery Issues + Shipping Time
SELECT
    delivery_issue,
    COUNT(*) AS total_orders,
    SUM(return_flag) AS total_returns,
    ROUND(SUM(return_flag)::DECIMAL / NULLIF(COUNT(*),0) * 100, 2) AS return_rate_pct,
    ROUND(AVG(shipping_time_days)::NUMERIC, 2) AS avg_shipping_days
FROM ecommerce_returns
GROUP BY delivery_issue
ORDER BY return_rate_pct DESC;

-- Payment Method vs Return Rate
SELECT
    payment_type,
    COUNT(*) AS total_orders,
    SUM(return_flag) AS total_returns,
    ROUND(SUM(return_flag)::DECIMAL / NULLIF(COUNT(*), 0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns
GROUP BY payment_type
ORDER BY return_rate_pct DESC;

-----Age vs Return Rate
SELECT
  customer_age,
  COUNT(*) AS total_orders,
  SUM(return_flag) AS total_returns,
  ROUND(SUM(return_flag)::DECIMAL / NULLIF(COUNT(*), 0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns
GROUP BY customer_age
ORDER BY return_rate_pct DESC
LIMIT 5;

----Return Rate Over Time
SELECT
  TO_CHAR(DATE_TRUNC('month', order_date), 'Mon YYYY') AS month,
  COUNT(*) AS total_orders,
  SUM(return_flag) AS total_returns,
  ROUND(SUM(return_flag)::DECIMAL / NULLIF(COUNT(*), 0) * 100, 2) AS return_rate_pct
FROM ecommerce_returns
GROUP BY TO_CHAR(DATE_TRUNC('month', order_date), 'Mon YYYY')
ORDER BY return_rate_pct DESC
LIMIT 5;




