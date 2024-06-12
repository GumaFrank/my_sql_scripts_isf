/* Formatted on 04/02/2020 11:09:25 (QP5 v5.256.13226.35538) */

SELECT * 
FROM 
(
SELECT A.V_Agent_Code,
       B.V_Name,
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 30, N_Manager_No, 0)))
                  Usm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = A.N_Agent_No AND V_Status = 'A')
          Unit_Sales_Manager,
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 20, N_Manager_No, 0)))
                  Asm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = A.N_Agent_No AND V_Status = 'A')
          Agency_Sales_Manager,
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 15, N_Manager_No, 0)))
                  Rsm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = A.N_Agent_No AND V_Status = 'A')
          Regional_Sales_Manager,
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 10, N_Manager_No, 0)))
                  AS Nsm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = A.N_Agent_No AND V_Status = 'A')
          National_Sales_Manager,
       --A.V_Status,
       (SELECT W.V_Agent_Status_Desc
          FROM Ammm_Agent_Status W
         WHERE W.V_Agent_Status_Code = A.V_Status)
          Agent_Status_Desc,
       D.V_Iden_No,
       B.D_Birth_Date,
       B.V_Marital_Status,
       B.V_Sex,
       -- (C.V_Iden_No) Pin,
       -- (E.V_Contact_Number) Email,
       -- (F.V_Contact_Number) Contact,
       A.D_Appointment,
       A.D_Termination
  FROM Ammm_Agent_Master A,
       Gnmt_Customer_Master B,
       --  Gndt_Customer_Identification C,
       Gndt_Customer_Identification D,
       -- Gndt_Custmobile_Contacts E,
       -- Gndt_Custmobile_Contacts F,
       Ammm_Agent_Master G,
       Gnmt_Customer_Master H
 WHERE     A.N_Cust_Ref_No = B.N_Cust_Ref_No
       --AND a.V_AGENT_CODE = '3082'
       -- And A.N_Cust_Ref_No = C.N_Cust_Ref_No(+)
       --  And C.V_Iden_No(+) Like 'A%'
       AND A.N_Cust_Ref_No = D.N_Cust_Ref_No(+)
       AND D.V_Iden_Code(+) = 'NIC'
       --  And A.N_Cust_Ref_No = E.N_Cust_Ref_No(+)
       -- And E.V_Contact_Number(+) Like '%@%'
       --  And A.N_Cust_Ref_No = F.N_Cust_Ref_No(+)
       --  And F.V_Contact_Number(+) Like '0%'
       AND A.N_Currently_Reporting_To = G.N_Agent_No(+)
       AND G.N_Cust_Ref_No = H.N_Cust_Ref_No(+)
       --and h.N_CUST_REF_NO is not null
       --AND a.D_APPOINTMENT BETWEEN :PDATE1 AND :PDATE2
       --AND (A.D_Appointment) BETWEEN ( :P_FromDate) AND ( :P_ToDate)
UNION
SELECT A.V_Agent_Code,
       B.V_Name,
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 30, N_Manager_No, 0)))
                  Usm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = A.N_Agent_No AND V_Status = 'A')
          Unit_Sales_Manager,
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 20, N_Manager_No, 0)))
                  Asm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = A.N_Agent_No AND V_Status = 'A')
          Agency_Sales_Manager,
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 15, N_Manager_No, 0)))
                  Rsm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = A.N_Agent_No AND V_Status = 'A')
          Regional_Sales_Manager,
       (SELECT Jhl_Utils.Agent_Name (
                  SUM (DECODE (N_Manager_Level, 10, N_Manager_No, 0)))
                  AS Nsm
          FROM Ammt_Agent_Hierarchy K
         WHERE K.N_Agent_No = A.N_Agent_No AND V_Status = 'A')
          National_Sales_Manager,
       --A.V_Status,
       (SELECT W.V_Agent_Status_Desc
          FROM Ammm_Agent_Status W
         WHERE W.V_Agent_Status_Code = A.V_Status)
          Agent_Status_Desc,
       D.V_Iden_No,
       B.D_Birth_Date,
       B.V_Marital_Status,
       B.V_Sex,
       --  (C.V_Iden_No) Pin,
       --  (E.V_Contact_Number) Email,
       --  (F.V_Contact_Number) Contact,
       A.D_Appointment,
       A.D_Termination
  FROM Ammm_Agent_Master A,
       Gnmt_Customer_Master B,
       --  Gndt_Customer_Identification C,
       Gndt_Customer_Identification D,
       --  Gndt_Custmobile_Contacts E,
       --  Gndt_Custmobile_Contacts F,
       Ammm_Agent_Master G,
       Gnmm_Company_Master H
 WHERE     A.N_Cust_Ref_No = B.N_Cust_Ref_No
       -- AND a.V_AGENT_CODE = '3082'
       --  And A.N_Cust_Ref_No = C.N_Cust_Ref_No(+)
       --  And C.V_Iden_No(+) Like 'A%'
       AND A.N_Cust_Ref_No = D.N_Cust_Ref_No(+)
       AND D.V_Iden_Code(+) = 'NIC'
       --  And A.N_Cust_Ref_No = E.N_Cust_Ref_No(+)
       --  And E.V_Contact_Number(+) Like '%@%'
       --  And A.N_Cust_Ref_No = F.N_Cust_Ref_No
       --  And F.V_Contact_Number(+) Like '0%'
       AND A.N_Currently_Reporting_To = G.N_Agent_No
       AND G.V_Company_Code = H.V_Company_Code
       AND G.V_Company_Branch = H.V_Company_Branch
       AND G.V_Company_Code IS NOT NULL
       AND G.V_Company_Branch IS NOT NULL
       --AND a.D_APPOINTMENT BETWEEN :PDATE1 AND :PDATE2
       --AND (A.D_Appointment) BETWEEN ( :P_FromDate) AND ( :P_ToDate)
       AND EXTRACT(YEAR FROM A.D_Appointment) = '2023')
       
       where AGENT_STATUS_DESC = 'Active'