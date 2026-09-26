-- Quaries to test silver.crm_cust_info


-- Writing a query to check if any duplicates are there in PK(cst_id) or not

select 
	cst_id,
	count(*) as count
from silver.crm_cust_info
group by cst_id
having count(*) > 1;



-- checking for unwanted space in firstname

select cst_firstname 
from silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname);




--checking for unwanted space in lastname

select cst_lastname 
from silver.crm_cust_info
where cst_lastname != TRIM(cst_lastname);




--lets check the values in martial_status column

select distinct cst_martial_status 
from silver.crm_cust_info;




-- lets check the values in gender column
select distinct cst_gndr
from silver.crm_cust_info;





--test for crm

