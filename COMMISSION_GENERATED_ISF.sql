
/* Formatted on 29/01/2020 09:50:34 (QP5 v5.256.13226.35538) */
SELECT * FROM 
(
 SELECT N_AGENT_NO,
         V_AGENT_CODE,
         V_AGENT_NAME,
         (V_POSTED_REF_NO) DOC_NUMBER,
         D_BILL_RAISED_DATE DOC_DATE,
         V_POLICY_NO,
         V_COMPANY_NAME,
         N_VOUCHER_NO,
         D_TRANS_DATE VOUCHER_DATE,
         D_COMM_GEN COMM_GENERATED_DATE,
         (N_PREM) PREMIUM,
         (N_COMM) COMMISSION,
         (N_WHT) WHT,
         (N_NET_COMM) NET_COMMISSION
    FROM (SELECT p.N_AGENT_NO,
                 V_AGENT_CODE,
                 q.V_COMPANY_NAME V_AGENT_NAME,
                 V_POLICY_NO,
                 p.V_COMPANY_NAME,
                 D_COMM_GEN,
                 V_POSTED_REF_NO,
                 D_BILL_RAISED_DATE,
                 N_PREM,
                 N_COMM,
                 D_TRANS_DATE,
                 N_VOUCHER_NO,
                 NVL (V_INCOME_TAX_RULE_REF, 0) / 100 * N_COMM N_WHT,
                 N_COMM - NVL (V_INCOME_TAX_RULE_REF, 0) / 100 * N_COMM
                    N_NET_COMM
            FROM (                                            --ALL COMMISSION
                  SELECT   N_AGENT_NO,
                           a.V_POLICY_NO,
                           V_COMPANY_NAME,
                           b.D_COMM_GEN,
                           V_POSTED_REF_NO,
                           N_COMM_PAID_SEQ,
                           D_BILL_RAISED_DATE,
                           SUM (N_PREM_BASE_CURRENCY) N_PREM,
                           SUM (N_COMM_AMT) N_COMM
                      FROM AMMT_COMMISSION_INTIMATION a,
                           AMMT_POL_COMM_DETAIL b,
                           GNDT_BILL_TRANS c,
                           GNMM_COMPANY_MASTER d
                     WHERE     a.N_COMM_INTIMATION_SEQ = b.N_COMM_INTIMATION_SEQ
                           AND a.N_SEQ_NO = b.N_SEQ_NO
                           AND a.V_PLAN_CODE = b.V_PLAN_CODE
                           AND V_COMM_PROCESS_CODE IN ('G', 'C', 'R')
                           AND N_BILL_TRN_NO = 1
                           AND V_POSTED_REF_NO = V_BILL_NO
                           AND NVL (c.V_COMPANY_CODE, 'X') =
                                  NVL (d.V_COMPANY_CODE, 'X')
                           AND NVL (c.V_COMPANY_BRANCH, 'X') =
                                  NVL (d.V_COMPANY_BRANCH, 'X')
                  GROUP BY N_AGENT_NO,
                           a.V_POLICY_NO,
                           V_COMPANY_NAME,
                           b.D_COMM_GEN,
                           V_POSTED_REF_NO,
                           N_COMM_PAID_SEQ,
                           D_BILL_RAISED_DATE) p,
                 (                                              --VOUCHER ONLY
                  SELECT x.N_BENEFIT_POOL_SEQ_NO,
                         x.N_AGENT_NO,
                         V_AGENT_CODE,
                         V_COMPANY_NAME,
                         V_TRANS_SOURCE_CODE,
                         x.V_TRANS_SOURCE_REF_NO,
                         y.D_TRANS_DATE,
                         N_AMOUNT,
                         V_CREDIT_DEBIT_FLAG,
                         V_ACCOUNTED,
                         x.N_BENEFIT_POOL_PAY_SEQ,
                         N_VOUCHER_NO,
                         V_INCOME_TAX_RULE_REF
                    FROM AMDT_AGENT_BENEFIT_POOL_DETAIL x,
                         AMDT_AGENT_BENE_POOL_PAYMENT y,
                         AMMM_AGENT_MASTER z,
                         GNMM_COMPANY_MASTER w
                   WHERE     x.N_BENEFIT_POOL_PAY_SEQ =
                                y.N_BENEFIT_POOL_PAY_SEQ
                         AND x.N_AGENT_NO = z.N_AGENT_NO
                         AND V_TRANS_SOURCE_CODE IN ('COMMISSION',
                                                     'COMMISSION REVERSAL',
                                                     'MISC_ADJ')
                         AND NVL (z.V_COMPANY_CODE, 'X') =
                                NVL (w.V_COMPANY_CODE, 'X')
                         AND NVL (z.V_COMPANY_BRANCH, 'X') =
                                NVL (w.V_COMPANY_BRANCH, 'X') --and x.N_AGENT_NO = 714
                                                             ) q
           WHERE     V_TRANS_SOURCE_REF_NO = TO_CHAR (N_COMM_PAID_SEQ)
                 --AND EXTRACT(YEAR FROM D_TRANS_DATE) >= 2023
                 --AND N_VOUCHER_NO NOT IN (SELECT V_VOU_NO FROM PYMT_VOU_MASTER WHERE NVL(V_CHQ_NO,'X') != 'X')
                 AND N_VOUCHER_NO IN (SELECT V_VOU_NO
                                        FROM PYMT_VOU_MASTER
                                       WHERE NVL (V_CHQ_NO, 'X') = 'X'))
                                       
--                 AND V_AGENT_CODE = :P_Agent_Code)
ORDER BY D_TRANS_DATE

) WHERE (COMM_GENERATED_DATE) BETWEEN '07-FEB-2024' AND '29-FEB-2024'