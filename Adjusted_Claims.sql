/* Formatted on 14/01/2020 16:24:11 (QP5 v5.256.13226.35538) */
SELECT A.V_CLAIM_NO,
       C.V_POLICY_NO,
       D.V_COMPANY_CODE,
       D.V_COMPANY_NAME,
       V_CLIENT_NAME,
        H.V_PLAN_DESC,I.V_LASTUPD_INFTIM,
       F.V_EVENT_CODE,
       F.V_EVENT_DESC,
       D_EVENT_DATE,
       A.D_CLAIM_DATE,
       A.D_INTIMATION,
       B.N_AMOUNT_PAYB,
       E.V_STATUS_DESC,
       TRUNC (I.V_LASTUPD_INFTIM) CLAIM_PAID_DATE,
        JHL_GEN_PKG.GET_CLAIM_PAYMENT_DATE (A.V_CLAIM_NO,
                                            B.N_AMOUNT_PAYB,
                                            TRUNC (I.V_LASTUPD_INFTIM))
          PAYMENT_DATE,
       JHL_BI_UTILS.Get_Claim_Adjusted_Amt (A.V_CLAIM_NO) ADJUSTED_AMOUNT,
       (SELECT MAX (PRV.D_PROVISION_DATE)
          FROM CLDT_PROVISION_DETAIL PRV
         WHERE     PRV.V_PROV_TYPE IN ('INC-PROV', 'DEC-PROV') --AND V_AMOUNT_TYPE <> 'I'
               AND PRV.V_CLAIM_NO = A.V_CLAIM_NO)
          Adjusted_Date
  FROM CLMT_CLAIM_MASTER A,
       CLDT_CLAIM_EVENT_POLICY_LINK B,
       GNMT_POLICY C,
       GNMM_COMPANY_MASTER D,
       CLMM_STATUS_MASTER E,
       GNMM_EVENT_MASTER F,
       CLDT_CLAIM_POLICY_SETTLEMENT G,
       GNMM_PLAN_MASTER H,
       CLDT_CLAIM_EVENT_STATUS_LINK I,
       CLDT_CLAIM_EVENT_LINK J
 WHERE     A.V_CLAIM_NO = B.V_CLAIM_NO
       AND B.V_POLICY_NO = C.V_POLICY_NO
       AND C.V_COMPANY_CODE = D.V_COMPANY_CODE
       AND C.V_COMPANY_BRANCH = D.V_COMPANY_BRANCH
       AND C.V_GRP_IND_FLAG = 'G'
       AND B.V_EVENT_CODE = F.V_EVENT_CODE
       AND B.V_CLAIM_NO = G.V_CLAIM_NO(+)
       AND B.N_SEQ_NO = G.N_SEQ_NO(+)
       AND B.V_PLRI_CODE = H.V_PLAN_CODE
       AND B.N_AMOUNT_PAYB > 0
       AND B.V_CLAIM_NO = I.V_CLAIM_NO
       AND B.N_SUB_CLAIM_NO = I.N_SUB_CLAIM_NO
       AND I.V_STATUS_CODE = E.V_STATUS_CODE
       --       AND I.V_STATUS_CODE = 'CLST04'
       AND B.V_CLAIM_NO = J.V_CLAIM_NO
       AND B.V_EVENT_CODE = J.V_EVENT_CODE
--       AND TRUNC (I.V_LASTUPD_INFTIM) BETWEEN NVL (
--                                                  :P_FM_DT,
--                                                  TRUNC (I.V_LASTUPD_INFTIM))
--                                           AND NVL (
--                                                  :P_TO_DT,
--                                                  TRUNC (I.V_LASTUPD_INFTIM))
--       AND D.V_COMPANY_CODE = NVL ( :P_COMPANY_CODE, D.V_COMPANY_CODE)
--       AND F.V_EVENT_CODE = NVL ( :P_EVENT_CODE, F.V_EVENT_CODE)
       AND JHL_BI_UTILS.Get_Claim_Adjusted_Amt (A.V_CLAIM_NO) <> 0
       AND EXTRACT(YEAR FROM I.V_LASTUPD_INFTIM) >= 2023