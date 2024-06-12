/* Formatted on 19/12/2019 11:33:42 (QP5 v5.256.13226.35538) */
select count(distinct V_POLICY_NO) from 
(
SELECT DISTINCT
       V_Vou_Source,
       V_Process_Name,
       H.V_Description,
       V_Source_Ref_No,
       E.V_Policy_No,
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
       N_Claimant_Amount Claim_Payable,
       N_Vou_Amount Voucher_Net_Amount,
       V_Chq_No,
       F.V_Lastupd_User,
       NVL (Jhl_Gen_Pkg.Get_Voucher_Payment_Method (B.V_Vou_No), 'CHQ')
          Pay_Method,
       Jhl_Gen_Pkg.Get_Voucher_Status_User (B.V_Vou_No, 'PREPARE')
          Processed_By,
       Jhl_Gen_Pkg.Get_Voucher_Date (B.V_Vou_No, 'APPROVE') Approval_Date,
       Jhl_Gen_Pkg.Get_Voucher_Status_User (B.V_Vou_No, 'APPROVE')
          Approved_By,
       (SELECT SUM (N_Amount)
          FROM Pydt_Vou_Details
         WHERE V_Payment_Type = 'D' AND V_Vou_No = B.V_Vou_No)
          Voucher_Gross_Amt
  FROM Pymt_Voucher_Root A,
       Pymt_Vou_Master B,
       Gnmm_Policy_Status_Master C,
       Gnmm_Process_Master D,
       Pydt_Voucher_Policy_Client E,
       Py_Voucher_Status_Log F,
       Cldt_Claim_Event_Policy_Link G,
       Cllu_Type_Master H,
       (  SELECT SUM (N_Claimant_Amount) N_Claimant_Amount,
                 V_Policy_No,
                 X.V_Claim_No
            FROM Cldt_Claimant_Master X, Cldt_Claim_Event_Policy_Link Y
           WHERE     X.V_Claim_No = Y.V_Claim_No
                 AND X.N_Sub_Claim_No = Y.N_Sub_Claim_No
        GROUP BY V_Policy_No, X.V_Claim_No) J
 WHERE     A.V_Main_Vou_No = B.V_Main_Vou_No
       AND A.V_Source_Ref_No = G.V_Claim_No
       AND A.V_Source_Ref_No = J.V_Claim_No
       AND J.V_Policy_No = E.V_Policy_No
       AND G.V_Claim_Type = H.V_Claim_Type
       AND V_Vou_Status = V_Status_Code
       AND V_Vou_Source = V_Process_Id
       AND A.V_Main_Vou_No = E.V_Main_Vou_No
       AND V_Vou_Source NOT IN ('PY014',
                                'PY010',
                                'PY009',
                                'PY001')                 --PY001 PY009 Removed
       AND B.V_Vou_Status NOT IN ('PY010', 'PY009', 'PY001')   --PY009 Removed
       AND B.V_Vou_No = F.V_Vou_No
       AND V_Current_Status IN ('PY005', 'PY004')          --PY009 PY001 added
       AND V_Vou_Source = 'CLAIMS'
       AND E.V_Policy_No NOT LIKE 'GL%'
       --AND TRUNC (D_Vou_Date) BETWEEN NVL ( :P_VOU_FM_DT, TRUNC (D_Vou_Date))
       --                           AND NVL ( :P_VOU_TO_DT, TRUNC (D_Vou_Date))
       --AND TRUNC (D_From_Date) BETWEEN NVL ( :P_Claim_FM_DT,
       --                                     TRUNC (D_From_Date))
       --                            AND NVL ( :P_Claim_TO_DT,
       --                                     TRUNC (D_From_Date))
       AND EXTRACT(YEAR FROM D_Vou_Date) = 2023
UNION
SELECT DISTINCT
       V_Vou_Source,
       V_Process_Name,
       H.V_Description,
       V_Source_Ref_No,
       E.V_Policy_No,
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
       N_Claimant_Amount Claim_Payable,
       N_Vou_Amount Voucher_Net_Amount,
       V_Chq_No,
       F.V_Lastupd_User,
       NVL (Jhl_Gen_Pkg.Get_Voucher_Payment_Method (B.V_Vou_No), 'CHQ')
          Pay_Method,
       Jhl_Gen_Pkg.Get_Voucher_Status_User (B.V_Vou_No, 'PREPARE')
          Processed_By,
       Jhl_Gen_Pkg.Get_Voucher_Date (B.V_Vou_No, 'APPROVE') Approval_Date,
       Jhl_Gen_Pkg.Get_Voucher_Status_User (B.V_Vou_No, 'APPROVE')
          Approved_By,
       (SELECT SUM (N_Amount)
          FROM Pydt_Vou_Details
         WHERE V_Payment_Type = 'D' AND V_Vou_No = B.V_Vou_No)
          Voucher_Gross_Amt
  FROM Pymt_Voucher_Root A,
       Pymt_Vou_Master B,
       Gnmm_Policy_Status_Master C,
       Gnmm_Process_Master D,
       Pydt_Voucher_Policy_Client E,
       Py_Voucher_Status_Log F,
       Cldt_Claim_Event_Policy_Link G,
       Cllu_Type_Master H,
       (  SELECT SUM (N_Claimant_Amount) N_Claimant_Amount,
                 V_Policy_No,
                 X.V_Claim_No
            FROM Cldt_Claimant_Master X, Cldt_Claim_Event_Policy_Link Y
           WHERE     X.V_Claim_No = Y.V_Claim_No
                 AND X.N_Sub_Claim_No = Y.N_Sub_Claim_No
        GROUP BY V_Policy_No, X.V_Claim_No) J
 WHERE     A.V_Main_Vou_No = B.V_Main_Vou_No
       AND A.V_Source_Ref_No = G.V_Claim_No
       AND A.V_Source_Ref_No = J.V_Claim_No
       AND J.V_Policy_No = E.V_Policy_No
       AND G.V_Claim_Type = H.V_Claim_Type
       AND V_Vou_Status = V_Status_Code
       AND V_Vou_Source = V_Process_Id
       AND A.V_Main_Vou_No = E.V_Main_Vou_No
       AND V_Vou_Source NOT IN ('PY014',
                                'PY010',
                                'PY005',
                                'PY004',
                                'PY002')
       AND B.V_Vou_Status NOT IN ('PY010',
                                  'PY005',
                                  'PY004',
                                  'PY002')
       AND B.V_Vou_No = F.V_Vou_No
       AND V_Current_Status IN ('PY009')                   --PY009 PY001 added
       AND V_Vou_Source = 'CLAIMS'
       AND E.V_Policy_No NOT LIKE 'GL%'
       --AND TRUNC (D_Vou_Date) BETWEEN NVL ( :P_VOU_FM_DT, TRUNC (D_Vou_Date))
       --                           AND NVL ( :P_VOU_TO_DT, TRUNC (D_Vou_Date))
       --AND TRUNC (D_From_Date) BETWEEN NVL ( :P_Claim_FM_DT,
       --                                     TRUNC (D_From_Date))
       --                            AND NVL ( :P_Claim_TO_DT,
       --                                     TRUNC (D_From_Date))
       AND EXTRACT(YEAR FROM D_Vou_Date) >= 2023
UNION
SELECT DISTINCT
       V_Vou_Source,
       V_Process_Name,
       H.V_Description,
       V_Source_Ref_No,
       E.V_Policy_No,
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
       N_Claimant_Amount Claim_Payable,
       N_Vou_Amount Voucher_Net_Amount,
       V_Chq_No,
       F.V_Lastupd_User,
       NVL (Jhl_Gen_Pkg.Get_Voucher_Payment_Method (B.V_Vou_No), 'CHQ')
          Pay_Method,
       Jhl_Gen_Pkg.Get_Voucher_Status_User (B.V_Vou_No, 'PREPARE')
          Processed_By,
       Jhl_Gen_Pkg.Get_Voucher_Date (B.V_Vou_No, 'APPROVE') Approval_Date,
       Jhl_Gen_Pkg.Get_Voucher_Status_User (B.V_Vou_No, 'APPROVE')
          Approved_By,
       (SELECT SUM (N_Amount)
          FROM Pydt_Vou_Details
         WHERE V_Payment_Type = 'D' AND V_Vou_No = B.V_Vou_No)
          Voucher_Gross_Amt
  FROM Pymt_Voucher_Root A,
       Pymt_Vou_Master B,
       Gnmm_Policy_Status_Master C,
       Gnmm_Process_Master D,
       Pydt_Voucher_Policy_Client E,
       Py_Voucher_Status_Log F,
       Cldt_Claim_Event_Policy_Link G,
       Cllu_Type_Master H,
       (  SELECT SUM (N_Claimant_Amount) N_Claimant_Amount,
                 V_Policy_No,
                 X.V_Claim_No
            FROM Cldt_Claimant_Master X, Cldt_Claim_Event_Policy_Link Y
           WHERE     X.V_Claim_No = Y.V_Claim_No
                 AND X.N_Sub_Claim_No = Y.N_Sub_Claim_No
        GROUP BY V_Policy_No, X.V_Claim_No) J
 WHERE     A.V_Main_Vou_No = B.V_Main_Vou_No
       AND A.V_Source_Ref_No = G.V_Claim_No
       AND A.V_Source_Ref_No = J.V_Claim_No
       AND J.V_Policy_No = E.V_Policy_No
       AND G.V_Claim_Type = H.V_Claim_Type
       AND V_Vou_Status = V_Status_Code
       AND V_Vou_Source = V_Process_Id
       AND A.V_Main_Vou_No = E.V_Main_Vou_No
       AND V_Vou_Source NOT IN ('PY014',
                                'PY010',
                                'PY005',
                                'PY004',
                                'PY002',
                                'PY009')
       AND B.V_Vou_Status NOT IN ('PY010',
                                  'PY005',
                                  'PY004',
                                  'PY002',
                                  'PY009')
       AND B.V_Vou_No = F.V_Vou_No
       AND V_Current_Status IN ('PY001')                   --PY009 PY001 added
       AND V_Vou_Source = 'CLAIMS'
       AND E.V_Policy_No NOT LIKE 'GL%'
       --AND TRUNC (D_Vou_Date) BETWEEN NVL ( :P_VOU_FM_DT, TRUNC (D_Vou_Date))
       --                           AND NVL ( :P_VOU_TO_DT, TRUNC (D_Vou_Date))
       --AND TRUNC (D_From_Date) BETWEEN NVL ( :P_Claim_FM_DT,
       --                                     TRUNC (D_From_Date))
       --                            AND NVL ( :P_Claim_TO_DT,
       --                                     TRUNC (D_From_Date))
       AND EXTRACT(YEAR FROM D_Vou_Date) = 2023
       )