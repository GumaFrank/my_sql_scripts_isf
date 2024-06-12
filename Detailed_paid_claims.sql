SELECT DISTINCT A.V_CLAIM_NO,
       C.V_POLICY_NO,
       D.V_COMPANY_CODE,
       D.V_COMPANY_NAME,
       V_CLIENT_NAME,
       H.V_PLAN_DESC,
       F.V_EVENT_CODE,
       F.V_EVENT_DESC,
        D_EVENT_DATE,I.V_LASTUPD_INFTIM,
       A.D_CLAIM_DATE,
       A.D_INTIMATION,
       B.N_AMOUNT_PAYB,
       E.V_STATUS_DESC,
       TRUNC (I.V_LASTUPD_INFTIM) CLAIM_PAID_DATE,
       JHL_GEN_PKG.
       GET_CLAIM_PAYMENT_DATE (A.V_CLAIM_NO,
                                B.N_AMOUNT_PAYB,
                               TRUNC (I.V_LASTUPD_INFTIM))
          PAYMENT_DATE,
       N_CLIENT_REF_NO,
       JHL_BI_UTILS.get_emp_id(C.V_POLICY_NO,N_CLIENT_REF_NO,'IDEN' ) V_IDEN_CODE,
           JHL_BI_UTILS.get_emp_id(C.V_POLICY_NO,N_CLIENT_REF_NO,'I' ) V_IDEN_NO,
        JHL_BI_UTILS.get_emp_id(C.V_POLICY_NO,N_CLIENT_REF_NO,'E' ) V_EMP_ID,
             N_CLIENT_REF_NO N_CUST_REF_NO,
       PY_DTLS.V_VOU_NO,
       N_VOU_AMOUNT,
       EFT_CHQ_NO,
       PY_DTLS.V_PAYEE_NAME,
       PY_DTLS.BANK_CODE,
       PY_DTLS.BRANCH_NAME,
       PY_DTLS.BANK_NAME,
       PY_DTLS.ACCOUNT_NO,
        Jhl_gen_pkg.Get_voucher_status_user (PY_DTLS.V_vou_no, 'PREPARE')
          Processed_by,
        Jhl_gen_pkg.Get_voucher_status_user (PY_DTLS.V_vou_no, 'VERIFY') Verified_by,
        Jhl_gen_pkg.Get_voucher_status_user (PY_DTLS.V_vou_no, 'APPROVE')
          Approved_by
  FROM CLMT_CLAIM_MASTER A,
       CLDT_CLAIM_EVENT_POLICY_LINK B,
       GNMT_POLICY C,
       GNMM_COMPANY_MASTER D,
       CLMM_STATUS_MASTER E,
       GNMM_EVENT_MASTER F,
       CLDT_CLAIM_POLICY_SETTLEMENT G,
       GNMM_PLAN_MASTER H,
       CLDT_CLAIM_EVENT_STATUS_LINK I,
       CLDT_CLAIM_EVENT_LINK J,
       (SELECT CLM.V_CLAIM_NO CLAIM_NO,
      CLM.N_SUB_CLAIM_NO  SUB_CLAIM_NO, 
               V_PAYEE_NAME,
               BNK_DTLS.V_BANK_CODE BANK_CODE,
               BNK_DTLS.V_BRANCH_CODE BRANCH_NAME,
               V_COMPANY_NAME BANK_NAME,
               V_ACCOUNT_NO ACCOUNT_NO,
               V_IDEN_NO,
                PV.N_CUST_REF_NO,
               PV.V_VOU_NO,
               N_VOU_AMOUNT,
               V_CHQ_NO EFT_CHQ_NO
          FROM PYMT_VOU_MASTER PV,
               PYMT_VOUCHER_ROOT PR,
               CLDT_CLAIMANT_MASTER CLM,   CLDT_CLAIMANT_DETAIL CLMD,PYDT_VOUCHER_POLICY_CLIENT VOU_POL,
               (SELECT BNK.V_BANK_CODE,
                        BNK.V_BRANCH_CODE,
                        V_COMPANY_NAME,
                       BNK.V_ACCOUNT_NO,
                        BNK.N_CUST_REF_NO,
                        I.V_IDEN_NO
                  FROM GNDT_CUSTOMER_BANK BNK,
                        GNMM_COMPANY_MASTER CO_BANK,
                        GNMT_CUSTOMER_MASTER CU,
                        GNDT_CUSTOMER_IDENTIFICATION I
                 WHERE     BNK.V_BANK_CODE = CO_BANK.V_COMPANY_CODE
                       AND BNK.V_BRANCH_CODE = CO_BANK.V_COMPANY_BRANCH
                       AND BNK.N_CUST_REF_NO = CU.N_CUST_REF_NO(+)
                       AND CU.N_CUST_REF_NO = I.N_CUST_REF_NO
                       AND BNK.V_SERVICE_ACCOUNT = 'Y'
                       AND BNK.V_ACCOUNT_STATUS = 'A') BNK_DTLS
         WHERE     PV.V_MAIN_VOU_NO = PR.V_MAIN_VOU_NO
         AND PR.V_SOURCE_REF_NO = CLM.V_CLAIM_NO 
               AND CLM.V_CLAIM_NO = CLMD.V_CLAIM_NO
                AND CLM.N_SUB_CLAIM_NO = CLMD.N_SUB_CLAIM_NO
                AND CLM.N_CLAIMANT_CODE = CLMD.N_CLAIMANT_CODE
                AND CLMD.V_VOUCHER_NO =  VOU_POL.V_POLICY_CLIENT_VOU_NO
                AND PV.V_VOU_NO = VOU_POL.V_VOU_NO
               AND PV.N_CUST_REF_NO = BNK_DTLS.N_CUST_REF_NO(+)
               AND V_VOU_SOURCE = 'CLAIMS') PY_DTLS
 WHERE     A.V_CLAIM_NO = B.V_CLAIM_NO
       AND B.V_POLICY_NO = C.V_POLICY_NO
       AND C.V_COMPANY_CODE = D.V_COMPANY_CODE
       AND C.V_COMPANY_BRANCH = D.V_COMPANY_BRANCH
       AND C.V_GRP_IND_FLAG = 'G'
       AND B.V_EVENT_CODE = F.V_EVENT_CODE
       AND B.V_CLAIM_NO = G.V_CLAIM_NO(+)
       AND B.N_SEQ_NO = G.N_SEQ_NO(+)
       AND B.V_PLRI_CODE = H.V_PLAN_CODE
       AND B.N_AMOUNT_PAYB > 0
       AND B.V_CLAIM_NO = I.V_CLAIM_NO
       AND B.N_SUB_CLAIM_NO = I.N_SUB_CLAIM_NO
       AND I.V_STATUS_CODE = E.V_STATUS_CODE
       AND I.V_STATUS_CODE = 'CLST04'
       AND B.V_CLAIM_NO = J.V_CLAIM_NO
       AND B.V_EVENT_CODE = J.V_EVENT_CODE
       AND B.V_CLAIM_NO = PY_DTLS.CLAIM_NO
       AND I.N_SUB_CLAIM_NO = PY_DTLS.SUB_CLAIM_NO
       AND EXTRACT(YEAR FROM I.V_LASTUPD_INFTIM) >= 2023
--       AND A.V_CLAIM_NO = 'CL20207111' 
--       AND TRUNC (I.V_LASTUPD_INFTIM) BETWEEN NVL (
--                                                  :P_FM_DT,
--                                                  TRUNC (I.V_LASTUPD_INFTIM))
--                                           AND NVL (
--                                                  :P_TO_DT,
--                                                  TRUNC (I.V_LASTUPD_INFTIM))
--       AND D.V_COMPANY_CODE = NVL (:P_COMPANY_CODE, D.V_COMPANY_CODE)
--       AND F.V_EVENT_CODE = NVL (:P_EVENT_CODE, F.V_EVENT_CODE)