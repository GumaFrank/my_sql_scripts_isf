SELECT V_NAME Client_Name,
       B.V_POLICY_NO Policy_No,
       D_RECEIPT_DATE Allocation_Date,
       N_RECEIPT_AMT Allocation_Amount, 
       SUM (N_RECEIPT_AMT) Total_Allocation_Amount
  FROM GNMT_CUSTOMER_MASTER T, GNMT_POLICY B, REMT_RECEIPT RCT
 WHERE T.N_CUST_REF_NO = B.N_PAYER_REF_NO 
 AND B.V_POLICY_NO = RCT.V_POLICY_NO
 --AND EXTRACT(YEAR FROM D_RECEIPT_DATE) >= 2023
 AND TRUNC (D_RECEIPT_DATE) BETWEEN :P_FROM_DT AND :P_TO_DT
 Group By B.V_POLICY_NO, V_NAME,N_RECEIPT_AMT,D_RECEIPT_DATE
 Order by B.V_POLICY_NO, Allocation_Date desc

--GNMT_POLICY, GNMM_COMPANY_MASTER