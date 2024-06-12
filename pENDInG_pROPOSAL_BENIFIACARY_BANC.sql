/* Formatted on 09/03/2020 10:12:30 (QP5 v5.256.13226.35538) */
SELECT V_POLICY_NO,
       V_LASTUPD_USER,
       V_STATUS_DESC,
       V_NAME,
       DATE_OF_BIRTH,
       KRA_PIN,
       NATIONAL_ID,
       V_CONTACT_NUMBER,
       EMAIL,
       ADDRESS_ONE,
       ADDRESS_TWO,
       D_PROPOSAL_SUBMIT,
       TOTAL_PREMIUM,
       NVL (N_RECEIPT_AMT, 0) N_RECEIPT_AMT,
       TOTAL_ANNUAL_PREM,
       N_SUM_COVERED,
       V_PYMT_DESC,
       V_PMT_METHOD_NAME,
       V_PLAN_CODE,
       V_PLAN_NAME,
       N_TERM,
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
  FROM (SELECT A.D_PROPOSAL_SUBMIT,
               D_ISSUE,
               A.V_POLICY_NO,
               A.V_LASTUPD_USER,
               B.V_NAME,
               JHL_UTILS.AGENT_NAME (C.N_AGENT_NO) AGENT,
               N_SUM_COVERED,
               B.N_TERM,
               A.V_PYMT_FREQ,
               V_PYMT_DESC,
               A.V_PMT_METHOD_CODE,
               V_PMT_METHOD_NAME,
               A.N_CONTRIBUTION TOTAL_PREMIUM,
                 DECODE (A.V_PYMT_FREQ, 0, 1, 12 / A.V_PYMT_FREQ)
               * A.N_CONTRIBUTION
                  TOTAL_ANNUAL_PREM,
               N_IND_BASIC_PREM BASIC_PREMIUM,
                 DECODE (A.V_PYMT_FREQ, 0, 1, 12 / A.V_PYMT_FREQ)
               * B.N_IND_BASIC_PREM
                  BASIC_ANNUAL_PREM,
               JHL_UTILS.RIDER_PREMIUM (A.V_POLICY_NO) RIDER_PREMIUM,
               A.V_CNTR_STAT_CODE,
               G.V_STATUS_DESC,
               V_UW_DECISION,
               JHL_UTILS.PENDING_DOCS (A.V_POLICY_NO) V_PENDING_DOCS,
               (SELECT SUM (N_RECEIPT_AMT)
                  FROM REMT_RECEIPT
                 WHERE     V_POLICY_NO = A.V_POLICY_NO
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
               (SELECT V.D_BIRTH_DATE
                  FROM GNMT_CUSTOMER_MASTER V
                 WHERE V.N_CUST_REF_NO = B.N_CUST_REF_NO)
                  DATE_OF_BIRTH,
               (SELECT V_IDEN_NO
                  FROM GNDT_CUSTOMER_IDENTIFICATION K
                 WHERE     V_IDEN_CODE = 'NIC'
                       AND N_CUST_REF_NO = A.N_PAYER_REF_NO
                       AND ROWNUM = 1)
                  NATIONAL_ID,
               (SELECT V_CONTACT_NUMBER
                  FROM GNDT_CUSTMOBILE_CONTACTS
                 WHERE     N_CUST_REF_NO = N_PAYER_REF_NO
                       AND V_STATUS = 'A'
                       AND V_CONTACT_NUMBER NOT LIKE '%@%'
                       AND V_CONTACT_NUMBER NOT LIKE '%A%'
                       AND ROWNUM = 1)
                  V_CONTACT_NUMBER,
               (SELECT Q.V_CONTACT_NUMBER
                  FROM GNDT_CUSTMOBILE_CONTACTS Q
                 WHERE     Q.N_CUST_REF_NO = B.N_CUST_REF_NO
                       AND A.N_PAYER_REF_NO = Q.N_CUST_REF_NO
                       AND Q.V_CONTACT_NUMBER LIKE '%@%'
                       AND ROWNUM = 1)
                  EMAIL,
               (SELECT V_ADD_ONE
                  FROM GNDT_CUSTOMER_ADDRESS R
                 WHERE     R.N_CUST_REF_NO = B.N_CUST_REF_NO
                       AND A.N_ADD_SEQ_NO = R.N_ADD_SEQ_NO
                       AND A.V_ADD_CODE = R.V_ADD_CODE)
                  ADDRESS_ONE,
               (SELECT V_ADD_TWO
                  FROM GNDT_CUSTOMER_ADDRESS R
                 WHERE     R.N_CUST_REF_NO = B.N_CUST_REF_NO
                       AND A.N_ADD_SEQ_NO = R.N_ADD_SEQ_NO
                       AND A.V_ADD_CODE = R.V_ADD_CODE)
                  ADDRESS_TWO,
               A.V_PLAN_CODE,
               V_PLAN_NAME,
               R.V_IDEN_NO AS BENEFICIARY_NO,
               R.V_NAME AS BENEFICIARY_NAME,
               R.V_IDEN_CODE AS BENEFICIARY_ID_TYPE,
               R.V_REL_CODE AS RELATIONSHIP_CODE
          FROM GNMT_POLICY A,
               GNMT_POLICY_DETAIL B,
               AMMT_POL_AG_COMM C,
               GNLU_PAY_METHOD D,
               GNLU_FREQUENCY_MASTER E,
               GNMM_POLICY_STATUS_MASTER G,
               GNMM_PLAN_MASTER H,
               PSMT_POLICY_BENEFICIARY R
         WHERE     A.V_POLICY_NO = B.V_POLICY_NO
               AND A.V_POLICY_NO = C.V_POLICY_NO
               AND A.V_POLICY_NO = R.V_POLICY_NO
               AND A.V_PMT_METHOD_CODE = D.V_PMT_METHOD_CODE
               AND A.V_PLAN_CODE = H.V_PLAN_CODE
               AND A.V_PYMT_FREQ = E.V_PYMT_FREQ
               AND V_ROLE_CODE = 'SELLING'
               AND C.V_STATUS = 'A'
               AND A.V_POLICY_NO NOT LIKE 'GL%'
               AND TRUNC (NVL (A.D_PROPOSAL_SUBMIT, SYSDATE)) BETWEEN NVL (
                                                                       :P_FM_DT,
                                                                       TRUNC (
                                                                          NVL (
                                                                             A.D_PROPOSAL_SUBMIT,
                                                                             SYSDATE)))
                                                                AND NVL (
                                                                       :P_TO_DT,
                                                                       TRUNC (
                                                                          NVL (
                                                                             A.D_PROPOSAL_SUBMIT,
                                                                             SYSDATE)))
               AND A.V_CNTR_STAT_CODE = G.V_STATUS_CODE
               
               /*AND C.N_AGENT_NO IN (1218,
                                    28020,
                                    22778,
                                    28779)
                                    */
               AND A.V_POLICY_NO NOT IN (SELECT N.V_POLICY_NO
                                           FROM GN_CONTRACT_STATUS_LOG N
                                          WHERE     N.V_POLICY_NO =
                                                       A.V_POLICY_NO
                                                AND N.V_PLRI_CODE =
                                                       A.V_PLAN_CODE
                                                AND V_PREV_STAT_CODE LIKE
                                                       ('NB010')
                                                AND ROWNUM = 1)
               AND A.V_CNTR_STAT_CODE IN ('NB054',
                                          'NB099',
                                          'NB099-Y',
                                          'NB001',
                                          'NB058',
                                          'NB099-N',
                                          'NB053',
                                          'NB002',
                                          'NB104',
                                          'NB064'))
UNION
SELECT V_POLICY_NO,
       V_LASTUPD_USER,
       V_STATUS_DESC,
       V_NAME,
       DATE_OF_BIRTH,
       KRA_PIN,
       NATIONAL_ID,
       V_CONTACT_NUMBER,
       EMAIL,
       ADDRESS_ONE,
       ADDRESS_TWO,
       D_PROPOSAL_SUBMIT,
       TOTAL_PREMIUM,
       NVL (N_RECEIPT_AMT, 0) N_RECEIPT_AMT,
       TOTAL_ANNUAL_PREM,
       N_SUM_COVERED,
       V_PYMT_DESC,
       V_PMT_METHOD_NAME,
       V_PLAN_CODE,
       V_PLAN_NAME,
       N_TERM,
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
  FROM (SELECT A.D_PROPOSAL_SUBMIT,
               D_ISSUE,
               A.V_POLICY_NO,
               A.V_LASTUPD_USER,
               B.V_NAME,
               JHL_UTILS.AGENT_NAME (C.N_AGENT_NO) AGENT,
               N_SUM_COVERED,
               B.N_TERM,
               A.V_PYMT_FREQ,
               V_PYMT_DESC,
               A.V_PMT_METHOD_CODE,
               V_PMT_METHOD_NAME,
               A.N_CONTRIBUTION TOTAL_PREMIUM,
                 DECODE (A.V_PYMT_FREQ, 0, 1, 12 / A.V_PYMT_FREQ)
               * A.N_CONTRIBUTION
                  TOTAL_ANNUAL_PREM,
               N_IND_BASIC_PREM BASIC_PREMIUM,
                 DECODE (A.V_PYMT_FREQ, 0, 1, 12 / A.V_PYMT_FREQ)
               * B.N_IND_BASIC_PREM
                  BASIC_ANNUAL_PREM,
               JHL_UTILS.RIDER_PREMIUM (A.V_POLICY_NO) RIDER_PREMIUM,
               A.V_CNTR_STAT_CODE,
               G.V_STATUS_DESC,
               V_UW_DECISION,
               JHL_UTILS.PENDING_DOCS (A.V_POLICY_NO) V_PENDING_DOCS,
               (SELECT SUM (N_RECEIPT_AMT)
                  FROM REMT_RECEIPT
                 WHERE     V_POLICY_NO = A.V_POLICY_NO
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
               (SELECT V.D_BIRTH_DATE
                  FROM GNMT_CUSTOMER_MASTER V
                 WHERE V.N_CUST_REF_NO = B.N_CUST_REF_NO)
                  DATE_OF_BIRTH,
               (SELECT V_IDEN_NO
                  FROM GNDT_CUSTOMER_IDENTIFICATION K
                 WHERE     V_IDEN_CODE = 'NIC'
                       AND N_CUST_REF_NO = A.N_PAYER_REF_NO
                       AND ROWNUM = 1)
                  NATIONAL_ID,
               (SELECT V_CONTACT_NUMBER
                  FROM GNDT_CUSTMOBILE_CONTACTS
                 WHERE     N_CUST_REF_NO = N_PAYER_REF_NO
                       AND V_CONTACT_NUMBER NOT LIKE '%@%'
                       AND V_CONTACT_NUMBER NOT LIKE '%A%'
                       AND V_STATUS = 'A'
                       AND ROWNUM = 1)
                  V_CONTACT_NUMBER,
               (SELECT Q.V_CONTACT_NUMBER
                  FROM GNDT_CUSTMOBILE_CONTACTS Q
                 WHERE     Q.N_CUST_REF_NO = B.N_CUST_REF_NO
                       AND A.N_PAYER_REF_NO = Q.N_CUST_REF_NO
                       AND Q.V_CONTACT_NUMBER LIKE '%@%'
                       AND ROWNUM = 1)
                  EMAIL,
               (SELECT V_ADD_ONE
                  FROM GNDT_CUSTOMER_ADDRESS R
                 WHERE     R.N_CUST_REF_NO = B.N_CUST_REF_NO
                       AND A.N_ADD_SEQ_NO = R.N_ADD_SEQ_NO
                       AND A.V_ADD_CODE = R.V_ADD_CODE)
                  ADDRESS_ONE,
               (SELECT V_ADD_TWO
                  FROM GNDT_CUSTOMER_ADDRESS R
                 WHERE     R.N_CUST_REF_NO = B.N_CUST_REF_NO
                       AND A.N_ADD_SEQ_NO = R.N_ADD_SEQ_NO
                       AND A.V_ADD_CODE = R.V_ADD_CODE)
                  ADDRESS_TWO,
               A.V_PLAN_CODE,
               V_PLAN_NAME,
               R.V_IDEN_NO AS BENEFICIARY_NO,
               R.V_NAME AS BENEFICIARY_NAME,
               R.V_IDEN_CODE AS BENEFICIARY_ID_TYPE,
               R.V_REL_CODE AS RELATIONSHIP_CODE
          FROM GNMT_POLICY A,
               GNMT_POLICY_DETAIL B,
               AMMT_POL_AG_COMM C,
               GNLU_PAY_METHOD D,
               GNLU_FREQUENCY_MASTER E,
               GNMM_POLICY_STATUS_MASTER G,
               GNMM_PLAN_MASTER H,
               PSMT_POLICY_BENEFICIARY R
         WHERE     A.V_POLICY_NO = B.V_POLICY_NO
               AND A.V_POLICY_NO = C.V_POLICY_NO
               AND A.V_POLICY_NO = R.V_POLICY_NO
               AND A.V_PMT_METHOD_CODE = D.V_PMT_METHOD_CODE
               AND A.V_PLAN_CODE = H.V_PLAN_CODE
               AND A.V_PYMT_FREQ = E.V_PYMT_FREQ
               AND C.V_STATUS = 'A'
               AND A.V_POLICY_NO NOT LIKE 'GL%'
               AND TRUNC (NVL (A.D_PROPOSAL_SUBMIT, SYSDATE)) BETWEEN NVL (
                                                                       :P_FM_DT,
                                                                       TRUNC (
                                                                          NVL (
                                                                             A.D_PROPOSAL_SUBMIT,
                                                                             SYSDATE)))
                                                                AND NVL (
                                                                       :P_TO_DT,
                                                                       TRUNC (
                                                                          NVL (
                                                                            A.D_PROPOSAL_SUBMIT,
                                                                             SYSDATE)))
               AND A.V_CNTR_STAT_CODE = G.V_STATUS_CODE
               AND C.N_AGENT_NO IN (65620,
                                    72770,
                                    74753,
                                    22778,
                                    80214,
                                    82494)
               AND A.V_POLICY_NO NOT IN (SELECT N.V_POLICY_NO
                                           FROM GN_CONTRACT_STATUS_LOG N
                                          WHERE     N.V_POLICY_NO =
                                                       A.V_POLICY_NO
                                                AND N.V_PLRI_CODE =
                                                       A.V_PLAN_CODE
                                                AND V_PREV_STAT_CODE LIKE
                                                       ('NB010')
                                                AND ROWNUM = 1)
               AND A.V_CNTR_STAT_CODE IN ('NB054',
                                          'NB099',
                                          'NB099-Y',
                                          'NB001',
                                          'NB058',
                                          'NB099-N',
                                          'NB053',
                                          'NB002',
                                          'NB104',
                                          'NB064'))