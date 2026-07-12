USE olist_dwh;
GO


/* ====================================================
   1. Database Exploration
==================================================== */

-- checking what views exist in gold layer
SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gold';

-- all columns in gold schema
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'
ORDER BY TABLE_NAME, ORDINAL_POSITION;


/* ====================================================
   2. Dimensions Exploration
==================================================== */

-- distinct customer states
SELECT DISTINCT customer_state
FROM gold.dim_customers
ORDER BY customer_state;

-- distinct product categories
SELECT DISTINCT category_name
FROM gold.dim_products
ORDER BY category_name;

-- how many products fall under 'Unknown'
SELECT COUNT(*) AS unknown_count
FROM gold.dim_products
WHERE category_name = 'Unknown';

-- unknown as % of total
SELECT 
    (SELECT COUNT(*) FROM gold.dim_products WHERE category_name = 'Unknown') * 100.0 
    / (SELECT COUNT(*) FROM gold.dim_products) AS unknown_pct;

SELECT DISTINCT order_status
FROM gold.fact_orders
ORDER BY order_status;

SELECT DISTINCT payment_type
FROM gold.dim_payments
ORDER BY payment_type;

-- need to check what values late_flag actually has before using it later
SELECT DISTINCT late_flag
FROM gold.fact_orders;


/* ====================================================
   3. Date Range Exploration
==================================================== */

-- min and max order date, total months covered
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS range_in_months
FROM gold.fact_orders;


/* ====================================================
   4. Measures Exploration
==================================================== */

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    COUNT(DISTINCT seller_id) AS total_sellers,
    SUM(price) AS total_revenue,
    AVG(price) AS avg_price,
    AVG(delivery_days) AS avg_delivery_days
FROM gold.fact_orders;

-- customer_id is per order not per person, so checking real unique customers
SELECT COUNT(DISTINCT customer_unique_id) AS unique_people
FROM gold.dim_customers;


/* ====================================================
   5. Magnitude Exploration
==================================================== */

-- revenue by state
SELECT 
    c.customer_state,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.price) AS total_revenue
FROM gold.fact_orders f
JOIN gold.dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- top 10 categories by revenue
SELECT TOP 10
    p.category_name,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.price) AS total_revenue,
    SUM(f.price) / COUNT(DISTINCT f.order_id) AS avg_rev_per_order
FROM gold.fact_orders f
JOIN gold.dim_products p ON f.product_id = p.product_id
GROUP BY p.category_name
ORDER BY total_revenue DESC;


/* ====================================================
   6. Ranking Exploration
==================================================== */

-- top 10 sellers by revenue
SELECT TOP 10
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.price) AS total_revenue
FROM gold.fact_orders f
JOIN gold.dim_sellers s ON f.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_state
ORDER BY total_revenue DESC;

-- late delivery % by state (late_flag values: Late / On Time / N/A)
SELECT 
    c.customer_state,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN f.late_flag = 'Late' THEN 1 ELSE 0 END) AS late_orders,
    SUM(CASE WHEN f.late_flag = 'Late' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS late_pct
FROM gold.fact_orders f
JOIN gold.dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY late_pct DESC;