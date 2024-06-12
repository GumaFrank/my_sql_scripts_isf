SELECT 
    V_VOU_DESC, 
    V_VOU_NO, 
    TRUNC(D_VOU_DATE),
    V_PAYEE_NAME, 
    N_VOU_AMOUNT, 
    V_CURRENCY_CODE
FROM 
    PYMT_VOUCHER_ROOT PM
JOIN 
    PYMT_VOU_MASTER PV ON PM.V_MAIN_VOU_NO = PV.V_MAIN_VOU_NO
WHERE 
    TO_DATE(D_VOU_DATE, 'DD/MM/RRRR') IN (
        DATE '2023-01-09', 
        DATE '2023-02-24', 
        DATE '2023-02-18', 
        DATE '2023-02-01', 
        DATE '2023-03-10', 
        DATE '2023-03-30', 
        DATE '2023-04-04', 
        DATE '2023-04-27', 
        DATE '2023-05-04', 
        DATE '2023-05-31', 
        DATE '2023-06-12', 
        DATE '2023-06-20', 
        DATE '2023-07-02', 
        DATE '2023-07-29', 
        DATE '2023-08-03', 
        DATE '2023-08-11', 
        DATE '2023-09-05', 
        DATE '2023-09-06', 
        DATE '2023-10-29', 
        DATE '2023-11-01', 
        DATE '2023-11-30', 
        DATE '2023-12-08', 
        DATE '2023-12-16', 
        DATE '2023-12-31'
    )
    AND JHL_GEN_PKG.IS_VOUCHER_CANCELLED(V_VOU_NO) = 'N'
    AND JHL_GEN_PKG.IS_VOUCHER_AUTHORIZED(V_VOU_NO) = 'Y'
