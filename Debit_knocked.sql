/* Formatted on 26/03/2019 12:39:45 (QP5 v5.256.13226.35538) */
select COUNT(V_POLICY_NO) FROM

(
SELECT V_POLICY_NO,
       V_BILL_NO,
      D_RECEIPT_DATE,
       D_BILL_RAISED_DATE,
       D_COMMENCEMENT,
       SUM (N_TRN_AMT) N_TRN_AMT,
       V_REF_NO,
       D_REF_DATE,
       AGENCY_SALES_MANAGER,
       REGIONAL_SALES_MANAGER,
       NATIONAL_SALES_MANAGER,
       D_REF_DATE D_POSTED_DATE
  FROM (  SELECT B.V_POLICY_NO,
                 V_POSTED_REF_NO V_BILL_NO,
                 TRUNC (D_DUE_DATE) D_BILL_RAISED_DATE,
                 TRUNC (D_COMMENCEMENT) D_COMMENCEMENT,
                 PREM.D_RECEIPT_DATE D_RECEIPT_DATE,
                 N_PREM_AMOUNT N_TRN_AMT,
                 V_RECEIPT_NO V_REF_NO,
                 TRUNC (PREM.D_RECEIPT_DATE) D_REF_DATE,
                 (SELECT JHL_GEN_PKG.AGENT_NAME (
                            SUM (DECODE (N_MANAGER_LEVEL, 20, N_MANAGER_NO, 0)))
                            ASM
                    FROM AMMT_AGENT_HIERARCHY K
                   WHERE K.N_AGENT_NO = C.N_AGENT_NO AND V_STATUS = 'A')
                    AGENCY_SALES_MANAGER,
                 (SELECT JHL_GEN_PKG.AGENT_NAME (
                            SUM (DECODE (N_MANAGER_LEVEL, 15, N_MANAGER_NO, 0)))
                            RSM
                    FROM AMMT_AGENT_HIERARCHY K
                   WHERE K.N_AGENT_NO = C.N_AGENT_NO AND V_STATUS = 'A')
                    REGIONAL_SALES_MANAGER,
                 (SELECT JHL_GEN_PKG.AGENT_NAME (
                            SUM (DECODE (N_MANAGER_LEVEL, 10, N_MANAGER_NO, 0)))
                            AS NSM
                    FROM AMMT_AGENT_HIERARCHY K
                   WHERE K.N_AGENT_NO = C.N_AGENT_NO AND V_STATUS = 'A'
                  UNION
                  SELECT JHL_GEN_PKG.AGENT_NAME (
                            SUM (DECODE (N_MANAGER_LEVEL, 10, N_MANAGER_NO, 0)))
                            BAM
                    FROM AMMT_AGENT_HIERARCHY K
                   WHERE K.N_AGENT_NO = C.N_AGENT_NO AND V_STATUS = 'A')
                    NATIONAL_SALES_MANAGER
            FROM PPMT_PREMIUM_REGISTER PREM, GNMT_POLICY B, AMMT_POL_AG_COMM C
           WHERE     PREM.V_POLICY_NO = B.V_POLICY_NO
                 AND B.V_POLICY_NO = C.V_POLICY_NO
                 AND V_ROLE_CODE = 'SELLING'
                 AND C.V_STATUS = 'A'
                 -- AND B.v_policy_no = 'IL201801446976'
                 --AND TRUNC (PREM.D_RECEIPT_DATE) BETWEEN '01-OCT-18' AND '15-OCT-18'
                 AND V_RECEIPT_NO IS NOT NULL
                 AND B.V_POLICY_NO NOT LIKE 'GL%'
               AND TRUNC (PREM.D_RECEIPT_DATE) BETWEEN :P_FM_DT AND :P_TO_DT)
                 --AND EXTRACT(YEAR FROM PREM.D_RECEIPT_DATE) >= 2023)
        GROUP BY V_POLICY_NO,
                 V_BILL_NO,
                 D_BILL_RAISED_DATE,
                 D_COMMENCEMENT,
                D_RECEIPT_DATE,
                 V_REF_NO,
                 D_REF_DATE,
                 AGENCY_SALES_MANAGER,
                 REGIONAL_SALES_MANAGER,
                 NATIONAL_SALES_MANAGER
                 )