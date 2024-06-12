SELECT COUNT( DISTINCT V_VOU_NO) FROM 
(
Select A.V_Policy_No,
       V_Name,
       D_Cntr_Start_Date,
       D_Cntr_End_Date,
       N_Contribution,
       N_Term,
       V_Plan_Code,
       D.N_Seq_No,
       D_Ind_Dob,
       N_Ind_Sa,
      -- D_Survival_Date,
       N_SURR_CODE,
       N_POL_GROSS_SURR,
       N_POL_NET_SURR,
       B.V_Main_Vou_No,
       V_Vou_No,
       V_Vou_Source,
       V_Vou_Desc,
       D_Vou_Date,
       N_Vou_Amount,
       V_Chq_No,
       V_Payee_Name
  From PSDT_TERMINATION A,
       Pymt_Voucher_Root B,
       Pymt_Vou_Master C,
       Gnmt_Policy_Detail D
 Where     To_Char (A.N_SURR_CODE) = B.V_Source_Ref_No(+)
       And B.V_Main_Vou_No = C.V_Main_Vou_No(+)
       And N_POL_NET_SURR > 0
       And A.V_Policy_No = D.V_Policy_No
       And A.N_Seq_No = D.N_Seq_No
       And V_Vou_Source = 'PR0003'
       AND TO_CHAR( D_VOU_DATE, 'MON-YY') = 'JAN-24'
      -- And EXTRACT(YEAR FROM D_VOU_DATE )=2024
       --AND trunc(D_VOU_DATE) BETWEEN :P_FROM_DATE 
                          --AND :P_TO_DATE
                          )