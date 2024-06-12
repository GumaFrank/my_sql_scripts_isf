/* Formatted on 05/03/2021 10:11:01 (QP5 v5.256.13226.35538) */
  SELECT PYR_NAME,
         POLICY_TYPE,
         POLICY_NO,
         BASIC_PREMIUM,
         PREV_PREMIUM,
         PREV_PREM_DATE,
         CURRENT_PREMIUM,
         CUR_PREM_DATE,
         DECODE (
            NVL (PREV_PREMIUM, 0),
            0, 100,
              (NVL (CURRENT_PREMIUM, 0) - NVL (PREV_PREMIUM, 0))
            / NVL (PREV_PREMIUM, 0)
            * 100)
            PREMIUM_PCT_GROWTH
    FROM (SELECT CUST.V_NAME PYR_NAME,
                 PROD.V_PLAN_DESC POLICY_TYPE,
                 RCT.V_POLICY_NO POLICY_NO,
                  (SELECT N_IND_BASIC_PREM FROM GNMT_POLICY_DETAIL DTL 
                  WHERE POL.V_POLICY_NO = DTL.V_POLICY_NO AND ROWNUM = 1  )BASIC_PREMIUM,
                 N_RECEIPT_AMT CURRENT_PREMIUM,
                 D_RECEIPT_DATE CUR_PREM_DATE,
                  JHL_BI_UTILS.get_prev_rct_amt (
                     RCT.V_POLICY_NO,
                     JHL_BI_UTILS.get_prev_rct_dt (RCT.V_POLICY_NO,
                                                   D_RECEIPT_DATE))
                     PREV_PREMIUM,
                  JHL_BI_UTILS.get_prev_rct_dt (RCT.V_POLICY_NO, D_RECEIPT_DATE)
                     PREV_PREM_DATE
            FROM REMT_RECEIPT RCT,
                 GNMT_CUSTOMER_MASTER CUST,
                 GNMT_POLICY POL,
                 GNMM_PLAN_MASTER PROD
           WHERE     RCT.V_RECEIPT_TABLE = 'DETAIL'
                 AND RCT.N_CUST_REF_NO = CUST.N_CUST_REF_NO(+)
                 AND RCT.V_POLICY_NO = POL.V_POLICY_NO(+)
                 AND POL.V_PLAN_CODE = PROD.V_PLAN_CODE
                 AND RCT.V_POLICY_NO NOT LIKE 'GL%'
                -- AND EXTRACT(YEAR FROM D_RECEIPT_DATE) >= 2023)
                AND TRUNC (D_RECEIPT_DATE) BETWEEN :P_FROM_DT AND :P_TO_DT)
   WHERE (NVL (CURRENT_PREMIUM, 0) - NVL (PREV_PREMIUM, 0)) > 0
ORDER BY CUR_PREM_DATE