
/*
Author Guma Frank Bagambe
Date 05-FEB-2024
Description  Checking Paid and Unpaid  Commission in ISF  
*/
SELECT * FROM 

(
SELECT 
  (
    SELECT 
      V_AGENT_CODE 
    FROM 
      V_AGENT_MASTER 
    WHERE 
      N_AGENT_NO = AGENT_NUMBER
  ) Agent_code, 
  (
    SELECT 
      V_AGENT_NAME 
    FROM 
      V_AGENT_MASTER 
    WHERE 
      N_AGENT_NO = AGENT_NUMBER
  ) Agent, 
  AGENT_NUMBER, 
  V_POLICY_NO, 
  D_COMM_GEN, 
  N_PREM_AMT, 
  D_RECEIPT, 
  V_RECEIPT_NO, 
  N_COMM_AMT, 
  N_COMM_YEAR, 
  V_COMM_STATUS, 
  N_LEVEL, 
  V_EARNED_RANK 
FROM 
  (
    SELECT 
      DISTINCT N_AGENT_NO AS AGENT_NUMBER, 
      V_POLICY_NO, 
      D_COMM_GEN, 
      N_PREM_AMT, 
      D_RECEIPT, 
      V_RECEIPT_NO, 
      N_COMM_AMT, 
      N_COMM_YEAR, 
      DECODE(
        V_COMM_STATUS, 'P', 'Paid', 'UP', 'Un Paid'
      ) V_COMM_STATUS, 
      V_STATUS, 
      N_LEVEL, 
      V_EARNED_RANK 
    from 
      AMMT_POL_COMM_DETAIL 
    where 
      D_COMM_GEN between '09-JAN-2024' 
      AND '31-JAN-2024' 
      AND V_COMM_STATUS IN ('P') --AND V_COMM_STATUS IN ('UP')
    ORDER BY 
      2 DESC
  ) 
order by 
  5 desc
)
WHERE AGENT_CODE IN 
('A0003492',
'A0003494',
'A0003496',
'A0003505',
'A0003507',
'A0003509',
'A0003513',
'A0003818',
'A0004325',
'A0004515',
'A0004616',
'A0005380',
'A0005524',
'A0005721',
'A0005740')
