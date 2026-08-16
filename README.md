# Sales Insights with SQL and Python

Analyze a retail sales dataset using **SQL (SQLite)** for data aggregation and **Python** for visualization.  
This project demonstrates how to move from raw transactional data → structured SQL database → actionable business insights with clear visuals.
        
---

## Project Overview

This project combines **data engineering**, **SQL analytics**, and **data visualization** to uncover key sales insights from a retail dataset.  
You’ll see how SQL handles powerful data aggregation, while Python brings the results to life with visualizations.

**Workflow:**
1. Load CSV data → SQLite database  
2. Run SQL queries for KPIs  
3. Export insights to CSV  
4. Visualize results with charts

---

## Project Structure

```text
sales-insights-sql/
├─ README.md
├─ requirements.txt
├─ data/
│  └─ sales_data.csv
├─ src/
│  ├─ create_db.py
│  ├─ queries.sql
│  ├─ advanced_analysis.sql
│  ├─ analyze_sales.py
│  ├─ run_advanced_analysis.py
│  └─ utils.py
└─ outputs/
   ├─ charts/
   │  ├─ revenue_by_region.png
   │  └─ monthly_sales_trend.png
   ├─ revenue_by_region.csv
   ├─ top_products_by_revenue.csv
   ├─ top_products_by_quantity.csv
   ├─ monthly_sales_trend.csv
   └─ aov_summary.csv
   ```

## Dataset
A synthetic retail transaction dataset covering one full year (2024),
with 10 products across 4 regions: North, South, East and West.

The dataset contains approximately 18K transaction-level records and
supports analysis of revenue, order volume, product performance and
regional trends.

| Column | Description |
|--------|--------------|
| order_id | Unique order identifier |
| date | Order date (YYYY-MM-DD) |
| region | Sales region |
| product | Product name |
| quantity | Quantity sold |
| unit_price | Unit price of the product |
| revenue | Calculated as `quantity × unit_price` |

Example preview:

| order_id | date       | region | product  | quantity | unit_price | revenue |
|-----------|------------|--------|-----------|-----------|-------------|----------|
| 1001 | 2024-01-01 | North | Laptop | 2 | 1050.00 | 2100.00 |
| 1001 | 2024-01-01 | North | Mouse | 1 | 23.50 | 23.50 |
| 1002 | 2024-01-01 | South | Printer | 1 | 145.00 | 145.00 |

---

## Setup & Usage

### Create Virtual Environment

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS/Linux
source .venv/bin/activate

pip install -r requirements.txt
```

### Create SQLite Database

```bash
python src/create_db.py --csv data/sales_data.csv --db sales.db
```

### Run SQL Analytics + Visualization

```bash
python src/analyze_sales.py --db sales.db --sql src/queries.sql --outdir outputs
```

---

## SQL Queries Summary

Inside `src/queries.sql`, five core analyses are defined:

| Query | Description |
|-------|--------------|
| **Revenue by Region** | Total revenue per region |
| **Top Products by Revenue** | Best-selling products |
| **Top Products by Quantity** | Most purchased products |
| **Monthly Sales Trend** | Revenue trend over time |
|**verage Order Value (AOV)** | Revenue per unique order by region

Example SQL snippet:

```sql
SELECT region, ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
GROUP BY region
ORDER BY total_revenue DESC;
```
### Additional Business Analysis

Additional business-focused analyses are implemented in
`src/advanced_analysis.sql`:

| Analysis | Purpose |
|----------|---------|
| **February Revenue RCA** | Decompose a monthly revenue decline by region |
| **Regional Performance Decomposition** | Compare revenue, orders, AOV and revenue share |
| **Product Revenue Concentration** | Measure each product's contribution to total revenue |
| **Top-3 Revenue Concentration** | Quantify revenue concentration among the highest-revenue products |


---

## Example Results

### Revenue by Region
<img width="1200" height="750" alt="revenue_by_region" src="https://github.com/user-attachments/assets/6b9ba0bc-1299-416d-8de4-6e49d2ed7968" />

**Insight:**  
The West region generated the highest annual revenue at approximately
$3.86M, followed by North at $3.81M. South recorded the lowest annual
revenue at approximately $3.45M.
---

### Monthly Sales Trend
<img width="1200" height="750" alt="monthly_sales_trend" src="https://github.com/user-attachments/assets/b5a403a4-6ae2-4f1d-998c-5073ff7bb676" />

**Insight:**  
Monthly revenue varied throughout 2024, with March recording the highest
monthly revenue at approximately $1.35M and February recording the lowest
at approximately $1.08M.

---
### Top Products by Revenue

| Product | Total Revenue | Revenue Share |
|----------|--------------:|--------------:|
| Laptop | $4,929,052.61 | 33.48% |
| Smartphone | $3,597,663.09 | 24.44% |
| Tablet | $2,242,695.88 | 15.23% |
| Monitor | $997,930.52 | 6.78% |
| Desk | $921,657.40 | 6.26% |
| Chair | $715,615.33 | 4.86% |
| Printer | $657,355.50 | 4.46% |
| Headphones | $347,820.89 | 2.36% |
| Keyboard | $204,620.71 | 1.39% |
| Mouse | $108,065.89 | 0.73% |

**Insight:**  
Laptop, Smartphone and Tablet together contribute **73.15% of total
revenue**, indicating significant revenue concentration among the top
three products.



---

### Average Order Value (AOV)


| Region | Total Revenue | Unique Orders | AOV | Revenue Share |
|--------|--------------:|--------------:|----:|--------------:|
| West | $3,863,611.34 | 2,272 | $1,700.53 | 26.24% |
| North | $3,808,908.00 | 2,324 | $1,638.94 | 25.87% |
| East | $3,595,279.81 | 2,195 | $1,637.94 | 24.42% |
| South | $3,454,678.67 | 2,188 | $1,578.92 | 23.47% |

**Insight:**  
West recorded the highest AOV at **$1,700.53**, while North had the
highest number of unique orders at **2,324**. This shows that regional
performance can differ depending on whether it is evaluated through
order volume, order value, or total revenue.
---



## Root-Cause Analysis: February Revenue Decline

Monthly revenue decreased from **$1.323M in January to $1.082M in
February**, representing an **18.16% month-over-month decline**.

Regional decomposition showed:

| Region | Revenue Change |
|--------|---------------:|
| South | -$99,716.37 |
| East | -$91,235.92 |
| North | -$43,223.96 |
| West | -$6,058.16 |

South and East together accounted for approximately **79.5% of the
total revenue decline**, identifying these regions as the primary areas
for further investigation.

---

## Business Implications

- The February revenue decline was concentrated primarily in the South
  and East regions, which together contributed approximately 79.5% of
  the decline.
- West recorded the highest revenue and AOV, while North recorded the
  highest number of unique orders.
- Laptop, Smartphone and Tablet contributed 73.15% of total revenue,
  indicating significant revenue concentration among the top three
  products.
- These findings can help prioritize further investigation into
  regional performance and high-revenue product performance.
---

## Tools & Libraries

| Technology | Purpose |
|-------------|----------|
| **SQLite** | Lightweight SQL database |
| **Python** | Orchestration, analysis, visualization |
| **pandas** | Data manipulation & CSV I/O |
| **matplotlib** | Chart creation |
| **SQL** | Querying and data aggregation |


---

## Key Learnings

- Combine **SQL** and **Python** for real-world analytics workflows  
- Build reproducible, automated reports  
- Apply common business KPIs: revenue, trends, and AOV  
- Communicate insights effectively with visuals

---

## Conclusion

**Sales Insights with SQL and Python** demonstrates an end-to-end
business analytics workflow, from loading transaction-level data into
SQLite to performing SQL-based analysis and communicating findings
through Python visualizations.

The project goes beyond descriptive reporting by evaluating regional
performance, product revenue concentration, and the drivers of a
significant month-over-month revenue decline.
