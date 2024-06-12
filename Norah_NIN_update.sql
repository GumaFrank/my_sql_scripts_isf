/*
Author   Frank Bagambe and Paul Denis Kiyingyi
Date 18-JAN-2024
Description   Norah needs to update National ID for all Customers whose National ID  is missing
*/

DECLARE
    CURSOR customer_cursor IS
        SELECT DISTINCT POLICY.N_PROPOSER_REF_NO AS N_CUST_REF_NO,
               (SELECT V_IDEN_NO FROM GNDT_CUSTOMER_IDENTIFICATION 
                WHERE N_CUST_REF_NO = POLICY.N_PROPOSER_REF_NO AND V_IDEN_CODE IN ('PIN') 
                FETCH FIRST 1 ROWS ONLY) AS PIN,
               (SELECT V_IDEN_NO FROM GNDT_CUSTOMER_IDENTIFICATION 
                WHERE N_CUST_REF_NO = POLICY.N_PROPOSER_REF_NO AND V_IDEN_CODE IN ('NIC') 
                FETCH FIRST 1 ROWS ONLY) AS NIC
        FROM GNMT_POLICY POLICY
        JOIN GNMM_POLICY_STATUS_MASTER POL_STATUS ON POLICY.V_CNTR_STAT_CODE = POL_STATUS.V_STATUS_CODE
        WHERE N_PROPOSER_REF_NO  IN (39874); -- Restrict to one record for testing

    cust_record customer_cursor%ROWTYPE;
    v_exists NUMBER;
BEGIN
    OPEN customer_cursor;

    LOOP
        FETCH customer_cursor INTO cust_record;
        EXIT WHEN customer_cursor%NOTFOUND;

        IF cust_record.NIC IS NULL AND cust_record.PIN IS NOT NULL THEN
            -- Check if a NIC record already exists for this customer
            SELECT COUNT(*) INTO v_exists FROM GNDT_CUSTOMER_IDENTIFICATION 
            WHERE N_CUST_REF_NO = cust_record.N_CUST_REF_NO AND V_IDEN_CODE = 'NIC';

            IF v_exists = 0 THEN
                INSERT INTO GNDT_CUSTOMER_IDENTIFICATION (N_CUST_REF_NO, V_IDEN_CODE, V_IDEN_NO, D_ISSUE, D_EXPIRY, V_STATUS, V_LASTUPD_USER, V_LASTUPD_PROG, V_LASTUPD_INFTIM) 
                VALUES (cust_record.N_CUST_REF_NO, 'NIC', cust_record.PIN, NULL, NULL, 'A', 'FBAGAMBE', 'CUSTOMER', SYSDATE);
            END IF;
        END IF;
    END LOOP;

    CLOSE customer_cursor;
END;

commit 