-- Measures regional pricing inconsistencies
-- across product sub-categories

SELECT
    "Sub-Category",

    ROUND(AVG(
        CASE WHEN Region = 'West' 
        THEN Sales 
    END), 2) AS west_avg,

    ROUND(AVG(
        CASE WHEN Region = 'East' 
        THEN Sales 
    END), 2) AS east_avg,

    ROUND(AVG(
        CASE WHEN Region = 'Central' 
        THEN Sales 
    END), 2) AS central_avg,

    ROUND(AVG(
        CASE WHEN Region = 'South' 
        THEN Sales 
    END), 2) AS south_avg,

    ROUND(AVG(Sales), 2) AS overall_avg,
    COUNT(*) AS total_transactions

FROM sales
GROUP BY "Sub-Category"
ORDER BY overall_avg DESC;
