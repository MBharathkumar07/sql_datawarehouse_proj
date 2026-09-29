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

