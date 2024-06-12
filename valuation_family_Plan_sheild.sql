/* Formatted on 17/02/2020 14:42:18 (QP5 v5.256.13226.35538) */

SELECT A.V_POLICY_NO,
       F.V_NAME,
       DECODE (V_PLAN_RIDER,  'R', 'RIDER',  'P', 'PLAN') V_PLAN_RIDER,
       V_STATUS_DESC,
       NVL2 (A.N_PROFIT, 1, 0) M_PROFIT_STATUS,
       A.V_PLAN_CODE,
       V_PLAN_NAME,
       F.N_IND_SA,
       A.N_TERM N_POLICY_TERM,
       A.N_PREM_PAY_TERM,
         (F.N_IND_BASIC_PREM * 12)
       / DECODE (A.V_PYMT_FREQ, '00', 12, TO_NUMBER (A.V_PYMT_FREQ))
          ANNUALISED_PREMIUM,
       AMOUNT BONUS,
         (NVL (N_IND_LOADING, 0) * 12)
       / DECODE (A.V_PYMT_FREQ, '00', 12, TO_NUMBER (A.V_PYMT_FREQ))
          EXTRA_PA,
         (NVL (N_IND_DISCOUNT, 0) * 12)
       / DECODE (A.V_PYMT_FREQ, '00', 12, TO_NUMBER (A.V_PYMT_FREQ))
          DISCOUNT,
       V_PYMT_DESC,
       DECODE (F.V_IND_SEX,  'M', 'MALE',  'F', 'FEMALE') V_GENDER,
       TO_CHAR (D_COMMENCEMENT, 'YYYY') RISK_YEAR,
       TO_CHAR (D_COMMENCEMENT, 'MM') RISK_MONTH,
       D_COMMENCEMENT Commencement_Date,
       A.D_PREM_DUE_DATE,
       D_NEXT_OUT_DATE,
       D_POLICY_END_DATE,
       (SELECT Q.D_BIRTH_DATE
          FROM GNMT_CUSTOMER_MASTER Q
         WHERE Q.N_CUST_REF_NO = F.N_CUST_REF_NO AND F.N_SEQ_NO = 1)
          DOB1,
       (SELECT Q.D_BIRTH_DATE
          FROM GNMT_CUSTOMER_MASTER Q
         WHERE     Q.N_CUST_REF_NO = F.N_CUST_REF_NO
               AND F.N_SEQ_NO IN (2,
                                  3,
                                  4,
                                  5,
                                  6,
                                  7,
                                  8,
                                  9))
          DOB2
  FROM GNMT_POLICY A,
       GNMM_PLAN_MASTER B,
       GNMM_POLICY_STATUS_MASTER C,
       GNLU_FREQUENCY_MASTER D,
       JHL_AMOUNTS_V2 E,
       GNMT_POLICY_DETAIL F
 WHERE     A.V_PLAN_CODE = B.V_PLAN_CODE
       AND A.V_CNTR_STAT_CODE = C.V_STATUS_CODE
       AND A.V_PYMT_FREQ = D.V_PYMT_FREQ
       AND V_PROD_LINE IN ('LOB001', 'LOB005')
       --AND a.V_CNTR_STAT_CODE = 'NB010'
       AND A.V_POLICY_NO = E.V_POLICY_NO(+)
       AND A.V_POLICY_NO = F.V_POLICY_NO
       AND N_SEQ_NO = 1
       AND E.AMT_TYPE(+) = 'DUE_BONUS_AMT'
       AND A.V_PLAN_CODE LIKE 'FSC%'
       --AND (   (TRUNC (D_ISSUE) BETWEEN :P_FM_DT AND :P_TO_DT)
       --     OR ( :P_FM_DT IS NULL))
--          AND NVL (TRUNC (D_ISSUE), TRUNC (SYSDATE)) BETWEEN NVL (
--                                                             :P_FM_DT,
--                                                             TRUNC (D_ISSUE))
--                                                      AND NVL (
--                                                             :P_TO_DT,
--                                                             TRUNC (D_ISSUE))
--AND D_ISSUE BETWEEN '01-OCT-2011' AND '30-MAY-2012'
--AND a.V_POLICY_NO = '100031'
AND EXTRACT(YEAR FROM D_COMMENCEMENT) >= 2023
UNION
SELECT A.V_POLICY_NO,
       F.V_NAME,
       DECODE (V_PLAN_RIDER,  'R', 'RIDER',  'P', 'PLAN') V_PLAN_RIDER,
       V_STATUS_DESC,
       NVL2 (A.N_BENEFIT_AMOUNT, 1, 0) M_PROFIT_STATUS,
       A.V_PLAN_CODE,
       V_PLAN_DESC,
       N_RIDER_SA N_SUM_COVERED,
       N_RIDER_TERM N_POLICY_TERM,
       A.N_PREM_PAY_TERM,
         (N_RIDER_PREMIUM * 12)
       / DECODE (E.V_PYMT_FREQ, '00', 12, TO_NUMBER (E.V_PYMT_FREQ))
          ANNUALISED_PREMIUM,
       0 BONUS,
         (NVL (N_RIDER_LOAD_PREM, 0) * 12)
       / DECODE (E.V_PYMT_FREQ, '00', 12, TO_NUMBER (E.V_PYMT_FREQ))
          EXTRA_PA,
         (NVL (N_RIDER_DISCOUNT, 0) * 12)
       / DECODE (E.V_PYMT_FREQ, '00', 12, TO_NUMBER (E.V_PYMT_FREQ))
          DISCOUNT,
       V_PYMT_DESC,
       DECODE (V_SEX,  'M', 'MALE',  'F', 'FEMALE') V_GENDER,
       TO_CHAR (D_RIDER_START, 'YYYY') RISK_YEAR,
       TO_CHAR (D_RIDER_START, 'MM') RISK_MONTH,
       D_COMMENCEMENT Commencement_Date,
       E.D_PREM_DUE_DATE,
       D_NEXT_OUT_DATE,
       D_POLICY_END_DATE,
       (SELECT Q.D_BIRTH_DATE
          FROM GNMT_CUSTOMER_MASTER Q
         WHERE Q.N_CUST_REF_NO = F.N_CUST_REF_NO AND F.N_SEQ_NO = 1)
          DOB1,
       (SELECT Q.D_BIRTH_DATE
          FROM GNMT_CUSTOMER_MASTER Q
         WHERE     Q.N_CUST_REF_NO = F.N_CUST_REF_NO
               AND F.N_SEQ_NO IN (2,
                                  3,
                                  4,
                                  5,
                                  6,
                                  7,
                                  8,
                                  9))
          DOB2
  FROM GNMT_POLICY_RIDERS A,
       GNMM_PLAN_MASTER B,
       GNMM_POLICY_STATUS_MASTER C,
       GNMT_POLICY E,
       GNLU_FREQUENCY_MASTER D,
       GNMT_POLICY_DETAIL F
 WHERE     A.V_PLAN_CODE = B.V_PLAN_CODE
       AND A.V_RIDER_STAT_CODE = C.V_STATUS_CODE
       AND A.V_POLICY_NO = E.V_POLICY_NO
       AND E.V_PYMT_FREQ = D.V_PYMT_FREQ
       AND V_PROD_LINE IN ('LOB001', 'LOB005')
       --AND a.V_RIDER_STAT_CODE = 'NB010'
       AND E.V_POLICY_NO = F.V_POLICY_NO
       AND A.V_POLICY_NO = F.V_POLICY_NO
       --AND a.N_SEQ_NO = 1
       AND A.N_SEQ_NO = F.N_SEQ_NO
       AND A.V_PLAN_CODE LIKE 'FSC%'
      -- AND (   (TRUNC (D_ISSUE) BETWEEN :P_FM_DT AND :P_TO_DT)
       --     OR ( :P_FM_DT IS NULL))
--           AND NVL (TRUNC (D_ISSUE), TRUNC (SYSDATE)) BETWEEN NVL (
--                                                             :P_FM_DT,
--                                                             TRUNC (D_ISSUE))
--                                                      AND NVL (
--                                                             :P_TO_DT,
--                                                             TRUNC (D_ISSUE))
--AND a.V_POLICY_NO = '100031'
--AND D_ISSUE BETWEEN '01-OCT-2011' AND '30-MAY-2012'
AND EXTRACT(YEAR FROM D_COMMENCEMENT) >= 2023