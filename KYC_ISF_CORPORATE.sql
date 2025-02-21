SELECT COUNT(DISTINCT POLICY_NO) N0_OF_POLICIES 
FROM 
(
SELECT DISTINCT
       --TO_CHAR (CO.V_Company_Code || '-' || CO.V_COMPANY_BRANCH) CUST_REF_NO,
       V_POLICY_NO POLICY_NO,
       D_COMMENCEMENT COMMENCEMENT_DATE,
       CO.V_Company_Code COMPANY_CODE,
        CO.V_COMPANY_BRANCH COMPANY_BRANCH,
       CO.V_COMPANY_NAME COMPANY_NAME,
       CO.V_REGN_NO PIN,
       NVL (
          DECODE (JHL_GEN_PKG.CHECK_VALID_PIN (CO.V_REGN_NO, NULL),
                  'N', NULL,
                  'Y'),
          'N')
          VALID_PIN,
       V_COMP_GROUP_CODE CERTIFICATE_NUMBER,
       NULL VALID_CERT,
       (SELECT MAX (V_Contact_Number)
          FROM Gndt_Compmobile_Contacts H
         WHERE     H.V_Company_Code = CO.V_Company_Code
               AND H.V_Company_Branch = CO.V_Company_Branch
               AND V_Contact_Number LIKE '%@%')
          EMAIL,
       JHL_GEN_PKG.
       CHECK_IDENTIFICATION_VALIDITY (
          (SELECT MAX (V_Contact_Number)
             FROM Gndt_Compmobile_Contacts H
            WHERE     H.V_Company_Code = CO.V_Company_Code
                  AND H.V_Company_Branch = CO.V_Company_Branch
                  AND V_Contact_Number LIKE '%@%'),
          'EMAIL')
          VALID_EMAIL,
       (SELECT MAX (V_Contact_Number)
          FROM Gndt_Compmobile_Contacts H
         WHERE     H.V_Company_Code = CO.V_Company_Code
               AND H.V_Company_Branch = CO.V_Company_Branch
               AND V_Contact_Number NOT LIKE '%@%')
          PHONE,
       NVL (JHL_GEN_PKG.
            CHECK_IDENTIFICATION_VALIDITY (
               (SELECT MAX (V_Contact_Number)
                  FROM Gndt_Compmobile_Contacts H
                 WHERE     H.V_Company_Code = CO.V_Company_Code
                       AND H.V_Company_Branch = CO.V_Company_Branch
                       AND V_Contact_Number NOT LIKE '%@%'),
               'PHONE'),
            'N')
          OWNER_VALID_PHONE,
          D_POLICY_END_DATE,
          V_PLAN_NAME,
       STATUS.V_STATUS_DESC POLICY_STATUS,
       (SELECT (V_NATION_DESC)
          FROM GNLU_NATIONALITY_MASTER NAT, GNDT_COMPANY_ADDRESS AD
         WHERE     AD.V_Company_Code = CO.V_Company_Code
               AND AD.V_Company_Branch = CO.V_Company_Branch
               AND AD.V_COUNTRY_CODE = NAT.V_NATION_CODE)
          NATIONALITY,
          V_COMP_ADD1 postal_address,
         CO. V_COMP_ADD3  PHYSICAL_ADDRESS,
          bo.V_IDEN_NO, bo.V_DESIGNATION,cm.V_NAME
  FROM Gnmm_Company_Master CO INNER JOIN 
       Gnmt_Policy POL ON CO.V_Company_Code = POL.V_Company_Code AND  CO.V_Company_Branch = POL.V_Company_Branch
       INNER JOIN GNMM_POLICY_STATUS_MASTER STATUS  
       ON  POL.V_CNTR_STAT_CODE = STATUS.V_STATUS_CODE
       INNER JOIN GNMM_PLAN_MASTER PROD
       on POL.V_PLAN_CODE = PROD.V_PLAN_CODE
       left join
       gnmt_beneficial_owner bo
       on  bo.V_COMPANY_CODE = co.V_COMPANY_CODE
       left join 
       GNDT_CUSTOMER_IDENTIFICATION ci on   ci.V_IDEN_NO = bo.V_IDEN_NO
       left join
       GNMT_CUSTOMER_MASTER cm on  cm.N_CUST_REF_NO = ci.N_CUST_REF_NO
       
 WHERE  STATUS.V_STATUS_DESC  = 'IN-FORCE' order by 1 
 
 )
 
 WHERE TO_CHAR(COMMENCEMENT_DATE, 'MON-YY') = 'JAN-24'