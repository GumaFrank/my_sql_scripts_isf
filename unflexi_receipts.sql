/* Formatted on 18/01/2019 15:54:48 (QP5 v5.256.13226.35538) */
  SELECT A.V_POLICY_NO,
         B.V_PAYER_NAME,
         N_RECEIPT_AMT,
         V_OTHER_REF_NO,
         D_OTHER_REF_DATE,
         V_RECEIPT_NO,
         D_RECEIPT_DATE
    FROM REMT_RECEIPT A, GNMT_POLICY B
   WHERE     V_RECEIPT_TABLE = 'DETAIL'
         AND A.V_POLICY_NO = B.V_POLICY_NO
        -- AND V_PLAN_CODE IN ('BUNIFLX01', 'BFGP001', 'BCLGP001')
         AND V_RECEIPT_STATUS <> 'RE002'
         --AND EXTRACT(YEAR FROM D_RECEIPT_DATE) >= 2023
        AND TRUNC (D_RECEIPT_DATE) BETWEEN NVL ( :P_FM_DT,
                                                TRUNC (D_RECEIPT_DATE))
                                        AND NVL ( :P_TO_DT,
                                                TRUNC (D_RECEIPT_DATE))
ORDER BY V_RECEIPT_NO DESC