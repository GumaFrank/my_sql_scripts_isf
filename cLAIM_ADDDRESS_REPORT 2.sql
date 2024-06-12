/* Formatted on 26/01/2019 22:49:01 (QP5 v5.256.13226.35538) */

SELECT COUNT(V_CLAIM_NO) FROM 
(
SELECT A.V_Claim_No,
       D.V_Policy_No,
       V_Name,
       (SELECT V_Add_One
          FROM Gndt_Customer_Address B, Gnmt_Policy D
         WHERE     B.N_Cust_Ref_No = G.N_Cust_Ref_No
               AND D.V_Policy_No = G.V_Policy_No
               AND D.N_Add_Seq_No = B.N_Add_Seq_No
               AND D.V_Add_Code = B.V_Add_Code
        UNION
        SELECT H.V_Add_One
          FROM Gndt_Company_Address H, Gnmm_Company_Master B
         WHERE     H.V_Company_Code = B.V_Company_Code
               AND H.V_Company_Branch = B.V_Company_Branch
               AND H.V_Company_Code = G.V_Company_Code
               AND H.V_Company_Branch = G.V_Company_Branch
               AND G.V_Policy_No LIKE '%GL%')
          Address_One,
       (SELECT V_Add_Two
          FROM Gndt_Customer_Address B, Gnmt_Policy D
         WHERE     B.N_Cust_Ref_No = G.N_Cust_Ref_No
               AND D.V_Policy_No = G.V_Policy_No
               AND D.N_Add_Seq_No = B.N_Add_Seq_No
               AND D.V_Add_Code = B.V_Add_Code
        UNION
        SELECT H.V_Add_Two
          FROM Gndt_Company_Address H, Gnmm_Company_Master B
         WHERE     H.V_Company_Code = B.V_Company_Code
               AND H.V_Company_Branch = B.V_Company_Branch
               AND H.V_Company_Code = G.V_Company_Code
               AND H.V_Company_Branch = G.V_Company_Branch
               AND G.V_Policy_No LIKE '%GL%')
          Address_Two,
       (SELECT V_Post_Box
          FROM Gndt_Customer_Address B, Gnmt_Policy D
         WHERE     B.N_Cust_Ref_No = G.N_Cust_Ref_No
               AND D.V_Policy_No = G.V_Policy_No
               AND D.N_Add_Seq_No = B.N_Add_Seq_No
               AND D.V_Add_Code = B.V_Add_Code
        UNION
        SELECT H.V_Post_Box
          FROM Gndt_Company_Address H, Gnmm_Company_Master B
         WHERE     H.V_Company_Code = B.V_Company_Code
               AND H.V_Company_Branch = B.V_Company_Branch
               AND H.V_Company_Code = G.V_Company_Code
               AND H.V_Company_Branch = G.V_Company_Branch
               AND G.V_Policy_No LIKE '%GL%')
          Post_Box,
       (SELECT V_Postcode
          FROM Gndt_Customer_Address B, Gnmt_Policy D
         WHERE     B.N_Cust_Ref_No = G.N_Cust_Ref_No
               AND D.V_Policy_No = G.V_Policy_No
               AND D.N_Add_Seq_No = B.N_Add_Seq_No
               AND D.V_Add_Code = B.V_Add_Code
        UNION
        SELECT H.V_Postcode
          FROM Gndt_Company_Address H, Gnmm_Company_Master B
         WHERE     H.V_Company_Code = B.V_Company_Code
               AND H.V_Company_Branch = B.V_Company_Branch
               AND H.V_Company_Code = G.V_Company_Code
               AND H.V_Company_Branch = G.V_Company_Branch
               AND G.V_Policy_No LIKE '%GL%')
          Postcode,
       (SELECT V_Town
          FROM Gndt_Customer_Address B, Gnmt_Policy D
         WHERE     B.N_Cust_Ref_No = G.N_Cust_Ref_No
               AND D.V_Policy_No = G.V_Policy_No
               AND D.N_Add_Seq_No = B.N_Add_Seq_No
               AND D.V_Add_Code = B.V_Add_Code
        UNION
        SELECT H.V_Town
          FROM Gndt_Company_Address H, Gnmm_Company_Master B
         WHERE     H.V_Company_Code = B.V_Company_Code
               AND H.V_Company_Branch = B.V_Company_Branch
               AND H.V_Company_Code = G.V_Company_Code
               AND H.V_Company_Branch = G.V_Company_Branch
               AND G.V_Policy_No LIKE '%GL%')
          Town,
       (SELECT Q.V_Contact_Number
          FROM Gndt_Custmobile_Contacts Q, Gnmt_Policy Z
         WHERE     Q.N_Cust_Ref_No = G.N_Cust_Ref_No
               AND Z.V_Policy_No = G.V_Policy_No
               AND Z.N_Payer_Ref_No = Q.N_Cust_Ref_No
               AND Q.V_Contact_Number NOT LIKE '%@%'
               AND ROWNUM = 1
        UNION
        SELECT H.V_Contact_Number
          FROM Gndt_Compmobile_Contacts H, Gnmm_Company_Master B
         WHERE     H.V_Company_Code = B.V_Company_Code
               AND H.V_Company_Branch = B.V_Company_Branch
               AND H.V_Company_Code = G.V_Company_Code
               AND H.V_Company_Branch = G.V_Company_Branch
               AND H.V_Contact_Number NOT LIKE '%@%'
               AND ROWNUM = 1)
          Telephone_No,
       (SELECT Q.V_Contact_Number
          FROM Gndt_Custmobile_Contacts Q, Gnmt_Policy Z
         WHERE     Q.N_Cust_Ref_No = G.N_Cust_Ref_No
               AND Z.V_Policy_No = G.V_Policy_No
               AND Z.N_Payer_Ref_No = Q.N_Cust_Ref_No
               AND Q.V_Contact_Number LIKE '%@%'
               AND ROWNUM = 1
        UNION
        SELECT H.V_Contact_Number
          FROM Gndt_Compmobile_Contacts H, Gnmm_Company_Master B
         WHERE     H.V_Company_Code = B.V_Company_Code
               AND H.V_Company_Branch = B.V_Company_Branch
               AND H.V_Company_Code = G.V_Company_Code
               AND H.V_Company_Branch = G.V_Company_Branch
               AND H.V_Contact_Number LIKE '%@%'
               AND ROWNUM = 1)
          Email_Address,
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
       NVL (N_Amount_Payable, 0) Claim_Prov,
       NVL (N_Prov_Amount, 0) Bonus_Prov,
       NVL (Gross_Paid, 0) Gross_Paid,
         NVL (N_Amount_Payable, 0)
       + NVL (N_Prov_Amount, 0)
       - NVL (Gross_Paid, 0)
          Claim_Os,
       D_Event_Date,
       D_Claim_Date,
       A.V_Lastupd_User,
       V_Client_Name,
       DECODE (N_Vou_Amount, NULL, NULL, A.D_Lastupd_Inftim) D_Vou_Date,
       N_Vou_Amount,
       JHL_GEN_PKG.Agent_Name6 (D.V_Policy_No) Agent_Name,
       JHL_GEN_PKG.Agent_Name5 (D.V_Policy_No) Agent_Contact_Number,
       JHL_GEN_PKG.Agent_Name7 (D.V_Policy_No) Agent_Email_Address,
  (SELECT ST.V_STATUS_DESC
  FROM Gnmt_Policy POL, GNMM_POLICY_STATUS_MASTER ST
  WHERE POL.V_CNTR_STAT_CODE = ST.V_STATUS_CODE 
  AND POL.V_Policy_No = G.V_Policy_No )  POLICY_STATUS
  FROM Clmt_Claim_Master A,
       Cllu_Type_Master B,
       Clmm_Status_Master C,
       Cldt_Claim_Event_Policy_Link D,
       Cldt_Provision_Master E,
       Cldt_Bonus_Provision F,
       Gnmt_Policy_Detail G,
       (SELECT DISTINCT V_Claim_No, D_Event_Date FROM Cldt_Claim_Event_Link)
       H,
       (  SELECT V_Source_Ref_No,
                 NULL V_Vou_No,
                 NULL V_Main_Vou_No,
                 V_Vou_Source,
                 NULL D_Vou_Date,
                 SUM (N_Vou_Amount) N_Vou_Amount,
                 NULL V_Chq_No,
                 NULL V_Payee_Name
            FROM Pymt_Voucher_Root A, Pymt_Vou_Master B
           WHERE A.V_Main_Vou_No = B.V_Main_Vou_No AND V_Vou_Source = 'CLAIMS'
        GROUP BY V_Source_Ref_No, V_Vou_Source) I,
       (  SELECT V_Claim_No, SUM (N_Claimant_Amount) Gross_Paid
            FROM Cldt_Claimant_Master
        GROUP BY V_Claim_No) J
 WHERE     D.V_Claim_Type = B.V_Claim_Type(+)
       AND A.V_Claim_Status = C.V_Status_Code
       AND A.V_Claim_No = D.V_Claim_No
       AND D.V_Claim_No = E.V_Claim_No(+)
       AND D.N_Sub_Claim_No = E.N_Sub_Claim_No(+)
       AND D.V_Claim_No = F.V_Claim_No(+)
       AND D.N_Sub_Claim_No = F.N_Sub_Claim_No(+)
       AND D.V_Policy_No = G.V_Policy_No
       AND D.N_Seq_No = G.N_Seq_No
       AND A.V_Claim_No = H.V_Claim_No
       AND A.V_Claim_No = I.V_Source_Ref_No(+)
       AND A.V_Claim_No = J.V_Claim_No(+)
--       AND TRUNC (D_Event_Date) BETWEEN NVL ( :P_FM_DT, TRUNC (D_Event_Date))
--                                    AND NVL ( :P_TO_DT, TRUNC (D_Event_Date))
--       AND (   (1 = DECODE ( :P_CLAIM_TYPE, NULL, 1, 0))
--            OR D.V_CLAIM_TYPE IN ( :P_CLAIM_TYPE))
     --  AND EXTRACT(YEAR FROM D_Event_Date) >= 2023
       AND TO_CHAR(D_Event_Date, 'MON-YY') = 'JAN-23'
       )