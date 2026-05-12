-- Regional revenue, order volume, and customer metrics

SELECT
    Region,
    ROUND(SUM(Sales), 2) AS total_revenue,
    COUNT(DISTINCT "Order ID") AS total_orders,
    COUNT(DISTINCT "Customer ID") AS unique_customers,
    ROUND(AVG(Sales), 2) AS avg_order_value,
    ROUND(
        SUM(Sales) / COUNT(DISTINCT "Customer ID"), 
        2
    ) AS revenue_per_customer
FROM sales
GROUP BY Region
ORDER BY total_revenue DESC;
