/* Formatted on 20/02/2019 12:47:56 (QP5 v5.256.13226.35538) */
  SELECT ROW_NUMBER () OVER (ORDER BY A.N_RECEIPT_SESSION) AS SERIAL_NUMBER,
         V_REF_CODE COMPANY_CODE,
         V_COMPANY_NAME COMPANY_NAME,
         A.V_CURRENCY_CODE,
         A.N_RECEIPT_SESSION,
         V_RECEIPT_NO,
         INITCAP (B.V_RECEIPT_DESC) RECEIPT_TYPE,
         D_RECEIPT_DATE,
         (SELECT DISTINCT B.V_LASTUPD_USER
            FROM REMT_RECEIPT B
           WHERE B.V_OTHER_REF_NO = A.V_RECEIPT_NO AND ROWNUM = 1)
            ALLOCATED_BY,
         (SELECT DISTINCT B.D_RECEIPT_DATE
            FROM REMT_RECEIPT B
           WHERE B.V_OTHER_REF_NO = A.V_RECEIPT_NO AND ROWNUM = 1)
            ALLOCATION_DATE,
         TO_CHAR (N_RECEIPT_AMT, 'fm999,999,999.00') N_RECEIPT_AMT,
         DECODE (V_RECEIPT_STATUS,
                 'RE001', 'Processed',
                 'RE002', 'Cancelled')
            V_RECEIPT_STATUS,
         V_USER_CODE,
         V_INS_NUMBER
    FROM REMT_RECEIPT A,
         REMM_RECEIPT_CODE B,
         GNMM_COMPANY_MASTER C,
         REMT_RECEIPT_INSTRUMENTS RCT_INS
   WHERE     V_RECEIPT_TABLE = 'DETAIL'
         AND A.V_RECEIPT_CODE = B.V_RECEIPT_CODE
         AND A.V_BUSINESS_CODE = B.V_BUSINESS_CODE
         AND A.V_COMPANY_CODE = C.V_COMPANY_CODE
         AND A.N_RECEIPT_SESSION = RCT_INS.N_RECEIPT_SESSION
         AND A.V_BUSINESS_CODE = 'MISC'
         AND V_BRANCH_CODE <> 'HO'
         AND A.V_REF_CODE NOT LIKE 'OTHER%'
     --    AND EXTRACT(YEAR FROM D_RECEIPT_DATE)>= 2023
         AND TRUNC (NVL (D_RECEIPT_DATE, SYSDATE)) BETWEEN NVL (
                                                              :P_FM_DT,
                                                              TRUNC (
                                                                 NVL (
                                                                    D_RECEIPT_DATE,
                                                                   SYSDATE)))
                                                      AND NVL (
                                                             :P_TO_DT,
                                                              TRUNC (
                                                                NVL (
                                                                    D_RECEIPT_DATE,
                                                                   SYSDATE)))
ORDER BY N_RECEIPT_SESSION