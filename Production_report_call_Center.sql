/* Formatted on 27/02/2020 11:19:21 (QP5 v5.256.13226.35538) */
SELECT COUNT(DISTINCT V_POLICY_NO) 
FROM 
(
SELECT A.D_PROPOSAL_DATE,
       A.D_ISSUE,
       a.D_COMMENCEMENT,
       a.V_LASTUPD_USER,
       a.V_POLICY_NO,
       b.V_NAME ASSURED_NAME,
       (SELECT V.D_BIRTH_DATE
          FROM GNMT_CUSTOMER_MASTER V
         WHERE V.N_CUST_REF_NO = B.N_CUST_REF_NO)
          DATE_OF_BIRTH,
       (SELECT V_IDEN_NO
          FROM GNDT_CUSTOMER_IDENTIFICATION
         WHERE     V_IDEN_CODE = 'PIN'
               AND N_CUST_REF_NO = A.N_PAYER_REF_NO
               AND ROWNUM = 1)
          KRA_PIN,
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
       Z.V_NAME AS BENEFICIARY_NAME,
       JHL_UTILS.AGENT_NAME (C.N_AGENT_NO) AGENT,
       N_SUM_COVERED,
       b.N_TERM,
       a.V_PYMT_FREQ,
       V_PYMT_DESC,
       a.V_PMT_METHOD_CODE,
       V_PMT_METHOD_NAME,
       a.N_CONTRIBUTION TOTAL_PREMIUM,
       DECODE (a.V_PYMT_FREQ, 0, 1, 12 / a.V_PYMT_FREQ) * a.N_CONTRIBUTION
          TOTAL_ANNUAL_PREM,
       N_IND_BASIC_PREM BASIC_PREMIUM,
       DECODE (a.V_PYMT_FREQ, 0, 1, 12 / a.V_PYMT_FREQ) * b.N_IND_BASIC_PREM
          BASIC_ANNUAL_PREM,
       JHL_UTILS.RIDER_PREMIUM (a.V_POLICY_NO) RIDER_PREMIUM,
       N_PAYER_REF_NO,
       f.V_NAME POLICY_OWNER,
       JHL_UTILS.GET_PREV_STATUS (a.V_POLICY_NO) V_PREV_STATUS,
       a.V_CNTR_STAT_CODE,
       V_STATUS_DESC V_CURR_STATUS,
       a.V_PLAN_CODE,
       V_PLAN_NAME,
       a.D_NEXT_OUT_DATE,
       N_PREM_OS,
       NUM_DUE,
       N_RECEIPT_AMT,
       a.D_DISPATCH_DATE,
       a.D_ACKNOWLEDGE
  FROM GNMT_POLICY a,
       GNMT_POLICY_DETAIL b,
       AMMT_POL_AG_COMM c,
       GNLU_PAY_METHOD d,
       GNLU_FREQUENCY_MASTER e,
       GNMT_CUSTOMER_MASTER f,
       GNMM_POLICY_STATUS_MASTER g,
       GNMM_PLAN_MASTER h,
       PSMT_POLICY_BENEFICIARY z,
       (SELECT x.V_POLICY_NO,
               N_PREM_OS,
               NUM_DUE,
               N_RECEIPT_AMT
          FROM (  SELECT V_POLICY_NO,
                         SUM (N_AMOUNT) N_PREM_OS,
                         SUM (NUM_DUE) NUM_DUE
                    FROM (SELECT V_POLICY_NO,
                                 DECODE (V_STATUS, 'A', N_AMOUNT, 0) N_AMOUNT,
                                 DECODE (V_STATUS, 'A', 1, 0) NUM_DUE
                            FROM PPMT_OUTSTANDING_PREMIUM)
                GROUP BY V_POLICY_NO) x,
               (  SELECT V_POLICY_NO, SUM (N_RECEIPT_AMT) N_RECEIPT_AMT
                    FROM REMT_RECEIPT
                   WHERE     V_RECEIPT_TABLE = 'DETAIL'
                         AND V_RECEIPT_STATUS = 'RE001'
                         AND V_RECEIPT_CODE IN ('RCT002', 'RCT003')
                GROUP BY V_POLICY_NO) y
         WHERE x.V_POLICY_NO = y.V_POLICY_NO(+)) i
 WHERE     a.V_POLICY_NO = b.V_POLICY_NO
       AND a.V_POLICY_NO = c.V_POLICY_NO
       AND A.V_POLICY_NO = Z.V_POLICY_NO
       AND a.V_PMT_METHOD_CODE = d.V_PMT_METHOD_CODE
       AND a.V_PYMT_FREQ = e.V_PYMT_FREQ
       --And a.N_PAYER_REF_NO = k.N_CUST_REF_NO
       AND V_ROLE_CODE = 'SELLING'
       AND c.V_STATUS = 'A'
       AND a.V_POLICY_NO NOT LIKE 'GL%'
       --AND A.D_ISSUE BETWEEN '01-JAN-2015' AND '31-jan-2015'
       AND a.N_PAYER_REF_NO = f.N_CUST_REF_NO
       AND a.V_CNTR_STAT_CODE = g.V_STATUS_CODE
       AND a.V_PLAN_CODE = h.V_PLAN_CODE
       AND a.V_POLICY_NO = i.V_POLICY_NO
       --AND EXTRACT(YEAR FROM A.D_ISSUE)>= 2023
       AND A.D_ISSUE BETWEEN :P_FM_DT AND :P_TO_DT
       --AND A.D_PROPOSAL_DATE BETWEEN :P_FM_DT1 AND :P_TO_DT1
       
       )