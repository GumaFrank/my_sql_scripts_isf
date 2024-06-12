/* Formatted on 26/01/2019 18:08:27 (QP5 v5.256.13226.35538) */

SELECT COUNT( DISTINCT V_POLICY_NO) FROM
(
  SELECT A.V_POLICY_NO,
         V_NAME,
         D_CNTR_START_DATE,
         D_CNTR_END_DATE,
         N_CONTRIBUTION,
         N_TERM,
         V_PLAN_CODE,
         D.N_SEQ_NO,
         D_IND_DOB,
         N_IND_SA,
         N_SURR_CODE,
         N_POL_GROSS_SURR,
         N_POL_NET_SURR,
         (SELECT V_STATUS_DESC
            FROM GNMM_POLICY_STATUS_MASTER K
           WHERE K.V_STATUS_CODE = D.V_CNTR_STAT_CODE)
            POLICY_STATUS
--         (SELECT TRUNC (D_FROM)
--            FROM GN_CONTRACT_STATUS_LOG X
--           WHERE     X.V_POLICY_NO = A.V_POLICY_NO
--                 AND X.N_SEQ = (SELECT MAX (N_SEQ)
--                                  FROM GN_CONTRACT_STATUS_LOG Q
--                                 WHERE Q.V_POLICY_NO = A.V_POLICY_NO))
--                 AND TRUNC (D_FROM) BETWEEN NVL ( :P_FM_DT, TRUNC (D_FROM))
--                                        AND NVL ( :P_TO_DT, TRUNC (D_FROM)))
 --           APL_DATE
    FROM PSDT_TERMINATION A,
         PYMT_VOUCHER_ROOT B,
         PYMT_VOU_MASTER C,
         GNMT_POLICY_DETAIL D
   WHERE     TO_CHAR (A.N_SURR_CODE) = B.V_SOURCE_REF_NO(+)
         AND B.V_MAIN_VOU_NO = C.V_MAIN_VOU_NO(+)
         AND A.V_POLICY_NO = D.V_POLICY_NO
         AND A.N_SEQ_NO = D.N_SEQ_NO
         AND D.V_CNTR_STAT_CODE = 'NB025'
         AND EXTRACT(YEAR FROM D_CNTR_END_DATE) >= 2023
--ORDER BY APL_DATE
)