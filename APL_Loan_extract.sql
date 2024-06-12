/* Formatted on 06/01/2020 10:09:58 (QP5 v5.256.13226.35538) */
  SELECT A.V_Policy_No,
         B.V_Name,
         A.V_Cntr_Stat_Code,
         (SELECT V_Status_Desc
            FROM Gnmm_Policy_Status_Master D
           WHERE D.V_Status_Code = A.V_Cntr_Stat_Code)
            Policy_Status,
         A.V_Cntr_Prem_Stat_Code,
         (SELECT V_Status_Desc
            FROM Gnmm_Policy_Status_Master D
           WHERE D.V_Status_Code = A.V_Cntr_Prem_Stat_Code)
            Premium_Status,
         A.N_Sum_Covered,
         A.N_Contribution,
         A.D_Commencement,
         A.D_Policy_End_Date,
         (SELECT MAX (TRUNC (Y.D_Loan_Drawn))
            FROM Psdt_Loan_Transaction Y, Psmt_Loan_Master X
           WHERE     Y.N_Loan_Ref_No = X.N_Loan_Ref_No
                 AND X.V_Policy_No = C.V_Policy_No
                 AND X.V_Loan_Cleared = 'N'
                 AND Y.V_Loan_Trans_Cleared = 'N')
            Last_Loan_Drawn_Date,
         (SELECT Y.N_Loan_Drawn
            FROM Psdt_Loan_Transaction Y, Psmt_Loan_Master X
           WHERE     Y.N_Loan_Ref_No = X.N_Loan_Ref_No
                 AND X.V_Policy_No = C.V_Policy_No
                 AND X.V_Loan_Cleared = 'N'
                 AND Y.V_Loan_Trans_Cleared = 'N'
                 AND TRUNC (Y.D_Loan_Drawn) =
                        (SELECT MAX (TRUNC (Z.D_Loan_Drawn))
                           FROM Psdt_Loan_Transaction Z
                          WHERE Z.N_Loan_Ref_No = Y.N_Loan_Ref_No)
                 AND ROWNUM = 1)
            Last_Loan_Drawn_Amt,
         Jhl_Gen_Pkg.Get_Loan_Amount (A.V_Policy_No) Loan_Drawn,
         Loan_Due_Amt,
         Jhl_Gen_Pkg.Get_Loan_Repaid (A.V_Policy_No) Loan_Repaid,
         Loan_Int_Amt,
         Jhl_Gen_Pkg.Get_Intr_Repaid (A.V_Policy_No) Interest_Repaid,
         (SELECT TRUNC (D_Start_Date)
            FROM Psmt_Policy_Apl K
           WHERE     K.V_Policy_No = C.V_Policy_No
                 AND V_Apl_Cleared = 'N'
                 AND ROWNUM = 1)
            D_Apl_Start_Date,
         Apl_Due_Amt,
         Apl_Int_Amt,
         (SELECT Amount
            FROM Jhl_Amounts_V3 L
           WHERE L.V_Policy_No = C.V_Policy_No AND ROWNUM = 1)
            Csv_Amount
    FROM Gnmt_Policy A,
         Gnmt_Customer_Master B,
         (SELECT A.V_Policy_No,
                 (SELECT V_Loan_Bal
                    FROM Jhl_Loan_Out_Dtls B
                   WHERE B.V_Policy_No = A.V_Policy_No AND ROWNUM = 1)
                    Loan_Due_Amt,
                 (SELECT V_Loan_Int
                    FROM Jhl_Loan_Out_Dtls B
                   WHERE B.V_Policy_No = A.V_Policy_No AND ROWNUM = 1)
                    Loan_Int_Amt,
                 (SELECT V_Due_Apl
                    FROM Jhl_Apl_Out_Dtls B
                   WHERE B.V_Policy_No = A.V_Policy_No AND ROWNUM = 1)
                    Apl_Due_Amt,
                 (SELECT V_Due_Apl_Int
                    FROM Jhl_Apl_Out_Dtls B
                   WHERE B.V_Policy_No = A.V_Policy_No AND ROWNUM = 1)
                    Apl_Int_Amt
            FROM Gnmt_Policy A
           WHERE A.V_Policy_No IN (SELECT DISTINCT V_Policy_No
                                     FROM Jhl_Loan_Out_Dtls
                                   UNION
                                   SELECT DISTINCT V_Policy_No
                                     FROM Jhl_Apl_Out_Dtls)) C
   WHERE     A.N_Payer_Ref_No = B.N_Cust_Ref_No
         AND A.V_Policy_No = C.V_Policy_No
        -- AND TO_CHAR( A.D_Policy_End_Date, 'MON-YY') = 'JAN-24'
         AND TRUNC( A.D_Policy_End_Date) BETWEEN '01-JAN-2024' AND '31-JAN-2024'
        -- AND EXTRACT(YEAR FROM A.D_Policy_End_Date) >= 2023
         --AND Jhl_Gen_Pkg.Get_Loan_Repaid (A.V_Policy_No) IS NOT NULL
--And A.V_Cntr_Stat_Code = 'NB010'
--AND A.V_Policy_No = 'IL201400364362'
GROUP BY A.V_Policy_No,
         B.V_Name,
         A.V_Cntr_Stat_Code,
         A.V_Cntr_Prem_Stat_Code,
         A.N_Sum_Covered,
         A.N_Contribution,
         D_Commencement,
         A.D_Policy_End_Date,
         Loan_Due_Amt,
         Loan_Int_Amt,
         C.V_Policy_No,
         Apl_Due_Amt,
         Apl_Int_Amt