-- fix crm_cust_info


insert into silver.crm_cust_info(
	cst_id, 
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_martial_status,
	cst_gndr,
	csr_create_date )
select 
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lastname,
case 
	when TRIM(UPPER(cst_martial_status)) = 'M' then 'Married'
	when TRIM(UPPER(cst_martial_status)) = 'S' then 'Single'
else 'n/a'
end as cst_martial_status,
case
	when TRIM(UPPER(cst_gndr)) = 'M' then 'Male'
	when TRIM(UPPER(cst_gndr)) = 'F' then 'Female'
else 'n/a'
end as cst_gndr,
csr_create_date
from (
	select *, 
		row_number() 
		over(partition by cst_id order by csr_create_date) as flag_last
	from bronze.crm_cust_info
) as t
where flag_last = 1 and cst_id is not null;
