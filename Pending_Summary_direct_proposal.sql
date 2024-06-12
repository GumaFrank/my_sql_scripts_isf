/* Formatted on 27/02/2020 10:54:59 (QP5 v5.256.13226.35538) */

select count (Distinct V_POLICY_NO) FROM 
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
         DECODE (
            A.V_PYMT_FREQ,
            0, DECODE (A.N_CONTRIBUTION,
                       0, 1,
                       (A.N_CONTRIBUTION / B.N_TERM) / A.N_CONTRIBUTION),
            12 / A.V_PYMT_FREQ)
       * A.N_CONTRIBUTION
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
       a.D_DISPATCH_DATE,
       a.D_ACKNOWLEDGE
  FROM GNMT_POLICY a,
       GNMT_POLICY_DETAIL b,
       AMMT_POL_AG_COMM c,
       GNLU_PAY_METHOD d,
       GNLU_FREQUENCY_MASTER e,
       GNMT_CUSTOMER_MASTER f,
       GNMM_POLICY_STATUS_MASTER g,
       GNMM_PLAN_MASTER h
 WHERE     a.V_POLICY_NO = b.V_POLICY_NO
       AND a.V_POLICY_NO = c.V_POLICY_NO
       AND a.V_PMT_METHOD_CODE = d.V_PMT_METHOD_CODE
       AND a.V_PYMT_FREQ = e.V_PYMT_FREQ
       AND V_ROLE_CODE = 'SELLING'
       AND c.V_STATUS = 'A'
       AND a.V_POLICY_NO NOT LIKE 'GL%'
       --AND D_ISSUE BETWEEN '01-JAN-2012' and '5-APR-2012'
       AND a.N_PAYER_REF_NO = f.N_CUST_REF_NO
       AND a.V_CNTR_STAT_CODE = g.V_STATUS_CODE
       AND a.V_PLAN_CODE = h.V_PLAN_CODE
       AND b.N_SEQ_NO = 1
       AND Jhl_Gen_Pkg.Policy_Awaiting_Premium (A.V_Policy_No) = 'Y'
       AND A.V_Cntr_Stat_Code IN ('NB054',
                                  'NB099',
                                  'NB099-Y',
                                  'NB001',
                                  'NB058',
                                  'NB099-N',
                                  'NB053',
                                  'NB002',
                                  'NB104',
                                  --'NB010',
                                  'NB064')
       --AND A.D_PROPOSAL_DATE BETWEEN :P_FM_DT AND :P_TO_DT
       AND C.N_AGENT_NO NOT IN (1218,
                                28020,
                                22778,
                                28779)
       AND A.V_Policy_No NOT IN (SELECT N.V_Policy_No
                                   FROM Gn_Contract_Status_Log N
                                  WHERE     N.V_Policy_No = A.V_Policy_No
                                        AND N.V_Plri_Code = A.V_Plan_Code
                                        AND V_Prev_Stat_Code LIKE ('NB010')
                                        AND ROWNUM = 1)
       AND A.V_Policy_No NOT IN (SELECT V_policy_no
                                   FROM Gnmt_policy X
                                  WHERE     X.V_policy_no = A.V_policy_no
                                        AND V_plan_code IN ('BSANN01',
                                                            'BANY001',
                                                            'BCEDANPT'))
       AND A.V_POLICY_NO NOT IN (SELECT A.V_POLICY_NO
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
                                        AND A.V_PMT_METHOD_CODE =
                                               D.V_PMT_METHOD_CODE
                                        AND A.V_PYMT_FREQ = E.V_PYMT_FREQ
                                        --AND V_ROLE_CODE = 'SELLING'
                                        AND C.V_STATUS = 'A'
                                        AND A.V_POLICY_NO NOT LIKE 'GL%'
                                        --AND A.D_ISSUE BETWEEN '01-APR-2017' AND '18-APR-2017'
                                        --AND NVL(A.D_ISSUE,TO_DATE('01/01/2000','DD/MM/YYYY')) BETWEEN TO_DATE(DECODE(PARAMDATES.ISSFROMDATE, '', '01/01/1900', PARAMDATES.ISSFROMDATE),'DD/MM/YYYY') AND TO_DATE(DECODE(PARAMDATES.ISSTODATE, '', '01/01/2050', PARAMDATES.ISSTODATE),'DD/MM/YYYY')
--                                        AND A.D_PROPOSAL_DATE BETWEEN :P_FM_DT
--                                                                  AND :P_TO_DT
                                        AND A.N_PAYER_REF_NO =
                                               F.N_CUST_REF_NO
                                        AND A.V_CNTR_STAT_CODE =
                                               G.V_STATUS_CODE
                                        AND A.V_PLAN_CODE = H.V_PLAN_CODE
                                        AND B.N_SEQ_NO = 1
                                        AND Jhl_Gen_Pkg.Policy_Awaiting_Premium (
                                               A.V_Policy_No) = 'Y'
                                        AND A.V_Cntr_Stat_Code IN ('NB054',
                                                                   'NB099',
                                                                   'NB099-Y',
                                                                   'NB001',
                                                                   'NB058',
                                                                   'NB099-N',
                                                                   'NB053',
                                                                   'NB002',
                                                                   'NB104',
                                                                   --  'NB010',
                                                                   'NB064')
                                        AND C.N_AGENT_NO IN (65620,
                                                             72770,
                                                             74753,
                                                             22778,
                                                             80214,
                                                             82494)
                                        AND A.V_Policy_No NOT IN (SELECT N.V_Policy_No
                                                                    FROM Gn_Contract_Status_Log N
                                                                   WHERE     N.V_Policy_No =
                                                                                A.V_Policy_No
                                                                         AND N.V_Plri_Code =
                                                                                A.V_Plan_Code
                                                                         AND V_Prev_Stat_Code LIKE
                                                                                ('NB010')
                                                                         AND ROWNUM =
                                                                                1))
                                        --AND EXTRACT(YEAR FROM A.D_PROPOSAL_DATE) = 2023
                                        AND TO_CHAR(A.D_PROPOSAL_DATE, 'MON-YY') = 'JAN-24'
                                        
                                        )