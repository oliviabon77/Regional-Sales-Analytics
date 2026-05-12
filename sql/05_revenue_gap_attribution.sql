-- Quantifies how pricing differences contribute
-- to the West vs South revenue gap

WITH region_subcat AS (

    SELECT
        Region,
        "Sub-Category",
        SUM(Sales) AS revenue,
        COUNT(*) AS transactions,
        AVG(Sales) AS avg_price
    FROM sales
    GROUP BY Region, "Sub-Category"

),

west_baseline AS (

    SELECT
        "Sub-Category",
        avg_price AS west_avg_price
    FROM region_subcat
    WHERE Region = 'West'

),

south_actual AS (

    SELECT
        r."Sub-Category",
        r.revenue AS south_revenue,
        r.transactions AS south_transactions,
        r.avg_price AS south_avg_price,
        w.west_avg_price,

        ROUND(
            (r.avg_price - w.west_avg_price)
            * r.transactions,
            2
        ) AS pricing_effect

    FROM region_subcat r
    JOIN west_baseline w
        ON r."Sub-Category" = w."Sub-Category"

    WHERE r.Region = 'South'

)

SELECT
    "Sub-Category",
    south_revenue,
    south_transactions,

    ROUND(south_avg_price, 2) AS south_avg,
    ROUND(west_avg_price, 2) AS west_avg,

    pricing_effect

FROM south_actual
ORDER BY ABS(pricing_effect) DESC;
