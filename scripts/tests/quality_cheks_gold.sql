/*
===================
gold.dim_customer
===================
*/

--General lookup
SELECT
	*
FROM gold.dim_customer

--Standardization checks
SELECT DISTINCT
	gender
FROM gold.dim_customer

SELECT DISTINCT
	country
FROM gold.dim_customer

SELECT DISTINCT
	marital_status
FROM gold.dim_customer

--Cheking if date of birth is greater then current date
SELECT 
  *
FROM gold.dim_customer
WHERE birth_date > GETDATE()

/*
===================
gold.dim_product
===================
*/

--General lookup
SELECT
  *
FROM gold.dim_product

--Standardization checks
SELECT DISTINCT
	category
FROM gold.dim_product

SELECT DISTINCT
	subcategory
FROM gold.dim_customer

SELECT DISTINCT
	marital_status
FROM gold.dim_customer

/*
===================
gold.fact_sales
===================
*/

--General lookup
SELECT
  *
FROM gold.fact_sales

--Checking if foreign keys exist in dim tables
SELECT
  *
FROM gold.fact_sales s
LEFT JOIN gold.dim_customer c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_product p
ON s.product_key = p.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL

--Cheking for wrong calculations
SELECT
  *
FROM gold.fact_sales 
WHERE sales_amount != quantity * price




