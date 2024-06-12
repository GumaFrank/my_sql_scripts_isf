/*
Author Frank bagambe
Des ISF users

*/

SELECT 
v_username,
USER_Account_Status,
ACCOUNT_STATUS,
lock_date,
creation_date
 FROM 
(
select  
(select V_USER_NAME from gnmt_user  where V_USER_NAME=USERNAME and V_USER_ID not in ('JHLISFUADM')) v_username,
(select V_STAT from gnmt_user where V_USER_NAME=USERNAME and V_USER_ID not in ('JHLISFUADM')) USER_Account_Status,
--USERNAME, 
ACCOUNT_STATUS,
lock_date,
creation_date
from 
(
Select 
USERNAME, ACCOUNT_STATUS, trunc(LOCK_DATE) lock_date, trunc(CREATED) creation_date
from  DBA_USERS)
)
where v_username is not null 
ORDER BY 5 DESC