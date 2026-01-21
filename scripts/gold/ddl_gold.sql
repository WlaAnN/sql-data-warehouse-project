/*
==============================
Create view for gold layer
==============================

Purpose:
	This script drops needed view if they already exist and recreates new ones.

Usage:
  These views can be queries direcly fo analytics and reporting.
*/

IF OBJECT_ID('gold.dim_customer', 'V') IS NOT NULL
  DROP VIEW gold.dim_customer
GO
CREATE VIEW gold.dim_customer AS
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cl.cntry AS country,
	CASE 
		WHEN ci.cst_gndr = 'Unknown' THEN COALESCE(ca.gen, 'Unknown')
		ELSE ci.cst_gndr
	END AS gender,
	ci.cst_marital_status AS marital_status,
	ca.bdate AS birth_date,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 cl
ON ci.cst_key = cl.cid

GO

IF OBJECT_ID('gold.dim_product', 'V') IS NOT NULL 
  DROP VIEW gold.dim_product
GO
CREATE VIEW gold.dim_product AS
SELECT
	ROW_NUMBER() OVER(ORDER BY ti.prd_id) AS product_key,
	ti.prd_id AS product_id,
	ti.prd_key AS product_number,
	ti.prd_nm AS product_name,
	ti.prd_cat_id AS category_id,
	tc.cat AS category,
	tc.subcat AS subcategory,
	tc.maintenance,
	ti.prd_cost AS cost,
	ti.prd_line AS product_line,
	ti.prd_start_dt AS start_date
FROM silver.crm_prd_info ti
LEFT JOIN silver.erp_px_cat_g1v2 tc
ON ti.prd_cat_id = tc.id
WHERE ti.prd_end_dt IS NULL

GO

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
  DROP VIEW 'gold.fact_sales' 
GO 
CREATE VIEW gold.fact_sales AS
SELECT
	sls_ord_num AS order_number,
	ti.product_key,
	ci.customer_key,
	sls_order_dt AS order_date,
	sls_ship_dt AS shipping_date,
	sls_due_dt AS due_date,
	sls_sales AS sales_amount,
	sls_quantity AS quantity,
	sls_price AS price
FROM silver.crm_sales_details si
LEFT JOIN gold.dim_product ti
ON ti.product_number = si.sls_prd_key
LEFT JOIN gold.dim_customer ci
ON ci.customer_id = si.sls_cust_id 


  
