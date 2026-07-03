# 🏪 Olist E-Commerce Data Warehouse

## 📌 Overview

An end-to-end SQL Data Warehouse built on the **Olist Brazilian E-Commerce Dataset**—a real-world commercial dataset containing over **100,000 orders** placed across multiple Brazilian marketplaces.

The project follows the **Medallion Architecture (Bronze → Silver → Gold)**, transforming eight raw CSV source files into a clean, business-ready **Star Schema** optimized for analytical queries and reporting.

### Key Features

- Bronze, Silver, and Gold layered architecture
- SQL-based ETL pipeline using stored procedures
- Star schema dimensional modeling
- Data quality validation
- Business-ready analytical views

---

# 🏗️ Architecture

![Data Architecture](docs/architecture.png)

The data warehouse is organized into three progressive layers:

### 🟤 Bronze Layer
Raw data is ingested as-is from eight CSV source files into SQL Server using stored procedures and `BULK INSERT`. No transformations are applied, preserving the original source data.

### 🥈 Silver Layer
Data is cleaned, standardized, and enriched through:
- Data cleansing
- Data standardization
- Duplicate removal
- Category translation
- Derived business columns
- Data enrichment

### 🥇 Gold Layer
Business-ready **Star Schema** implemented using SQL views, optimized for analytical reporting and business intelligence.

---

# 📂 Repository Structure

```text
olist-ecommerce-data-warehouse/
│
├── data_quality/
│   ├── quality_checks_gold.sql
│   └── quality_checks_silver.sql
│
├── docs/
│   ├── architecture.png
│   └── data_catalog.md
│
├── scripts/
│   ├── bronze/
│   │   ├── ddl_bronze.sql
│   │   └── load_bronze.sql
│   │
│   ├── silver/
│   │   ├── ddl_silver.sql
│   │   ├── explore_bronze.sql
│   │   └── load_silver.sql
│   │
│   ├── gold/
│   │   └── ddl_gold.sql
│   │
│   └── init_database.sql
│
└── README.md
```

---

# 📊 Dataset

**Source:** **[Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)**

The project uses eight CSV datasets:

| Dataset | Description |
|----------|-------------|
| `olist_customers_dataset.csv` | Customer details and locations |
| `olist_orders_dataset.csv` | Order status and timestamps |
| `olist_order_items_dataset.csv` | Products and pricing per order |
| `olist_order_payments_dataset.csv` | Payment methods and payment values |
| `olist_order_reviews_dataset.csv` | Customer review scores and comments |
| `olist_products_dataset.csv` | Product information and categories |
| `olist_sellers_dataset.csv` | Seller information and locations |
| `product_category_name_translation.csv` | Portuguese-to-English category mapping |

---

# 🔄 ETL Pipeline

## 🟤 Bronze Layer

All eight CSV files are loaded into SQL Server using the stored procedure `bronze.load_bronze` with `BULK INSERT`. No transformations are applied, ensuring the raw source data is preserved.

## 🥈 Silver Layer

Data is transformed through the stored procedure `silver.load_silver`, which performs:

- Data cleansing
- Data standardization
- Date casting
- Category translation
- Review deduplication
- Data enrichment
- Derived columns:
  - `delivery_days`
  - `late_flag`

## 🥇 Gold Layer

The Gold layer implements a business-ready **Star Schema** consisting of:

- `fact_orders`
- `dim_customers`
- `dim_products`
- `dim_sellers`
- `dim_payments`

For detailed table and column descriptions, see **docs/data_catalog.md**.

---

# ✅ Data Quality

SQL validation scripts are included to verify:

- Duplicate records
- Missing values
- Primary key uniqueness
- Referential integrity
- Business rule consistency

Quality check scripts are located in the **data_quality/** directory.

---

# ▶️ How to Run

## Prerequisites

- SQL Server Express
- SQL Server Management Studio (SSMS)

## Setup

1. Download the **[Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)**.
2. Update the CSV file paths in `load_bronze.sql`.
3. Execute the SQL scripts in the following order:

```text
scripts/init_database.sql

scripts/bronze/ddl_bronze.sql
scripts/bronze/load_bronze.sql

scripts/silver/ddl_silver.sql
scripts/silver/load_silver.sql

scripts/gold/ddl_gold.sql
```

4. Execute the SQL scripts in the `data_quality/` folder to validate the warehouse.

---

# 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| SQL Server Express | Database engine |
| SQL Server Management Studio (SSMS) | Database development and execution |
| SQL | ETL, transformation, and dimensional modeling |
| Draw.io | Architecture diagram |
| Git & GitHub | Version control and project hosting |

---
