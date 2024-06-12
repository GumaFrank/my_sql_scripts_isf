SELECT DISTINCT 
CO.V_COMPANY_CODE,
         CO.V_COMPANY_BRANCH,
         CO.V_COMPANY_NAME,
         POL.V_POLICY_NO,
         D_POLICY_END_DATE,
         D_EXIT,
         POL_DTL.N_SEQ_NO,
         C.V_NAME,
         N_AGE_ENTRY,
         D_IND_DOB,
         RTS.V_GROUP_CODE,
         RTS.N_NET_EVENT_URATE,
         RTS.V_PLRI_CODE,
         RTS.V_PARENT_EVENT_CODE,
         N_IND_SA,
         N_ORIGINAL_FCL,
         POL.N_TERM,
         EVNT.N_EVENT_NET_PREM,
         N_SYS_GROSS_EVENT_URATE USER_UNIT_RATE,
         N_NET_EVENT_URATE NET_UNIT_RATE,
         RI_DTLS.N_SA_IN SUM_ASSURED,
         JHL_BI_UTILS.get_ri_arrangement_amt ('SHARE_PER',
                                              RI_DTLS.V_RI_POLICY_NO,
                                              RI_DTLS.V_TREATY_CODE,
                                              'PTA')
            PTA_SHARE_PERCENT,
         JHL_BI_UTILS.get_ri_arrangement_amt ('SHARE_AMT',
                                              RI_DTLS.V_RI_POLICY_NO,
                                              RI_DTLS.V_TREATY_CODE,
                                              'PTA')
            PTA_SHARE_AMT,
         JHL_BI_UTILS.get_ri_arrangement_amt ('SHARE_PER',
                                              RI_DTLS.V_RI_POLICY_NO,
                                              RI_DTLS.V_TREATY_CODE,
                                              'JIC')
            JIC_SHARE_PERCENT,
         JHL_BI_UTILS.get_ri_arrangement_amt ('SHARE_AMT',
                                              RI_DTLS.V_RI_POLICY_NO,
                                              RI_DTLS.V_TREATY_CODE,
                                              'JIC')
            JIC_SHARE_AMT,
         JHL_BI_UTILS.get_ri_arrangement_amt ('CEDED_AMT',
                                              RI_DTLS.V_RI_POLICY_NO,
                                              RI_DTLS.V_TREATY_CODE,
                                              'JIC')
            JIC_CEDED_AMT,
         JHL_BI_UTILS.get_ri_arrangement_amt ('CEDED_AMT',
                                              RI_DTLS.V_RI_POLICY_NO,
                                              RI_DTLS.V_TREATY_CODE,
                                              'PTA')
            PTA_CEDED_AMT,
         (SELECT V_TYPE
            FROM RIDT_TREATY_LISTING RI_LST
           WHERE RI_LST.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO AND ROWNUM = 1)
            V_TYPE,
         (SELECT SUM (N_SA_CHANGE)
            FROM RIDT_TREATY_LISTING RI_LST
           WHERE RI_LST.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO)
            SA_CHANGE,
         (SELECT SUM (N_PREM_CHANGE)
            FROM RIDT_TREATY_LISTING RI_LST
           WHERE     RI_LST.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO
                 AND RI_LST.V_POSTING_PROCESS = 'RI_PREMIUM')
            PREM_CHANGE,
         (SELECT (N_PREM_CHANGE)
            FROM RIDT_TREATY_LISTING RI_LST
           WHERE     RI_LST.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO
                 AND RI_LST.V_POSTING_PROCESS = 'RI_PREMIUM'
                 AND RI_LST.V_REINSURER_CODE = 'PTA'
                 AND ROWNUM = 1)
            PTA_PREM_CHANGE,
         (SELECT (N_PREM_CHANGE)
            FROM RIDT_TREATY_LISTING RI_LST
           WHERE     RI_LST.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO
                 AND RI_LST.V_POSTING_PROCESS = 'RI_PREMIUM'
                 AND RI_LST.V_REINSURER_CODE = 'JIC'
                 AND ROWNUM = 1)
            JIC_PREM_CHANGE,
         --         (SELECT N_SA_OUT
         --            FROM RIMT_POLICY_TREATY RI_PT
         --           WHERE RI_PT.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO AND ROWNUM = 1)
         --            FULCATITIVE_SA,
         (SELECT (NVL (SUM (N_SA_CHANGE), 0))
            FROM RIDT_TREATY_LISTING RI_LST
           WHERE     RI_LST.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO
                 AND V_LIST_TYPE = 'F')
            FULCATITIVE_SA,
         (SELECT (NVL (SUM (N_PREM_CHANGE), 0))
            FROM RIDT_TREATY_LISTING RI_LST
           WHERE     RI_LST.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO
                 AND V_LIST_TYPE = 'F')
            FULCATITIVE_PREM,
         V_RI_SPECIAL_GROUP_ID,
         DECODE (RI_DTLS.V_NORMAL_FAC,
                 'N', 'Normal',
                 'F', 'Fulcatitive',
                 RI_DTLS.V_NORMAL_FAC)
            NORMAL_FAC,
         (SELECT (N_GROSS_PREM)
            FROM RIDT_TREATY_LISTING RI_LST
           WHERE RI_LST.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO AND ROWNUM = 1)
            GROSS_PREM,
         (SELECT N_LOAD_DISCOUNT_VALUE
            FROM RIMT_QUOT_LOAD_DISC_DETAIL QUOT
           WHERE QUOT.V_RI_QUOTATION_ID = RI_DTLS.V_RI_QUOTATION_ID)
            LOAD_Percentage,
         (SELECT (N_LOAD_PREM)
            FROM RIDT_TREATY_LISTING RI_LST
           WHERE RI_LST.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO AND ROWNUM = 1)
            LOADING_PREM,
         (SELECT (N_RI_STD_PREM)
            FROM RIDT_TREATY_LISTING RI_LST
           WHERE RI_LST.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO AND ROWNUM = 1)
            STANDARD_PREM,
         (SELECT (N_RI_COMM)
            FROM RIDT_TREATY_LISTING RI_LST
           WHERE RI_LST.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO AND ROWNUM = 1)
            COMMISSION,
         RI_DTLS.V_RI_POLICY_NO
    --V_STATUS_DESC
    FROM GNMM_COMPANY_MASTER CO,
         GNMT_POLICY POL,
         GNMM_POLICY_STATUS_MASTER STATUS,
         GNMM_PLAN_MASTER PROD,
         GNMT_POLICY_DETAIL POL_DTL,
         GNMT_CUSTOMER_MASTER C,
         GNMT_POLICY_EVENT_LINK EVNT,
         GNDT_POLICY_EVENT_URATES RTS,
         (  SELECT RI_LINK.V_POLICY_NO,
                   RI_LINK.N_SEQ_NO,
                   RI_LINK.V_PLRI_CODE,
                   TRUNC (RI_LST.D_POSTED) D_POSTED,
                   --RI_LST.V_TYPE,
                  -- CASE WHEN RI_LST.V_TYPE = 'D' THEN SUM (RI_LST.N_PREM_CHANGE) WHEN  N_PREM_CHANGE,
                   SUM (RI_LST.N_PREM_CHANGE)N_PREM_CHANGE,
                   RI_LINK.V_RI_POLICY_NO,
                   RI_LST.V_RI_QUOTATION_ID,
                   RI_TR.V_NORMAL_FAC,
                   RI_TR.N_SA_IN,
                   RI_TR.V_TREATY_CODE
              FROM RIDT_POLICY_REINS_LINK RI_LINK,
                   RIDT_TREATY_LISTING RI_LST,
                   RIMT_POLICY_TREATY RI_TR
             WHERE     RI_LINK.V_RI_POLICY_NO = RI_LST.V_RI_POLICY_NO
                   AND RI_LINK.V_RI_QUOTATION_ID = RI_LST.V_RI_QUOTATION_ID
                   AND RI_LST.V_RI_POLICY_NO = RI_TR.V_RI_POLICY_NO(+)
                   AND RI_LINK.V_RI_POLICY_NO = RI_TR.V_RI_POLICY_NO(+)
                   AND RI_LINK.V_RI_QUOTATION_ID = RI_TR.V_RI_QUOTATION_ID(+)
--                   AND RI_TR.V_TREATY_CODE IN (--'T_GL_RC_ADTH_L3',
--                                               'T_GL_RC_DTH_L3')
          --AND RI_LST.V_REINSURER_CODE <> 'JIC'
          --and V_NORMAL_FAC = 'N'
          GROUP BY V_POLICY_NO,
                   N_SEQ_NO,
                   V_PLRI_CODE,
                   TRUNC (D_POSTED),
                   RI_LINK.V_RI_POLICY_NO,
                   RI_LST.V_RI_QUOTATION_ID,
                   RI_TR.V_NORMAL_FAC,
                   RI_TR.N_SA_IN,
                   RI_TR.V_TREATY_CODE) RI_DTLS
   WHERE     CO.V_COMPANY_CODE = POL.V_COMPANY_CODE
         AND CO.V_COMPANY_BRANCH = POL.V_COMPANY_BRANCH
         AND POL_DTL.V_CNTR_STAT_CODE = STATUS.V_STATUS_CODE
         AND POL.V_PLAN_CODE = PROD.V_PLAN_CODE
         AND POL.V_POLICY_NO = POL_DTL.V_POLICY_NO
         AND POL_DTL.N_CUST_REF_NO = C.N_CUST_REF_NO
         AND POL.V_POLICY_NO = EVNT.V_POLICY_NO
         AND POL_DTL.N_SEQ_NO = EVNT.N_SEQ_NO
         AND POL.V_POLICY_NO = RTS.V_POLICY_NO
         --AND EVNT.V_PLRI_CODE = RTS.V_PLRI_CODE
         AND EVNT.V_POLICY_NO = RI_DTLS.V_POLICY_NO
         AND POL_DTL.N_SEQ_NO = RI_DTLS.N_SEQ_NO
         AND EVNT.V_PLRI_CODE = RI_DTLS.V_PLRI_CODE
         --AND RTS.V_RI_POLICY_NO = RI_DTLS.V_RI_POLICY_NO
        -- AND POL.V_POLICY_NO LIKE 'GL%'
         --AND POL_DTL.V_CNTR_STAT_CODE = 'NB010'
         --AND POL.V_POLICY_NO = NVL ( :P_POLICY_NO, POL.V_POLICY_NO)
        -- AND POL_DTL.N_SEQ_NO = NVL ( :P_SEQ_NO, POL_DTL.N_SEQ_NO)
       -- AND TRUNC (D_POSTED) BETWEEN ( :P_FROMDATE) AND ( :P_TODATE)
ORDER BY POL.V_POLICY_NO, POL_DTL.N_SEQ_NO, v_plri_code