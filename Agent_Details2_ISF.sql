
/* Formatted on 29/09/2020 10:17:21 (QP5 v5.256.13226.35538) */

WITH AGENT_SERVICE_HISTORY AS(
select 
    N_agent_no,
    V_ACTION_REMARKS,V_ACTION,
    max(case when V_action = 'Suspended' then D_action_date end) Suspension_date,
    max(case when V_action = 'Active' then D_action_date end) Reinstatement_date,
    max(case when V_action = 'Promotion' then D_action_date end) Promotion_date,
    max(case when V_action = 'AGENT TRANSFER' then D_action_date end) Transfer_date,
    max(case when V_action = 'Demotion' then D_action_date end) Demotion_date
from Amdt_agent_service_history 
WHERE D_ACTION_DATE >= :P_FM_DT AND D_ACTION_DATE <= :P_TO_DT
group by N_agent_no,V_ACTION_REMARKS,V_ACTION
)

SELECT A.V_agent_code,
       B.V_name,
       (SELECT Jhl_utils.Agent_name (
                  SUM (DECODE (N_manager_level, 30, N_manager_no, 0)))
                  Usm
          FROM Ammt_agent_hierarchy K
         WHERE K.N_agent_no = A.N_agent_no AND V_status = 'A')
          Unit_sales_manager,
       (SELECT Jhl_utils.Agent_name (
                  SUM (DECODE (N_manager_level, 20, N_manager_no, 0)))
                  Asm
          FROM Ammt_agent_hierarchy K
         WHERE K.N_agent_no = A.N_agent_no AND V_status = 'A')
          Agency_sales_manager,
       (SELECT Jhl_utils.Agent_name (
                  SUM (DECODE (N_manager_level, 15, N_manager_no, 0)))
                  Rsm
          FROM Ammt_agent_hierarchy K
         WHERE K.N_agent_no = A.N_agent_no AND V_status = 'A')
          Regional_sales_manager,
       (SELECT Jhl_utils.Agent_name (
                  SUM (DECODE (N_manager_level, 10, N_manager_no, 0)))
                  AS Nsm
          FROM Ammt_agent_hierarchy K
         WHERE K.N_agent_no = A.N_agent_no AND V_status = 'A')
          National_sales_manager,
       --A.V_Status,
       (SELECT W.V_agent_status_desc
          FROM Ammm_agent_status W
         WHERE W.V_agent_status_code = A.V_status)
          Agent_status_desc,
       (SELECT V_iden_no
          FROM Gndt_customer_identification K
         WHERE     V_iden_code = 'NIC'
               AND N_cust_ref_no = A.N_cust_ref_no
               AND ROWNUM = 1)
          V_Iden_No,
       B.D_birth_date,
       B.V_marital_status,
       B.V_sex,
       (SELECT V_iden_no
          FROM Gndt_customer_identification
         WHERE     V_iden_code = 'PIN'
               AND N_cust_ref_no = A.N_cust_ref_no
               AND ROWNUM = 1)
          Pin,
       (SELECT Q.V_contact_number
          FROM Gndt_custmobile_contacts Q
         WHERE     A.N_cust_ref_no = Q.N_cust_ref_no
               AND Q.V_contact_number LIKE '%@%'
               AND ROWNUM = 1)
          Email,
       (SELECT V_contact_number
          FROM Gndt_custmobile_contacts
         WHERE     N_cust_ref_no = A.N_cust_ref_no
               AND V_contact_number NOT LIKE '%@%'
               AND V_status = 'A'
               AND ROWNUM = 1)
          Contact,
       A.D_appointment,
       A.D_termination,
--       (SELECT MAX (D_action_date)
--          FROM Amdt_agent_service_history
--         WHERE V_action = 'Suspended' AND N_agent_no = A.N_agent_no)
--          Suspension_date,
C.SUSPENSION_DATE,
--       (SELECT MAX (D_action_date)
--          FROM Amdt_agent_service_history
--         WHERE V_action = 'Active' AND N_agent_no = A.N_agent_no)
          C.REINSTATEMENT_DATE,
--       (SELECT MAX (D_action_date)
--          FROM Amdt_agent_service_history
--         WHERE V_action = 'Promotion' AND N_agent_no = A.N_agent_no)
          C.PROMOTION_DATE,
--       (SELECT MAX (D_action_date)
--          FROM Amdt_agent_service_history
--         WHERE V_action = 'Demotion' AND N_agent_no = A.N_agent_no)
        C.DEMOTION_DATE,
--       (SELECT MAX (D_action_date)
--          FROM Amdt_agent_service_history
--         WHERE V_action = 'AGENT TRANSFER' AND N_agent_no = A.N_agent_no)
          C.TRANSFER_DATE,
       (SELECT                                                 -- v_policy_no,
              RTRIM (
                  XMLAGG (XMLELEMENT (E, V_education_desc || ',')).EXTRACT (
                     '//text()'),
                  ',')
                  V_education_desc
          FROM Amdt_agent_education X, Ammm_education_master Y
         WHERE     N_agent_no = A.N_agent_no
               AND X.V_education_code = Y.V_education_code)
          Education_details,
          C.V_ACTION COMMISSION_STATUS,
          C.V_ACTION_REMARKS V_COMM_PAY_STATUS_REASON
  FROM Ammm_agent_master A, Gnmt_customer_master B, AGENT_SERVICE_HISTORY C
 WHERE     A.N_cust_ref_no = B.N_cust_ref_no --And A.V_AGENT_CODE = G.V_AGENT_CODE
 AND A.N_agent_no = C.N_agent_no
       AND TRUNC (A.D_APPOINTMENT) BETWEEN NVL ( :P_FM_DT,
                                                TRUNC (A.D_APPOINTMENT))
                                       AND NVL ( :P_TO_DT,
                                                TRUNC (A.D_APPOINTMENT))
                                                AND  C.V_ACTION_REMARKS IS NOT NULL