/* Formatted on 09/07/2020 15:27:47 (QP5 v5.139.911.3011) */
  SELECT DISTINCT V_payee_name,
                  V_policy_no,
                  (SELECT SUM (N_amount)
                     FROM Pydt_vou_details
                    WHERE V_payment_type = 'D' AND V_vou_no = B.V_vou_no)
                     Gross_amt,
                  N_vou_amount,
                   V_process_name,
                  D_vou_date,
                  B.V_vou_no,
                  SUM (N_vou_amount) Total_Amount
    FROM Pymt_voucher_root A,
         Pymt_vou_master B,
         Gnmm_policy_status_master C,
         Gnmm_process_master D,
         Pydt_voucher_policy_client E,
         Py_voucher_status_log F
   WHERE     A.V_main_vou_no = B.V_main_vou_no
         AND V_vou_status = V_status_code
         AND V_vou_source = V_process_id
         AND A.V_main_vou_no = E.V_main_vou_no
         AND V_vou_source NOT IN ('PY001', 'PY014', 'PY009', 'PY010')
         AND B.V_vou_status NOT IN ('PY010', 'PY009')
         AND B.V_vou_no = F.V_vou_no
         AND V_current_status IN ('PY004')
         AND EXTRACT(YEAR FROM D_FROM_DATE) >= 2023
         --AND TRUNC (D_FROM_DATE) BETWEEN (:P_FromDate) AND (:P_ToDate)
GROUP BY V_payee_name,
         V_policy_no,
         N_vou_amount,
         V_process_name,
         D_vou_date,
         B.V_vou_no
ORDER BY V_policy_no, D_vou_date