# Data Catalog

## Overview
The Gold Layer is the buisness ready data. It contains **dimensions** and **facts tables**. 

---

### 1. **gold.dim_customer**
**Purpose:** It has all the information about customers
**Columns:**
| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| customer_key | INT | Surrogate primary key for customers |
| customer_id | INT | Identifier from the original source |
| customer_number | NVARCHAR(50) | Alphanumeric identifier used to track orders |
| first_name | NVARCHAR(50) | Customer's first name |
| last_name | NVARCHAR(50) | Customer's last name | 
| country | NVARCHAR(50) | Customer's location (e.g., 'Australia') |
| gender | NVARCHAR(50) | Customer's gender (e.g., 'Male') |
| marital_status | NVARCHAR(50) | Customer's marital status (e.g., Married) |
| birth_date | DATE | Customer's birth date | 
| create_date | DATE | Customer's account create date|

---

### 2. **gold.dim_product**
**Purpose:** It has all the information about products
**Columns:**
| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| product_key | INT | Surrogate primary key for products |
| product_id | INT | Identifier from the original source |
| product_number | NVARCHAR(50) | Alphanumeric identifier used connect with orders |
| product_name | NVARCHAR(50) | Product name |
| category_id | NVARCHAR(50) | Product's category id | 
| category | NVARCHAR(50) | Product's category name |
| subcategory | NVARCHAR(50) | Product's subcategory name |
| maintenance | NVARCHAR(50) | Maintenance ('Yes' or 'No') |
| cost | INT | Product's cost measured in monetary | 
| product_line | NVARCHAR(50) | Product line or series to which the product belongs (e.g., 'Road') |
| start_date | DATE | The date when the product became available |

---

### 3. **gold.fact_sales**
**Purpose:** It has all the information about products
**Columns:**
| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| order_number | NVARCHAR(50) | A unique alphanumeric order identifier |
| product_key | INT | Foreign key to connect with dim_product |
| customer_key | INT | Foreign key to connect with dim_customer |
| order_date | DATE | A date when the order was placed |
| shipping_date | DATE | A date when the order was shipped |
| due_date | DATE | A date when the order payment was due |
| sales_amount | INT | The total monetary value of the sale  (e.g., '100') |
| quantity | INT | The number of units (e.g., '10') |
| price | INT | The price per unit (e.g., '10') |
