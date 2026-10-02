--===========================================================================
-- Quaries to test silver.crm_cust_info
--===========================================================================

--===========================================================================
-- Writing a query to check if any duplicates are there in PK(cst_id) or not
--===========================================================================

select 
	cst_id,
	count(*) as count
from silver.crm_cust_info
group by cst_id
having count(*) > 1;


--==========================================================================
-- checking for unwanted space in firstname
--==========================================================================

select cst_firstname 
from silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname);



--=========================================================================
--checking for unwanted space in lastname
--=========================================================================

select cst_lastname 
from silver.crm_cust_info
where cst_lastname != TRIM(cst_lastname);


--========================================================================
--lets check the values in martial_status column
--========================================================================

select distinct cst_martial_status 
from silver.crm_cust_info;

--========================================================================
-- lets check the values in gender column
--========================================================================

select distinct cst_gndr
from silver.crm_cust_info;














--========================================================================
--test for crm_prd_info
--========================================================================


--========================================================================
-- cheking prd_id has any duplicates or null 
--========================================================================

select prd_id,
count(*) as count
from bronze.crm_prd_info
group by prd_id
having count(*) > 1 and prd_id is null;



--=======================================================================
-- checking if prd_nm has any unwanted space
--=======================================================================

select * 
from silver.crm_prd_info
where prd_nm != trim(prd_nm);

--======================================================================
-- checking prd_cost has any null
--======================================================================

select *
from bronze.crm_prd_info
where prd_cost is null;


--======================================================================
-- lets check if the start date is less than end date
--======================================================================

select *from silver.crm_prd_info
where prd_start_dt > prd_end_dt;












========================================================================
-- test for crm_sales_details
========================================================================


========================================================================
-- Checking for invalid dates for sls_order_dt
========================================================================
	
SELECT
sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0 or len(sls_order_dt) != 8 or sls_order_dt is null
========================================================================
-- Checking for invalid dates for sls_ship_dt
========================================================================
	
SELECT
sls_ship_dt
from bronze.crm_sales_details
where sls_ship_dt <= 0 or len(sls_ship_dt) != 8 or sls_ship_dt is null
========================================================================
-- Lets check for due_dt
========================================================================
	
SELECT
sls_due_dt
from bronze.crm_sales_details
where sls_due_dt <= 0 or len(sls_due_dt) != 8 or sls_due_dt is null;

SELECT * from bronze.crm_sales_details
where sls_sales is null or sls_sales !=  sls_quantity * sls_price  ;


SELECT * from bronze.crm_sales_details
where sls_price is null or sls_price !=  sls_sales / sls_quantity  ;

SELECT * from bronze.crm_sales_details
where sls_quantity is null or sls_quantity !=  sls_sales / sls_price  ;













-- test for erp_cust_az12



-- Lets get the diff types of values in gender
select distinct gen
from bronze.erp_cust_az12;


-- getting invalud bdates
SELECT DISTINCT
bdate
from bronze.erp_cust_az12
where bdate < '1926-01-01' or bdate > getdate()
