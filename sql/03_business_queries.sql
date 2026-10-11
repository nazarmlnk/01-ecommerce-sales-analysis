-- ============================================================
-- Бізнес-запити: Olist E-Commerce Sales Analysis
-- Відповідає на питання з business_questions.md
-- Revenue = SUM(price) з order_items, лише order_status = 'delivered'
-- ============================================================


-- ------------------------------------------------------------
-- Q1. Який загальний revenue?
-- ------------------------------------------------------------
SELECT
    COUNT(DISTINCT o.order_id)           AS delivered_orders,
    ROUND(SUM(oi.price)::numeric, 2)     AS total_revenue,
    ROUND(AVG(oi.price)::numeric, 2)     AS avg_item_price
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';


-- ------------------------------------------------------------
-- Q2. Як revenue змінювався по місяцях? (+ MoM growth)
-- Неповні місяці на краях позначені через in_analysis_period
-- ------------------------------------------------------------
WITH monthly_revenue AS (
    SELECT
        o.purchase_month,
        o.in_analysis_period,
        ROUND(SUM(oi.price)::numeric, 2) AS revenue,
        COUNT(DISTINCT o.order_id)       AS orders_count
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.purchase_month, o.in_analysis_period
)
SELECT
    purchase_month,
    in_analysis_period,
    revenue,
    orders_count,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY purchase_month))
        / NULLIF(LAG(revenue) OVER (ORDER BY purchase_month), 0) * 100,
        1
    ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY purchase_month;


-- ------------------------------------------------------------
-- Q3. Які категорії генерують найбільше revenue?
-- Товари без категорії потрапляють в 'unknown' (заповнено на етапі cleaning)
-- ------------------------------------------------------------
WITH category_revenue AS (
    SELECT
        p.category,
        ROUND(SUM(oi.price)::numeric, 2)   AS revenue,
        COUNT(DISTINCT oi.order_id)        AS orders_count,
        COUNT(*)                           AS items_sold
    FROM order_items oi
    JOIN orders o   ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.order_status = 'delivered'
    GROUP BY p.category
)
SELECT
    category,
    revenue,
    orders_count,
    items_sold,
    ROUND(revenue / SUM(revenue) OVER () * 100, 1) AS pct_of_total_revenue
FROM category_revenue
ORDER BY revenue DESC
LIMIT 15;
