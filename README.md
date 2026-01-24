# SQL Data Warehouse Project
## 📌 Project Overview

This project implements a layered SQL Data Warehouse using Microsoft SQL Server.
The solution follows the Bronze → Silver → Gold architecture to ingest raw data, apply data quality rules, and expose analytics-ready datasets.

The warehouse integrates data from the following source systems:

1. CRM — customers, products, and sales
2. ERP — customers, locations, and product categories

The Gold layer represents the presentation layer and is designed for BI tools and analytical queries.

---

## 🏗️ Architecture
| Layer | Purpose | Description |
|-------|---------|-------------|
| Bronze | Raw ingestion | Stores raw data loaded directly from source CSV files |
| Silver | Cleansed data | Applies transformations, standardization, and validation |
| Gold | Analytics | Exposes dimensional and fact views for reporting |

---

## 🛢️ Database Initialization

The init_database.sql script performs the following actions:

1. Drops and recreates the DataWareHouse database
2. Creates logical schemas: bronze, silver, and gold

### WARNING
Running this script will permanently delete the existing DataWareHouse database if it already exists.

---

## 🥉 Bronze Layer
### 📄 Data Definition

Defined in ddl_bronze.sql.

Raw tables representing CRM and ERP source systems are created without applying business transformations.

### 🔄 Load Process

Implemented in proc_load_bronze.sql.

Key characteristics:

1. Full reload strategy using TRUNCATE TABLE
2. Data ingestion from CSV files via BULK INSERT
3. Execution time logging for each table
4. Centralized error handling using TRY / CATCH

Example execution:

```EXEC bronze.load_bronze;```

---

## 🥈 Silver Layer
### 📄 Data Definition

Defined in ddl_silver.sql.

Enhancements compared to the Bronze layer:

1. Normalized data types
2. Additional audit column (dwh_create_date)
3. Tables optimized for analytical workloads

### 🔧 Transformations

Implemented in proc_load_silver.sql.

Key data quality rules:

1. Customer deduplication using window functions
2. Standardization of gender, marital status, and country values
3. Validation and correction of date fields
4. Sales data consistency checks and recalculation
5. Product category parsing and normalization

Example execution:

```EXEC silver.load_silver;```

---

## 🥇 Gold Layer

Defined in ddl_gold.sql as presentation-level SQL views.

### 📐 Dimensions

1. gold.dim_customer
2. gold.dim_product

### 📊 Fact

gold.fact_sales

Design principles:

1. Surrogate keys generated using ROW_NUMBER()
2. Clean joins between CRM and ERP domains
3. Star-schema-friendly structure
4. Optimized for BI and reporting tools

---

## 📊 Diagrams

The project includes diagrams illustrating:

1. Data Architecture
2. Data Flow
3. Data Integration
4. Data Model

Diagrams a stored in docs/

---

## 🧰 Technologies Used

1. Microsoft SQL Server
2. T-SQL
3. BULK INSERT
4. Layered Data Warehouse architecture
5. Dimensional modeling

6. ---

## 🎯 Key Learnings

1. End-to-end Data Warehouse design
2. Layered ETL implementation in SQL
3. Practical data cleansing and validation
4. Dimensional modeling for analytics
5. Writing production-grade stored procedures

Additional learning is working with Git

--

## 📌 Notes

1. All data loads are implemented as full refresh processes
2. CSV file paths must be adapted to the local environment
3. The project is intended for educational and portfolio purposes
