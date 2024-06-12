

/* Formatted on 20/02/2019 12:11:25 (QP5 v5.256.13226.35538) */
  SELECT ROW_NUMBER () OVER (ORDER BY V_RECEIPT_NO) AS SERIAL_NUMBER,
         V_REF_CODE V_POLICY_NO,
         V_NAME,
         V_CURRENCY_CODE,
         V_OTHER_REF_NO,
         D_OTHER_REF_DATE,
         V_RECEIPT_NO,
         INITCAP (B.V_RECEIPT_DESC) RECEIPT_TYPE,
         D_RECEIPT_DATE,
         TO_CHAR (N_RECEIPT_AMT, 'fm999,999,999.00') N_RECEIPT_AMT,
         N_RECEIPT_SESSION,
         V_USER_CODE
    FROM REMT_RECEIPT A, REMM_RECEIPT_CODE B, GNMT_CUSTOMER_MASTER C
   WHERE     V_RECEIPT_TABLE = 'DETAIL'
   AND TRUNC(D_RECEIPT_DATE) BETWEEN '01-JAN-2024' AND '31-JAN-2024'
         AND A.N_RECEIPT_SESSION IN (SELECT N_RECEIPT_SESSION
                                       FROM REMT_RECEIPT
--                                      WHERE V_RECEIPT_NO IN :P_RCPT_NO
                                      )
         AND A.V_RECEIPT_CODE = B.V_RECEIPT_CODE
         AND A.V_BUSINESS_CODE = B.V_BUSINESS_CODE
         AND A.N_CUST_REF_NO = C.N_CUST_REF_NO
        
         --and TRUNC(D_OTHER_REF_DATE) BETWEEN '01-JAN-2024' AND '31-JAN-2024'
        -- AND EXTRACT(YEAR FROM D_OTHER_REF_DATE )>= 2023
ORDER BY V_RECEIPT_NO