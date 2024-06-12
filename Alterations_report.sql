/* Formatted on 29/01/2020 11:25:21 (QP5 v5.256.13226.35538) */
  SELECT B.V_Policy_No,
         B.V_Plri_Code,
         DECODE (B.V_Plri_Flag,  'P', 'PLAN',  'R', 'RIDER') Plan_Rider,
         B.V_Alter_Code,
         F.V_Alter_Code_Desc,
         B.V_Old_Value,
         B.V_New_Value,
         B.V_Lastupd_User Lastupdated_By,
         TRUNC (G.D_Commencement) Commencement_Date,
         MAX (B.D_Lastupd_Inftim) Lastupdated_On
    FROM Psdt_Alteration_History B,
         Psmt_Alteration C,
         Gnmt_Quotation_Detail E,
         Psmm_Alter_Codes F,
         Gnmt_Policy G
   WHERE     B.V_Policy_No = E.V_Policy_No
         AND B.V_Policy_No = G.V_Policy_No
         AND B.N_Alteration_Seq_No = C.N_Alteration_Seq_No
         AND E.V_Quotation_Id = B.V_Quotation_Id
         AND E.N_Seq_No = B.N_Seq_No
         AND B.V_Alter_Code = F.V_Alter_Code
         AND B.V_Policy_No NOT LIKE 'GL%'
         AND B.V_Old_Value NOT IN ('0', 'FP')
         AND B.V_Alter_Code NOT IN ('AL102',
                                    'AL139',
                                    'AL138',
                                    'AL114',
                                    'AL137',
                                    'AL140',
                                    'AL178',
                                    'AL101',
                                    'AL84',
                                    'AL36',
                                    'AL50',
                                    'AL43',
                                    'AL42',
                                    'AL41',
                                    'AL76',
                                    'AL49',
                                    'AL105',
                                    'AL53',
                                    'AL51',
                                    'AL107',
                                    'AL99',
                                    'AL106',
                                    'AL45',
                                    'AL31',
                                    'AL108',
                                    'AL124',
                                    'AL136',
                                    'AL130',
                                    'AL55',
                                    'AL104',
                                    'AL48')
           -- AND EXTRACT(YEAR FROM B.D_Lastupd_Inftim) >= 2023                        
         And Trunc (B.D_Lastupd_Inftim) Between :From_Date And :To_Date
       AND TRUNC (B.D_Lastupd_Inftim) BETWEEN ( :P_FromDate) AND ( :P_ToDate)
GROUP BY B.V_Policy_No,
         B.V_Plri_Code,
         B.V_Alter_Code,
         F.V_Alter_Code_Desc,
         B.V_Old_Value,
         B.V_New_Value,
         D_Commencement,
         B.V_Lastupd_User,
         B.V_Plri_Flag