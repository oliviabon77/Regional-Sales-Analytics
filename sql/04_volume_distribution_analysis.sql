-- Transaction distribution by region
-- for each product sub-category

SELECT
    "Sub-Category",

    SUM(
        CASE WHEN Region = 'West' 
        THEN 1 ELSE 0 
    END) AS west_count,

    SUM(
        CASE WHEN Region = 'East' 
        THEN 1 ELSE 0 
    END) AS east_count,

    SUM(
        CASE WHEN Region = 'Central' 
        THEN 1 ELSE 0 
    END) AS central_count,

    SUM(
        CASE WHEN Region = 'South' 
        THEN 1 ELSE 0 
    END) AS south_count,

    COUNT(*) AS total,
    ROUND(SUM(Sales), 2) AS total_revenue

FROM sales
GROUP BY "Sub-Category"
ORDER BY total_revenue DESC;
