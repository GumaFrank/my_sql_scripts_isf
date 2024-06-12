
/*
Author  Eng Frank B
Date 29-JAN-2024
Description  Premium Rate asked  Dorothy PWC 
*/

select 
  Plan_code, 
  product, 
  (
    SELECT 
      V_PYMT_FREQ 
    FROM 
      GNMM_PLAN_MODAL_FACTOR_LINK 
    where 
      V_PLAN_CODE = Plan_code 
      and rownum = 1
  ) V_PYMT_FREQ, 
  (
    SELECT 
      N_MODAL_FACTOR 
    FROM 
      GNMM_PLAN_MODAL_FACTOR_LINK 
    where 
      V_PLAN_CODE = Plan_code 
      and rownum = 1
  ) N_MODAL_FACTOR, 
  N_START_AGE, 
  N_END_AGE, 
  N_START_TERM, 
  N_END_TERM, 
  N_BASE_SA, 
  N_PREM_RATE 
from 
  (
    select 
      distinct Plan_code, 
      (
        select 
          V_PLAN_NAME 
        from 
          gnmm_plan_master 
        where 
          V_PLAN_CODE = Plan_code
      ) as product, 
      N_START_AGE, 
      N_END_AGE, 
      N_START_TERM, 
      N_END_TERM, 
      N_BASE_SA, 
      N_PREM_RATE 
    from 
      (
        select 
          V_PLAN_CODE as Plan_code, 
          N_START_AGE, 
          N_END_AGE, 
          N_START_TERM, 
          N_END_TERM, 
          N_BASE_SA, 
          N_PREM_RATE 
        from 
          gnmm_premium
      ) 
    where 
      N_START_TERM is not null
  )
