select trunc(CREATED_ON) EffectiveDate, MEMBERNO,MEMBERSTATUS,
MEMBERNAME,IDNUMBER,KRAPIN,TELEPHONE,EMAIL,COUNTRY 
from DAUG.gpnc_member --where SCHEMECODE = '100999' and MEMBERSTATUS = 'A'