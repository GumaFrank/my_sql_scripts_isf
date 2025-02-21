84 628 955

84 628 955

84 821 235

--POL_CANCEL_DT

SELECT  SUM(PREMIUM) FROM
(
SELECT  POL.V_POLICY_NO POLICY_NO , 
V_PLAN_NAME PLAN_NAME , 
V_STATUS_DESC POL_STATUS, 
D_COMMENCEMENT  POL_START_DT,  
POL.V_LASTUPD_INFTIM POL_CANCEL_DT , CEIL( (POL.V_LASTUPD_INFTIM - POL.D_COMMENCEMENT )) POL_DURATION,N_SUM_COVERED SUM_ASSURED ,N_CONTRIBUTION PREMIUM,
V_PYMT_DESC PAYMENT_FREQ
 FROM GNMT_POLICY POL, GNMM_PLAN_MASTER PROD,GNMM_POLICY_STATUS_MASTER  STATUS,GNLU_FREQUENCY_MASTER FREQ
WHERE  POL.V_PLAN_CODE = PROD.V_PLAN_CODE
AND POL.V_CNTR_STAT_CODE = STATUS.V_STATUS_CODE
  AND POL.V_PYMT_FREQ = FREQ.V_PYMT_FREQ
AND POL.V_POLICY_NO  NOT LIKE 'GL%'
AND V_STATUS_CODE IN ('NB004','NB020','NB003','NB021','NB211')
--POL.V_LASTUPD_INFTIM
--AND TRUNC (POL.LASTUPD_INFTIM) BETWEEN NVL ( :P_FM_DT,TRUNC (POL.V_LASTUPD_INFTIM)) AND NVL ( :P_TO_DT,TRUNC (POL.V_LASTUPD_INFTIM))
--AND V_STATUS_CODE IN ('NB021','NB004')
 --AND TRUNC (D_COMMENCEMENT) BETWEEN NVL ( :P_FM_DT,TRUNC (D_COMMENCEMENT)) AND NVL ( :P_TO_DT,TRUNC (D_COMMENCEMENT))
 --AND EXTRACT(YEAR FROM D_COMMENCEMENT) >= 2023
 )
  WHERE POL_CANCEL_DT BETWEEN '01-JAN-2024' AND '31-JAN-2024'
  --WHERE TO_CHAR(POL_CANCEL_DT, 'MON-YY') = 'JAN-24' --BETWEEN '01-JAN-2024' AND '31-JAN-2024'