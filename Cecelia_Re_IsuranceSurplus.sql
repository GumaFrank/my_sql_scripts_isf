/* Formatted on 23/02/2022 16:17:48 (QP5 v5.256.13226.35538) */
  SELECT POL.V_POLICY_NO,
         POL_DTL.N_SEQ_NO,
         C.V_NAME,
         POL.D_COMMENCEMENT,
         D_POLICY_END_DATE,
         D_IND_DOB,
         N_AGE_ENTRY,
         N_IND_SA,
         (SELECT N_RIDER_SA
            FROM GNMT_POLICY_RIDERS RIDER
           WHERE     POL_DTL.V_POLICY_NO = RIDER.V_POLICY_NO
                 AND EVNT.V_PLRI_CODE = RIDER.V_PARENT_PLRI_CODE
                 AND ROWNUM = 1)
            RIDERS_SA,
         D_CNTR_END_DATE,
         EVNT.V_PLRI_CODE,
         N_ORIGINAL_FCL,
         0 RETENTION,
         N_FCL_AMOUNT /*nvl(Decode(RTS.V_Plri_Flag,'P', Decode(Sign(N_Fcl_Amount-N_Ind_Sa), -1, N_Fcl_Amount, N_Ind_Sa)),0) */
                     RESTRICTED_SA,
         JHL_GEN_PKG.get_ri_load_pct (V_RI_POLICY_NO, V_RI_QUOTATION_ID)
            N_LOADING_PCT,
         POL.N_TERM,
         N_GROSS_EVENT_URATE USER_UNIT_RATE,
         N_NET_EVENT_URATE NET_UNIT_RATE,
         D_POSTED,
         V_RI_POLICY_NO,
         V_RI_QUOTATION_ID,
         RI_DTLS.V_LIST_TYPE,
         RI_DTLS.V_TYPE,
         JHL_GEN_PKG.get_ri_amount ('SA',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'AFRE',
                                    D_POSTED)
            AFRICA_RE_SUM_REASSURED,
         JHL_GEN_PKG.get_ri_amount ('PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'AFRE',
                                    D_POSTED)
            AFRICA_RE_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('EM-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'AFRE',
                                    D_POSTED)
            AFRICA_RE_EM_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('SA',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'KEN',
                                    D_POSTED)
            KENYA_RE_SUM_REASSURED,
         JHL_GEN_PKG.get_ri_amount ('PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'KEN',
                                    D_POSTED)
            KENYA_RE_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('EM-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'KEN',
                                    D_POSTED)
            KENYA_RE_EM_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('SA',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'PTA',
                                    D_POSTED)
            PTA_RE_SUM_REASSURED,
         JHL_GEN_PKG.get_ri_amount ('PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'PTA',
                                    D_POSTED)
            PTA_RE_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('EM-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'PTA',
                                    D_POSTED)
            PTA_RE_EM_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('SA',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'CON',
                                    D_POSTED)
            CONTINENTAL_RE_SUM_REASSURED,
         JHL_GEN_PKG.get_ri_amount ('PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'CON',
                                    D_POSTED)
            CONTINENTAL_RE_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('EM-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'CON',
                                    D_POSTED)
            CONTINENTAL_RE_EM_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('SA',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'EAR',
                                    D_POSTED)
            EAST_AFR_RE_SUM_REASSURED,
         JHL_GEN_PKG.get_ri_amount ('PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'EAR',
                                    D_POSTED)
            EAST_AFR_RE_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('EM-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'EAR',
                                    D_POSTED)
            EAST_AFR_RE_EM_PREMIUM,
         /*FALCALTATIVE*/

         JHL_GEN_PKG.get_ri_amount ('F-SA',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'AFRE',
                                    D_POSTED)
            AFRICA_RE_FAC_SUM_REASSURED,
         JHL_GEN_PKG.get_ri_amount ('F-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'AFRE',
                                    D_POSTED)
            AFRICA_RE_FAC_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('F-EM-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'AFRE',
                                    D_POSTED)
            AFRICA_RE_FAC_EM_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('F-SA',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'KEN',
                                    D_POSTED)
            KENYA_RE_FAC_SUM_REASSURED,
         JHL_GEN_PKG.get_ri_amount ('F-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'KEN',
                                    D_POSTED)
            KENYA_RE_FAC_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('F-EM-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'KEN',
                                    D_POSTED)
            KENYA_RE_FAC_EM_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('F-SA',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'PTA',
                                    D_POSTED)
            PTA_RE_FAC_SUM_REASSURED,
         JHL_GEN_PKG.get_ri_amount ('F-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'PTA',
                                    D_POSTED)
            PTA_RE_FAC_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('F-EM-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'PTA',
                                    D_POSTED)
            PTA_RE_FAC_EM_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('F-SA',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'CON',
                                    D_POSTED)
            CONTINENTAL_RE_FAC_SUM_REASSURED,
         JHL_GEN_PKG.get_ri_amount ('F-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'CON',
                                    D_POSTED)
            CONTINENTAL_RE_FAC_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('F-EM-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'CON',
                                    D_POSTED)
            CONTINENTAL_RE_FAC_EM_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('F-SA',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'EAR',
                                    D_POSTED)
            EAST_AFR_RE_FAC_SUM_REASSURED,
         JHL_GEN_PKG.get_ri_amount ('F-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'EAR',
                                    D_POSTED)
            EAST_AFR_RE_FAC_PREMIUM,
         JHL_GEN_PKG.get_ri_amount ('F-EM-PREM',
                                    V_RI_POLICY_NO,
                                    V_RI_QUOTATION_ID,
                                    'EAR',
                                    D_POSTED)
            EAST_AFR_RE_FAC_EM_PREMIUM
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
                   SUM (RI_LST.N_PREM_CHANGE) N_PREM_CHANGE,
                   RI_LINK.V_RI_POLICY_NO,
                   RI_LST.V_RI_QUOTATION_ID,
                   RI_LST.V_LIST_TYPE,
                   RI_LST.V_TYPE
              FROM RIDT_POLICY_REINS_LINK RI_LINK, RIDT_TREATY_LISTING RI_LST
             WHERE     RI_LINK.V_RI_POLICY_NO = RI_LST.V_RI_POLICY_NO --and RI_LINK.V_RI_QUOTATION_ID = RI_LST.V_RI_QUOTATION_ID
                   AND RI_LST.V_REINSURER_CODE <> 'JIC'
          GROUP BY V_POLICY_NO,
                   N_SEQ_NO,
                   V_PLRI_CODE,
                   TRUNC (D_POSTED),
                   RI_LINK.V_RI_POLICY_NO,
                   RI_LST.V_RI_QUOTATION_ID,
                   RI_LST.V_LIST_TYPE,
                   RI_LST.V_TYPE --and   trunc(D_POSTED) BETWEEN '01-JAN-20' AND SYSDATE
                                --and RI_LINK.V_POLICY_NO =    :P_POLICY_NO  --EVNT.V_POLICY_NO
                                --and RI_LINK.N_SEQ_NO = 1 --POL_DTL.N_SEQ_NO
                                --and RI_LINK.V_PLRI_CODE = EVNT.V_PLRI_CODE
         ) RI_DTLS
   WHERE     CO.V_COMPANY_CODE = POL.V_COMPANY_CODE
         AND CO.V_COMPANY_BRANCH = POL.V_COMPANY_BRANCH
         AND POL.V_CNTR_STAT_CODE = STATUS.V_STATUS_CODE
         AND POL.V_PLAN_CODE = PROD.V_PLAN_CODE
         AND POL.V_POLICY_NO = POL_DTL.V_POLICY_NO
         AND POL_DTL.N_CUST_REF_NO = C.N_CUST_REF_NO
         AND POL.V_POLICY_NO = EVNT.V_POLICY_NO
         AND POL_DTL.N_SEQ_NO = EVNT.N_SEQ_NO
         AND POL.V_POLICY_NO = RTS.V_POLICY_NO
         AND EVNT.V_PLRI_CODE = RTS.V_PLRI_CODE
         AND EVNT.V_POLICY_NO = RI_DTLS.V_POLICY_NO
         AND POL_DTL.N_SEQ_NO = RI_DTLS.N_SEQ_NO
         AND EVNT.V_PLRI_CODE = RI_DTLS.V_PLRI_CODE
         --AND POL.V_POLICY_NO LIKE 'GL%'
         -- AND POL_DTL.V_CNTR_STAT_CODE = 'NB010'
         --AND POL.V_POLICY_NO = NVL ( :P_POLICY_NO, POL.V_POLICY_NO)
        -- AND POL_DTL.N_SEQ_NO = NVL ( :P_SEQ_NO, POL_DTL.N_SEQ_NO)
        -- AND TRUNC (D_POSTED) BETWEEN ( :P_FROMDATE) AND ( :P_TODATE)
ORDER BY POL.V_POLICY_NO, POL_DTL.N_SEQ_NO, D_POSTED