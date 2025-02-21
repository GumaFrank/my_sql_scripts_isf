
/* Formatted on 08/12/2021 12:39:20 (QP5 v5.256.13226.35538) */
--#NAME?

SELECT COUNT (DISTINCT POLICY_NO) FROM 
(
SELECT POLICY_NO,
       POLICY_STATUS,
       D_COMMENCEMENT,
       D_ISSUE,
       LIFE_ASSURED_NAME,
       ID_NO,
       JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (ID_NO, 'ID') VALID_ID,
       PASSPORT,
       JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (PASSPORT, 'PP') VALID_PP,
       PIN,
       NVL (DECODE (JHL_GEN_PKG.CHECK_VALID_PIN (PIN, NULL), 'N', NULL, 'Y'),
            'N')
          VALID_PIN,
       EMAIL,
       JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (EMAIL, 'EMAIL') VALID_EMAIL,
       PHONE,
       NVL (JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (PHONE, 'PHONE'), 'N')
          VALID_PHONE,
       POLICY_OWNER_NAME,
       OWNER_ID_NO,
       JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (OWNER_ID_NO, 'ID')
          OWNER_VALID_ID,
       OWNER_PIN,
       NVL (
          DECODE (JHL_GEN_PKG.CHECK_VALID_PIN (OWNER_PIN, NULL),
                  'N', NULL,
                  'Y'),
          'N')
          OWNER_VALID_PIN,
       OWNER_EMAIL,
       JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (OWNER_EMAIL, 'EMAIL')
          OWNER_VALID_EMAIL,
       OWNER_PHONE,
       NVL (JHL_GEN_PKG.CHECK_IDENTIFICATION_VALIDITY (OWNER_PHONE, 'PHONE'),
            'N')
          OWNER_VALID_PHONE,
       V_PLAN_NAME PRODUCT,
       V_UNDERWRITER UNDRWRITER,
       NATIONALITY,
       Residential_address,
       Postal_Address
     from   (

SELECT  LI.V_NAME LIFE_ASSURED_NAME,
               C.V_NAME POLICY_OWNER_NAME,
               V_POLICY_NO POLICY_NO,
               D_ISSUE,
               D_COMMENCEMENT,
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
                 WHERE     N_CUST_REF_NO = LI.N_CUST_REF_NO --               AND V_STATUS = 'A'
                       AND V_Contact_Number LIKE '%@%')
                  EMAIL,
               (SELECT MAX (V_CONTACT_NUMBER)
                  FROM GNDT_CUSTMOBILE_CONTACTS
                 WHERE     N_CUST_REF_NO = C.N_CUST_REF_NO --               AND V_STATUS = 'A'
                       AND V_Contact_Number LIKE '%@%')
                  OWNER_EMAIL,
               (SELECT V_CONTACT_NUMBER
                  FROM GNDT_CUSTMOBILE_CONTACTS
                 WHERE     N_CUST_REF_NO = LI.N_CUST_REF_NO --               AND V_STATUS = 'A'
                       AND V_Contact_Number NOT LIKE '%@%'
                       AND ROWNUM = 1)
                  PHONE,
               (SELECT V_CONTACT_NUMBER
                  FROM GNDT_CUSTMOBILE_CONTACTS
                 WHERE     N_CUST_REF_NO = C.N_CUST_REF_NO --               AND V_STATUS = 'A'
                       AND V_Contact_Number NOT LIKE '%@%'
                       AND ROWNUM = 1)
                  OWNER_PHONE,
               TO_DATE (C.D_BIRTH_DATE, 'DD/MM/RRRR') D_BIRTH_DATE,
               LI.N_CUST_REF_NO,
               TRUNC (NVL (D_PROPOSAL_DATE, D_COMMENCEMENT)) COMMENCEMENT_DT,
               V_STATUS_DESC POLICY_STATUS,
               V_PLAN_NAME,
               V_UNDERWRITER,
               c.v_birth_country Nationality,
               cc.V_CONTACT_NUMBER Residential_address,
               ca.V_ADD_ONE Postal_Address
          FROM GNMT_CUSTOMER_MASTER C
              inner join  GNMT_POLICY POL on  C.N_CUST_REF_NO = POL.N_PAYER_REF_NO
               left join GNMT_CUSTOMER_MASTER LI on POL.N_PROPOSER_REF_NO = LI.N_CUST_REF_NO
               left join GNMM_POLICY_STATUS_MASTER STATUS on  POL.V_CNTR_STAT_CODE = STATUS.V_STATUS_CODE  AND STATUS.V_STATUS_CODE = 'NB010'
               inner join GNMM_PLAN_MASTER PROD on POL.V_PLAN_CODE = PROD.V_PLAN_CODE
               left join GNDT_CUSTMOBILE_CONTACTS cc on   C.N_CUST_REF_NO =cc.N_CUST_REF_NO
               inner join GNDT_CUSTOMER_ADDRESS ca on C.N_CUST_REF_NO =ca.N_CUST_REF_NO
         WHERE    
                cc.V_CONTACT_CODE = 'CONT001'  
                --AND EXTRACT(YEAR FROM D_PROPOSAL_DATE) >= 2023
                )
--                AND TRUNC (NVL (D_PROPOSAL_DATE, D_COMMENCEMENT)) <=
--                       :P_As_At_Dt)

) WHERE TO_CHAR(D_ISSUE,'MON-YY') = 'JAN-24'