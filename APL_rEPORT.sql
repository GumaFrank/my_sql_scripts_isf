/* Formatted on 26/01/2019 17:42:26 (QP5 v5.256.13226.35538) */
SELECT COUNT(DISTINCT V_POLICY_NO)  FROM
(
SELECT A.V_POLICY_NO,
       B.V_NAME,
       A.V_CNTR_STAT_CODE,
       (SELECT V_STATUS_DESC
          FROM GNMM_POLICY_STATUS_MASTER D
         WHERE D.V_STATUS_CODE = A.V_CNTR_STAT_CODE)
          POLICY_STATUS,
       A.V_CNTR_PREM_STAT_CODE,
       (SELECT V_STATUS_DESC
          FROM GNMM_POLICY_STATUS_MASTER D
         WHERE D.V_STATUS_CODE = A.V_CNTR_PREM_STAT_CODE)
          PREMIUM_STATUS,
       A.N_SUM_COVERED,
       A.N_CONTRIBUTION,
       A.D_COMMENCEMENT,
       A.D_POLICY_END_DATE,
       (SELECT TRUNC (D_LASTUPD_INFTIM)
          FROM PSMT_LOAN_MASTER K
         WHERE     K.V_POLICY_NO = C.V_POLICY_NO
               AND V_LOAN_CLEARED = 'N'
               AND ROWNUM = 1)
          D_LOAN_DRAWN,
       LOAN_DUE_AMT,
       LOAN_INT_AMT,
       (SELECT TRUNC (D_START_DATE)
          FROM PSMT_POLICY_APL K
         WHERE     K.V_POLICY_NO = C.V_POLICY_NO
               AND V_APL_CLEARED = 'N'
               AND ROWNUM = 1)
--               AND TRUNC (D_START_DATE) BETWEEN NVL ( :P_FM_DT,
--                                                     TRUNC (D_START_DATE))
--                                            AND NVL ( :P_TO_DT,
--                                                     TRUNC (D_START_DATE)))
         D_APL_START_DATE,
       APL_DUE_AMT,
       APL_INT_AMT,
       (SELECT AMOUNT
          FROM JHL_AMOUNTS_V3 L
         WHERE L.V_POLICY_NO = C.V_POLICY_NO AND ROWNUM = 1)
          CSV_AMOUNT
  FROM GNMT_POLICY A,
       GNMT_CUSTOMER_MASTER B,
       (SELECT A.V_POLICY_NO,
               (SELECT V_LOAN_BAL
                  FROM JHL_LOAN_OUT_DTLS B
                 WHERE B.V_POLICY_NO = A.V_POLICY_NO AND ROWNUM = 1)
                  LOAN_DUE_AMT,
               (SELECT V_LOAN_INT
                  FROM JHL_LOAN_OUT_DTLS B
                 WHERE B.V_POLICY_NO = A.V_POLICY_NO AND ROWNUM = 1)
                  LOAN_INT_AMT,
               (SELECT V_DUE_APL
                  FROM JHL_APL_OUT_DTLS B
                 WHERE B.V_POLICY_NO = A.V_POLICY_NO AND ROWNUM = 1)
                  APL_DUE_AMT,
               (SELECT V_DUE_APL_INT
                  FROM JHL_APL_OUT_DTLS B
                 WHERE B.V_POLICY_NO = A.V_POLICY_NO AND ROWNUM = 1)
                  APL_INT_AMT
          FROM GNMT_POLICY A
         WHERE A.V_POLICY_NO IN (SELECT DISTINCT V_POLICY_NO
                                   FROM JHL_LOAN_OUT_DTLS
                                 UNION
                                 SELECT DISTINCT V_POLICY_NO
                                   FROM JHL_APL_OUT_DTLS)) C
 WHERE A.N_PAYER_REF_NO = B.N_CUST_REF_NO AND A.V_POLICY_NO = C.V_POLICY_NO
-- AND EXTRACT(YEAR FROM (SELECT TRUNC (D_START_DATE)
--          FROM PSMT_POLICY_APL K
--         WHERE     K.V_POLICY_NO = C.V_POLICY_NO
--               AND V_APL_CLEARED = 'N'
--               AND ROWNUM = 1
--               AND TRUNC (D_START_DATE) BETWEEN NVL ( :P_FM_DT,
--                                                     TRUNC (D_START_DATE))
--                                            AND NVL ( :P_TO_DT,
--                                                     TRUNC (D_START_DATE)))) >= 2023
--AND EXTRACT(YEAR FROM A.D_COMMENCEMENT)>= 2023
)
 WHERE D_APL_START_DATE BETWEEN '01-JAN-2023' AND '31-DEC-2023'