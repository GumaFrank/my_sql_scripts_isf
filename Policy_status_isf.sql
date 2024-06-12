/* Formatted on 18/01/2019 15:45:24 (QP5 v5.256.13226.35538) */
  SELECT A.V_POLICY_NO,
         V_PLRI_CODE,
         B.V_STATUS_DESC PREVIOUS_STATUS,
         C.V_STATUS_DESC CURRENT_STATUS,
         A.D_FROM CURRENT_STATUS_DATE
    FROM GN_CONTRACT_STATUS_LOG A,
         GNMM_POLICY_STATUS_MASTER B,
         GNMM_POLICY_STATUS_MASTER C,
         GNMT_POLICY D
   WHERE     A.V_PREV_STAT_CODE = B.V_STATUS_CODE
         AND A.V_CURR_STAT_CODE = C.V_STATUS_CODE
         AND V_PREV_STAT_CODE IS NOT NULL
         AND A.V_POLICY_NO = D.V_POLICY_NO
         AND V_GRP_IND_FLAG = 'I'
         AND TO_CHAR(A.D_FROM, 'MON-YY') = 'JAN-24'
         --AND EXTRACT(YEAR FROM A.D_FROM)>= 2023
--         AND TRUNC (D_FROM) BETWEEN NVL ( :P_FM_DT, TRUNC (D_FROM))
--                                AND NVL ( :P_TO_DT, TRUNC (D_FROM))
ORDER BY V_POLICY_NO