# Regional Sales Analytics — Superstore Dataset

Sales analysis on a US retail superstore dataset looking at why revenue varies so much across the four regions. The West brings in $710k and the South brings in $389k, which is a 45% gap, and the goal was to trace where that comes from rather than just observe that it exists.

Turns out the answer is both pricing inconsistencies and lower volume in the South, and they don't point in the same direction.

---

## The Question

West region: $710,220. South region: $389,151. That's a $321,068 difference. What's driving it?

---

## Findings

**The gap shows up across all three product categories**

Breaking revenue down by Furniture, Office Supplies, and Technology separately, the same ranking appears in all three: West and East lead, Central is in the middle, South is last. It's not a single-category issue.

**Machines have a large pricing spread across regions**

The Machines sub-category averages $2,994 per sale in the South versus $1,088 in the West. That's a 107% spread for the same product type across regions. Copiers show a 64% spread and Tables show a 59% spread.

**South transaction volume is below the 25% baseline in every sub-category**

With four regions, equal distribution would give each region roughly 25% of transactions. South is under that in every one of the top 10 sub-categories by revenue. Copiers are the most extreme at 10.6%.

**The Machines pricing effect is actually positive for the South**

South charges more per machine than any other region and sells fewer of them. The gap attribution analysis shows this adds $34,301 to South revenue relative to West pricing. The volume deficit is the bigger problem, not pricing in the direction you'd expect.

---

## Approach

Data is the Sample Superstore Sales Dataset from Kaggle: 9,800 rows, 4 regions, 3 categories, 17 sub-categories, 2015 to 2018.

After validating the data (11 missing postal codes, nothing that affects the analysis), the regional revenue summary came from SQL GROUP BY aggregations in DuckDB. From there, a pivot by category tested whether the gap was isolated or consistent across product lines.

The pricing analysis calculated average sale value per sub-category per region and used a spread metric to rank which sub-categories had the most inconsistency across regions.

The gap attribution used a counterfactual: what would South revenue have been for each sub-category if it had sold at West's average prices? The difference isolates the pricing component from the volume component.

Tools: Python (Pandas, DuckDB, Matplotlib). Power BI dashboard coming soon with the star schema and DAX measures built on the clean output tables.

---

## Results

**Regional Revenue Summary**

| Region  | Revenue    | Orders | Avg Order | Revenue / Customer |
|---------|------------|--------|-----------|--------------------|
| West    | $710,220   | 1,587  | $226      | $1,043             |
| East    | $669,519   | 1,369  | $240      | $1,001             |
| Central | $492,647   | 1,156  | $216      | $787               |
| South   | $389,151   | 810    | $244      | $765               |

West to South revenue gap: **$321,068 (45.2%)**

**Top Pricing Inconsistencies by Sub-Category**

| Sub-Category | West Avg | East Avg | Central Avg | South Avg | Spread |
|--------------|----------|----------|-------------|-----------|--------|
| Machines     | $1,088   | $1,787   | $1,276      | $2,994    | 107%   |
| Copiers      | $2,020   | $2,661   | $2,329      | $1,329    | 64%    |
| Tables       | $717     | $491     | $544        | $877      | 59%    |

**South Volume Share vs 25% Equal-Share Baseline**

| Sub-Category | South Share | At or Above 25%? |
|--------------|-------------|------------------|
| Copiers      | 10.6%       | No               |
| Bookcases    | 12.4%       | No               |
| Chairs       | 14.2%       | No               |
| Storage      | 15.3%       | No               |
| Machines     | 15.7%       | No               |
| Phones       | 15.9%       | No               |
| Tables       | 15.9%       | No               |
| Binders      | 16.2%       | No               |
| Paper        | 16.3%       | No               |
| Accessories  | 16.5%       | No               |

South is below the 25% baseline in all 10 top sub-categories by revenue.

---

## Charts

<img width="2384" height="1769" alt="regional_sales_analysis (2)" src="https://github.com/user-attachments/assets/4b0bbea9-6421-4a1a-8ec5-8f3ab32f7bb7" />


Power BI dashboard coming soon.

---
## SQL Files

This project includes standalone SQL files extracted from the DuckDB workflow used in the Python analysis pipeline.

The SQL covers:
- Regional KPI aggregation
- Revenue breakdowns by category and region
- Pricing inconsistency analysis
- Transaction volume distribution
- Revenue gap attribution using counterfactual pricing logic

DuckDB was used within Google Colab to run the analytical SQL queries and generate output tables for downstream visualization and dashboarding.

## Future Directions

A few things worth exploring with more time or better data:

- **Profit margin by region** — this dataset only has revenue, not cost. The South's higher average sale value on Machines could mean higher margins or it could mean different product mix within the sub-category. Would need cost data to separate those.

- **Customer-level analysis** — the gap in revenue per customer ($1,043 West vs $765 South) is significant but this analysis treats it as an output, not an input. Worth digging into whether South customers buy less frequently, buy smaller items, or churn faster.

- **Time series** — the dataset covers 2015 to 2018. Is the gap growing, shrinking, or stable over time? A year-over-year breakdown by region would show whether this is a structural long-term issue or something that shifted recently.

- **Zip code or state-level analysis** — the South region is large and geographically diverse. Aggregating the whole region might be masking a smaller number of high-performing states and a long tail of underperforming ones.

- **Statistical significance** — the pricing spread analysis is descriptive. A proper test (e.g. ANOVA across regions for each sub-category) would confirm whether the differences are statistically meaningful or just noise from small sample sizes, especially for low-volume sub-categories like Copiers (66 total transactions).

---


## Repo Structure

```text
regional-sales-analytics/
│
├── superstore_regional_analysis.py
├── regional_sales_analysis.png
├── README.md
│
├── sql/
│   ├── 01_regional_revenue_summary.sql
│   ├── 02_category_region_analysis.sql
│   ├── 03_pricing_inconsistency_analysis.sql
│   ├── 04_volume_distribution_analysis.sql
│   └── 05_revenue_gap_attribution.sql
│
└── outputs/
    ├── fact_sales.csv
    ├── dim_region_summary.csv
    ├── dim_category_region.csv
    ├── dim_pricing_analysis.csv
    ├── dim_monthly_revenue.csv
    ├── dim_volume_distribution.csv
    └── gap_attribution.csv
```
```

---

## How to Run

Download the dataset from Kaggle (search "Sample Superstore"), open Google Colab, upload `train.csv`, paste the script and run. The last cell downloads all output CSVs automatically.

```python
!pip install duckdb  # only needed in Colab
```

---

## Author

Olivia Bonnette, CWRU B.S. Biomedical Engineering and Business Management (May 2026)
[linkedin.com/in/oliviabonnette](https://linkedin.com/in/oliviabonnette) | [GitHub](https://github.com/oliviabon77)
