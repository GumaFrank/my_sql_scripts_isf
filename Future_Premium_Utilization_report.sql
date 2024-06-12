/*
running future Premium utilization_procedure 
*/

BEGIN
   JHL_GEN_PKG.FUTURE_PREM_UTILIZATION_PROC;
END;

--JHK_GEN_PKG.FUTURE_PREM_UTILIZATION_PROC

select  v_excess_payment_option  from gnmt_policy where v_policy_no='UI201900421251';