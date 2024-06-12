begin
    declare
        cursor c1 is

            SELECT V_VOU_DESC, V_VOU_NO, D_VOU_DATE
            FROM PYMT_VOUCHER_ROOT PM, PYMT_VOU_MASTER PV
            WHERE     PM.V_MAIN_VOU_NO = PV.V_MAIN_VOU_NO
              AND TO_DATE (D_VOU_DATE, 'DD/MM/RRRR') BETWEEN TO_DATE (
                    '01-JAN-23',
                    'DD/MM/RRRR')
                and sysdate
              AND JHL_GEN_PKG.IS_VOUCHER_CANCELLED (V_VOU_NO) = 'N'
              AND JHL_GEN_PKG.IS_VOUCHER_AUTHORIZED (V_VOU_NO) = 'Y'
        and V_VOU_NO not in ('2023012673');


    begin
        for i in c1 loop
                JHL_OFA_UTILS_1.JHL_OFA_TRANSFORM_GL_VOU(i.V_VOU_NO);
            end loop;
    end;
end;

commit;
