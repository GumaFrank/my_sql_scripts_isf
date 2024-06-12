/* Formatted on 26/02/2019 20:20:55 (QP5 v5.256.13226.35538) */

SELECT SUM ( N_COMM_AMT) 
FROM 
(
  SELECT V_AGENT_CODE,
         V_NAME,
         DESIGNATION,
         AGENCY,
         TRANS_DATE,
         V_POLICY_NO,
         N_SEQ_NO,
         ASSURED_NAME,
         POLICY_YEAR,
         D_PREMIUM_DUE,
         V_OVERRIDE,
--         SUB_AGENT_CODE,
         SUM (PREMIUM_AMT) PREMIUM_AMT,
         SUM (N_COMM_AMT) N_COMM_AMT,
         SUM (N_WHT) N_WHT,
         SUM (N_NET_COMM) N_NET_COMM
    FROM (SELECT A.N_AGENT_NO,
                 V_AGENT_CODE,
                 D.V_NAME,
                 V_DESCRIPTION DESIGNATION,
                 E.V_ADD_THREE AGENCY,
                 A.V_PLAN_CODE,
                 D_COMM_GEN TRANS_DATE,
                 A.V_POLICY_NO,
                 A.N_SEQ_NO,
                 B.V_NAME ASSURED_NAME,
                 N_COMM_YEAR POLICY_YEAR,
                 D_PREMIUM_DUE,
                 N_PREM_AMT PREMIUM_AMT,
                 V_RECEIPT_NO,
                 N_COMM_AMT,
                 N_COMM_RATE,
                 NVL (V_INCOME_TAX_RULE_REF, 0) / 100 * N_COMM_AMT N_WHT,
                 N_COMM_AMT - NVL (V_INCOME_TAX_RULE_REF, 0) / 100 * N_COMM_AMT
                    N_NET_COMM,
                 V_OC_FLAG V_OVERRIDE
--                 BPG_AGENCY.BFN_GET_AGENT_CODE (N_SUB_AGENT_NO) SUB_AGENT_CODE
            FROM AMMT_POL_COMM_DETAIL A,
                 GNMT_POLICY_DETAIL B,
                 AMMM_AGENT_MASTER C,
                 GNMT_CUSTOMER_MASTER D,
                 GNDT_CUSTOMER_ADDRESS E,
                 AMMM_RANK_MASTER F,
                 AMDT_AGENT_BENEFIT_POOL_DETAIL G,
                 AMDT_AGENT_BENE_POOL_PAYMENT H
           WHERE     V_COMM_STATUS IN ('P')
                 AND A.V_POLICY_NO = B.V_POLICY_NO
                 AND A.N_SEQ_NO = B.N_SEQ_NO
                 AND A.N_AGENT_NO = C.N_AGENT_NO
                 AND C.N_CUST_REF_NO = D.N_CUST_REF_NO
                 AND C.N_CUST_REF_NO = E.N_CUST_REF_NO
                 AND C.V_RANK_CODE = F.V_RANK_CODE
                 AND C.N_CHANNEL_NO = F.N_CHANNEL_NO
--                 AND TRUNC (NVL (D_VOUCHER_DATE, SYSDATE)) BETWEEN NVL (
--                                                                      :P_FM_DT,
--                                                                      TRUNC (
--                                                                         NVL (
--                                                                            D_VOUCHER_DATE,
--                                                                            SYSDATE)))
--                                                               AND NVL (
--                                                                      :P_TO_DT,
--                                                                      TRUNC (
--                                                                         NVL (
--                                                                            D_VOUCHER_DATE,
--                                                                            SYSDATE)))
                 AND A.V_POLICY_NO NOT LIKE 'GL%'
                 AND E.N_ADD_SEQ_NO = 1
                 AND V_OC_FLAG != 'Y'
                 AND V_ACCOUNTED = 'Y'
                 AND TO_CHAR (A.N_COMM_PAID_SEQ) = G.V_TRANS_SOURCE_REF_NO
                 AND G.N_BENEFIT_POOL_PAY_SEQ(+) = H.N_BENEFIT_POOL_PAY_SEQ
                 --AND EXTRACT(YEAR FROM D_VOUCHER_DATE)>= 2023
               


              AND  TO_CHAR(D_COMM_GEN, 'MON-YY') = 'NOV-23')
GROUP BY V_AGENT_CODE,
         V_NAME,
         DESIGNATION,
         AGENCY,
         TRANS_DATE,
         V_POLICY_NO,
         N_SEQ_NO,
         ASSURED_NAME,
         POLICY_YEAR,
         D_PREMIUM_DUE,
         V_OVERRIDE
--         SUB_AGENT_CODE

)

106  497 396 8.16