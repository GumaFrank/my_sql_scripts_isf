SELECT A.V_Policy_No,
       F.V_Name Policy_Owner,
       N_Payer_Ref_No AS Cust_Ref_No,
       (SELECT V_Iden_No
          FROM Gndt_Customer_Identification K
         WHERE     V_Iden_Code = 'NIC'
               AND N_Cust_Ref_No = A.N_Payer_Ref_No
               AND ROWNUM = 1)
          National_Id,
       V_Pmt_Method_Name,
       N_Ind_Basic_Prem Basic_Premium,
       A.D_Prem_Due_Date,
       A.D_Next_Out_Date,
       A.D_Commencement,
       A.D_Policy_End_Date,
       (SELECT V_Lastupd_Inftim
          FROM Psmt_Non_Payment_Termination L
         WHERE A.V_Policy_No = L.V_Policy_No AND ROWNUM = 1)
          System_Lapse_Date,
       A.N_Sum_Covered,
       A.N_Contribution,
       (SELECT N_Amount
          FROM Ppmt_Overshort_Payment F
         WHERE A.V_Policy_No = F.V_Policy_No)
          Amount_In_Pd,
       A.V_Pymt_Freq,
       A.V_Cntr_Stat_Code,
       A.V_Cntr_Prem_Stat_Code,
       V_Status_Desc V_Curr_Status,
       Jhl_Utils.Agent_Name (C.N_Agent_No) Agent_Agency,
       (SELECT V_Contact_Number
          FROM Gndt_Custmobile_Contacts
         WHERE     N_Cust_Ref_No = N_Payer_Ref_No
               AND V_Contact_Number NOT LIKE '%@%'
               AND V_Status = 'A'
               AND ROWNUM = 1)
          V_Contact_Number,
       (SELECT Q.V_Contact_Number
          FROM Gndt_Custmobile_Contacts Q
         WHERE     A.N_Payer_Ref_No = Q.N_Cust_Ref_No
               AND Q.V_Contact_Number LIKE '%@%'
               AND ROWNUM = 1)
          Email,
       (SELECT V_Add_One
          FROM Gndt_Customer_Address R
         WHERE     R.N_Cust_Ref_No = A.N_Payer_Ref_No
               AND A.N_Add_Seq_No = R.N_Add_Seq_No
               AND A.V_Add_Code = R.V_Add_Code)
          Address_One,
       (SELECT V_Add_Two
          FROM Gndt_Customer_Address R
         WHERE     R.N_Cust_Ref_No = A.N_Payer_Ref_No
               AND A.N_Add_Seq_No = R.N_Add_Seq_No
               AND A.V_Add_Code = R.V_Add_Code)
          Address_Two,
       (SELECT Jhl_Utils.
           Agent_Name (
           SUM (DECODE (N_Manager_Level, 30, N_Manager_No, 0)))
           Usm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = C.N_Agent_No AND V_Status = 'A')
          Unit_Sales_Manager,
       (SELECT Jhl_Utils.
          Agent_Name (
          SUM (DECODE (N_Manager_Level, 20, N_Manager_No, 0)))
           Asm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = C.N_Agent_No AND V_Status = 'A')
          Agency_Sales_Manager,
       (SELECT Jhl_Utils.
         Agent_Name (
         SUM (DECODE (N_Manager_Level, 15, N_Manager_No, 0)))
         Rsm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = C.N_Agent_No AND V_Status = 'A')
          Regional_Sales_Manager,
       (SELECT Jhl_Utils.
         Agent_Name (
          SUM (DECODE (N_Manager_Level, 10, N_Manager_No, 0)))
           AS Nsm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = C.N_Agent_No AND V_Status = 'A')
          National_Sales_Manager
  FROM Gnmt_Policy A,
       Gnmt_Policy_Detail B,
       Ammt_Pol_Ag_Comm C,
       Gnlu_Pay_Method D,
       Gnlu_Frequency_Master E,
       Gnmt_Customer_Master F,
       Gnmm_Policy_Status_Master G,
       Gnmm_Plan_Master H,
       Ammm_Agent_Master V
 WHERE     A.V_Policy_No = B.V_Policy_No
       AND A.V_Policy_No = C.V_Policy_No
       AND A.V_Pmt_Method_Code = D.V_Pmt_Method_Code
       AND A.V_Pymt_Freq = E.V_Pymt_Freq
       AND V_Role_Code = 'SELLING'
       AND C.V_Status = 'A'
       AND A.V_Policy_No NOT LIKE 'GL%'
       AND A.N_Payer_Ref_No = F.N_Cust_Ref_No
       AND A.V_Cntr_Stat_Code = G.V_Status_Code
       AND A.V_Plan_Code = H.V_Plan_Code
       AND A.V_Cntr_Stat_Code = 'NB010'
       --AND S.V_COMPANY_CODE =  'MX100'
       AND C.N_Agent_No = V.N_Agent_No
      -- AND TRUNC (D_Policy_End_Date) BETWEEN :From_Date AND :TO_DATE
       And Trunc (D_Policy_End_Date) BETWEEN :P_FROM_DATE
                                          AND :P_TO_DATE