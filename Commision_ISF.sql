/*
Author Frank bagambe
Desc  All commission
*/

SELECT 
  V_POLICY_NO, 
  V_PROPOSER_NAME, 
  AGENT_NO, 
  (
    SELECT 
      V_AGENT_NAME 
    FROM 
      V_AGENT_MASTER 
    WHERE 
      N_AGENT_NO = AGENT_NO
  ) AGENT_NAME, 
  (
    SELECT 
      V_AGENT_CODE 
    FROM 
      V_AGENT_MASTER 
    WHERE 
      N_AGENT_NO = AGENT_NO
  ) AGENT_CODE, 
  D_COMM_GEN, 
  D_RECEIPT, 
  N_COMM_AMT, 
  V_COMM_STATUS, 
  N_COMM_YEAR, 
  V_RECEIPT_NO, 
  V_EARNED_RANK 
FROM 
  (
    select 
      DISTINCT A.V_POLICY_NO, 
      D.V_PROPOSER_NAME, 
      A.N_AGENT_NO AS AGENT_NO, 
      A.D_COMM_GEN, 
      A.D_RECEIPT, 
      A.N_COMM_AMT, 
      A.V_COMM_STATUS, 
      A.N_COMM_YEAR, 
      A.V_RECEIPT_NO, 
      A.V_EARNED_RANK 
    from 
      AMMT_POL_COMM_DETAIL A, 
      GNMT_POLICY D 
    where 
      TO_DATE(D_COMM_GEN, 'DD/MM/RRRR') BETWEEN TO_DATE('01-DEC-23', 'DD/MM/RRRR') 
      AND TO_DATE('31-DEC-23', 'DD/MM/RRRR') 
      AND V_COMM_STATUS = 'P' 
      AND D.V_POLICY_NO = A.V_POLICY_NO
  )
