select DISTINCT
A.V_NAME ASSURED_NAME,
B.D_ISSUE POLICY_ISSUE_DATE, 
B.V_POLICY_NO POLICY_NUMBER, 
B.N_PROPOSER_REF_NO CUSTOMER_REF_NUMBER,
A.V_Consent_Status DATA_PROCESSING_COSENT, 
A.V_Market_Consent_Status MARKET_CONSENT
FROM gnmt_policy B, gnmt_customer_master A
 where  B.N_PROPOSER_REF_NO =A.N_CUST_REF_NO
 AND  TO_CHAR(D_ISSUE, 'MON-YY') = 'JAN-24'
 ORDER BY 2 DESC


Select V_Consent_Status, V_Market_Consent_Status from gnmm_company_master;
Select * from Gndt_Company_Address;


--Y - For received
--N - Not received
--Blank - No comment
AGA KHAN FOUNDATION

Select A.V_Consent_Status, A.V_Market_Consent_Status, A.*  from gnmm_company_master A 
where V_COMPANY_NAME ='AGA KHAN FOUNDATION';

Select *  from gnmt_customer_master; --V_Consent_Status, V_Market_Consent_Status

select A.V_Consent_Status,A.V_Market_Consent_Status, 
A.* from gnmt_customer_master A where N_CUST_REF_NO = 244013

select DISTINCT
A.V_NAME ASSURED_NAME,
B.D_ISSUE POLICY_ISSUE_DATE, 
B.V_POLICY_NO POLICY_NUMBER, 
B.N_PROPOSER_REF_NO CUSTOMER_REF_NUMBER,
A.V_Consent_Status DATA_PROCESSING_COSENT, 
A.V_Market_Consent_Status MARKET_CONSENT
FROM gnmt_policy B, gnmt_customer_master A
 where  B.N_PROPOSER_REF_NO =A.N_CUST_REF_NO
 AND  TO_CHAR(D_ISSUE, 'MON-YY') = 'JAN-24'
 ORDER BY 2 DESC
 
--V_POLICY_NO ='UI202401053105'


update gnmt_customer_master
set -- V_Consent_Status ='Y',
V_Market_Consent_Status ='Y'
WHERE N_CUST_REF_NO IN (
SELECT DISTINCT N_PROPOSER_REF_NO FROM gnmt_policy where  V_POLICY_NO
IN ())

-- conset for group_policies
update gnmt_customer_master
set  V_Consent_Status ='Y'
--V_Market_Consent_Status ='Y'
WHERE N_CUST_REF_NO IN (
SELECT DISTINCT a.N_CUST_REF_NO FROM  GNMT_POLICY_DETAIL a WHERE a.V_POLICY_NO = 'UG201700254324')

