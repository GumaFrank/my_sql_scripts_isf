select * from gndt_bill_trans
where  V_BILL_NO ='DN2437942'

--24 209 5307.54

select * from gndt_bill_ind_dets where v_policy_no='UI201700249601' and v_rec_status<>'R' order by 4;
select * from psmt_policy_revival where v_policy_no='UI201700249601'   order by 4;
select * from psdt_redate_detail where v_policy_no='UI201700249601'   order by 4;
select * from ppmt_overshort_payment where v_policy_no='UI201700249601'   order by 4;


COMMIT

Link https://isfprod.jubileekenya.com:9005/forms/frmservlet?config=jhlkeprod
Username CNAMUGERWA@JHLUGPROD
Password  FreeUganda2DAY456$# 

SELECT * FROM DBA_USERS WHERE USERNAME = 'LMARVIN'
SELECT * FROM DBA_USERS WHERE USERNAME = 'JNALUSIBA'

CREATE USER CNAMUGERWA IDENTIFIED BY FreeUganda2DAY456$#1224 DEFAULT TABLESPACE JHLISFUPROD_DATA
TEMPORARY TABLESPACE TEMP ACCOUNT UNLOCK;  --PASSWORD EXPIRE;

--ALTER USER SGACHIE IDENTIFIED BY ORACLE438 ACCOUNT UNLOCK PASSWORD EXPIRE

--ALTER USER JKARASHA IDENTIFIED BY oraclejhl660 ACCOUNT UNLOCK PASSWORD EXPIRE

GRANT CONNECT, RESOURCE, SELECT_CATALOG_ROLE, QUERY REWRITE,CREATE TABLE, CREATE VIEW,  
RFORALLOBJECTS, RNORMAL TO CNAMUGERWA;

Insert into GNMT_USER
   (V_USER_ID, V_PASSWORD, D_PASSWORD_EXP, V_USER_NAME, V_USER_TYPE, 
    V_BRANCH_CODE, V_STAT, D_STAT_ASAT, V_LASTUPD_USER, V_LASTUPD_PROG, 
    D_LASTUPD_INFTIM, D_VALID_FROM, D_VALID_TO, N_PASSWORD_VALID_DAYS, V_EMP_ID, 
    V_EMP_DESIGNATION, X_LASTUPD_USER, X_LASTUPD_PROG, X_LASTUPD_INFTIM, V_DESIG_CODE, 
    V_GROUP, V_COMPANY_CODE, V_VIEW_PENDING, V_EMAIL, V_DEPT_CODE, 
    V_FORM_ROLE, N_AGENT_NO, V_STRING_LANG_PREFERENCE, V_SIGNATURE, N_SECURITY_LEVEL, 
    V_ARABIC_NAME, V_ARABIC_USER_NAME)
Values
   ('CNAMUGERWA', NULL, NULL, 'CNAMUGERWA', NULL, 
    'HO', 'A', NULL, 'LIFEUAT', 'SQL', 
    SYSDATE, NULL, NULL, NULL, '2', 
    NULL, NULL, NULL, NULL, 'TL', 
    'JIC', NULL, NULL, NULL, 'BD', 
    NULL, NULL, 'EN', NULL, NULL, 
    NULL, NULL);

SELECT * FROM  JHL_USER_ROLE where V_USER_NAME like 'BABEJA'
SELECT * FROM  JHL_USER_ROLE where V_USER_NAME like 'FBOSANA'
SELECT * FROM  JHL_USER_ROLE where V_USER_NAME like 'EOGWANG'

SELECT * FROM  JHL_USER_ROLE where V_USER_NAME like 'LMARVIN'
SELECT * FROM  JHL_USER_ROLE where V_USER_NAME like 'EOGWANG'

INSERT INTO JHL_USER_ROLE
SELECT 'CNAMUGERWA' V_USER_NAME, V_ROLE_NAME, V_ROLE_TYPE, V_TABLESPACE
FROM JHL_USER_ROLE
WHERE V_USER_NAME = 'BKAIGWA'

INSERT INTO JHL_USER_ROLE (V_USER_NAME, V_ROLE_NAME, V_ROLE_TYPE, V_TABLESPACE)
SELECT 'EOGWANG', V_ROLE_NAME, V_ROLE_TYPE, V_TABLESPACE
FROM JHL_USER_ROLE
WHERE V_USER_NAME LIKE 'BABEJA%'



SELECT * FROM GNMT_USER WHERE  V_USER_ID IN ('FBOSANA', 'EOGWANG')
SELECT * FROM GNMM_BRANCH_SERVER WHERE V_USER_ID IN ('EOGWANG', 'FBOSANA')

Insert into GNMM_BRANCH_SERVER
   (V_BRANCH_CODE, V_SERVER_CODE, V_USER_ID, V_USER_NAME, V_LASTUPD_USER, 
    V_LASTUPD_PROG, D_LASTUPD_INFTIM)
Values
   ('HO', NULL, 'CNAMUGERWA', 'Namugerwa Charlote', 'JHLISFADMIN', 
    'SECURITY', SYSDATE);

SELECT * FROM GNMM_BRANCH_SERVER WHERE V_USER_ID IN ('EOGWANG', 'TNAMUGERWA')
SELECT * FROM GNMM_BRANCH_SERVER WHERE V_USER_ID IN ('EOGWANG', 'NTHERESA')

-- COPYING ROLES FROM ONE USER TO ANOTHER
SELECT * FROM GNDT_USER_PROG_EXCEPTION WHERE V_USER_ID = 'NTHERESA'
SELECT * FROM GNDT_USER_PROG_EXCEPTION WHERE V_USER_ID = 'BMUWANGA'

INSERT INTO GNDT_USER_PROG_EXCEPTION (V_USER_ID, V_PROG_ID, V_ADD_SUSPEND, V_STATUS, V_REASON, D_EFFECTIVE_FROM, D_EFFECTIVE_TO, V_REQUESTED_BY, V_LASTUPD_USER, D_LASTUPD_INFTIM, V_LASTUPD_PROG, V_MENU_NAME, V_TYPE)
SELECT 'BMUWANGA',  V_PROG_ID, V_ADD_SUSPEND, V_STATUS, V_REASON, D_EFFECTIVE_FROM, D_EFFECTIVE_TO, V_REQUESTED_BY, V_LASTUPD_USER, D_LASTUPD_INFTIM, V_LASTUPD_PROG, V_MENU_NAME, V_TYPE FROM GNDT_USER_PROG_EXCEPTION 
WHERE V_USER_ID = 'NTHERESA' and V_PROG_ID NOT IN ('AM_FRM_02')

INSERT INTO GNDT_USER_PROG_EXCEPTION
 (SELECT * FROM GNDT_USER_PROG_EXCEPTION WHERE V_USER_ID = 'NTHERESA')
 WHERE V_USER_ID = 'BMUWANGA'

INSERT INTO JHL_USER_ROLE (V_USER_NAME, V_ROLE_NAME, V_ROLE_TYPE, V_TABLESPACE)
SELECT 'EOGWANG', V_ROLE_NAME, V_ROLE_TYPE, V_TABLESPACE
FROM JHL_USER_ROLE
WHERE V_USER_NAME LIKE 'BABEJA%'


COMMIT 
SELECT * FROM 
EDIT GNMM_BRANCH_SERVER WHERE V_USER_ID IN ('BMUWANGA', 'FBOSANA')

EXEC JHL_SEC_MATRIX_SINGLE('EOGWANG');

COMMIT

commit

--SELECT ROWID, A.* FROM GNDT_UM_USER_PRIVS_TASK A WHERE V_USER_NAME = 'LCHEBET'

--CHANGE ROLE
SELECT ROWID, A.* FROM GNDT_UM_USER_PRIVS_TASK A
--WHERE V_GRANTROLE_NAME = 'R050'
WHERE V_USER_NAME LIKE '%FBOSANA%'
SELECT ROWID, A.* FROM GNDT_UM_USER_PRIVS_TASK A where V_GRANTROLE_NAME ='R2010'

SELECT ROWID, A.* FROM GNDT_UM_USER_PRIVS_TASK A
--WHERE V_GRANTROLE_NAME = 'R050'
WHERE V_USER_NAME LIKE '%EOGWANG%'  --1302

R090
RFORALLOBJECTS
RNORMAL


COMMIT 



SELECT * FROM 
EDIT GNMT_USER WHERE V_USER_ID IN ('EOGWANG', 'FBOSANA')