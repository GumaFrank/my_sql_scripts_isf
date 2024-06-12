/* Formatted on 25/02/2019 19:56:12 (QP5 v5.256.13226.35538) */

SELECT A.V_AGENT_CODE,
       B.V_NAME AGENT_NAME,
       (SELECT JHL_UTILS.AGENT_NAME (
                  SUM (DECODE (N_MANAGER_LEVEL, 20, N_MANAGER_NO, 0)))
                  BAS
          FROM AMMT_AGENT_HIERARCHY K
         WHERE K.N_AGENT_NO = A.N_AGENT_NO AND V_STATUS = 'A')
          BANCA_ASSURANCE_SUPERVISOR,
       (SELECT JHL_UTILS.AGENT_NAME (
                  SUM (DECODE (N_MANAGER_LEVEL, 10, N_MANAGER_NO, 0)))
                  BAM
          FROM AMMT_AGENT_HIERARCHY K
         WHERE K.N_AGENT_NO = A.N_AGENT_NO AND V_STATUS = 'A')
          BANCA_ASSURANCE_MANAGER,
       --A.V_Status,
       (SELECT W.V_AGENT_STATUS_DESC
          FROM AMMM_AGENT_STATUS W
         WHERE W.V_AGENT_STATUS_CODE = A.V_STATUS)
          AGENT_STATUS_DESC,
       D.V_IDEN_NO,
       B.D_BIRTH_DATE,
       B.V_MARITAL_STATUS,
       B.V_SEX,
       (C.V_IDEN_NO) PIN,
       (E.V_CONTACT_NUMBER) EMAIL,
       (F.V_CONTACT_NUMBER) CONTACT,
       A.D_APPOINTMENT,
       A.D_TERMINATION
  FROM AMMM_AGENT_MASTER A,
       GNMT_CUSTOMER_MASTER B,
       GNDT_CUSTOMER_IDENTIFICATION C,
       GNDT_CUSTOMER_IDENTIFICATION D,
       GNDT_CUSTMOBILE_CONTACTS E,
       GNDT_CUSTMOBILE_CONTACTS F,
       AMMM_AGENT_MASTER G,
       GNMT_CUSTOMER_MASTER H
 WHERE     A.N_CUST_REF_NO = B.N_CUST_REF_NO
       AND A.N_CUST_REF_NO = C.N_CUST_REF_NO(+)
       AND C.V_IDEN_NO(+) LIKE 'A%'
       AND A.N_CUST_REF_NO = D.N_CUST_REF_NO(+)
       AND D.V_IDEN_CODE(+) = 'NIC'
       AND A.N_CUST_REF_NO = E.N_CUST_REF_NO(+)
       AND E.V_CONTACT_NUMBER(+) LIKE '%@%'
       AND A.N_CUST_REF_NO = F.N_CUST_REF_NO(+)
       AND F.V_CONTACT_NUMBER(+) LIKE '0%'
       AND A.N_CURRENTLY_REPORTING_TO = G.N_AGENT_NO(+)
       AND G.N_CUST_REF_NO = H.N_CUST_REF_NO(+)
       
       AND TRUNC (NVL (A.D_APPOINTMENT, SYSDATE)) BETWEEN NVL (
                                                             :P_FM_DT,
                                                            TRUNC (
                                                                NVL (
                                                                   A.D_APPOINTMENT,
                                                                   SYSDATE)))
                                                      AND NVL (
                                                             :P_TO_DT,
                                                             TRUNC (
                                                                NVL (
                                                                   A.D_APPOINTMENT,
                                                                   SYSDATE)))

UNION
SELECT A.V_AGENT_CODE,
       B.V_NAME AGENT_NAME,
       (SELECT JHL_UTILS.AGENT_NAME (
                  SUM (DECODE (N_MANAGER_LEVEL, 20, N_MANAGER_NO, 0)))
                  BAS
          FROM AMMT_AGENT_HIERARCHY K
         WHERE K.N_AGENT_NO = A.N_AGENT_NO AND V_STATUS = 'A')
          BANCA_ASSURANCE_SUPERVISOR,
       (SELECT JHL_UTILS.AGENT_NAME (
                  SUM (DECODE (N_MANAGER_LEVEL, 10, N_MANAGER_NO, 0)))
                  BAM
          FROM AMMT_AGENT_HIERARCHY K
         WHERE K.N_AGENT_NO = A.N_AGENT_NO AND V_STATUS = 'A')
          BANCA_ASSURANCE_MANAGER,
       (SELECT W.V_AGENT_STATUS_DESC
          FROM AMMM_AGENT_STATUS W
         WHERE W.V_AGENT_STATUS_CODE = A.V_STATUS)
          AGENT_STATUS_DESC,
       D.V_IDEN_NO,
       B.D_BIRTH_DATE,
       B.V_MARITAL_STATUS,
       B.V_SEX,
       (C.V_IDEN_NO) PIN,
       (E.V_CONTACT_NUMBER) EMAIL,
       (F.V_CONTACT_NUMBER) CONTACT,
       A.D_APPOINTMENT,
       A.D_TERMINATION
  FROM AMMM_AGENT_MASTER A,
       GNMT_CUSTOMER_MASTER B,
       GNDT_CUSTOMER_IDENTIFICATION C,
       GNDT_CUSTOMER_IDENTIFICATION D,
       GNDT_CUSTMOBILE_CONTACTS E,
       GNDT_CUSTMOBILE_CONTACTS F,
       AMMM_AGENT_MASTER G,
       GNMM_COMPANY_MASTER H
 WHERE     A.N_CUST_REF_NO = B.N_CUST_REF_NO
       AND A.N_CUST_REF_NO = C.N_CUST_REF_NO(+)
       AND C.V_IDEN_NO(+) LIKE 'A%'
       AND A.N_CUST_REF_NO = D.N_CUST_REF_NO(+)
       AND D.V_IDEN_CODE(+) = 'NIC'
       AND A.N_CUST_REF_NO = E.N_CUST_REF_NO(+)
       AND E.V_CONTACT_NUMBER(+) LIKE '%@%'
       AND A.N_CUST_REF_NO = F.N_CUST_REF_NO
       AND F.V_CONTACT_NUMBER(+) LIKE '0%'
       AND A.N_CURRENTLY_REPORTING_TO = G.N_AGENT_NO
       AND G.V_COMPANY_CODE = H.V_COMPANY_CODE
       AND G.V_COMPANY_BRANCH = H.V_COMPANY_BRANCH
       AND G.V_COMPANY_CODE IS NOT NULL
       AND G.V_COMPANY_BRANCH IS NOT NULL
       AND TRUNC (NVL (A.D_APPOINTMENT, SYSDATE)) BETWEEN NVL (
                                                             :P_FM_DT,
                                                             TRUNC (
                                                               NVL (
                                                                   A.D_APPOINTMENT,
                                                                   SYSDATE)))
                                                      AND NVL (
                                                             :P_TO_DT,
                                                            TRUNC (
                                                                NVL (
                                                                  A.D_APPOINTMENT,
                                                                  SYSDATE)))