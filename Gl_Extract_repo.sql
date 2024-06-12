/* Formatted on 14/02/2019 21:32:09 (QP5 v5.256.13226.35538) */
  SELECT V_POLAG_NO,
         N_NET_CONTRIBUTION,
         D_COMMENCEMENT,
         D_POLICY_END_DATE,
         V_STATUS_DESC,
         V_GISS_CODE,
         V_GL_CODE,
         V_DOCU_TYPE,
         V_DOCU_REF_NO,
         D_DATE D_POSTED_DATE,
         V_PROCESS_CODE,
         V_PROCESS_NAME,
         V_DESC,
         AGENCY,
         SUM (N_AMT) N_AMT,
         V_POLICY_BRANCH,
          V_REMARKS ORACLE_JV
    FROM (
    SELECT B.V_POLAG_NO,
                 N_NET_CONTRIBUTION,
                 D_COMMENCEMENT,
                 D_POLICY_END_DATE,
                 V_STATUS_DESC,
                 B.N_REF_NO,
                 V_GISS_CODE,
                 V_GL_CODE,
                 V_DOCU_TYPE,
                 V_DOCU_REF_NO,
                 D_POSTED_DATE,
                 D_DATE,
                 V_TYPE,
                 DECODE (V_TYPE, 'D', N_AMT, -N_AMT) N_AMT,
                 V_PROCESS_CODE,
                 V_PROCESS_NAME,
                 V_DESC,
                 V_ACCOUNT_TYPE,
                 B.V_POLAG_TYPE,
                 JHL_UTILS.AGENCY_NAME2 (B.V_POLAG_NO) AGENCY,
                 D.V_POLICY_BRANCH,
                 B. V_REMARKS 
            FROM GNDT_GL_DETAILS A,
                 GNMT_GL_MASTER B,
                 GNMM_PROCESS_MASTER C,
                 GNMT_POLICY D,
                 GNMM_POLICY_STATUS_MASTER E
           WHERE     A.N_REF_NO = B.N_REF_NO
                 AND B.V_POLAG_NO = D.V_POLICY_NO
                 AND V_PROCESS_CODE = V_PROCESS_ID(+)
                 AND V_STATUS_CODE = V_CNTR_STAT_CODE
                 AND V_PROCESS_CODE != 'PR0140'
                 AND B.V_JOURNAL_STATUS = 'C'
                -- AND V_GL_CODE IN :P_GL_CODE
--                 AND NVL (TRUNC (B.D_DATE), TRUNC (SYSDATE)) BETWEEN NVL (
--                                                                        :P_FM_DT,
--                                                                        TRUNC (
--                                                                           SYSDATE))
--                                                                 AND NVL (
--                                                                        :P_TO_DT,
--                                                                        TRUNC (
--                                                                           SYSDATE))
                 AND B.N_REF_NO NOT IN (SELECT N_REF_NO
                                          FROM GNMT_GL_MASTER
                                         WHERE     TRUNC (D_DATE) >=
                                                      '1-jan-2015'
                                               AND D_POSTED_DATE <=
                                                      '31-dec-2014')
                AND EXTRACT(YEAR FROM B.D_DATE) >= 2023 )     
        GROUP BY        
         V_POLAG_NO,
         N_NET_CONTRIBUTION,
         D_COMMENCEMENT,
         D_POLICY_END_DATE,
         V_STATUS_DESC,
         V_GISS_CODE,
         V_GL_CODE,
         V_DOCU_TYPE,
         V_DOCU_REF_NO,
         D_DATE ,
         V_PROCESS_CODE,
         V_PROCESS_NAME,
         V_DESC,
         AGENCY,
         V_POLICY_BRANCH,
          V_REMARKS