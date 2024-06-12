/* Formatted on 21/01/2020 11:20:18 (QP5 v5.256.13226.35538) */
SELECT A.V_Claim_No,
       I.N_Sub_Claim_No,
       C.V_Policy_No,
       D.V_Company_Name,
       V_Client_Name,
        H.V_Plan_Desc,I.V_Lastupd_Inftim,
       F.V_Event_Desc,
       D_Event_Date,
       A.D_Claim_Date,
       A.D_Intimation,
       B.N_Amount_Payb,
       E.V_Status_Desc,
       I.V_Lastupd_Inftim Status_Date
  FROM Clmt_Claim_Master A,
       Cldt_Claim_Event_Policy_Link B,
       Gnmt_Policy C,
       Gnmm_Company_Master D,
       Clmm_Status_Master E,
       Gnmm_Event_Master F,
       Cldt_Claim_Policy_Settlement G,
       Gnmm_Plan_Master H,
       Cldt_Claim_Event_Status_Link I,
       Cldt_Claim_Event_Link J
 WHERE     A.V_Claim_No = B.V_Claim_No
       ---and A.V_CLAIM_NO IN ( 'CL20173409')
       --and a. V_CLAIM_TYPE= b.V_CLAIM_TYPE;
       AND B.V_Policy_No = C.V_Policy_No
       AND C.V_Company_Code = D.V_Company_Code
       AND C.V_Company_Branch = D.V_Company_Branch
       AND C.V_Grp_Ind_Flag = 'G'
       --and a.V_CLAIM_STATUS = E.V_STATUS_CODE
       AND B.V_Event_Code = F.V_Event_Code
       AND B.V_Claim_No = G.V_Claim_No(+)
       AND B.N_Seq_No = G.N_Seq_No(+)
       AND B.V_Plri_Code = H.V_Plan_Code
       AND B.N_Amount_Payb > 0
       AND B.V_Claim_No = I.V_Claim_No
       AND B.N_Sub_Claim_No = I.N_Sub_Claim_No
       AND B.V_Claim_No = J.V_Claim_No
       AND B.V_Event_Code = J.V_Event_Code
       AND I.V_Status_Code = E.V_Status_Code
--       AND I.V_Status_Code IN ('CLST05',
--                                'CLST06',
--                                'CLST08',
--                                'CLST09')
       -- AND EXTRACT(YEAR FROM A.D_Claim_Date) >= 2023                       
--       AND I.V_Lastupd_Inftim BETWEEN :P_FM_DT AND :P_TO_DT
--       AND D.V_COMPANY_CODE = NVL ( :P_COMPANY_CODE, D.V_COMPANY_CODE)
--       AND F.V_EVENT_CODE = NVL ( :P_EVENT_CODE, F.V_EVENT_CODE)