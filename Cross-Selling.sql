/* Formatted on 23/12/2019 11:44:13 (QP5 v5.256.13226.35538) */
SELECT B.V_Agent_Code,
       C.V_Name Agent_Name,
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 30, N_Manager_No, 0)))
                  Usm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = B.N_Agent_No AND V_Status = 'A')
          Unit_Manager,
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 20, N_Manager_No, 0)))
                  Asm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = B.N_Agent_No AND V_Status = 'A')
          Agency_Manager,
       A.V_Policy_No,
       M.D_Proposal_Date,
       A.V_Name Policy_Name,
       D_Issue_Date,
       H.V_Status_Desc Policy_Status,
       F.V_Agent_Code Selling_Agent_Code,
       G.V_Name Selling_Agent_Name,
      dd.v_plan_name,
      D.V_Role_Code,
     D.V_Overriding, 
        D.V_Status, 
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 30, N_Manager_No, 0)))
                  Usm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = D.N_Agent_No AND V_Status = 'A')
          Selling_Unit_Manager,
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 20, N_Manager_No, 0)))
                  Asm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = D.N_Agent_No AND V_Status = 'A')
          Selling_Agency_Manager
  FROM Ammm_Agent_Master B,
       Gnmt_Policy_Detail A,
       Gnmt_Customer_Master C,
       Ammt_Pol_Ag_Comm D,
       Ammm_Agent_Master F,
       Gnmt_Customer_Master G,
       Gnmm_Policy_Status_Master H,
       gnmm_plan_master          dd,
      Gnmt_Policy M
 WHERE     B.N_Cust_Ref_No = A.N_Cust_Ref_No
       AND A.V_Policy_No LIKE 'UI%'
       --and a.v_policy_no='IL201200031196'
       AND A.V_Cntr_Stat_Code = H.V_Status_Code
       AND B.N_Cust_Ref_No = C.N_Cust_Ref_No
       AND A.V_Policy_No = D.V_Policy_No
      --AND D.V_Role_Code = 'SELLING'
    -- AND D.V_Overriding = 'N'
       --AND D.V_Status = 'A'
       AND D.N_Agent_No = F.N_Agent_No
       AND B.N_Agent_No <> F.N_Agent_No
       AND F.N_Cust_Ref_No = G.N_Cust_Ref_No
       AND A.V_Policy_No = M.V_Policy_No
        AND A.v_plan_code = dd.v_plan_code
       AND EXTRACT(YEAR FROM M.D_Proposal_Date )=2023
      -- AND TRUNC (M.D_Proposal_Date) BETWEEN ( :P_FromDate) AND ( :P_ToDate)