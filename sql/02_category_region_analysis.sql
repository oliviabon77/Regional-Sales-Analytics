-- Revenue breakdown by category and region

SELECT
    Category,
    Region,
    ROUND(SUM(Sales), 2) AS total_revenue,
    COUNT(DISTINCT "Order ID") AS orders,
    ROUND(AVG(Sales), 2) AS avg_order_value
FROM sales
GROUP BY Category, Region
ORDER BY Category, total_revenue DESC;
