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









-- fix crm_sales_details


insert into silver.crm_sales_details(
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
	WHEN sls_order_dt <= 0 or len(sls_order_dt) != 8 THEN NULL
	ELSE cast(cast(sls_order_dt as varchar) as date)
END as sls_order_dt,
CASE 
	WHEN sls_ship_dt <= 0 or len(sls_ship_dt) != 8 THEN NULL
	ELSE cast(cast(sls_ship_dt as varchar) as date)
END as sls_ship_dt,
CASE	
	WHEN sls_due_dt <= 0 or len(sls_due_dt) != 8 THEN NULL
	ELSE cast(cast(sls_due_dt as varchar) as date)
END as sls_due_dt,
CASE
	WHEN sls_sales is null or sls_sales != sls_quantity * abs(sls_price)
	THEN sls_quantity * abs(sls_price)
	ELSE sls_sales
END as sls_sales,
sls_quantity,
CASE
	WHEN sls_price is null or sls_price <= 0
	THEN sls_sales / nullif(sls_quantity,0)
	ELSE sls_price
END as sls_price
from bronze.crm_sales_details;










-- Fix erp_cust_az12



INSERT INTO silver.erp_cust_az12(
cid,
bdate,
gen
)
SELECT 
CASE 
	WHEN cid like 'NASA%' then substring(cid, 4, len(cid))
	ELSE cid
END AS cid,
CASE
	WHEN bdate > getdate() or bdate < '1924-01-01' THEN null
	ELSE bdate
END AS bdate,
CASE
	WHEN UPPER(trim(gen)) in ('M','Male') then 'Male' 
	WHEN UPPER(trim(gen)) in ('F', 'Female') then 'Female'
	ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_az12;
