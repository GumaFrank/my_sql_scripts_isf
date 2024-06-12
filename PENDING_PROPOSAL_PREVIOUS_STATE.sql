/* Formatted on 09/03/2020 10:56:50 (QP5 v5.256.13226.35538) */
SELECT COUNT (DISTINCT V_POLICY_NO)  
 FROM 
(
SELECT V_Policy_No,
       V_Lastupd_User,
       Underwriten_By,
       V_Status_Desc,
       DECODE (Previous_Status, 'NB010', 'IN-FORCE', '-') Previous_Status,
       V_Name,
       Kra_Pin,
       Id_Passport,
       V_Contact_Number,
       D_Proposal_Submit,
       Total_Premium,
       NVL (N_Receipt_Amt, 0) N_Receipt_Amt,
       Total_Annual_Prem,
       N_Sum_Covered,
       Policy_Term,
       Prem_Pay_Term,
       V_Pymt_Desc,
       V_Pmt_Method_Name,
       V_Plan_Code,
       V_Plan_Name,
       SUBSTR (Agent, 1, INSTR (Agent, '-') - 1) Agent_Code,
       Agent,
       SUBSTR (Agent,
               INSTR (Agent, '-') + 1,
               INSTR (Agent, ' (') - INSTR (Agent, '-') + 1 - 2)
          Agent_Name,
       SUBSTR (Agent,
               INSTR (Agent, '(') + 1,
               INSTR (Agent, ')') - INSTR (Agent, '(') + 1 - 2)
          Agency,
       Unit_Sales_Manager,
       Agency_Sales_Manager,
       Regional_Sales_Manager,
       National_Sales_Manager,
       V_Uw_Decision,
       V_UW_REASON,
       V_Pending_Docs,
       Notepad
  FROM (SELECT A.D_Proposal_Submit,
               D_Issue,
               A.V_Policy_No,
               A.V_Lastupd_User,
               (SELECT V_lastupd_user
                  FROM Psmt_alteration Q
                 WHERE     Q.V_policy_no = A.V_policy_no
                       AND N_alteration_seq_no =
                              (SELECT MAX (N_alteration_seq_no)
                                         N_alteration_seq_no
                                 FROM Psmt_alteration R
                                WHERE R.V_policy_no = Q.V_policy_no))
                  Underwriten_By,
               V_Name,
               Jhl_Utils.Agent_Name (C.N_Agent_No) Agent,
               (SELECT Jhl_Utils.Agent_Name (
                          SUM (DECODE (N_Manager_Level, 30, N_Manager_No, 0)))
                          Usm
                  FROM Ammt_Agent_Hierarchy K
                 WHERE K.N_Agent_No = C.N_Agent_No AND V_Status = 'A')
                  Unit_Sales_Manager,
               (SELECT Jhl_Utils.Agent_Name (
                          SUM (DECODE (N_Manager_Level, 20, N_Manager_No, 0)))
                          Asm
                  FROM Ammt_Agent_Hierarchy K
                 WHERE K.N_Agent_No = C.N_Agent_No AND V_Status = 'A')
                  Agency_Sales_Manager,
               (SELECT Jhl_Utils.Agent_Name (
                          SUM (DECODE (N_Manager_Level, 15, N_Manager_No, 0)))
                          Rsm
                  FROM Ammt_Agent_Hierarchy K
                 WHERE K.N_Agent_No = C.N_Agent_No AND V_Status = 'A')
                  Regional_Sales_Manager,
               (SELECT Jhl_Utils.Agent_Name (
                          SUM (DECODE (N_Manager_Level, 10, N_Manager_No, 0)))
                          AS Nsm
                  FROM Ammt_Agent_Hierarchy K
                 WHERE K.N_Agent_No = C.N_Agent_No AND V_Status = 'A')
                  National_Sales_Manager,
               N_Sum_Covered,
               B.N_Term Policy_Term,
               B.N_Prem_Pay_Term Prem_Pay_Term,
               A.V_Pymt_Freq,
               V_Pymt_Desc,
               A.V_Pmt_Method_Code,
               V_Pmt_Method_Name,
               A.N_Contribution Total_Premium,
                 DECODE (
                    A.V_Pymt_Freq,
                    0, DECODE (
                          A.N_Contribution,
                          0, 1,
                          (A.N_Contribution / B.N_Term) / A.N_Contribution),
                    12 / A.V_Pymt_Freq)
               * A.N_Contribution
                  Total_Annual_Prem,
               N_Ind_Basic_Prem Basic_Premium,
                 DECODE (A.V_Pymt_Freq, 0, 1, 12 / A.V_Pymt_Freq)
               * B.N_Ind_Basic_Prem
                  Basic_Annual_Prem,
               Jhl_Utils.Rider_Premium (A.V_Policy_No) Rider_Premium,
               A.V_Cntr_Stat_Code,
               G.V_Status_Desc,
               V_Uw_Decision,
               jhl_gen_pkg.get_policy_requirement (A.V_Policy_No) V_UW_REASON,
               Jhl_Utils.Pending_Docs (A.V_Policy_No) V_Pending_Docs,
               (SELECT SUM (N_Receipt_Amt)
                  FROM Remt_Receipt
                 WHERE     V_Policy_No = A.V_Policy_No
                       AND V_Receipt_Table = 'DETAIL'
                       AND V_Receipt_Status = 'RE001'
                       AND V_Receipt_Code IN ('RCT002', 'RCT003'))
                  N_Receipt_Amt,
               (SELECT V_Iden_No
                  FROM Gndt_Customer_Identification
                 WHERE     V_Iden_Code = 'PIN'
                       AND N_Cust_Ref_No = A.N_Payer_Ref_No
                       AND ROWNUM = 1)
                  Kra_Pin,
               (SELECT V_Iden_No
                  FROM Gndt_Customer_Identification
                 WHERE     V_Iden_Code IN ('NIC', 'PP')
                       AND N_Cust_Ref_No = A.N_Payer_Ref_No
                       AND ROWNUM = 1)
                  Id_Passport,
               A.V_Plan_Code,
               V_Plan_Name,
               (SELECT V_Contact_Number
                  FROM Gndt_Custmobile_Contacts
                 WHERE     N_Cust_Ref_No = A.N_Payer_Ref_No
                       AND V_Contact_Number NOT LIKE '%@%'
                       AND V_Status = 'A'
                       AND ROWNUM = 1)
                  V_Contact_Number,
               (SELECT N.V_Prev_Stat_Code
                  FROM Gn_Contract_Status_Log N
                 WHERE     N.V_Policy_No = A.V_Policy_No
                       AND N.V_Plri_Code = A.V_Plan_Code
                       AND V_Prev_Stat_Code LIKE ('NB010')
                       AND ROWNUM = 1)
                  Previous_Status,
               (SELECT RTRIM (
                          XMLAGG (
                             XMLELEMENT (
                                e,
                                   DBMS_LOB.SUBSTR (v_note_message, 4000, 1)
                                || ';')).EXTRACT ('//text()'),
                          ',')
                  FROM PSDT_POLICY_NOTEPAD i
                 WHERE i.v_policy_no = A.v_policy_no)
                  Notepad
          FROM Gnmt_Policy A,
               Gnmt_Policy_Detail B,
               Ammt_Pol_Ag_Comm C,
               Gnlu_Pay_Method D,
               Gnlu_Frequency_Master E,
               Gnmm_Policy_Status_Master G,
               Gnmm_Plan_Master H
         WHERE     A.V_Policy_No = B.V_Policy_No
               AND A.V_Policy_No = C.V_Policy_No
               AND A.V_Pmt_Method_Code = D.V_Pmt_Method_Code
               AND A.V_Plan_Code = H.V_Plan_Code
               AND A.V_Pymt_Freq = E.V_Pymt_Freq
               AND V_Role_Code = 'SELLING'
               AND C.V_Status = 'A'
               AND A.V_Policy_No NOT LIKE 'GL%'
              -- AND A.D_PROPOSAL_SUBMIT BETWEEN ( :P_FM_DT) AND ( :P_TO_DT)
               --AND A.D_PROPOSAL_DATE between '01-JAN-2016' and '15-JAN-2016'
               --AND a.V_POLICY_NO = f.V_POLICY_NO(+)
               AND A.V_Cntr_Stat_Code = G.V_Status_Code
               AND A.V_Policy_No NOT IN (SELECT V_policy_no
                                           FROM Gnmt_policy X
                                          WHERE     X.V_policy_no =
                                                       A.V_policy_no
                                                AND V_plan_code IN ('BSANN01',
                                                                    'BANY001',
                                                                    'BCEDANPT'))
               --AND NVL(D_ISSUE,'01-JAN-1900') = '01-JAN-1900'
               AND A.V_Cntr_Stat_Code IN ('NB054',
                                          'NB099',
                                          'NB099-Y',
                                          'NB001',
                                          'NB058',
                                          'NB099-N',
                                          'NB053',
                                          'NB006',
                                          'NB002',
                                          'NB104',
                                          'NB004',
                                          'NB064') --AND a.V_CNTR_STAT_CODE = 'NB053'
             --  AND EXTRACT(YEAR FROM A.D_PROPOSAL_DATE) >=2023                                  )
-- WHERE TRIM (
--          UPPER (
--             SUBSTR (Agent,
--                     INSTR (Agent, '(') + 1,
--                     INSTR (Agent, ')') - INSTR (Agent, '(') + 1 - 2))) IN ( :P_AGENCY)
--WHERE TRIM(UPPER(SUBSTR(AGENT, INSTR(AGENT,'(')+1, INSTR(AGENT,')')-INSTR(AGENT,'(')+1-2))) = 'DSU'

)   WHERE TO_CHAR(D_Proposal_Submit, 'MON-YY') = 'DEC-23')