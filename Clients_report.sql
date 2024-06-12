/* Formatted on 31/01/2019 15:06:59 (QP5 v5.256.13226.35538) */
SELECT V_NAME,
       (SELECT MAX (V_IDEN_NO)
          FROM GNDT_CUSTOMER_IDENTIFICATION
         WHERE     V_IDEN_CODE = 'NIC'
               AND V_LASTUPD_INFTIM =
                      (SELECT MAX (V_LASTUPD_INFTIM)
                         FROM GNDT_CUSTOMER_IDENTIFICATION
                        WHERE     V_IDEN_CODE = 'NIC'
                              AND N_CUST_REF_NO = C.N_CUST_REF_NO)
               AND N_CUST_REF_NO = C.N_CUST_REF_NO)
          ID_NO,
       (SELECT MAX (V_IDEN_NO)
          FROM GNDT_CUSTOMER_IDENTIFICATION
         WHERE     V_IDEN_CODE = 'PP'
               AND V_LASTUPD_INFTIM =
                      (SELECT MAX (V_LASTUPD_INFTIM)
                         FROM GNDT_CUSTOMER_IDENTIFICATION
                        WHERE     V_IDEN_CODE = 'PP'
                              AND N_CUST_REF_NO = C.N_CUST_REF_NO)
               AND N_CUST_REF_NO = C.N_CUST_REF_NO)
          PASSPORT,
       (SELECT MAX (V_IDEN_NO)
          FROM GNDT_CUSTOMER_IDENTIFICATION
         WHERE     V_IDEN_CODE = 'PIN'
               AND V_LASTUPD_INFTIM =
                      (SELECT MAX (V_LASTUPD_INFTIM)
                         FROM GNDT_CUSTOMER_IDENTIFICATION
                        WHERE     V_IDEN_CODE = 'PIN'
                              AND N_CUST_REF_NO = C.N_CUST_REF_NO)
               AND N_CUST_REF_NO = C.N_CUST_REF_NO)
          PIN,
       (SELECT V_CONTACT_NUMBER
          FROM GNDT_CUSTMOBILE_CONTACTS
         WHERE     N_CUST_REF_NO = C.N_CUST_REF_NO --               AND V_STATUS = 'A'
               AND V_Contact_Number LIKE '%@%'
               AND ROWNUM = 1)
          EMAIL,
       (SELECT V_CONTACT_NUMBER
          FROM GNDT_CUSTMOBILE_CONTACTS
         WHERE     N_CUST_REF_NO = C.N_CUST_REF_NO --               AND V_STATUS = 'A'
               AND V_Contact_Number NOT LIKE '%@%'
               AND ROWNUM = 1)
          PHONE,
       V_LASTUPD_INFTIM LAST_UDT_DATE,
       V_LASTUPD_USER LASTUPD_USER,
       'IL_CUSTOMER' CUST_TYPE
  FROM GNMT_CUSTOMER_MASTER C
 WHERE     C.N_CUST_REF_NO IN (SELECT POL.N_PAYER_REF_NO
                                 FROM GNMT_POLICY POL --                    WHERE V_CNTR_STAT_CODE IN ('NB010','NB022','NB025')
                                                     )
       --and TRUNC(V_LASTUPD_INFTIM) BETWEEN '24-MAY-18' AND TRUNC(SYSDATE)

--       AND TRUNC (NVL (V_LASTUPD_INFTIM, SYSDATE)) BETWEEN NVL (
--                                                              :P_FM_DT,
--                                                              TRUNC (
--                                                                 NVL (
--                                                                    V_LASTUPD_INFTIM,
--                                                                    SYSDATE)))
--                                                       AND NVL (
--                                                              :P_TO_DT,
--                                                              TRUNC (
--                                                                 NVL (
--                                                                    V_LASTUPD_INFTIM,
--                                                                    SYSDATE)))
--AND EXTRACT(YEAR FROM V_LASTUPD_INFTIM)>=2023  
AND TO_CHAR(V_LASTUPD_INFTIM, 'MON-YY') = 'JAN-24'
UNION
SELECT V_NAME,
       (SELECT MAX (V_IDEN_NO)
          FROM GNDT_CUSTOMER_IDENTIFICATION
         WHERE     V_IDEN_CODE = 'NIC'
               AND V_LASTUPD_INFTIM =
                      (SELECT MAX (V_LASTUPD_INFTIM)
                         FROM GNDT_CUSTOMER_IDENTIFICATION
                        WHERE     V_IDEN_CODE = 'NIC'
                              AND N_CUST_REF_NO = C.N_CUST_REF_NO)
               AND N_CUST_REF_NO = C.N_CUST_REF_NO)
          ID_NO,
       (SELECT MAX (V_IDEN_NO)
          FROM GNDT_CUSTOMER_IDENTIFICATION
         WHERE     V_IDEN_CODE = 'PP'
               AND V_LASTUPD_INFTIM =
                      (SELECT MAX (V_LASTUPD_INFTIM)
                         FROM GNDT_CUSTOMER_IDENTIFICATION
                        WHERE     V_IDEN_CODE = 'PP'
                              AND N_CUST_REF_NO = C.N_CUST_REF_NO)
               AND N_CUST_REF_NO = C.N_CUST_REF_NO)
          PASSPORT,
       (SELECT MAX (V_IDEN_NO)
          FROM GNDT_CUSTOMER_IDENTIFICATION
         WHERE     V_IDEN_CODE = 'PIN'
               AND V_LASTUPD_INFTIM =
                      (SELECT MAX (V_LASTUPD_INFTIM)
                         FROM GNDT_CUSTOMER_IDENTIFICATION
                        WHERE     V_IDEN_CODE = 'PIN'
                              AND N_CUST_REF_NO = C.N_CUST_REF_NO)
               AND N_CUST_REF_NO = C.N_CUST_REF_NO)
          PIN,
       (SELECT V_CONTACT_NUMBER
          FROM GNDT_CUSTMOBILE_CONTACTS
         WHERE     N_CUST_REF_NO = C.N_CUST_REF_NO --               AND V_STATUS = 'A'
               AND V_Contact_Number LIKE '%@%'
               AND ROWNUM = 1)
          EMAIL,
       (SELECT V_CONTACT_NUMBER
          FROM GNDT_CUSTMOBILE_CONTACTS
         WHERE     N_CUST_REF_NO = C.N_CUST_REF_NO --               AND V_STATUS = 'A'
               AND V_Contact_Number NOT LIKE '%@%'
               AND ROWNUM = 1)
          PHONE,
       V_LASTUPD_INFTIM LAST_UDT_DATE,
       V_LASTUPD_USER LASTUPD_USER,
       'AGENT' CUST_TYPE
  FROM GNMT_CUSTOMER_MASTER C
 WHERE     C.N_CUST_REF_NO IN (SELECT AGN.N_CUST_REF_NO
                                 FROM Ammm_Agent_Master AGN --                    WHERE V_CNTR_STAT_CODE IN ('NB010','NB022','NB025')
                                                           )
        --AND EXTRACT(YEAR FROM V_LASTUPD_INFTIM)>=2023    
        AND TO_CHAR(V_LASTUPD_INFTIM, 'MON-YY') = 'JAN-24'                                               
       --and TRUNC(V_LASTUPD_INFTIM) BETWEEN '24-MAY-18' AND TRUNC(SYSDATE)

--       AND TRUNC (NVL (V_LASTUPD_INFTIM, SYSDATE)) BETWEEN NVL (
--                                                              :P_FM_DT,
--                                                              TRUNC (
--                                                                 NVL (
--                                                                    V_LASTUPD_INFTIM,
--                                                                    SYSDATE)))
--                                                       AND NVL (
--                                                              :P_TO_DT,
--                                                              TRUNC (
--                                                                 NVL (
--                                                                    V_LASTUPD_INFTIM,
--                                                                    SYSDATE)))
ORDER BY 9 DESC