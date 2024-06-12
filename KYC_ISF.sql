
select a.n_agent_no,B.V_ROLE_CODE,A.N_CHANNEL_NO, A.V_RANK_CODE,
C.V_POLICY_NO FROM AMMM_AGENT_MASTER A,AMMT_POL_AG_COMM B,GNMT_POLICY C
                      WHERE A.N_AGENT_NO = B.N_AGENT_NO
                      AND B.V_POLICY_NO = C.V_POLICY_NO;
                      
                    --SELECT * FROM AMMM_AGENT_MASTER
CREATE VIEW FRA_KYC_VIEW AS 
select a.n_agent_no,B.V_ROLE_CODE,A.N_CHANNEL_NO, A.V_RANK_CODE,
C.V_POLICY_NO FROM AMMM_AGENT_MASTER A,AMMT_POL_AG_COMM B,GNMT_POLICY C
                      WHERE A.N_AGENT_NO = B.N_AGENT_NO
                      AND B.V_POLICY_NO = C.V_POLICY_NO
                      
SELECT * FROM FRA_KYC_VIEW



/* SELECT DISTINCT N_CHANNEL_NO, V_RANK_CODE FROM  AMMM_AGENT_MASTER
AUTHOR Frank Bagambe
Date 12-JAN-2024
Description, KYC (know Your Customer

 */

SELECT  distinct 
--*
Decode((SELECT N_CHANNEL_NO FROM FRA_KYC_VIEW WHERE V_POLICY_NO=POLICY_NO  AND ROWNUM =1), '10', 'Agent', 'Bancassurance') AS CHANNEL, 
--CUST_REF_NO,    
POLICY_NO,    
DATE_ISSUE,    
START_DATE,    
POLICY_OWNER_NAME,    
OWNER_PIN,    
--VALID_PIN,    
OWNER_ID_NO,
--OWNER_VALID_ID,    
OWNER_EMAIL,    
VALID_EMAIL,    
OWNER_PHONE,    
OWNER_VALID_PHONE,    
POLICY_STATUS,    
NATIONALITY,    
--RESIDENTIAL_ADDRESS,    
POSTAL_ADDRESS,    
PRODUCT_NAME
FROM 

(
SELECT DISTINCT
    TO_CHAR (CUST_REF_NO) CUST_REF_NO,
    POLICY_NO,
    DATE_ISSUE,
    START_DATE,
    POLICY_OWNER_NAME,
    OWNER_PIN,
    NVL (
    DECODE (JHL_GEN_PKG.CHECK_VALID_PIN (OWNER_PIN, NULL),
    'N', NULL,
    'Y'),
    'N')
    VALID_PIN,
    OWNER_ID_NO,
    JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (OWNER_ID_NO, 'ID')
    OWNER_VALID_ID,
    OWNER_EMAIL,
    JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (OWNER_EMAIL, 'EMAIL')
    VALID_EMAIL,
    OWNER_PHONE,
    NVL (JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (OWNER_PHONE, 'PHONE'),
    'N')
    OWNER_VALID_PHONE,
    POLICY_STATUS,
    NATIONALITY,
    RESIDENTIAL_ADDRESS, POSTAL_ADDRESS, PRODUCT_NAME
    FROM (
        SELECT 
            C.N_CUST_REF_NO CUST_REF_NO,
            LI.V_NAME LIFE_ASSURED_NAME,
            C.V_NAME POLICY_OWNER_NAME,
            V_POLICY_NO POLICY_NO,
            D_ISSUE DATE_ISSUE,
            D_COMMENCEMENT START_DATE,
            (SELECT MAX (V_IDEN_NO)
            FROM GNDT_CUSTOMER_IDENTIFICATION IDN
            WHERE     IDN.V_IDEN_CODE = 'NIC'
            AND IDN.N_CUST_REF_NO = LI.N_CUST_REF_NO
            AND IDN.V_STATUS = 'A')
            ID_NO,
            (SELECT MAX (V_IDEN_NO)
            FROM GNDT_CUSTOMER_IDENTIFICATION IDN
            WHERE     IDN.V_IDEN_CODE = 'NIC'
            AND IDN.N_CUST_REF_NO = C.N_CUST_REF_NO
            AND IDN.V_STATUS = 'A')
            OWNER_ID_NO,
            (SELECT MAX (V_IDEN_NO)
            FROM GNDT_CUSTOMER_IDENTIFICATION IDN
            WHERE     IDN.V_IDEN_CODE = 'PP'
            AND IDN.V_STATUS = 'A'
            AND IDN.N_CUST_REF_NO = C.N_CUST_REF_NO)
            PASSPORT,
            (SELECT MAX (V_IDEN_NO)
            FROM GNDT_CUSTOMER_IDENTIFICATION IDN
            WHERE     IDN.V_IDEN_CODE = 'PIN'
            AND IDN.V_STATUS = 'A'
            AND IDN.N_CUST_REF_NO = LI.N_CUST_REF_NO)
            PIN,
            (SELECT MAX (V_IDEN_NO)
            FROM GNDT_CUSTOMER_IDENTIFICATION IDN
            WHERE     IDN.V_IDEN_CODE = 'PIN'
            AND IDN.V_STATUS = 'A'
            AND IDN.N_CUST_REF_NO = C.N_CUST_REF_NO)
            OWNER_PIN,
            (SELECT MAX (V_CONTACT_NUMBER)
            FROM GNDT_CUSTMOBILE_CONTACTS
            WHERE     N_CUST_REF_NO = LI.N_CUST_REF_NO -- AND V_STATUS = 'A'
            AND V_Contact_Number LIKE '%@%')
            EMAIL,
            (SELECT MAX (V_CONTACT_NUMBER)
            FROM GNDT_CUSTMOBILE_CONTACTS
            WHERE     N_CUST_REF_NO = C.N_CUST_REF_NO -- AND V_STATUS = 'A'
            AND V_Contact_Number LIKE '%@%')
            OWNER_EMAIL,
            (SELECT V_CONTACT_NUMBER
            FROM GNDT_CUSTMOBILE_CONTACTS
            WHERE     N_CUST_REF_NO = LI.N_CUST_REF_NO -- AND V_STATUS = 'A'
            AND V_Contact_Number NOT LIKE '%@%'
            AND ROWNUM = 1)
            PHONE,
            (SELECT V_CONTACT_NUMBER
            FROM GNDT_CUSTMOBILE_CONTACTS
            WHERE     N_CUST_REF_NO = C.N_CUST_REF_NO -- AND V_STATUS = 'A'
            AND V_Contact_Number NOT LIKE '%@%'
            AND ROWNUM = 1)
            OWNER_PHONE,
            TO_DATE (C.D_BIRTH_DATE, 'DD/MM/RRRR') D_BIRTH_DATE,
            LI.N_CUST_REF_NO,
            TRUNC (NVL (D_PROPOSAL_DATE, D_COMMENCEMENT)) COMMENCEMENT_DT,
            V_STATUS_DESC POLICY_STATUS,
             (SELECT NAT.V_NATION_DESC FROM GNLU_NATIONALITY_MASTER NAT WHERE NAT.V_NATION_CODE =C.V_NATION_CODE) NATIONALITY,
           /* (SELECT V_NATION_DESC
            FROM GNLU_NATIONALITY_MASTER NAT
            WHERE NAT.V_NATION_CODE = C.V_BIRTH_COUNTRY)
            NATIONALITY, */
            cc.V_CONTACT_NUMBER Residential_address,
            ca.V_ADD_ONE Postal_Address,
            V_PLAN_NAME PRODUCT_NAME
        FROM GNMT_CUSTOMER_MASTER C
        inner join GNMT_POLICY POL on C.N_CUST_REF_NO = POL.N_PAYER_REF_NO 
                                   -- and  TRUNC (NVL (D_PROPOSAL_DATE, D_COMMENCEMENT)) >= :S_As_At_Dt
                                   -- and  TRUNC (NVL (D_PROPOSAL_DATE, D_COMMENCEMENT)) <= :P_As_At_Dt
        left join GNMT_CUSTOMER_MASTER LI on POL.N_PROPOSER_REF_NO = LI.N_CUST_REF_NO
        left join GNMM_POLICY_STATUS_MASTER STATUS on POL.V_CNTR_STAT_CODE = STATUS.V_STATUS_CODE
        inner join GNMM_PLAN_MASTER PROD on POL.V_PLAN_CODE = PROD.V_PLAN_CODE
        left join GNDT_CUSTMOBILE_CONTACTS cc on   C.N_CUST_REF_NO =cc.N_CUST_REF_NO
        inner join GNDT_CUSTOMER_ADDRESS ca on C.N_CUST_REF_NO =ca.N_CUST_REF_NO
        )   
        
         UNION ALL
         
        SELECT DISTINCT
            TO_CHAR (CO.V_Company_Code || '-' || CO.V_COMPANY_BRANCH) CUST_REF_NO,
            V_POLICY_NO POLICY_NO,
            D_ISSUE DATE_ISSUE,
            D_COMMENCEMENT START_DATE,
            CO.V_COMPANY_NAME,
            V_REGN_NO PIN,
            NVL (
            DECODE (JHL_GEN_PKG.CHECK_VALID_PIN (V_REGN_NO, NULL),
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
            JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (
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
            NVL (JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (
            (SELECT MAX (V_Contact_Number)
            FROM Gndt_Compmobile_Contacts H
            WHERE     H.V_Company_Code = CO.V_Company_Code
            AND H.V_Company_Branch = CO.V_Company_Branch
            AND V_Contact_Number NOT LIKE '%@%'),
            'PHONE'),
            'N')
            OWNER_VALID_PHONE,
            STATUS.V_STATUS_DESC POLICY_STATUS,
            -- (SELECT NAT.V_NATION_DESC FROM GNLU_NATIONALITY_MASTER NAT WHERE NAT.V_NATION_CODE =C.V_NATION_CODE) NATIONALITY,
           (SELECT (V_NATION_DESC)
            FROM GNLU_NATIONALITY_MASTER NAT, GNDT_COMPANY_ADDRESS AD
            WHERE     AD.V_Company_Code = CO.V_Company_Code
            AND AD.V_Company_Branch = CO.V_Company_Branch
            AND AD.V_COUNTRY_CODE = NAT.V_NATION_CODE)
            NATIONALITY,
           '' Residential_address,
           '' Postal_Address,
            PROD.V_PLAN_NAME PRODUCT_NAME
        FROM Gnmm_Company_Master CO
        INNER JOIN Gnmt_Policy POL ON  CO.V_Company_Code = POL.V_Company_Code AND CO.V_Company_Branch = POL.V_Company_Branch 
                                                          --  and  TRUNC (NVL (D_PROPOSAL_DATE, D_COMMENCEMENT)) >= :S_As_At_Dt
                                                          --  and  TRUNC (NVL (D_PROPOSAL_DATE, D_COMMENCEMENT)) <= :P_As_At_Dt
        INNER JOIN GNMM_POLICY_STATUS_MASTER STATUS ON POL.V_CNTR_STAT_CODE = STATUS.V_STATUS_CODE
        INNER JOIN GNMM_PLAN_MASTER PROD ON POL.V_PLAN_CODE = PROD.V_PLAN_CODE
        
        )  WHERE POLICY_STATUS IN ('IN-FORCE') --and ROWNUM  <=3
        
        ORDER BY  3 DESC
        
        --SELECT * FROM GNMT_POLICY
        
