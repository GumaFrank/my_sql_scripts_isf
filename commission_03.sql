SELECT  distinct
a.V_POLICY_NO,
a.N_AGENT_NO,
a.D_COMM_GEN,
a.N_PREM_AMT,
a.D_RECEIPT,
a.V_RECEIPT_NO,
a.N_COMM_AMT,
a.N_COMM_YEAR,
a.V_COMM_STATUS,
a.V_EARNED_RANK,
b.V_TRANS_SOURCE_CODE,
b.V_REMARKS,
c.N_GROSS_AMOUNT,
c.N_NET_PAID,
c.N_VOUCHER_NO
FROM Ammt_Pol_Comm_Detail a
JOIN Amdt_Agent_Benefit_Pool_Detail b
  ON a.N_AGENT_NO = b.N_AGENT_NO
JOIN Amdt_Agent_Bene_Pool_Payment c
  ON a.N_AGENT_NO = c.N_AGENT_NO
 and a.D_COMM_GEN between '10-JAN-2024' AND '06-FEB-2024' 
 order by 3 desc