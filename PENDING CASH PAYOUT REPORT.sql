
-- PENDING CASH PAYOUT REPORT

SELECT  COUNT (DISTINCT V_POLICY_NO ) 
FROM
(
SELECT A.V_Policy_No,
       V_Name,
       G.V_CONTACT_NUMBER PHONE_NUMBER,
       D_Cntr_Start_Date,
       D_Cntr_End_Date,
       D_Survival_Date,
       D.N_Contribution,
       D.N_Term,
       D.V_Plan_Code,
       D.N_Seq_No,
       D_Ind_Dob,
       N_Ind_Sa,
       DECODE (V_Survival_Status, 'NP', 'UN-PAID', 'PAID') Status,
       V_STATUS_DESC POLICY_STATUS, 
       
       A.N_TOT_SURVIVAL_AMT GROSS_SURVIVAL_AMT, 
       null APL_INTEREST_DEDUCTED,  null   LOAN_INTEREST_DEDUCTED, 
       N_NET_SURVIVAL_AMT,
       
(SELECT MAX(E.V_VOU_NO)
FROM PYDT_VOUCHER_POLICY_CLIENT E, PYMT_VOU_MASTER F, Pymt_Voucher_Root PM
WHERE  E.V_VOU_NO = F.V_VOU_NO
AND F.V_MAIN_VOU_NO = PM.V_MAIN_VOU_NO
AND V_VOU_DESC = 'CASH PAYMENT'
AND E.v_policy_no =  A.V_Policy_No) VOUCHER_NUMBER

  FROM Psmt_Policy_Survival A, Gnmt_Policy_Detail D, gnmt_policy c,  GNMM_POLICY_STATUS_MASTER STATUS,GNDT_CUSTMOBILE_CONTACTS G
 WHERE     A.V_Policy_No = D.V_Policy_No
       AND A.N_Seq_No = D.N_Seq_No
       and d.v_policy_no = c.v_policy_no
       AND G.N_CUST_REF_NO=D.N_CUST_REF_NO
        AND C.V_CNTR_STAT_CODE = STATUS.V_STATUS_CODE
       AND V_Survival_Status = 'P'
--       AND d.v_policy_no =  'IL201200038340'
--       AND trunc(D_Survival_Date) BETWEEN  to_date(:FD,'DD/MM/RRRR') AND to_date(:TD,'DD/MM/RRRR')
       --AND D_Survival_Date BETWEEN :P_FROM_DATE 
       --                   AND :P_TO_DATE
     --  AND EXTRACT(YEAR FROM  D_Cntr_Start_Date) >= 2023
     
     )
     WHERE TRUNC(D_Survival_Date) BETWEEN '01-JAN-2023' AND '31-JAN-2023'