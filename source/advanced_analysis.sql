-- =========================================================
-- ADVANCED BUSINESS ANALYSIS
-- =========================================================


-- 1) FEBRUARY REVENUE DROP — ROOT CAUSE ANALYSIS
-- Compare January vs February revenue and orders by region

WITH monthly_region AS (
    SELECT
        strftime('%Y-%m', date) AS month,
        region,
        SUM(revenue) AS revenue,
        COUNT(DISTINCT order_id) AS orders
    FROM sales
    WHERE date >= '2024-01-01'
      AND date < '2024-03-01'
    GROUP BY month, region
)

SELECT
    region,
    ROUND(SUM(CASE WHEN month = '2024-01'
                   THEN revenue ELSE 0 END), 2) AS jan_revenue,

    ROUND(SUM(CASE WHEN month = '2024-02'
                   THEN revenue ELSE 0 END), 2) AS feb_revenue,

    ROUND(
        SUM(CASE WHEN month = '2024-02'
                 THEN revenue ELSE 0 END)
        -
        SUM(CASE WHEN month = '2024-01'
                 THEN revenue ELSE 0 END),
        2
    ) AS revenue_change

FROM monthly_region
GROUP BY region
ORDER BY revenue_change ASC;


-- =========================================================


-- 2) REGIONAL PERFORMANCE DECOMPOSITION
-- Revenue + orders + AOV + revenue contribution

SELECT
    region,

    ROUND(SUM(revenue), 2) AS total_revenue,

    COUNT(DISTINCT order_id) AS orders,

    ROUND(
        SUM(revenue) * 1.0 /
        COUNT(DISTINCT order_id),
        2
    ) AS aov,

    ROUND(
        SUM(revenue) * 100.0 /
        (SELECT SUM(revenue) FROM sales),
        2
    ) AS revenue_share_pct

FROM sales

GROUP BY region

ORDER BY total_revenue DESC;


-- =========================================================


-- 3) PRODUCT REVENUE CONCENTRATION
-- Revenue contribution of each product

WITH product_revenue AS (
    SELECT
        product,
        SUM(revenue) AS revenue
    FROM sales
    GROUP BY product
)

SELECT
    product,

    ROUND(revenue, 2) AS total_revenue,

    ROUND(
        revenue * 100.0 /
        (SELECT SUM(revenue) FROM sales),
        2
    ) AS revenue_share_pct

FROM product_revenue

ORDER BY revenue DESC;


-- =========================================================


-- 4) TOP-3 PRODUCT REVENUE CONCENTRATION

WITH product_revenue AS (
    SELECT
        product,
        SUM(revenue) AS revenue
    FROM sales
    GROUP BY product
),

ranked_products AS (
    SELECT
        product,
        revenue,
        ROW_NUMBER() OVER (
            ORDER BY revenue DESC
        ) AS rnk
    FROM product_revenue
)

SELECT
    ROUND(SUM(revenue), 2) AS top_3_revenue,

    ROUND(
        SUM(revenue) * 100.0 /
        (SELECT SUM(revenue) FROM sales),
        2
    ) AS top_3_revenue_share_pct

FROM ranked_products