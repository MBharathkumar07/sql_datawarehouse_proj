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


















-- fix crm_prd_info





INSERT INTO silver.crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
SELECT
prd_id,
REPLACE(SUBSTRING(prd_key,1,5), '-','_') as cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) as prd_key,
prd_nm,
ISNULL(prd_cost, 0) as prd_cost,
CASE
	WHEN UPPER(TRIM(prd_line)) = 'R' then 'Road'
	WHEN UPPER(TRIM(prd_line)) = 'M' then 'Mountain'
	WHEN UPPER(TRIM(prd_line)) = 'S' then 'other sales'
	WHEN UPPER(TRIM(prd_line)) = 'T' then 'Touring'
else 'n/a'
END as prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
    CAST(
        DATEADD(day, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) 
    AS DATE) AS prd_end_dt
from bronze.crm_prd_info;
