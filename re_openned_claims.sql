Select DISTINCT A.V_Claim_No,
       C.V_Policy_No,
       D.V_Company_Name,
       V_Client_Name,
       H.V_Plan_Desc,
       F.V_Event_Desc,
        D_Event_Date,I.V_Lastupd_Inftim,
       A.D_Claim_Date,
       A.D_Intimation,
       (Select min(D_From_Status) From Cldt_Claim_Decision_History X Where X.V_Claim_No = L.V_Claim_No And X.V_Curr_Status In  ('CLST05', 'CLST06', 'CLST08', 'CLST09')) Date_Rejected,
       (Select min(D_From_Status) From Cldt_Claim_Decision_History X Where X.V_Claim_No = L.V_Claim_No And X.V_PRV_STATUS In  ('CLST05', 'CLST06', 'CLST08', 'CLST09')) Date_ReOpened,
       B.N_Amount_Payb,
       E.V_Status_Desc,
      Trunc (I.V_Lastupd_Inftim) Claim_Paid_Date
  From Clmt_Claim_Master A,
       Cldt_Claim_Event_Policy_Link B,
       Gnmt_Policy C,
       Gnmm_Company_Master D,
       Clmm_Status_Master E,
       Gnmm_Event_Master F,
       Cldt_Claim_Policy_Settlement G,
       Gnmm_Plan_Master H,
       Cldt_Claim_Event_Status_Link I,
       Cldt_Claim_Event_Link J,
       Cldt_Claim_Decision_History L
Where     A.V_Claim_No = B.V_Claim_No
       And    A.V_Claim_No = L.V_Claim_No
       --and A.V_CLAIM_NO IN ( 'CL20173457')
       --and a. V_CLAIM_TYPE= b.V_CLAIM_TYPE;
       And B.V_Policy_No = C.V_Policy_No
       And C.V_Company_Code = D.V_Company_Code
       And C.V_Company_Branch = D.V_Company_Branch
      -- And C.V_POLICY_NO LIKE  'GL%'
       --and a.V_CLAIM_STATUS = E.V_STATUS_CODE
       And B.V_Event_Code = F.V_Event_Code
       And B.V_Claim_No = G.V_Claim_No(+)
       And B.N_Seq_No = G.N_Seq_No(+)
       And B.V_Plri_Code = H.V_Plan_Code
       And B.N_Amount_Payb > 0
       And B.V_Claim_No = I.V_Claim_No
       And B.N_Sub_Claim_No = I.N_Sub_Claim_No
       And I.V_Status_Code = E.V_Status_Code
       --And I.V_Status_Code in ( 'CLST04','CLST02','CLST01','CLST01','CLST02')
      -- And L.V_Prv_Status In ('CLST05', 'CLST06', 'CLST08', 'CLST09')
       And B.V_Claim_No = J.V_Claim_No
       And B.V_Event_Code = J.V_Event_Code
       --AND EXTRACT(YEAR FROM I.V_LASTUPD_INFTIM) >= 2023
--       AND TRUNC (I.V_LASTUPD_INFTIM) BETWEEN NVL ( :P_FM_DT, TRUNC (I.V_LASTUPD_INFTIM))  AND NVL (:P_TO_DT,TRUNC (I.V_LASTUPD_INFTIM))
--       AND D.V_COMPANY_CODE = NVL(:P_COMPANY_CODE,D.V_COMPANY_CODE)
--       AND F.V_EVENT_CODE = NVL(:P_EVENT_CODE,F.V_EVENT_CODE)