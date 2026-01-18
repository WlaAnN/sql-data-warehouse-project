/*
==========================
Loading Data on bronze lvl
==========================

Purpose:
	This sript creates procedure that trancates all the tables and then 
	fully loads all the data from crm and erp sources

Parameters:
	None

Using:
  EXEC bronze.load_bronze;
=====================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN	
	DECLARE @start_time DATETIME, @end_time DATETIME, @full_start_time DATETIME, @full_end_time DATETIME 
	BEGIN TRY
		PRINT '====================';
		PRINT 'Loading Bronze Layer';
		PRINT '====================';

		PRINT '--------------------';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------';

		PRINT '';
		PRINT '-------------------------';
		SET @full_start_time = GETDATE();
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\DataEngineer\Project\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration for crm_cust_info:' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR);
		PRINT '-------------------------';
		PRINT '';

		PRINT '';
		PRINT '-------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\DataEngineer\Project\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration for crm_prd_info:' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR);
		PRINT '-------------------------';
		PRINT '';

		PRINT '';
		PRINT '-------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\DataEngineer\Project\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration for crm_sales_details:' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR);
		PRINT '-------------------------';
		PRINT '';

		PRINT '--------------------';
		PRINT 'Loading ERP Tables';
		PRINT '--------------------';

		PRINT '';
		PRINT '-------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\DataEngineer\Project\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration for erp_cust_az12:' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR);
		PRINT '-------------------------';
		PRINT '';

		PRINT '';
		PRINT '-------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\DataEngineer\Project\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration for erp_loc_a101:' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR);
		PRINT '-------------------------';
		PRINT '';

		PRINT '';
		PRINT '-------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\DataEngineer\Project\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load duration for erp_px_cat_g1v2:' + CAST(DATEDIFF(second, @end_time, @start_time) AS NVARCHAR);
		PRINT '-------------------------';
		PRINT '';
		SET @full_end_time = GETDATE();
		PRINT '===========================================';
		PRINT 'Loading Bronze Layer Completed Successfully'
		PRINT 'Full Load Time: ' + CAST(DATEDIFF(second, @full_start_time, @full_end_time) AS NVARCHAR);
		PRINT '===========================================';
	END TRY
	BEGIN CATCH
		PRINT '============================';
		PRINT 'ERROR WHILE LOADING DATA';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '============================';
	END CATCH
END 
