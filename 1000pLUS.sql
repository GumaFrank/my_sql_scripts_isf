/* Formatted on 06/02/2020 15:37:41 (QP5 v5.256.13226.35538) */

SELECT COUNT ( DISTINCT V_AGENT_CODE ) FROM
(
SELECT DISTINCT
       a.N_AGENT_NO,
       a.V_RANK_CODE,
       a.V_AGENT_CODE,
       c.V_NAME V_AGENT_NAME,
       e.V_ADD_THREE,
       a.N_LEVEL,
       a.V_AGENT_TYPE,
       a.N_CURRENTLY_REPORTING_TO,
       b.V_AGENT_CODE MANAGER_CODE,
       d.V_NAME V_MANAGER_NAME,
      a.V_INCOME_TAX_RULE_REF,
       JHL_GEN_PKG.AGENT_PROD (a.N_AGENT_NO,
                              NULL, --:P_FM_DT,
                              NULL,--:P_TO_DT,
                               'MONTH',
                               'COUNT')
          MONTH_POL_COUNT,
       JHL_GEN_PKG.AGENT_PROD (a.N_AGENT_NO,
                               NULL,--:P_FM_DT,
                               NULL,--:P_TO_DT,
                               'MONTH',
                               'PREMIUM')
          MONTH_API,
       JHL_GEN_PKG.AGENT_PROD (a.N_AGENT_NO,
                               NULL,--:P_FM_DT,
                               NULL,--:P_TO_DT,
                               'YTD',
                               'COUNT')
          YTD_POL_COUNT,
       JHL_GEN_PKG.AGENT_PROD (a.N_AGENT_NO,
                               NULL,--:P_FM_DT,
                               NULL,--:P_TO_DT,
                               'YTD',
                               'PREMIUM')
          YTD_API,
       JHL_GEN_PKG.AGENT_PROD_FIRST_YEAR (a.N_AGENT_NO, 'COUNT')
          FIRST_YR_COUNT,
       JHL_GEN_PKG.AGENT_PROD_FIRST_YEAR (a.N_AGENT_NO, 'PREMIUM')
          FIRST_YR_PREMIUM
  FROM AMMM_AGENT_MASTER a,
       AMMM_AGENT_MASTER b,
       GNMT_CUSTOMER_MASTER c,
       GNMT_CUSTOMER_MASTER d,
       GNDT_CUSTOMER_ADDRESS e
 WHERE     a.N_CHANNEL_NO = 10
       AND a.N_CURRENTLY_REPORTING_TO = b.N_AGENT_NO
       AND a.N_CUST_REF_NO = c.N_CUST_REF_NO
       AND b.N_CUST_REF_NO = d.N_CUST_REF_NO(+)
       AND a.N_CUST_REF_NO = e.N_CUST_REF_NO
       AND e.N_ADD_SEQ_NO = 1
       )