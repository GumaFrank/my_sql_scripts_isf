-- for Uganda

WITH py_dtls AS (
    SELECT
        clm.v_claim_no         claim_no,
        clm.n_sub_claim_no     sub_claim_no,
        v_payee_name,
        bnk_dtls.v_bank_code   bank_code,
        bnk_dtls.v_branch_code branch_name,
        v_company_name         bank_name,
        v_account_no           account_no,
        v_iden_no,
        pv.n_cust_ref_no,
        pv.v_vou_no,
        n_vou_amount,
        v_chq_no               eft_chq_no
    FROM
        pymt_vou_master            pv,
        pymt_voucher_root          pr,
        cldt_claimant_master       clm,
        cldt_claimant_detail       clmd,
        pydt_voucher_policy_client vou_pol,
        (
            SELECT
                bnk.v_bank_code,
                bnk.v_branch_code,
                v_company_name,
                bnk.v_account_no,
                bnk.n_cust_ref_no,
                i.v_iden_no
            FROM
                gndt_customer_bank           bnk,
                gnmm_company_master          co_bank,
                gnmt_customer_master         cu,
                gndt_customer_identification i
            WHERE
                    bnk.v_bank_code = co_bank.v_company_code
                AND bnk.v_branch_code = co_bank.v_company_branch
                AND bnk.n_cust_ref_no = cu.n_cust_ref_no (+)
                AND cu.n_cust_ref_no = i.n_cust_ref_no
                AND bnk.v_service_account = 'Y'
                AND bnk.v_account_status = 'A'
        )                          bnk_dtls
    WHERE
            pv.v_main_vou_no = pr.v_main_vou_no
        AND pr.v_source_ref_no = clm.v_claim_no
        AND clm.v_claim_no = clmd.v_claim_no
        AND clm.n_sub_claim_no = clmd.n_sub_claim_no
        AND clm.n_claimant_code = clmd.n_claimant_code
        AND clmd.v_voucher_no = vou_pol.v_policy_client_vou_no
        AND pv.v_vou_no = vou_pol.v_vou_no
        AND pv.n_cust_ref_no = bnk_dtls.n_cust_ref_no (+)
        AND v_vou_source = 'CLAIMS'
), cte_all_ri AS (
    SELECT
        a.v_claim_no,
        a.v_policy_no,
        a.v_plan_code,
        a.v_parent_plan_code,
        a.v_event_code,
        a.v_parent_event_code,
        a.v_ri_policy_no,
   --a.v_treaty_code,
        a.v_reinsurer_code,
        a.n_total_provision
    FROM
             ridt_claim_ri_provision a
        INNER JOIN rimm_retention b ON a.v_treaty_code = b.v_treaty_code
                                       AND a.v_reinsurer_code = b.v_reinsurer_code

), cte_retention AS (
    SELECT
        *
    FROM
        cte_all_ri PIVOT (
            SUM ( n_total_provision )
        liability
            FOR v_reinsurer_code
            IN ( 'JIC' jicu, 'AFRE' afre, 'KEN' kenya_re, 'PTA' pta_re, 'CON' continental_re, 'EAR' east_afr_re, 'UG' uganda_re )
        )
    ORDER BY
        1
)
SELECT DISTINCT
    a.v_claim_no,
    c.v_policy_no,
    d.v_company_code,
    d.v_company_name,
    v_client_name,
    h.V_PLAN_CODE,
    h.v_plan_desc,
    f.v_event_code,
    f.v_event_desc,
    d_event_date,
    a.d_claim_date,
    a.d_intimation,
    b.n_amount_payb,
    e.v_status_desc,
    trunc(i.v_lastupd_inftim)                                                                    claim_paid_date,
    jhl_gen_pkg.get_claim_payment_date(a.v_claim_no, b.n_amount_payb, trunc(i.v_lastupd_inftim)) payment_date,
    c.N_TERM,
    n_client_ref_no,
    jhl_bi_utils.get_emp_id(c.v_policy_no, n_client_ref_no, 'IDEN')                              v_iden_code,
    jhl_bi_utils.get_emp_id(c.v_policy_no, n_client_ref_no, 'I')                                 v_iden_no,
    jhl_bi_utils.get_emp_id(c.v_policy_no, n_client_ref_no, 'E')                                 v_emp_id,
    n_client_ref_no                                                                              n_cust_ref_no,
    k.v_vou_no
    n_vou_amount,
    eft_chq_no,
    k.v_payee_name,
    k.bank_code,
    k.branch_name,
    k.bank_name,
    k.account_no,
    jhl_gen_pkg.get_voucher_status_user(k.v_vou_no, 'PREPARE')                                   processed_by,
    jhl_gen_pkg.get_voucher_status_user(k.v_vou_no, 'VERIFY')                                    verified_by,
    jhl_gen_pkg.get_voucher_status_user(k.v_vou_no, 'APPROVE')                                   approved_by,
    nvl(jicu_liability, 0)                                                                       retention,
    nvl(jicu_liability, 0)                                                                       jicu_liability,
    nvl(afre_liability, 0)                                                                       afre_liability,
    nvl(kenya_re_liability, 0)                                                                   kenya_re_liability,
    nvl(pta_re_liability, 0)                                                                     pta_re_liability,
    nvl(continental_re_liability, 0)                                                             continental_re_liability,
    nvl(east_afr_re_liability, 0)                                                                east_afr_re_liability,
    nvl(uganda_re_liability, 0)                                                                uganda_re_liability
FROM
    clmt_claim_master            a,
    cldt_claim_event_policy_link b,
    gnmt_policy                  c,
    gnmm_company_master          d,
    clmm_status_master           e,
    gnmm_event_master            f,
    cldt_claim_policy_settlement g,
    gnmm_plan_master             h,
    cldt_claim_event_status_link i,
    cldt_claim_event_link        j,
    py_dtls                      k,
    cte_retention                l
WHERE
        a.v_claim_no = b.v_claim_no
    AND b.v_policy_no = c.v_policy_no
    AND c.v_company_code = d.v_company_code
    AND c.v_company_branch = d.v_company_branch
    AND c.v_grp_ind_flag = 'G'
    AND b.v_event_code = f.v_event_code
    AND b.v_claim_no = g.v_claim_no (+)
    AND b.n_seq_no = g.n_seq_no (+)
    AND b.v_plri_code = h.v_plan_code
    AND b.n_amount_payb > 0
    AND b.v_claim_no = i.v_claim_no
    AND b.n_sub_claim_no = i.n_sub_claim_no
    AND i.v_status_code = e.v_status_code
    AND i.v_status_code = 'CLST04'
    AND b.v_claim_no = j.v_claim_no
    AND b.v_event_code = j.v_event_code
    AND b.v_claim_no = k.claim_no
    AND i.n_sub_claim_no = k.sub_claim_no
    AND a.v_claim_no = l.v_claim_no
    AND f.v_event_code = l.v_event_code
  --  AND a.v_claim_no = 'CL20218518' 

    --AND trunc(i.v_lastupd_inftim) BETWEEN nvl(:p_fm_dt, trunc(i.v_lastupd_inftim)) AND nvl(:p_to_dt, trunc(i.v_lastupd_inftim))
    --AND d.v_company_code = nvl(:p_company_code, d.v_company_code)
   -- AND f.v_event_code = nvl(:p_event_code, f.v_event_code)
   
   order by 11 desc