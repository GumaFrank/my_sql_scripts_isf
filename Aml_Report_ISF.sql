/* Formatted on 26/01/2019 17:27:05 (QP5 v5.256.13226.35538) */
SELECT NVL ( (SELECT X.V_POLICY_NO
                FROM GNMT_QUOTATION X
               WHERE X.V_QUOTATION_ID = A.V_POLICY_NO),
            A.V_POLICY_NO)
          POLICY_NO,
       (SELECT V_PROCESS_NAME
          FROM GNMM_PROCESS_MASTER PR
         WHERE PR.V_PROCESS_ID = A.V_PROCESS_ID)
          PROCESS,
       D_IDENTIFIED_DATE,
       V_NAME,
       (SELECT DECODE (V_REL_CODE,
                       'SO', 'Beneficiary',
                       'DA', 'Beneficiary',
                       'BR', 'Beneficiary',
                       'MO', 'Beneficiary',
                       'NP', 'Beneficiary',
                       'FA', 'Beneficiary',
                       'SI', 'Beneficiary',
                       'WI', 'Beneficiary',
                       'Not Provided')
                  TYPE
          FROM PSMT_POLICY_BENEFICIARY G
         WHERE G.N_CUST_REF_NO = A.N_CUST_REF_NO
         AND ROWNUM = 1
        UNION
        SELECT DECODE (V_REL_CODE,
                       'SO', 'Beneficiary',
                       'DA', 'Beneficiary',
                       'BR', 'Beneficiary',
                       'MO', 'Beneficiary',
                       'NP', 'Beneficiary',
                       'FA', 'Beneficiary',
                       'SI', 'Beneficiary',
                       'WI', 'Beneficiary',
                       'Not Provided')
                  TYPE
          FROM PSDT_NOMINATION_TRANSACTION G
         WHERE G.N_CUST_REF_NO = A.N_CUST_REF_NO
        UNION
        SELECT 'Life_Assured' TYPE
          FROM GNDT_AML_TRANSACTION H
         WHERE     H.N_CUST_REF_NO IN (SELECT N_CUST_REF_NO
                                         FROM GNDT_AML_TRANSACTION
                                       MINUS
                                       (SELECT N_CUST_REF_NO
                                          FROM PSDT_NOMINATION_TRANSACTION
                                        UNION
                                        SELECT N_CUST_REF_NO
                                          FROM PSMT_POLICY_BENEFICIARY))
               AND H.N_CUST_REF_NO = A.N_CUST_REF_NO)
          TYPE,
       C.V_IDEN_NO,
       N_AML_TRANS_NO,
       V_AML_TYPE,
       (SELECT V_STATUS_DESC
          FROM GNLU_AML_REVIEW_STATUS ST
         WHERE ST.V_STATUS_CODE = V_AML_REVIEW_STATUS)
          STATUS,
          V_STATUS_REMARKS
  FROM GNDT_AML_TRANSACTION A,
       GNMT_CUSTOMER_MASTER B,
       GNDT_CUSTOMER_IDENTIFICATION C
 WHERE     A.N_CUST_REF_NO = B.N_CUST_REF_NO
       AND A.N_CUST_REF_NO = C.N_CUST_REF_NO
       AND C.V_IDEN_CODE IN ('NIC',
                             'SID',
                             'OT',
                             'PP')
    --   AND EXTRACT(YEAR FROM D_IDENTIFIED_DATE)>=2023                         
 AND  (  (TRUNC(  D_IDENTIFIED_DATE)   BETWEEN  :P_FM_DT AND  :P_TO_DT) OR  (:P_FM_DT IS NULL AND  :P_TO_DT IS NULL ) )