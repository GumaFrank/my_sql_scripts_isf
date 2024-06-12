/* Formatted on 19/12/2019 14:16:02 (QP5 v5.256.13226.35538) */
--AGEING DTH OUTSTANDING DETAILS
SELECT COUNT (DISTINCT V_POLICY_NO)
 FROM 
 (
SELECT V_Policy_No,
       Outstanding_Days,
       Claim_Prov,
       V_Plan_Code,
       V_Plan_Desc,
       CUSTOMER_ADDRESS,
       CUSTOMER_NAME
  FROM (SELECT A.V_Claim_No,
               D.V_Policy_No,
               G.V_Plan_Code,
               I.V_Plan_Desc,
               NVL (N_Amount_Payable, 0) Claim_Prov,
               NVL (N_Prov_Amount, 0) Bonus_Prov,
               D_Event_Date,
               D_Claim_Date,
               TRUNC (SYSDATE) - TRUNC (D_Claim_Date) Outstanding_Days,
               (SELECT V_ADD_ONE || ' ' || V_ADD_TWO ADDRESS
                  FROM GNDT_CUSTOMER_ADDRESS
                 WHERE N_CUST_REF_NO = G.N_CUST_REF_NO AND ROWNUM = 1)
                  CUSTOMER_ADDRESS,
               (SELECT V_NAME
                  FROM GNMT_CUSTOMER_MASTER
                 WHERE N_CUST_REF_NO = G.N_CUST_REF_NO AND ROWNUM = 1)
                  CUSTOMER_NAME
          FROM Clmt_Claim_Master A,
               Cllu_Type_Master B,
               Clmm_Status_Master C,
               Cldt_Claim_Event_Policy_Link D,
               Cldt_Provision_Master E,
               Cldt_Bonus_Provision F,
               Gnmt_Policy_Detail G,
               Gnmt_Policy P,
               (SELECT DISTINCT V_Claim_No, D_Event_Date
                  FROM Cldt_Claim_Event_Link) H,
               Gnmm_Plan_Master I
         WHERE     D.V_Claim_Type = B.V_Claim_Type(+)
               AND A.V_Claim_Status = C.V_Status_Code
               AND A.V_Claim_No = D.V_Claim_No
               AND D.V_Claim_No = E.V_Claim_No(+)
               AND D.N_Sub_Claim_No = E.N_Sub_Claim_No(+)
               AND D.V_Claim_No = F.V_Claim_No(+)
               AND D.N_Sub_Claim_No = F.N_Sub_Claim_No(+)
               AND D.V_Policy_No = G.V_Policy_No
               AND D.V_Policy_No = P.V_Policy_No
               AND D.N_Seq_No = G.N_Seq_No
               AND A.V_Claim_No = H.V_Claim_No
               AND G.V_Plan_Code = I.V_plan_code
               AND N_Amount_Payable > 0
               AND D.V_Policy_No NOT LIKE 'GL%'
               AND D.V_CLAIM_TYPE IN ('CLTP001')
               AND c.V_STATUS_CODE IN ('CLST01') 
               AND EXTRACT(YEAR FROM D_Claim_Date ) >= 2023--'CLST02',
               --AND D_Claim_Date <= '31-may-2017'))group by v_policy_no)--AND D_Claim_Date BETWEEN :From_Date AND :TO_DATE
--               AND TRUNC (NVL (D_Claim_Date, SYSDATE)) <=
--                      ( :P_AS_AT_DATE)
                      )
                      )