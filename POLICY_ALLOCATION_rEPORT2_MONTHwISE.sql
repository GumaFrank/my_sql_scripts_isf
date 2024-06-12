/* Formatted on 19/02/2019 19:20:02 (QP5 v5.256.13226.35538) */

SELECT EXTRACT(MONTH FROM D_RECEIPT_DATE), COUNT( DISTINCT RECEIPT_NO) FROM 
(
  SELECT RCT.V_BRANCH_CODE,
         INS.V_INS_CODE,
         RCT.V_BRANCH_CODE BRANCH,
         RCT.V_CURRENCY_CODE,
         V_CURRENCY_DESC CURRENCY_DESC,
         INS.V_INS_CODE PAYMENT_CODE,
         INS.V_DESC PAYMENT_METHOD,
         D_RECEIPT_DATE, 
         V_RECEIPT_NO RECEIPT_NO,
         NVL (
            CUST.V_NAME,
            (SELECT V_COMPANY_NAME
               FROM GNMM_COMPANY_MASTER C
              WHERE     C.V_COMPANY_CODE = RCT.V_COMPANY_CODE
                    AND C.V_COMPANY_BRANCH = RCT.V_COMPANY_BRANCH))
            DESCRIPTION,
         DECODE (RCT.V_RECEIPT_CODE,
                 'RCT002', 'Policy Premium',
                 'RCT003', 'Proposal Deposit',
                 'RCT004', 'Loan Repayment',
                 'RCT100', 'Policy Premium',
                 'RCT001', 'Policy Premium',
                 'RCT012', 'Scheme Premium',
                 (SELECT RC.V_RECEIPT_DESC
                    FROM REMM_RECEIPT_CODE RC
                   WHERE RC.V_RECEIPT_CODE = RCT.V_RECEIPT_CODE))
            RECEIPT_TYPE,
         DECODE (RCT.V_BUSINESS_CODE,
                 'IND', 'Individual Life',
                 'GRP', 'Group Life',
                 'MISC', 'Miscellaneous',
                 RCT.V_BUSINESS_CODE)
            BUSINESS_CODE,
         NVL (V_INS_NUMBER, ' - ') CHEQUE_NO,
         BANKS.V_COMPANY_NAME || ' - ' || BANKS.V_COMPANY_BRANCH CLIENT_BANK,
         N_RECEIPT_AMT RECEIPT_AMOUNT,
         V_INS_BANK,
         V_INS_BANK_BRANCH,
         RCT.V_USER_CODE,
         RCT.V_POLICY_NO,
         JHL_GEN_PKG.GET_DR_BANK (INS.V_INS_CODE,
                                  RCT.V_BRANCH_CODE,
                                  RCT.V_BUSINESS_CODE)
            DR_BANK,
         JHL_GEN_PKG.GET_DR_BANK_CODE (INS.V_INS_CODE,
                                       RCT.V_BRANCH_CODE,
                                       RCT.V_BUSINESS_CODE)
            DR_BANK_CODE
    FROM REMT_RECEIPT RCT,
         REMT_RECEIPT_INSTRUMENTS RCT_INS,
         UNMM_CURRENCY_MASTER CUR,
         REMM_INSTRUMENT INS,
         GNMT_CUSTOMER_MASTER CUST,
         GNMM_COMPANY_MASTER BANKS
   WHERE     RCT.N_RECEIPT_SESSION = RCT_INS.N_RECEIPT_SESSION
         AND RCT.V_CURRENCY_CODE = CUR.V_CURRENCY_CODE
         AND RCT_INS.V_INS_CODE = INS.V_INS_CODE
         AND RCT.N_CUST_REF_NO = CUST.N_CUST_REF_NO(+)
         AND RCT_INS.V_INS_BANK = BANKS.V_COMPANY_CODE(+)
         AND RCT_INS.V_INS_BANK_BRANCH = BANKS.V_COMPANY_BRANCH(+)
         AND V_RECEIPT_TABLE = 'DETAIL'
         AND RCT.V_INSTRUMENT_STATUS = 'A'
         AND EXTRACT(YEAR FROM D_RECEIPT_DATE) = 2023
        
      /*   AND NVL (TRUNC (D_RECEIPT_DATE), TRUNC (SYSDATE)) BETWEEN NVL (
                                                                     :P_FM_DT,
                                                                     TRUNC (
                                                                        SYSDATE))
                                                               AND NVL (
                                                                     :P_TO_DT,
                                                                     TRUNC (
                                                                         SYSDATE))
                                                                         */
         AND UPPER (NVL (RCT.V_RECEIPT_REMARKS, 'XXXXX')) NOT LIKE '%OFFLINE%'
ORDER BY 1,
         2,
         4,
11

)

GROUP BY EXTRACT(MONTH FROM D_RECEIPT_DATE) ORDER BY 1 ASC