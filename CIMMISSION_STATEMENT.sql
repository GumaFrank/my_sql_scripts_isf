/* Formatted on 11/05/2022 12:45:59 (QP5 v5.256.13226.35538) teddy */
--commission Statement
----------------------------

  SELECT V_Agent_Code,
         V_Name,
         Designation,
         Agency,
         Trans_Date,
         Trans_Date2,
         V_Policy_No,
         N_Seq_No,
         V_Plan_Desc,
         Assured_Name,
         Policy_Year,
         D_Premium_Due,
         V_Override,
         Sub_Agent_Code,
         V_PYMT_FREQ,
         SUM (Premium_Amt) Premium_Amt,
         SUM (N_Comm_Amt) N_Comm_Amt,
         SUM (N_Wht) N_Wht,
         SUM (N_Net_Comm) N_Net_Comm,
         A.V_Receipt_No Receipt_No
    FROM (SELECT A.N_Agent_No,
                 V_Agent_Code,
                 D.V_Name,
                 V_Description Designation,
                 NULL Agency,
                 b.V_PYMT_FREQ,
                 A.V_Plan_Code,
                 J.V_Plan_Desc,
                 D_Comm_Gen Trans_Date,
                 G.D_Trans_Date Trans_Date2,
                 A.V_Policy_No,
                 A.N_Seq_No,
                 B.V_Name Assured_Name,
                 N_Comm_Year Policy_Year,
                 D_Premium_Due,
                 N_Prem_Amt Premium_Amt,
                 V_Receipt_No,
                 N_Comm_Amt,
                 N_Comm_Rate,
                 NVL (V_Income_Tax_Rule_Ref, 0) / 100 * N_Comm_Amt N_Wht,
                 N_Comm_Amt - NVL (V_Income_Tax_Rule_Ref, 0) / 100 * N_Comm_Amt
                    N_Net_Comm,
                 V_Oc_Flag V_Override,
                 Bpg_Agency.Bfn_Get_Agent_Code (N_Sub_Agent_No) Sub_Agent_Code
            FROM Ammt_Pol_Comm_Detail A,
                 Gnmt_Policy_Detail B,
                 Ammm_Agent_Master C,
                 Gnmt_Customer_Master D,
                 --GNDT_CUSTOMER_ADDRESS e,
                 Ammm_Rank_Master F,
                 Amdt_Agent_Benefit_Pool_Detail G,
                 Amdt_Agent_Bene_Pool_Payment H,
                 Gnmm_Plan_Master J
           WHERE     V_Comm_Status IN ('P')
                 AND A.V_Policy_No = B.V_Policy_No
                 AND A.N_Seq_No = B.N_Seq_No
                 AND A.N_Agent_No = C.N_Agent_No
                 AND C.N_Cust_Ref_No = D.N_Cust_Ref_No
                 --AND c.N_CUST_REF_NO = e.N_CUST_REF_NO
                 AND C.V_Rank_Code = F.V_Rank_Code
                 AND C.N_Channel_No = F.N_Channel_No
                 --AND D_Voucher_Date BETWEEN '14-APR-2012' AND '16-MAY-2012'
                 --AND D_Voucher_Date BETWEEN :From_date AND :To_Date
                 
                 AND H.D_Trans_Date BETWEEN ( :P_FM_DT) AND ( :P_TO_DT) --05/02/2018-04/03/2018
                 
                 AND G.V_Trans_Source_Code IN ('COMMISSION',
                                               'COMMISSION REVERSAL')
                 --AND D_VOUCHER_DATE BETWEEN TO_DATE(?,'DD/MM/YYYY') AND TO_DATE(?,'DD/MM/YYYY')
                 -- AND V_AGENT_CODE = '11969'
                 ---AND A.V_Policy_No NOT LIKE 'GL%'
                 --AND A.V_POLICY_NO = '11969'
                 --AND e.N_ADD_SEQ_NO=1
                 AND V_Accounted = 'Y'
                 AND A.V_Plan_Code = J.V_Plan_Code
                 AND A.N_Comm_Benefit_Pool_Seq_No = G.N_Benefit_Pool_Seq_No
                 ---AND TO_CHAR (A.N_Comm_Paid_Seq) = G.V_Trans_Source_Ref_No
                 AND G.N_Benefit_Pool_Pay_Seq(+) = H.N_Benefit_Pool_Pay_Seq
                 --AND EXTRACT(YEAR FROM D_VOUCHER_DATE)>= 2023
                 )a
GROUP BY V_Agent_Code,
         V_Name,
         Designation,
         Agency,
         Trans_Date,
         Trans_Date2,
         V_Policy_No,
         N_Seq_No,
         V_Receipt_No,
         V_Plan_Desc,
         Assured_Name,
         Policy_Year,
         D_Premium_Due,
         V_Override,
         Sub_Agent_Code,
         V_PYMT_FREQ
ORDER BY V_Policy_No