/* Formatted on 08/01/2020 16:13:26 (QP5 v5.256.13226.35538) */
SELECT COUNT (DISTINCT V_POLICY_NO) FROM 
(
SELECT A.D_PROPOSAL_DATE,
       A.D_ISSUE,
       A.D_COMMENCEMENT,
       A.V_LASTUPD_USER,
       A.V_POLICY_NO,
       B.V_NAME ASSURED_NAME,
       (SELECT V_IDEN_NO
          FROM GNDT_CUSTOMER_IDENTIFICATION
         WHERE     V_IDEN_CODE = 'PIN'
               AND N_CUST_REF_NO = A.N_PAYER_REF_NO
               AND ROWNUM = 1)
          KRA_PIN,
       (SELECT V_CONTACT_NUMBER
          FROM GNDT_CUSTMOBILE_CONTACTS
         WHERE     N_CUST_REF_NO = N_PAYER_REF_NO
               AND V_STATUS = 'A'
               AND ROWNUM = 1)
          V_CONTACT_NUMBER,
       JHL_UTILS.AGENT_NAME (C.N_AGENT_NO) AGENT,
       (SELECT JHL_UTILS.AGENT_NAME (
                  SUM (DECODE (N_MANAGER_LEVEL, 20, N_MANAGER_NO, 0)))
                  BAS
          FROM AMMT_AGENT_HIERARCHY K
         WHERE K.N_AGENT_NO = A.N_AGENT_NO AND V_STATUS = 'A')
          BANCA_ASSURANCE_SUPERVISOR,
       (SELECT JHL_UTILS.AGENT_NAME (
                  SUM (DECODE (N_MANAGER_LEVEL, 10, N_MANAGER_NO, 0)))
                  BAM
          FROM AMMT_AGENT_HIERARCHY K
         WHERE K.N_AGENT_NO = A.N_AGENT_NO AND V_STATUS = 'A')
          BANCA_ASSURANCE_MANAGER,
       N_SUM_COVERED,
       B.N_TERM,
       A.V_PYMT_FREQ,
       V_PYMT_DESC,
       A.V_PMT_METHOD_CODE,
       V_PMT_METHOD_NAME,
       A.N_CONTRIBUTION TOTAL_PREMIUM,
       DECODE (A.V_PYMT_FREQ, 0, 1, 12 / A.V_PYMT_FREQ) * A.N_CONTRIBUTION
          TOTAL_ANNUAL_PREM,
       N_IND_BASIC_PREM BASIC_PREMIUM,
       DECODE (A.V_PYMT_FREQ, 0, 1, 12 / A.V_PYMT_FREQ) * B.N_IND_BASIC_PREM
          BASIC_ANNUAL_PREM,
       JHL_UTILS.RIDER_PREMIUM (A.V_POLICY_NO) RIDER_PREMIUM,
       N_PAYER_REF_NO,
       F.V_NAME POLICY_OWNER,
       JHL_UTILS.GET_PREV_STATUS (A.V_POLICY_NO) V_PREV_STATUS,
       A.V_CNTR_STAT_CODE,
       V_STATUS_DESC V_CURR_STATUS,
       A.V_PLAN_CODE,
       V_PLAN_NAME,
       A.D_NEXT_OUT_DATE,
       A.D_DISPATCH_DATE,
       A.D_ACKNOWLEDGE
  FROM GNMT_POLICY A,
       GNMT_POLICY_DETAIL B,
       AMMT_POL_AG_COMM C,
       GNLU_PAY_METHOD D,
       GNLU_FREQUENCY_MASTER E,
       GNMT_CUSTOMER_MASTER F,
       GNMM_POLICY_STATUS_MASTER G,
       GNMM_PLAN_MASTER H
 WHERE     A.V_POLICY_NO = B.V_POLICY_NO
       AND A.V_POLICY_NO = C.V_POLICY_NO
       AND A.V_PMT_METHOD_CODE = D.V_PMT_METHOD_CODE
       AND A.V_PYMT_FREQ = E.V_PYMT_FREQ
       AND V_ROLE_CODE = 'SELLING'
       AND C.V_STATUS = 'A'
       AND A.V_POLICY_NO NOT LIKE 'GL%'
       AND A.N_PAYER_REF_NO = F.N_CUST_REF_NO
       AND A.V_CNTR_STAT_CODE = G.V_STATUS_CODE
       AND A.V_PLAN_CODE = H.V_PLAN_CODE
       AND B.N_SEQ_NO = 1
       AND JHL_GEN_PKG.POLICY_AWAITING_PREMIUM (A.V_POLICY_NO) = 'Y'
       AND A.V_POLICY_NO NOT IN (SELECT N.V_POLICY_NO
                                   FROM GN_CONTRACT_STATUS_LOG N
                                  WHERE     N.V_POLICY_NO = A.V_POLICY_NO
                                        AND N.V_PLRI_CODE = A.V_PLAN_CODE
                                        AND V_PREV_STAT_CODE LIKE ('NB010')
                                        AND ROWNUM = 1)
       AND A.V_Policy_No NOT IN (SELECT V_policy_no
                                   FROM Gnmt_policy X
                                  WHERE     X.V_policy_no = A.V_policy_no
                                        AND V_plan_code IN ('BSANN01',
                                                            'BANY001',
                                                            'BCEDANPT'))
       AND A.V_CNTR_STAT_CODE IN ('NB054',
                                  'NB099',
                                  'NB099-Y',
                                  'NB001',
                                  'NB058',
                                  'NB099-N',
                                  'NB053',
                                  'NB002',
                                  'NB104',
                                  'NB064')
--       AND C.N_AGENT_NO IN (1218,
--                            28020,
--                            22778,
--                            28779)
AND TO_CHAR(A.D_PROPOSAL_DATE, 'MON-YY') = 'JAN-24'
      -- AND  EXTRACT(YEAR FROM A.D_PROPOSAL_DATE)=2023                    
--       AND NVL (TRUNC (A.D_PROPOSAL_DATE), TRUNC (SYSDATE)) BETWEEN NVL (
--                                                                       :P_FM_DT,
--                                                                       TRUNC (
--                                                                          SYSDATE))
--                                                                AND NVL (
--                                                                       :P_TO_DT,
--                                                                       TRUNC (
--                                                                          SYSDATE))
UNION
SELECT A.D_PROPOSAL_DATE,
       A.D_ISSUE,
       A.D_COMMENCEMENT,
       A.V_LASTUPD_USER,
       A.V_POLICY_NO,
       B.V_NAME ASSURED_NAME,
       (SELECT V_IDEN_NO
          FROM GNDT_CUSTOMER_IDENTIFICATION
         WHERE     V_IDEN_CODE = 'PIN'
               AND N_CUST_REF_NO = A.N_PAYER_REF_NO
               AND ROWNUM = 1)
          KRA_PIN,
       (SELECT V_CONTACT_NUMBER
          FROM GNDT_CUSTMOBILE_CONTACTS
         WHERE     N_CUST_REF_NO = N_PAYER_REF_NO
               AND V_STATUS = 'A'
               AND ROWNUM = 1)
          V_CONTACT_NUMBER,
       JHL_UTILS.AGENT_NAME (C.N_AGENT_NO) AGENT,
       NVL (
          (SELECT JHL_UTILS.AGENT_NAME (
                     SUM (DECODE (N_MANAGER_LEVEL, 20, N_MANAGER_NO, 0)))
                     BAS
             FROM AMMT_AGENT_HIERARCHY K
            WHERE K.N_AGENT_NO = A.N_AGENT_NO AND V_STATUS = 'A'),
          ' ')
          BANCA_ASSURANCE_SUPERVISOR,
       NVL (
          (SELECT JHL_UTILS.AGENT_NAME (
                     SUM (DECODE (N_MANAGER_LEVEL, 10, N_MANAGER_NO, 0)))
                     BAM
             FROM AMMT_AGENT_HIERARCHY K
            WHERE K.N_AGENT_NO = A.N_AGENT_NO AND V_STATUS = 'A'),
          ' ')
          BANCA_ASSURANCE_MANAGER,
       N_SUM_COVERED,
       B.N_TERM,
       A.V_PYMT_FREQ,
       V_PYMT_DESC,
       A.V_PMT_METHOD_CODE,
       V_PMT_METHOD_NAME,
       A.N_CONTRIBUTION TOTAL_PREMIUM,
       DECODE (A.V_PYMT_FREQ, 0, 1, 12 / A.V_PYMT_FREQ) * A.N_CONTRIBUTION
          TOTAL_ANNUAL_PREM,
       N_IND_BASIC_PREM BASIC_PREMIUM,
       DECODE (A.V_PYMT_FREQ, 0, 1, 12 / A.V_PYMT_FREQ) * B.N_IND_BASIC_PREM
          BASIC_ANNUAL_PREM,
       JHL_UTILS.RIDER_PREMIUM (A.V_POLICY_NO) RIDER_PREMIUM,
       N_PAYER_REF_NO,
       F.V_NAME POLICY_OWNER,
       JHL_UTILS.GET_PREV_STATUS (A.V_POLICY_NO) V_PREV_STATUS,
       A.V_CNTR_STAT_CODE,
       V_STATUS_DESC V_CURR_STATUS,
       A.V_PLAN_CODE,
       V_PLAN_NAME,
       A.D_NEXT_OUT_DATE,
       A.D_DISPATCH_DATE,
       A.D_ACKNOWLEDGE
  FROM GNMT_POLICY A,
       GNMT_POLICY_DETAIL B,
       AMMT_POL_AG_COMM C,
       GNLU_PAY_METHOD D,
       GNLU_FREQUENCY_MASTER E,
       GNMT_CUSTOMER_MASTER F,
       GNMM_POLICY_STATUS_MASTER G,
       GNMM_PLAN_MASTER H
 WHERE     A.V_POLICY_NO = B.V_POLICY_NO
       AND A.V_POLICY_NO = C.V_POLICY_NO
       AND A.V_PMT_METHOD_CODE = D.V_PMT_METHOD_CODE
       AND A.V_PYMT_FREQ = E.V_PYMT_FREQ
       AND C.V_STATUS = 'A'
       AND A.V_POLICY_NO NOT LIKE 'GL%'
       AND A.N_PAYER_REF_NO = F.N_CUST_REF_NO
       AND A.V_CNTR_STAT_CODE = G.V_STATUS_CODE
       AND A.V_PLAN_CODE = H.V_PLAN_CODE
       AND B.N_SEQ_NO = 1
       AND JHL_GEN_PKG.POLICY_AWAITING_PREMIUM (A.V_POLICY_NO) = 'Y'
       AND A.V_POLICY_NO NOT IN (SELECT N.V_POLICY_NO
                                   FROM GN_CONTRACT_STATUS_LOG N
                                  WHERE     N.V_POLICY_NO = A.V_POLICY_NO
                                        AND N.V_PLRI_CODE = A.V_PLAN_CODE
                                        AND V_PREV_STAT_CODE LIKE ('NB010')
                                        AND ROWNUM = 1)
       AND A.V_Policy_No NOT IN (SELECT V_policy_no
                                   FROM Gnmt_policy X
                                  WHERE     X.V_policy_no = A.V_policy_no
                                        AND V_plan_code IN ('BSANN01',
                                                            'BANY001',
                                                            'BCEDANPT'))
       AND A.V_CNTR_STAT_CODE IN ('NB054',
                                  'NB099',
                                  'NB099-Y',
                                  'NB001',
                                  'NB058',
                                  'NB099-N',
                                  'NB053',
                                  'NB002',
                                  'NB104',
                                  'NB064')
--       AND C.N_AGENT_NO IN (65620,
--                            72770,
--                            74753,
--                            22778,
--                            80214,
--                            82494)
        AND TO_CHAR(A.D_PROPOSAL_DATE, 'MON-YY') = 'JAN-24'
        --AND EXTRACT(YEAR FROM A.D_PROPOSAL_DATE)=2023                    
--       AND NVL (TRUNC (A.D_PROPOSAL_DATE), TRUNC (SYSDATE)) BETWEEN NVL (
--                                                                       :P_FM_DT,
--                                                                       TRUNC (
--                                                                          SYSDATE))
--                                                                AND NVL (
--                                                                       :P_TO_DT,
--                                                                       TRUNC (
--                                                                          SYSDATE))
)