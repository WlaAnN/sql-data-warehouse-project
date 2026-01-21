/*
=================================
Tests for data quality
=================================
*/

/*
=================================
crm_cust_info
=================================
*/

--General lookup
SELECT TOP 50
	*
FROM silver.crm_cust_info;

--Checking primary key
SELECT
	flag
FROM( 
	SELECT
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date) flag
	FROM silver.crm_cust_info) t
WHERE flag != 1;

--Checking for standardized values in cst_gndr
SELECT DISTINCT
	cst_gndr
FROM silver.crm_cust_info;

--Checking for standardized values in cst_marital_status
SELECT DISTINCT
	cst_marital_status
FROM silver.crm_cust_info;

--Checking for unwanted spaces in cst_lastname and cst_firstname
SELECT
	cst_firstname,
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname) OR cst_lastname != TRIM(cst_lastname);


/*
=================================
crm_prd_info
=================================
*/

--Gereral lookup 
SELECT TOP 50
	*
FROM silver.crm_prd_info;

--Checking if prd_cat_id has the correct format
SELECT
	prd_cat_id
FROM silver.crm_prd_info
WHERE prd_cat_id LIKE '%-%';

--Checking if the values in prd_line are standardized
SELECT DISTINCT
	prd_line
FROM silver.crm_prd_info;

--Checking for NULLs in prd_cost
SELECT
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL;

--Checking if prd_end_dt is before then prd_start_dt
SELECT
	prd_start_dt,
	prd_end_dt
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;


/*
=================================
crm_sales_details
=================================
*/
--General lookup
SELECT TOP 50
	*
FROM silver.crm_sales_details;

--Cheking if sls_prd_key does not exist in crm_prd_info
SELECT	
	s.sls_prd_key,
	p.prd_key
FROM silver.crm_sales_details s
LEFT JOIN silver.crm_prd_info p
ON s.sls_prd_key = p.prd_key
WHERE p.prd_key IS NULL;

--Cheking if sls_cust_id does not exist in crm_cust_info
SELECT
	s.sls_cust_id,
	c.cst_id
FROM silver.crm_sales_details s
LEFT JOIN silver.crm_cust_info c
ON c.cst_id = s.sls_cust_id
WHERE c.cst_id IS NULL;

--Checking if sls_order_dt is after sls_ship_dt or sls_due_dt
SELECT
	sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

/*Checking if sls_sales has wrong calculations or sls_sales is negative or NULL
or sls_price is negative or 0 or NULL*/

SELECT 
	sls_sales
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price OR sls_sales IS NULL
	OR sls_price IS NULL OR sls_price <= 0;

/*
=================================
erp_cust_az12
=================================
*/

--General lookup
SELECT TOP 50
	*
FROM silver.erp_cust_az12;

--Checking if cid has the right format
SELECT
	cid
FROM silver.erp_cust_az12
WHERE cid LIKE 'NAS%';

--Checking if bdate is greater then current date
SELECT
	bdate 
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

--Checking if values in gen are standardized
SELECT DISTINCT 
	gen
FROM silver.erp_cust_az12;

/*
=================================
erp_loc_a101
=================================
*/

--General lookup
SELECT TOP 50
	*
FROm silver.erp_loc_a101;

--Checking if values in cntry are standardized
SELECT DISTINCT	
	cntry
FROM silver.erp_loc_a101;

--Checking if cid has the right format
SELECT
	cid
FROM silver.erp_loc_a101
WHERE cid LIKE '%-%';

/*
=================================
erp_px_cat_g1v2
=================================
*/

--General lookup
SELECT TOP 50
	*
FROM silver.erp_px_cat_g1v2;

--Checking if cat is standardized
SELECT DISTINCT	
	cat
FROM silver.erp_px_cat_g1v2;

--Checking if subcat is standardized
SELECT DISTINCT	
	subcat
FROM silver.erp_px_cat_g1v2;

--Checking if maintenance is standardized
SELECT DISTINCT	
	maintenance
FROM silver.erp_px_cat_g1v2;
