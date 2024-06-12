/*
Author  Frank Bagambe
Kyc Pension
*/

SELECT  DISTINCT 
 CODE as scheme_code,
  MEMBERNO, 
 (select SCHEMENAME from  gpnc_scheme where SCHEMECODE=CODE) SCHEMENAME,
  (select EMAIL from  gpnc_scheme where SCHEMECODE=CODE) email,
   (select CONTACTPERSON from  gpnc_scheme where SCHEMECODE=CODE) contactperson,
    (select PHONE from  gpnc_scheme where SCHEMECODE=CODE) phone,
     (select PHONE from  gpnc_scheme where SCHEMECODE=CODE) phone,
 MEMBERNAME, 
 MEMBERSTATUS, 
 POLICYNO,
 broker_code,
 (select INTERMEDIARYNAME from gpnc_intermediaryreg where  INTERMEDIARYCODE = broker_code) Agent_name,
 (select INTERMEDIARYTYPE from gpnc_intermediaryreg where  INTERMEDIARYCODE = broker_code) Intermediary_type
 FROM 
 (
select 
SCHEMECODE as CODE,
--select SCHEMENAME from  gpnc_scheme where 
 MEMBERNO, 
 MEMBERNAME, 
 MEMBERSTATUS, 
 POLICYNO,
 BROKERCODE as broker_code
from gpnc_member
WHERE MEMBERSTATUS = 'A'
) --where rownum<=9





select * from gpnc_scheme
EMAIL
CONTACTPERSON
PHONE
select * from  gpnc_scheme
select * from gpnc_member where BROKERCODE = 49208
select * from gpnc_intermediaryreg
select distinct INTERMEDIARYTYPE from gpnc_intermediaryreg INTERMEDIARYCODE

BROKERCODE

select INTERMEDIARYNAME from gpnc_intermediaryreg where 

select * from gpnc_intermediaryreg

select * from  gpnc_member

--select * from gpnc_member