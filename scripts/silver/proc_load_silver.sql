/* 
==================================
Cleansing table broze.cr_cust_info
==================================

Purpose:
	This script creates a procedure that loads data from broze layer to silver layer.
	Actions: 
		-Truncates silver tables.
		-Inserts transformed and cleansed data from bronze into silver tables.

Parameters:
	NONE

How to use:
	EXEC silver.load_silver

*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @full_start_time DATETIME, @full_end_time DATETIME 
	BEGIN TRY
		PRINT '====================';
		PRINT 'Loading Silver Layer';
		PRINT '====================';

		PRINT '--------------------';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------';
		PRINT ''

		SET @full_start_time = GETDATE();
		SET @start_time = GETDATE()
		PRINT '------------------------------------------';
		PRINT '>>Truncating Table: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>>Inserting Data Into Table: silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info (
			cst_id, 
			cst_key, 
			cst_firstname, 
			cst_lastname, 
			cst_marital_status, 
			cst_gndr, 
			cst_create_date)

		SELECT
			cst_id,
			TRIM(cst_key) AS cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE 
				WHEN cst_marital_status = 'S' THEN 'Single'
				WHEN cst_marital_status = 'M' THEN 'Married'
				ELSE 'Unknown'
			END AS cst_marital_status,
			CASE 
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				ELSE 'Unknown'
			END AS cst_gndr,
			cst_create_date
		FROM (
			SELECT
				*,
				ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last 
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		) t
		WHERE flag_last = 1;
		SET @end_time = GETDATE(); 
		PRINT '>> Load duration for crm_cust_info:' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
		PRINT '------------------------------------------';

		PRINT '';
		PRINT '------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: silver.crm_prd_info' ;
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>>Inserting Data Into Table: silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info(
			prd_id,
			prd_cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)

		SELECT
			prd_id,
			REPLACE(SUBSTRING(TRIM(prd_key), 1, 5), '-', '_') AS prd_cat_id,
			SUBSTRING(TRIM(prd_key), 7, LEN(prd_key)) AS prd_key,
			TRIM(prd_nm) AS prd_nm,
			ISNULL(prd_cost, 0) AS prd_cost,
			CASE UPPER(TRIM(prd_line))
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'Unknown'
			END AS prd_line,
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(
				LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) -1 
				AS DATE) 
			AS prd_end_dt
		FROM bronze.crm_prd_info;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration For crm_prd_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
		PRINT '------------------------------------------';

		PRINT '';
		PRINT '------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: silver.crm_sales_details'; 
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>>Inserting Data Into Table: silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE 
				WHEN sls_order_dt = 0 
					OR LEN(sls_order_dt) != 8 
					OR sls_order_dt < 19000101 
					OR sls_order_dt > 20500101
					THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) as DATE)
			END sls_order_dt, 
			CASE 
				WHEN sls_ship_dt = 0 
					OR LEN(sls_ship_dt) != 8 
					OR sls_ship_dt < 19000101 
					OR sls_ship_dt > 20500101
					THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) as DATE)
			END sls_ship_dt,
			CASE 
				WHEN sls_due_dt = 0 
					OR LEN(sls_due_dt) != 8 
					OR sls_due_dt < 19000101 
					OR sls_due_dt > 20500101
					THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) as DATE)
			END sls_due_dt,
			CASE 
				WHEN sls_sales <= 0 
					OR sls_sales IS NULL 
					OR sls_sales != ABS(sls_quantity) * ABS(sls_price)
				 THEN ABS(sls_quantity) * ABS(sls_price)  
				ELSE sls_sales
			END AS sls_sales,
			ABS(sls_quantity) AS sls_quantity,
			CASE 
				WHEN sls_price = 0 OR sls_price IS NULL THEN ABS(sls_sales) / NULLIF(ABS(sls_quantity), 0) 
				WHEN sls_price < 0 THEN ABS(sls_price)
				ELSE sls_price
			END AS sls_price
		FROM bronze.crm_sales_details;
		SET @end_time = GETDATE();
		PRINT '>> Load duration for crm_sales_details: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
		PRINT '------------------------------------------';

		PRINT '';
		PRINT '------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>>Inserting Data Into Table: silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12(
			cid,
			bdate,
			gen
		)
		SELECT
		CASE 
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
			ELSE cid
		END AS cid,
		CASE 
			WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
		END AS bdate,
		CASE
			WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
			ELSE 'Unknown'
		END AS gen
		FROM bronze.erp_cust_az12;
		SET @end_time = GETDATE();
		PRINT 'Load Duration For erp_cust_az12: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
		PRINT '------------------------------------------';

		PRINT '';
		PRINT '------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: silver.erp_loc_a101'; 
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>>Inserting Data Into Table: silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101(
			cid,
			cntry
		)
		SELECT
			REPLACE(cid, '-', '') AS cid,
			CASE
				WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY')  THEN 'Germany'
				WHEN UPPER(TRIM(cntry)) IN ('US', 'UNITED STATES', 'USA') THEN 'United States'
				WHEN UPPER(TRIM(cntry)) IN ('AUSTRALIA', 'CANADA', 'FRANCE', 'UNITED KINGDOM') THEN TRIM(cntry)
				ELSE 'Unknown'
			END AS cntry
		FROM bronze.erp_loc_a101; 
		SET @end_time = GETDATE();
		PRINT '>> Load duration for erp_loc_a101: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
		PRINT '------------------------------------------';

		PRINT '';
		PRINT '------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>>Truncating Table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>>Inserting Data Into Table: silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2(
			id,
			cat, 
			subcat,
			maintenance
		)
		SELECT 
			id,
			COALESCE(cat 'No category') AS cat, 
			COALESCE(subcat, 'No subcategory') AS subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		SET @full_end_time = GETDATE();
		PRINT '>> Load Duration For erp_px_cat_g1v2: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
		PRINT '------------------------------------------';
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-';
		PRINT '>> Full Load Duration: ' + CAST(DATEDIFF(SECOND, @full_start_time, @full_end_time) AS NVARCHAR);
		PRINT '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-';
 	END TRY
	BEGIN CATCH
		PRINT '============================';
		PRINT 'ERROR WHILE LOADING DATA';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '============================';
	END CATCH
END;
