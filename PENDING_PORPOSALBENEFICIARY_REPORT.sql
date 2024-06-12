/* Formatted on 26/02/2020 16:04:46 (QP5 v5.256.13226.35538) */

SELECT COUNT (DISTINCT V_POLICY_NO)  FROM 
(
SELECT V_POLICY_NO,
       V_LASTUPD_USER,
       V_STATUS_DESC,
       V_NAME,
       KRA_PIN,
       D_PROPOSAL_SUBMIT,
       TOTAL_PREMIUM,
       NVL (N_RECEIPT_AMT, 0) N_RECEIPT_AMT,
       TOTAL_ANNUAL_PREM,
       N_SUM_COVERED,
       V_PYMT_DESC,
       V_PMT_METHOD_NAME,
       V_PLAN_CODE,
       V_PLAN_NAME,
       BENEFICIARY_NAME,
       RELATIONSHIP_CODE,
       BENEFICIARY_ID_TYPE,
       BENEFICIARY_NO,
       SUBSTR (AGENT, 1, INSTR (AGENT, '-') - 1) AGENT_CODE,
       AGENT,
       SUBSTR (AGENT,
               INSTR (AGENT, '-') + 1,
               INSTR (AGENT, ' (') - INSTR (AGENT, '-') + 1 - 2)
          AGENT_NAME,
       SUBSTR (AGENT,
               INSTR (AGENT, '(') + 1,
               INSTR (AGENT, ')') - INSTR (AGENT, '(') + 1 - 2)
          AGENCY,
       V_UW_DECISION,
       V_PENDING_DOCS
  FROM (SELECT a.D_PROPOSAL_SUBMIT,
               D_ISSUE,
               a.V_POLICY_NO,
               a.V_LASTUPD_USER,
               b.V_NAME,
               JHL_UTILS.AGENT_NAME (c.N_AGENT_NO) AGENT,
               N_SUM_COVERED,
               b.N_TERM,
               a.V_PYMT_FREQ,
               V_PYMT_DESC,
               a.V_PMT_METHOD_CODE,
               V_PMT_METHOD_NAME,
               a.N_CONTRIBUTION TOTAL_PREMIUM,
                 DECODE (a.V_PYMT_FREQ, 0, 1, 12 / a.V_PYMT_FREQ)
               * a.N_CONTRIBUTION
                  TOTAL_ANNUAL_PREM,
               N_IND_BASIC_PREM BASIC_PREMIUM,
                 DECODE (a.V_PYMT_FREQ, 0, 1, 12 / a.V_PYMT_FREQ)
               * b.N_IND_BASIC_PREM
                  BASIC_ANNUAL_PREM,
               JHL_UTILS.RIDER_PREMIUM (a.V_POLICY_NO) RIDER_PREMIUM,
               a.V_CNTR_STAT_CODE,
               g.V_STATUS_DESC,
               V_UW_DECISION,
               JHL_UTILS.PENDING_DOCS (a.V_POLICY_NO) V_PENDING_DOCS,
               (SELECT SUM (N_RECEIPT_AMT)
                  FROM REMT_RECEIPT
                 WHERE     V_POLICY_NO = a.V_POLICY_NO
                       AND V_RECEIPT_TABLE = 'DETAIL'
                       AND V_RECEIPT_STATUS = 'RE001'
                       AND V_RECEIPT_CODE IN ('RCT002', 'RCT003'))
                  N_RECEIPT_AMT,
               (SELECT V_IDEN_NO
                  FROM GNDT_CUSTOMER_IDENTIFICATION
                 WHERE     V_IDEN_CODE = 'PIN'
                       AND N_CUST_REF_NO = A.N_PAYER_REF_NO
                       AND ROWNUM = 1)
                  KRA_PIN,
               a.V_PLAN_CODE,
               V_PLAN_NAME,
               r.V_IDEN_NO AS BENEFICIARY_NO,
               r.V_NAME AS BENEFICIARY_NAME,
               r.V_IDEN_CODE AS BENEFICIARY_ID_TYPE,
               r.V_REL_CODE AS RELATIONSHIP_CODE
          FROM GNMT_POLICY a,
               GNMT_POLICY_DETAIL b,
               AMMT_POL_AG_COMM c,
               GNLU_PAY_METHOD d,
               GNLU_FREQUENCY_MASTER e,
               GNMM_POLICY_STATUS_MASTER g,
               GNMM_PLAN_MASTER h,
               PSMT_POLICY_BENEFICIARY r
         WHERE     a.V_POLICY_NO = b.V_POLICY_NO
               AND a.V_POLICY_NO = c.V_POLICY_NO
               AND a.V_POLICY_NO = r.V_POLICY_NO
               AND a.V_PMT_METHOD_CODE = d.V_PMT_METHOD_CODE
               AND a.V_PLAN_CODE = h.V_PLAN_CODE
               AND a.V_PYMT_FREQ = e.V_PYMT_FREQ
               AND V_ROLE_CODE = 'SELLING'
               AND c.V_STATUS = 'A'
               AND a.V_POLICY_NO NOT LIKE 'GL%'
               --AND A.D_PROPOSAL_DATE BETWEEN ( :P_FromDate) AND ( :P_ToDate)
               --AND A.D_PROPOSAL_DATE between '01-JAN-2015' and '31-JAN-2015'
               --AND a.V_POLICY_NO = f.V_POLICY_NO(+)
               AND a.V_CNTR_STAT_CODE = g.V_STATUS_CODE
               --AND NVL(D_ISSUE,'01-JAN-1900') = '01-JAN-1900'
               AND a.V_CNTR_STAT_CODE IN ('NB054',
                                          'NB099',
                                          'NB099-Y',
                                          'NB001',
                                          'NB058',
                                          'NB099-N',
                                          'NB053',
                                          'NB006',
                                          'NB002',
                                          'NB104',
                                          'NB004',
                                          'NB064') --AND a.V_CNTR_STAT_CODE = 'NB053'
                                                  )
 /*WHERE NVL (
          TRIM (
             UPPER (
                SUBSTR (AGENT,
                        INSTR (AGENT, '(') + 1,
                        INSTR (AGENT, ')') - INSTR (AGENT, '(') + 1 - 2))),
          'X') IN :P_AGENCY
          */
--WHERE TRIM(UPPER(SUBSTR(AGENT, INSTR(AGENT,'(')+1, INSTR(AGENT,')')-INSTR(AGENT,'(')+1-2)))

) WHERE TO_CHAR( D_PROPOSAL_SUBMIT, 'MON-YY') = 'JUN-23'