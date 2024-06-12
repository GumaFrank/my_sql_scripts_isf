--Re_insurance Outstanding Claims 
--UGA

--select distinct v_reinsurer_code  from ridt_claim_ri_provision

WITH cte_all_ri AS (
    SELECT
        a.v_claim_no,
        a.n_sub_claim_no,
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

--WHERE
--    v_claim_no = 'CL20218518'
), cte_retention AS (
    SELECT
        *
    FROM
        cte_all_ri PIVOT (
            SUM ( n_total_provision ) as liability
        
            FOR v_reinsurer_code
            IN ( 'JIC' jicu, 'AFRE' afre, 'KEN' kenya_re, 'PTA' pta_re, 'CON' continental_re, 'EAR' east_afr_re , 'UGA' uganda_re)
        )
    ORDER BY
        1
)
SELECT
    a.v_claim_no,
    i.n_sub_claim_no,
    c.v_policy_no,
    d.v_company_name,
    v_client_name,
    h.v_plan_desc,
    f.v_event_desc,
    d_event_date,
    a.d_claim_date,
    a.d_intimation,
    b.n_amount_payb,
    decode(upper(e.v_status_desc), 'PENDING', 're-opened', e.v_status_desc) v_status_desc,
--       P.V_IDEN_NO AS V_IDEN_NO,P.V_EMP_ID
    jhl_bi_utils.get_emp_id(b.v_policy_no, n_client_ref_no, 'I')            v_iden_no,
    jhl_bi_utils.get_emp_id(b.v_policy_no, n_client_ref_no, 'E')            v_emp_id,
    nvl(jicu_liability, 0)                                                  retention,
    nvl(jicu_liability, 0)                                                  "jicu_liability",
    nvl(afre_liability, 0)                                                  "afre_liability",
    nvl(kenya_re_liability, 0)                                              "kenya_re_liability",
    nvl(pta_re_liability, 0)                                                "pta_re_liability",
    nvl(continental_re_liability, 0)                                        "continental_re_liability",
    nvl(east_afr_re_liability, 0)                                           "east_afr_re_liability",
    nvl(uganda_re_liability, 0)                                           "uganda_re_liability"
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
    cte_retention                   k
WHERE
        a.v_claim_no = b.v_claim_no

    AND b.v_policy_no = c.v_policy_no
    AND c.v_company_code = d.v_company_code
    AND c.v_company_branch = d.v_company_branch
    AND c.v_grp_ind_flag = 'G'
       --and a.V_CLAIM_STATUS = E.V_STATUS_CODE
    AND b.v_event_code = f.v_event_code
    AND b.v_claim_no = g.v_claim_no (+)
    AND b.n_seq_no = g.n_seq_no (+)
    AND b.v_plri_code = h.v_plan_code
    AND b.n_amount_payb > 0
    AND b.v_claim_no = i.v_claim_no
    AND b.n_sub_claim_no = i.n_sub_claim_no
    AND b.v_claim_no = j.v_claim_no
    AND b.v_event_code = j.v_event_code
    AND i.v_status_code = e.v_status_code
    AND i.v_status_code IN ( 'CLST01', 'CLST02' )
    AND a.v_claim_no = k.v_claim_no
    AND i.n_sub_claim_no = k.n_sub_claim_no
    --AND d.v_company_code = nvl(:p_company_code, d.v_company_code)
    --AND f.v_event_code = nvl(:p_event_code, f.v_event_code)
       order by  a.d_claim_date desc, a.v_claim_no,
    i.n_sub_claim_no