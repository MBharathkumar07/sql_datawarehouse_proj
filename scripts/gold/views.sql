================================================================
-- Creating dimension customer table
================================================================
  
CREATE VIEW gold.dim_customers AS
SELECT 
ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
ci.cst_id                          AS customer_id,
ci.cst_key                         AS customer_number,
ci.cst_firstname                   AS first_name,
ci.cst_lastname                    AS last_name,
cl.cntry                           AS country,
ci.cst_martial_status              As martial_status,
COALESCE(ci.cst_gndr, ca.gen)      As gender,
ca.bdate                           AS birthdate,
ci.csr_create_date                 As create_date
from silver.crm_cust_info as ci
left join silver.erp_cust_az12 as ca
	on ci.cst_key = ca.cid
left join silver.erp_loc_a101 as cl
	on ci.cst_key = cl.cid;
