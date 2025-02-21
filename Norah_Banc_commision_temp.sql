SELECT 
    A.N_AGENT_NO,
    DECODE(A.N_AGENT_NO,
        '4962', 'DIAMOND TRUST BANK',
        '4963', 'I AND M BANK',
        '4964', 'ABSA BANK UGANDA LIMITED',
        '4972', 'UNITED BANK FOR AFRICA',
        '4973', 'FINANCE TRUST BANK',
        '4974', 'KCB BANK',
        '4977', 'EXIM BANK',
        '5383', 'CENTENARY BANK',
        '6275', 'ECOBANK UGANDA LIMITED',
        '6504', 'DFCU BANK',
        '6644', 'POSTBANK UGANDA LTD',
        '7625', 'BANK OF AFRICA UGANDA LIMITED',
        '7889', 'EQUITY BANK UGANDA LIMITED',
        '8109', 'NCBA BANK',
        '8128', 'HOUSING FINANCE BANK LIMITED'
    ) AS BANK,
    A.V_POLICY_NO,
    D.V_PROPOSER_NAME,
    A.N_AGENT_NO,
    A.D_COMM_GEN,
    A.D_RECEIPT,
    A.N_COMM_AMT,
    A.N_COMM_YEAR,
    A.V_RECEIPT_NO,
    A.V_EARNED_RANK
FROM 
    AMMT_POL_COMM_DETAIL A
INNER JOIN 
    GNMT_POLICY D ON D.V_POLICY_NO = A.V_POLICY_NO
WHERE 
    TO_DATE(A.D_COMM_GEN, 'DD/MM/RRRR') BETWEEN TO_DATE('09-JAN-24', 'DD/MM/RRRR') AND TO_DATE('31-JAN-24', 'DD/MM/RRRR')
    AND A.N_AGENT_NO IN ('4962', '4963', '4964', '4972', '4973', '4974', '4977', '5383', '6275', '6504', '6644', '7625', '7889', '8109', '8128')
