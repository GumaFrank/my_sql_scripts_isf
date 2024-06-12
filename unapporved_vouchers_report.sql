
select COUNT (DISTINCT V_VOU_NO) from 
(
SELECT DISTINCT
       V_Vou_Source,
       V_Process_Name,
       V_Source_Ref_No,
       V_Policy_No,
       D_Vou_Date,
       B.V_Vou_No,
       B.V_Vou_Status,
       V_Status_Desc,
       B.N_Cust_Ref_No,
       V_Payee_Name,
       (SELECT V_Contact_Number
          FROM Gndt_Custmobile_Contacts H
         WHERE     E.N_Cust_Ref_No = H.N_Cust_Ref_No
               AND V_Contact_Number NOT LIKE '%@%'
               AND ROWNUM = 1)
          Contact_No,
       N_Vou_Amount,
       V_Chq_No,
       F.V_Lastupd_User,
       NVL (jhl_gen_pkg.get_voucher_payment_method (B.V_Vou_No), 'CHQ')
          PAY_METHOD,
       jhl_gen_pkg.get_voucher_status_user (B.V_VOU_NO, 'PREPARE')
          PROCESSED_BY,
          Jhl_gen_pkg.Get_voucher_status_user (B.V_vou_no, 'VERIFY') Verified_by,
       Jhl_gen_pkg.Get_voucher_date (B.V_vou_no, 'VERIFY') Verification_date,
       jhl_gen_pkg.get_voucher_date (B.V_VOU_NO, 'APPROVE') APPROVAL_DATE,
       jhl_gen_pkg.get_voucher_status_user (B.V_VOU_NO, 'APPROVE')
          APPROVED_BY,
       (SELECT SUM (N_AMOUNT)
          FROM PYDT_VOU_DETAILS
         WHERE V_PAYMENT_TYPE = 'D' AND V_VOU_NO = B.V_VOU_NO)
          GROSS_AMT
  FROM Pymt_Voucher_Root A,
       Pymt_Vou_Master B,
       Gnmm_Policy_Status_Master C,
       Gnmm_Process_Master D,
       Pydt_Voucher_Policy_Client E,
       Py_Voucher_Status_Log F
 WHERE     A.V_Main_Vou_No = B.V_Main_Vou_No
       AND V_Vou_Status = V_Status_Code
       AND V_Vou_Source = V_Process_Id
       AND A.V_Main_Vou_No = E.V_Main_Vou_No
--       AND V_Vou_Source NOT IN ('PY001', 'PY009', 'PY010')
--AND V_Vou_Source NOT IN ('PY001', 'PY009', 'PY010')
       AND B.V_Vou_No = F.V_Vou_No
--       AND V_VOU_STATUS = 'PY002'
AND EXTRACT(YEAR FROM D_FROM_DATE) >= 2023
--and NVL(JHL_GEN_PKG.IS_VOUCHER_AUTHORIZED(B.V_Vou_No),'N') <> 'Y'
--       AND TRUNC (D_FROM_DATE) BETWEEN NVL ( :CL_VC_FROM_DT,
--                                            TRUNC (D_FROM_DATE))
--                                   AND NVL ( :CL_VC_TO_DT,
--                                            TRUNC (D_FROM_DATE))

) where TO_CHAR(D_VOU_DATE, 'MON-YY') ='DEC-23' 