SELECT 
COUNT( DISTINCT V_Claim_No) Claims
FROM (
Select A.D_Lastupd_Inftim D_Vou_Date,
       A.V_Claim_No,
       D.V_Policy_No,
       V_Name,
       D_Cntr_Start_Date,
       D_Cntr_End_Date,
       N_Contribution,
       N_Term,
       V_Plan_Code,
       D.N_Seq_No,
       N_Client_Ref_No,
       D_Ind_Dob,
       N_Ind_Sa,
       D.V_Claim_Type,
       V_Description Claim_Type,
       V_Claim_Status,
       V_Status_Desc,
       V_Event_Code,
       Nvl (N_Amount_Payable, 0) Claim_Prov,
       Nvl (N_Prov_Amount, 0) Bonus_Prov,
       Nvl (Gross_Paid, 0) Gross_Paid,
         Nvl (N_Amount_Payable, 0)
       + Nvl (N_Prov_Amount, 0)
       - Nvl (Gross_Paid, 0)
          Claim_Os,
       D_Event_Date,
       D_Claim_Date,
       A.V_Lastupd_User,
       V_Client_Name,
       --Decode (N_Vou_Amount, Null, Null, A.D_Lastupd_Inftim) D_Vou_Date,
       N_Vou_Amount,
       V_Chq_No,
       Jhl_Utils.Agent_Name3 (D.V_Policy_No) Agency_Name
  From Clmt_Claim_Master A,
       Cllu_Type_Master B,
       Clmm_Status_Master C,
       Cldt_Claim_Event_Policy_Link D,
       Cldt_Provision_Master E,
       Cldt_Bonus_Provision F,
       Gnmt_Policy_Detail G,
       (Select Distinct V_Claim_No, D_Event_Date From Cldt_Claim_Event_Link) H,
       (  Select V_Source_Ref_No,
                 Null V_Vou_No,
                 Null V_Main_Vou_No,
                 V_Vou_Source,
                 Null D_Vou_Date,
                 Sum (N_Vou_Amount) N_Vou_Amount,
                 V_Chq_No,
                 Null V_Payee_Name
            From Pymt_Voucher_Root A, Pymt_Vou_Master B
           Where A.V_Main_Vou_No = B.V_Main_Vou_No And V_Vou_Source = 'CLAIMS'
        Group By V_Source_Ref_No, V_Vou_Source,V_Chq_No) I,
       (  Select V_Claim_No, Sum (N_Claimant_Amount) Gross_Paid
            From Cldt_Claimant_Master
        Group By V_Claim_No) J
 Where     D.V_Claim_Type = B.V_Claim_Type(+)
       And A.V_Claim_Status = C.V_Status_Code
       And A.V_Claim_No = D.V_Claim_No
       And D.V_Claim_No = E.V_Claim_No(+)
       And D.N_Sub_Claim_No = E.N_Sub_Claim_No(+)
       And D.V_Claim_No = F.V_Claim_No(+)
       And D.N_Sub_Claim_No = F.N_Sub_Claim_No(+)
       And D.V_Policy_No = G.V_Policy_No
       And D.N_Seq_No = G.N_Seq_No
       And A.V_Claim_No = H.V_Claim_No
       And A.V_Claim_No = I.V_Source_Ref_No(+)
       And A.V_Claim_No = J.V_Claim_No(+)
       And A.V_Claim_Type In ('CLTP033', 'CLTP016')
       And C.V_Status_Code = 'CLST04'
--    And Trunc (A.D_Lastupd_Inftim) BETWEEN :P_FROM_DATE 
--                                         AND :P_TO_DATE
     --AND  EXTRACT (YEAR FROM A.D_Lastupd_Inftim)>= 2023
       )
       --WHERE EXTRACT (YEAR FROM D_Vou_Date) = 2023 -- AND EXTRACT(MONTH FROM D_Lastupd_Inftim) = 1
         where D_VOU_DATE between '01-JAN-2023' AND '31-DEC-2023'