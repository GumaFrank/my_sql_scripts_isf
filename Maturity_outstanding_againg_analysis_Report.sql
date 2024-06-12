/* Formatted on 19/12/2019 16:02:42 (QP5 v5.256.13226.35538) */
--AGEING MTRY OUTSTANDING DETAILS

SELECT V_POLICY_NO,
       OUTSTANDING_DAYS,
       CLAIM_PROV,
       V_PLAN_CODE,
       V_PLAN_DESC,
       V_CONTACT_NUMBER,
       POLICY_STATUS,
       CUSTOMER_ADDRESS,
       CUSTOMER_NAME
  FROM (  SELECT A.V_CLAIM_NO,
                 D.V_POLICY_NO,
                 G.V_PLAN_CODE,
                 K.V_PLAN_DESC,
                 NVL (N_AMOUNT_PAYABLE, 0) CLAIM_PROV,
                 NVL (N_PROV_AMOUNT, 0) BONUS_PROV,
                 D_EVENT_DATE,
                 D_CLAIM_DATE,
                 TRUNC (SYSDATE) - TRUNC (G.D_CNTR_END_DATE) OUTSTANDING_DAYS,
                 (SELECT V_CONTACT_NUMBER
                    FROM GNDT_CUSTMOBILE_CONTACTS
                   WHERE     N_CUST_REF_NO = G.N_CUST_REF_NO
                         AND V_CONTACT_NUMBER NOT LIKE '%@%'
                         AND V_STATUS = 'A'
                         AND ROWNUM = 1)
                    V_CONTACT_NUMBER,
                 (SELECT Q.V_STATUS_DESC
                    FROM GNMM_POLICY_STATUS_MASTER Q
                   WHERE Q.V_STATUS_CODE = G.V_CNTR_STAT_CODE)
                    POLICY_STATUS,
                 (SELECT V_ADD_ONE || ' ' || V_ADD_TWO ADDRESS
                    FROM GNDT_CUSTOMER_ADDRESS
                   WHERE N_CUST_REF_NO = G.N_CUST_REF_NO AND ROWNUM = 1)
                    CUSTOMER_ADDRESS,
                 (SELECT V_NAME
                    FROM GNMT_CUSTOMER_MASTER
                   WHERE N_CUST_REF_NO = G.N_CUST_REF_NO AND ROWNUM = 1)
                    CUSTOMER_NAME
            FROM CLMT_CLAIM_MASTER A,
                 CLLU_TYPE_MASTER B,
                 CLMM_STATUS_MASTER C,
                 CLDT_CLAIM_EVENT_POLICY_LINK D,
                 CLDT_PROVISION_MASTER E,
                 CLDT_BONUS_PROVISION F,
                 GNMT_POLICY_DETAIL G,
                 (SELECT DISTINCT V_CLAIM_NO, D_EVENT_DATE
                    FROM CLDT_CLAIM_EVENT_LINK) H,
                 (  SELECT V_SOURCE_REF_NO,
                           NULL V_VOU_NO,
                           NULL V_MAIN_VOU_NO,
                           V_VOU_SOURCE,
                           NULL D_VOU_DATE,
                           SUM (N_VOU_AMOUNT) N_VOU_AMOUNT,
                           NULL V_CHQ_NO,
                           NULL V_PAYEE_NAME
                      FROM PYMT_VOUCHER_ROOT A, PYMT_VOU_MASTER B
                     WHERE     A.V_MAIN_VOU_NO = B.V_MAIN_VOU_NO
                           AND V_VOU_SOURCE = 'CLAIMS'
                  GROUP BY V_SOURCE_REF_NO, V_VOU_SOURCE) I,
                 (  SELECT V_CLAIM_NO, SUM (N_CLAIMANT_AMOUNT) GROSS_PAID
                      FROM CLDT_CLAIMANT_MASTER
                  GROUP BY V_CLAIM_NO) J,
                 GNMM_PLAN_MASTER K
           WHERE     D.V_CLAIM_TYPE = B.V_CLAIM_TYPE(+)
                 AND A.V_CLAIM_STATUS = C.V_STATUS_CODE
                 AND A.V_CLAIM_NO = D.V_CLAIM_NO
                 AND D.V_CLAIM_NO = E.V_CLAIM_NO(+)
                 AND D.N_SUB_CLAIM_NO = E.N_SUB_CLAIM_NO(+)
                 AND D.V_CLAIM_NO = F.V_CLAIM_NO(+)
                 AND D.N_SUB_CLAIM_NO = F.N_SUB_CLAIM_NO(+)
                 AND D.V_POLICY_NO = G.V_POLICY_NO
                 AND D.N_SEQ_NO = G.N_SEQ_NO
                 AND A.V_CLAIM_NO = H.V_CLAIM_NO
                 AND A.V_CLAIM_NO = I.V_SOURCE_REF_NO(+)
                 AND A.V_CLAIM_NO = J.V_CLAIM_NO(+)
                 AND G.V_PLAN_CODE = K.V_PLAN_CODE
                 AND A.V_CLAIM_TYPE IN ('CLTP033', 'CLTP016')
                 AND C.V_STATUS_CODE = 'CLST02'
                 AND G.D_CNTR_END_DATE <= SYSDATE
                 AND G.V_CNTR_STAT_CODE NOT IN ('NB022',
                                                'NB025',
                                                'NB050',
                                                'NB024',
                                                'NB080')
                AND EXTRACT(YEAR FROM A.D_LASTUPD_INFTIM) >= 2023                               
                 --  AND A.D_LASTUPD_INFTIM BETWEEN TO_DATE ('01/01/2017', 'DD/MM/YYYY') AND TO_DATE ('31/01/2017', 'DD/MM/YYYY')
--                 AND TRUNC (NVL (D_Claim_Date, SYSDATE)) <= ( :P_AS_AT_DATE)
        ORDER BY D.V_POLICY_NO)