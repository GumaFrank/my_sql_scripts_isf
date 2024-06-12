/* Formatted on 06/05/2020 13:49:18 (QP5 v5.139.911.3011) */

SELECT  count(distinct V_VOU_NO) FROM 
(
SELECT DISTINCT V_vou_source,
       V_process_name,
       V_source_ref_no,
       V_policy_no,
       D_vou_date,
       B.V_vou_no,
       B.V_vou_status,
       V_status_desc,
       B.N_cust_ref_no,
       B.V_COMPANY_CODE,
       B.V_COMPANY_BRANCH,
       V_payee_name,
       (SELECT V_contact_number
          FROM Gndt_custmobile_contacts H
         WHERE     E.N_cust_ref_no = H.N_cust_ref_no
               AND V_contact_number NOT LIKE '%@%'
               AND ROWNUM = 1)
          Contact_no,
       N_vou_amount,
       V_chq_no,
       F.V_lastupd_user,
       NVL (Jhl_gen_pkg.Get_voucher_payment_method (B.V_vou_no), 'CHQ')
          Pay_method,
       Jhl_gen_pkg.Get_voucher_status_user (B.V_vou_no, 'PREPARE')
          Processed_by,
       Jhl_gen_pkg.Get_voucher_status_user (B.V_vou_no, 'VERIFY') Verified_by,
       Jhl_gen_pkg.Get_voucher_date (B.V_vou_no, 'VERIFY') Verification_date,
       Jhl_gen_pkg.Get_voucher_status_user (B.V_vou_no, 'APPROVE')
          Approved_by,
       Jhl_gen_pkg.Get_voucher_date (B.V_vou_no, 'APPROVE') Approval_date,
       (SELECT SUM (N_amount)
          FROM Pydt_vou_details
         WHERE V_payment_type = 'D' AND V_vou_no = B.V_vou_no)
          Gross_amt,
       N_VOU_AMOUNT NET_AMOUNT,
       NVL (BNK_DTLS.V_BANK_CODE, BNK_DTLS_CO.V_BANK_CODE) V_BANK_CODE,
       NVL (BNK_DTLS.V_BRANCH_CODE, BNK_DTLS_CO.V_BRANCH_CODE) V_BRANCH_CODE,
       NVL (BNK_DTLS.V_COMPANY_NAME, BNK_DTLS_CO.V_COMPANY_NAME) BANK_NAME,
       NVL (BNK_DTLS.V_ACCOUNT_NO, BNK_DTLS_CO.V_ACCOUNT_NO) ACCOUNT_NO,
       JHL_BI_UTILS.get_policy_scheme (V_policy_no) SCHEME_NAME,
       JHL_BI_UTILS.get_voucher_payment_date (B.V_vou_no,N_vou_amount,TRUNC (A.D_VOU_DATE)) PAYMENT_DATE
  FROM Pymt_voucher_root A,
       Pymt_vou_master B,
       Gnmm_policy_status_master C,
       Gnmm_process_master D,
       (SELECT DISTINCT V_MAIN_VOU_NO, V_POLICY_NO, N_cust_ref_no
          FROM Pydt_voucher_policy_client) E,
       Py_voucher_status_log F,
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
               AND BNK.V_ACCOUNT_STATUS = 'A') BNK_DTLS,
       (SELECT BNK.V_BANK_CODE,
               BNK.V_BRANCH_CODE,
               CO_BANK.V_COMPANY_NAME,
               V_ACCOUNT_NO,
               BNK.V_COMPANY_CODE,
               BNK.V_COMPANY_BRANCH
          FROM GNDT_COMPANY_BANK BNK, GNMM_COMPANY_MASTER CO_BANK
         WHERE     BNK.V_BANK_CODE = CO_BANK.V_COMPANY_CODE
               AND BNK.V_BRANCH_CODE = CO_BANK.V_COMPANY_BRANCH
               AND BNK.V_SERVICE_ACCOUNT = 'Y'
               AND BNK.V_ACCOUNT_STATUS = 'A') BNK_DTLS_CO
 WHERE     A.V_main_vou_no = B.V_main_vou_no
       AND V_vou_status = V_status_code
       AND V_vou_source = V_process_id
       AND A.V_main_vou_no = E.V_main_vou_no
       AND V_vou_source NOT IN (--'PY001',
                                'PY014', 'PY009', 'PY010')
       AND B.V_vou_status NOT IN ('PY010', 'PY009')
       AND B.V_vou_no = F.V_vou_no
       AND V_current_status IN ('PY004')
       AND (V_POLICY_NO LIKE 'GL%' OR V_vou_source IN ('PY001'))
       -- AND B.V_MAIN_VOU_NO = A.V_MAIN_VOU_NO
       AND B.N_CUST_REF_NO = BNK_DTLS.N_CUST_REF_NO(+)
       AND B.V_COMPANY_CODE = BNK_DTLS_CO.V_COMPANY_CODE(+)
       AND B.V_COMPANY_BRANCH = BNK_DTLS_CO.V_COMPANY_BRANCH(+)
      -- AND TRUNC (D_FROM_DATE) BETWEEN (:P_FromDate) AND (:P_ToDate)
--AND B.V_vou_no='2020013160'
      ---AND EXTRACT(YEAR FROM D_FROM_DATE) >= 2023
      )
     WHERE TO_CHAR(APPROVAL_DATE, 'MON-YY') = 'DEC-23'