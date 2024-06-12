/* Formatted on 03/03/2020 18:29:46 (QP5 v5.256.13226.35538) */

select count( distinct v_policy_no)
from 
(
SELECT a.V_POLICY_NO,
       V_AGENT_CODE,
       V_AGENT_NAME,
       V_MANAGER_CODE,
       V_MANAGER_NAME,
       V_AGENCY,
       V_PYMT_FREQ,
       N_CONTRIBUTION,
       DECODE (b.V_PYMT_FREQ, 0, 1, 12 / b.V_PYMT_FREQ) * b.N_CONTRIBUTION
          API,
       D_CNTR_START_DATE,
       D_PREM_DUE_DATE NDD,
       V_CNTR_STAT_CODE,
       V_STATUS_DESC,
       DECODE (n.N_WOP_APPROVED_AMOUNT, NULL, 'NO', 'YES') WOP_CLAIM,
       b.V_PMT_METHOD_CODE,
       V_PMT_METHOD_NAME,
       N_IND_SA,
       V_NAME,
       b.V_PLAN_CODE,
       V_PLAN_NAME,
       (SELECT SUM (N_RECEIPT_AMT)
          FROM REMT_RECEIPT
         WHERE     V_RECEIPT_TABLE = 'DETAIL'
               AND V_RECEIPT_STATUS = 'RE001'
               AND V_RECEIPT_CODE IN ('RCT002', 'RCT003')
               AND V_POLICY_NO = a.V_POLICY_NO)
          N_BOOKED_PREM,
       (SELECT SUM (N_AMOUNT)
          FROM PPMT_OUTSTANDING_PREMIUM
         WHERE V_STATUS != 'R' AND V_POLICY_NO = a.V_POLICY_NO)
          N_EXPECTED_PREM,
       CASE
          WHEN D_CNTR_START_DATE >= ADD_MONTHS (TRUNC (SYSDATE), -12) THEN 1
          WHEN D_CNTR_START_DATE >= ADD_MONTHS (TRUNC (SYSDATE), -24) THEN 2
          WHEN D_CNTR_START_DATE >= ADD_MONTHS (TRUNC (SYSDATE), -36) THEN 3
       END
          RISK_YEAR,
       CASE
          WHEN D_PREM_DUE_DATE <= ADD_MONTHS (TRUNC (SYSDATE), -3)
          THEN
             'LAPSED'
          ELSE
             'IN-FORCE'
       END
          V_POLICY_STATUS
  FROM AMMT_POL_AG_COMM a,
       GNMT_POLICY_DETAIL b,
       GNMM_POLICY_STATUS_MASTER c,
       GNMM_PLAN_MASTER d,
       GNLU_PAY_METHOD f,
       GNMT_WOP_ACCOUNT n,
       (SELECT u.N_AGENT_NO,
               u.N_CUST_REF_NO N_AGENT_CUST_REF_NO,
               u.V_AGENT_CODE,
               v.V_NAME V_AGENT_NAME,
               TRIM (V_ADD_THREE) V_AGENCY,
               u.N_CURRENTLY_REPORTING_TO N_MANAGER_NO,
               y.N_CUST_REF_NO N_MANAGER_CUST_REF_NO,
               x.V_AGENT_CODE V_MANAGER_CODE,
               y.V_NAME V_MANAGER_NAME
          FROM AMMM_AGENT_MASTER u,
               GNMT_CUSTOMER_MASTER v,
               GNDT_CUSTOMER_ADDRESS w,
               AMMM_AGENT_MASTER x,
               GNMT_CUSTOMER_MASTER y
         WHERE     u.N_CUST_REF_NO = v.N_CUST_REF_NO
               AND v.N_CUST_REF_NO = w.N_CUST_REF_NO(+)
               AND u.N_CURRENTLY_REPORTING_TO = x.N_AGENT_NO
               AND x.N_CUST_REF_NO = y.N_CUST_REF_NO(+)
               AND w.N_ADD_SEQ_NO = 1) e
 WHERE     --D_CNTR_START_DATE BETWEEN ( :P_FM_DT) AND ( :P_TO_DT) AND
       ---WHERE D_CNTR_START_DATE BETWEEN TO_DATE('01/01/2013','DD/MM/YYYY') AND TO_DATE('31/01/2013','DD/MM/YYYY')
        a.V_POLICY_NO = b.V_POLICY_NO
       AND b.V_CNTR_STAT_CODE = c.V_STATUS_CODE
       AND b.V_PMT_METHOD_CODE = f.V_PMT_METHOD_CODE
       AND b.V_PLAN_CODE = d.V_PLAN_CODE
       --AND b.V_CNTR_STAT_CODE NOT IN ('NB053','NB054','NB058','NB099')
       AND b.V_CNTR_STAT_CODE NOT IN ('NB054',
                                      'NB099',
                                      'NB099-Y',
                                      'NB001',
                                      'NB058',
                                      'NB099-N',
                                      'NB053',
                                      'NB006',
                                      'NB002',
                                      'NB104')
       AND b.V_POLICY_NO = n.V_POLICY_NO(+)
       AND b.N_SEQ_NO = n.N_SEQ_NO(+)
       AND a.N_AGENT_NO = e.N_AGENT_NO(+)
       AND a.V_POLICY_NO NOT LIKE 'GL%'
       AND b.N_SEQ_NO = 1
       AND a.V_STATUS = 'A'
       AND V_ROLE_CODE = 'SELLING'
       AND EXTRACT(YEAR FROM D_CNTR_START_DATE)=2023
--AND a.V_POLICY_NO IN ('196705', '206181', 'IL201200054263')

)