/* Formatted on 18/01/2019 15:04:09 (QP5 v5.256.13226.35538) */
SELECT A.V_POLICY_NO,
       V_NAME,
       D_CNTR_START_DATE,
       D_CNTR_END_DATE,
       N_CONTRIBUTION,
       N_TERM,
       V_PLAN_CODE,
       C.N_SEQ_NO,
       D_IND_DOB,
       N_IND_SA,
       D_SURVIVAL_DATE,
       V_SURVIVAL_STATUS,
       A.N_SURV_TRANS_NO,
       V_PROCESS_ID,
       N_RATE,
       N_UNITS,
       V_PLRI_CODE,
       N_RATE / N_UNITS * N_IND_SA N_SURV_AMT
  FROM PSMT_POLICY_SURVIVAL A,
       PSDT_PLAN_SURVIVAL_BREAKUP B,
       GNMT_POLICY_DETAIL C
 WHERE     A.N_SURV_TRANS_NO = B.N_SURV_TRANS_NO
       AND A.V_POLICY_NO = C.V_POLICY_NO
       AND A.N_SEQ_NO = C.N_SEQ_NO
     --  AND EXTRACT(YEAR FROM D_SURVIVAL_DATE)>= 2023
       AND TRUNC (D_SURVIVAL_DATE) BETWEEN NVL ( :P_FM_DT,
                                                   TRUNC (D_SURVIVAL_DATE))
                                       AND NVL ( :P_TO_DT,
                                             TRUNC (D_SURVIVAL_DATE))