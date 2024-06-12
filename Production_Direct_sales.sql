/* Formatted on 27/02/2020 11:06:13 (QP5 v5.256.13226.35538) */

SELECT COUNT( DISTINCT V_POLICY_NO) FROM 
(
SELECT A.D_PROPOSAL_DATE,
       A.D_ISSUE,
       a.D_COMMENCEMENT,
       a.V_LASTUPD_USER,
       a.V_POLICY_NO,
       b.V_NAME ASSURED_NAME,
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
       JHL_UTILS.AGENT_NAME (c.N_AGENT_NO) AGENT,
       (SELECT JHL_UTILS.AGENT_NAME (
                  SUM (DECODE (N_MANAGER_LEVEL, 30, N_MANAGER_NO, 0)))
                  USM
          FROM AMMT_AGENT_HIERARCHY k
         WHERE k.N_AGENT_NO = c.N_AGENT_NO AND V_STATUS = 'A')
          UNIT_SALES_MANAGER,
       (SELECT JHL_UTILS.AGENT_NAME (
                  SUM (DECODE (N_MANAGER_LEVEL, 20, N_MANAGER_NO, 0)))
                  ASM
          FROM AMMT_AGENT_HIERARCHY k
         WHERE k.N_AGENT_NO = c.N_AGENT_NO AND V_STATUS = 'A')
          AGENCY_SALES_MANAGER,
       (SELECT JHL_UTILS.AGENT_NAME (
                  SUM (DECODE (N_MANAGER_LEVEL, 15, N_MANAGER_NO, 0)))
                  RSM
          FROM AMMT_AGENT_HIERARCHY k
         WHERE k.N_AGENT_NO = c.N_AGENT_NO AND V_STATUS = 'A')
          REGIONAL_SALES_MANAGER,
       (SELECT JHL_UTILS.AGENT_NAME (
                  SUM (DECODE (N_MANAGER_LEVEL, 10, N_MANAGER_NO, 0)))
                  AS NSM
          FROM AMMT_AGENT_HIERARCHY k
         WHERE k.N_AGENT_NO = c.N_AGENT_NO AND V_STATUS = 'A')
          NATIONAL_SALES_MANAGER,
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
       (SELECT x.V_POLICY_NO, N_PREM_OS, NUM_DUE             --, N_RECEIPT_AMT
          FROM (  SELECT V_POLICY_NO,
                         SUM (N_AMOUNT) N_PREM_OS,
                         SUM (NUM_DUE) NUM_DUE
                    FROM (SELECT V_POLICY_NO,
                                 DECODE (V_STATUS, 'A', N_AMOUNT, 0) N_AMOUNT,
                                 DECODE (V_STATUS, 'A', 1, 0) NUM_DUE
                            FROM PPMT_OUTSTANDING_PREMIUM --WHERE V_POLICY_NO = 'IL201200137132'
                                                         )
                GROUP BY V_POLICY_NO) x) i
 WHERE     a.V_POLICY_NO = b.V_POLICY_NO
       AND a.V_POLICY_NO = c.V_POLICY_NO
       AND a.V_PMT_METHOD_CODE = d.V_PMT_METHOD_CODE
       AND a.V_PYMT_FREQ = e.V_PYMT_FREQ
       AND V_ROLE_CODE = 'SELLING'
       AND c.V_STATUS = 'A'
       AND A.V_CNTR_STAT_CODE IN ('NB010',
                                  'NB105',
                                  'NB020',
                                  'NB022',
                                  'NB050',
                                  'NB058')
       --AND a.V_POLICY_NO NOT LIKE 'GL%'
       --AND D_ISSUE BETWEEN '01-JAN-2012' and '5-APR-2012'
       AND a.N_PAYER_REF_NO = f.N_CUST_REF_NO
       AND a.V_CNTR_STAT_CODE = g.V_STATUS_CODE
       AND a.V_PLAN_CODE = h.V_PLAN_CODE
       AND a.V_POLICY_NO = i.V_POLICY_NO
       AND b.N_SEQ_NO = 1
       AND a.V_policy_no NOT IN (SELECT V_policy_no
                                   FROM Gnmt_policy X
                                  WHERE     X.V_policy_no = A.V_policy_no
                                        AND V_plan_code IN ('BSANN01',
                                                            'BANY001',
                                                            'BCEDANPT'))
       --AND A.D_ISSUE BETWEEN :P_FM_DT AND :P_TO_DT
--       AND C.N_AGENT_NO NOT IN (1218,
--                                28020,
--                                22778,
--                                28779)
       AND A.V_POLICY_NO NOT IN (SELECT A.V_POLICY_NO
                                   FROM GNMT_POLICY A,
                                        GNMT_POLICY_DETAIL B,
                                        AMMT_POL_AG_COMM C,
                                        GNLU_PAY_METHOD D,
                                        GNLU_FREQUENCY_MASTER E,
                                        GNMT_CUSTOMER_MASTER F,
                                        GNMM_POLICY_STATUS_MASTER G,
                                        GNMM_PLAN_MASTER H,
                                        (SELECT X.V_POLICY_NO,
                                                N_PREM_OS,
                                                NUM_DUE      --, N_RECEIPT_AMT
                                           FROM (  SELECT V_POLICY_NO,
                                                          SUM (N_AMOUNT)
                                                             N_PREM_OS,
                                                          SUM (NUM_DUE) NUM_DUE
                                                     FROM (SELECT V_POLICY_NO,
                                                                  DECODE (
                                                                     V_STATUS,
                                                                     'A', N_AMOUNT,
                                                                     0)
                                                                     N_AMOUNT,
                                                                  DECODE (
                                                                     V_STATUS,
                                                                     'A', 1,
                                                                     0)
                                                                     NUM_DUE
                                                             FROM PPMT_OUTSTANDING_PREMIUM --WHERE V_POLICY_NO = 'IL201200137132'
                                                                                          )
                                                 GROUP BY V_POLICY_NO) X) I
                                  WHERE     A.V_POLICY_NO = B.V_POLICY_NO
                                        AND A.V_POLICY_NO = C.V_POLICY_NO
                                        AND A.V_PMT_METHOD_CODE =
                                               D.V_PMT_METHOD_CODE
                                        AND A.V_PYMT_FREQ = E.V_PYMT_FREQ
                                        --AND V_ROLE_CODE = 'SELLING'
                                        AND C.V_STATUS = 'A'
                                        AND A.V_CNTR_STAT_CODE IN ('NB010',
                                                                   'NB105',
                                                                   'NB020',
                                                                   'NB022',
                                                                   'NB050',
                                                                   'NB058')
                                       -- AND A.V_POLICY_NO NOT LIKE 'GL%'
                                        --AND A.D_ISSUE BETWEEN '01-APR-2017' AND '18-APR-2017'
--                                        AND A.D_ISSUE BETWEEN :P_FM_DT
--                                                          AND :P_TO_DT
                                        --AND NVL(A.D_PROPOSAL_DATE,TO_DATE('01/01/2000','DD/MM/YYYY')) BETWEEN TO_DATE(DECODE(PARAMDATES.PROFROMDATE, '', '01/01/1900', PARAMDATES.PROFROMDATE),'DD/MM/YYYY') AND TO_DATE(DECODE(PARAMDATES.PROTODATE, '', '01/01/2050', PARAMDATES.PROTODATE),'DD/MM/YYYY')
                                        AND A.N_PAYER_REF_NO =
                                               F.N_CUST_REF_NO
                                        AND A.V_CNTR_STAT_CODE =
                                               G.V_STATUS_CODE
                                        AND A.V_PLAN_CODE = H.V_PLAN_CODE
                                        AND A.V_POLICY_NO = I.V_POLICY_NO
                                        AND B.N_SEQ_NO = 1
                                        --AND A.V_POLICY_NO IN(SELECT N.V_POLICY_NO FROM GN_CONTRACT_STATUS_LOG N
                                        --WHERE N.V_POLICY_NO = A.V_POLICY_NO
                                        --AND N.V_PLRI_CODE = A.V_PLAN_CODE
                                        --AND V_PREV_STAT_CODE LIKE( 'NB010')
                                        --AND ROWNUM = 1)
--                                        AND C.N_AGENT_NO IN (65620,
--                                                             72770,
--                                                             74753,
--                                                             22778,
--                                                             80214))
and to_char(A.D_PROPOSAL_DATE, 'MON-YY') = 'JAN-23'
                                       -- AND EXTRACT(YEAR FROM A.D_PROPOSAL_DATE) >= 2023 
                                        
                                         )
                                         )