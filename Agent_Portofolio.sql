
/* Formatted on 23/12/2019 15:50:42 (QP5 v5.256.13226.35538) */
SELECT DISTINCT
       A.V_Policy_No,
       (SELECT V_Name
          FROM Gnmt_Customer_Master X
         WHERE X.N_Cust_Ref_No = A.N_Payer_Ref_No)
          Policy_Owner,
       (SELECT v_contact_number
          FROM gndt_custmobile_contacts
         WHERE     n_cust_ref_no = A.n_payer_ref_no
               AND v_contact_number NOT LIKE '%@%'
               AND v_status = 'A'
               AND ROWNUM = 1)
          v_contact_number,
       D.V_Agent_Code,
       B.V_Name,
       A.N_Contribution Contribution,
       P.V_Plan_Code,
       DECODE (n.N_WOP_APPROVED_AMOUNT, NULL, 'NO', 'YES') WOP_CLAIM,
       A.D_Commencement,
       A.D_prem_due_date,
       A.D_Policy_End_Date,
       K.V_Status_Desc
  FROM Gnmt_Policy A,
       Gnmt_Customer_Master B,
       Ammt_Pol_Ag_Comm C,
       Ammm_Agent_Master D,
       Gnmt_Policy_Detail P,
       Gnmm_Policy_Status_Master K,
       GNMT_WOP_ACCOUNT n
 WHERE     A.V_Cntr_Stat_Code = K.V_Status_Code
       AND A.V_Policy_No = C.V_Policy_No
       AND D.N_Cust_Ref_No = B.N_Cust_Ref_No
       AND C.V_Role_Code = 'SELLING'
       AND C.N_Agent_No = D.N_Agent_No
       AND A.V_Policy_No = P.V_Policy_No
       AND P.V_POLICY_NO = n.V_POLICY_NO(+)
       AND P.N_SEQ_NO = n.N_SEQ_NO(+)
       AND EXTRACT(YEAR FROM A.D_Commencement)>=2023
       -- AND P.V_Cntr_Stat_Code = 'NB010'
       --AND D.V_Agent_Code in (:P_Agent)