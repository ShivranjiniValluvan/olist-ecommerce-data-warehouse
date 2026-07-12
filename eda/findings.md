# EDA Findings

Key observations from the exploratory analysis on the Gold layer of `olist_dwh`.

## Dataset Overview
| Metric | Value |
|---|---|
| Date range | Sep 2016 – Sep 2018 (24 months) |
| Total orders | 98,666 |
| Unique customers | 96,096 |
| Repeat purchase rate | ~2.6% |
| Total revenue | ~13.6M |
| Average item price | ~120 |
| Average delivery time | 12 days |

## Revenue is heavily concentrated in the Southeast region
- SP alone contributes ~38% of total revenue and ~42% of total orders.
- SP, RJ, and MG together account for ~61% of total revenue.
- North region states (AM, AC, AP, RR) each contribute under 25,000 in revenue.

## Category revenue does not always follow order volume
- `health_beauty` generates the highest revenue despite `bed_bath_table` having more orders, indicating a higher average item price.
- `watches_gifts` shows a similar pattern — comparatively low order volume but strong revenue, pointing to higher-priced items.

## Delivery delays are more common away from the Southeast
- AL has the highest late delivery rate at ~23%, followed by MA and SE.
- SP, MG, and PR, the states with the highest order volume, have the lowest late delivery rates, all under 6%.
- This suggests delivery delays are linked more to distance from the seller-dense Southeast region than to order volume.

## Minor inconsistencies exist in the source data
- `category_name` contains a few inconsistent labels carried over from the original dataset (e.g. `costruction_tools_garden`, `home_confort`), left unchanged to preserve source accuracy.
- ~1.89% of products fall under an `Unknown` category.
- `late_flag` includes an `N/A` value, likely for cancelled or undelivered orders where delivery days could not be calculated.
