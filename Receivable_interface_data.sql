select * from JHL_OFA_GL_INTERFACE where GROUP_ID = 6738252;
select * from JHLISFADMIN.JHL_OFA_NON_RCT_GL_INTER where GROUP_ID = 6738252;

select * from JHL_OFA_GL_INTERFACE WHERE SET_OF_BOOKS_ID ='2028'


select * from JHL_OFA_GL_INTERFACE 
WHERE 
    TO_DATE(ACCOUNTING_DATE, 'DD/MM/RRRR') IN (
        DATE '2023-01-09', 
        DATE '2023-02-24', 
        DATE '2023-02-18', 
        DATE '2023-02-01', 
        DATE '2023-03-10', 
        DATE '2023-03-30', 
        DATE '2023-04-04', 
        DATE '2023-04-27', 
        DATE '2023-05-04', 
        DATE '2023-05-31', 
        DATE '2023-06-12', 
        DATE '2023-06-20', 
        DATE '2023-07-02', 
        DATE '2023-07-29', 
        DATE '2023-08-03', 
        DATE '2023-08-11', 
        DATE '2023-09-05', 
        DATE '2023-09-06', 
        DATE '2023-10-29', 
        DATE '2023-11-01', 
        DATE '2023-11-30', 
        DATE '2023-12-08', 
        DATE '2023-12-16', 
        DATE '2023-12-31'
    )
    
    SELECT * FROM JHL_OFA_NON_RCT_GL_INTER WHERE SET_OF_BOOKS_ID = 2088
    AND 
    TO_DATE(ACCOUNTING_DATE, 'DD/MM/RRRR') IN (
        DATE '2023-01-09', 
        DATE '2023-02-24', 
        DATE '2023-02-18', 
        DATE '2023-02-01', 
        DATE '2023-03-10', 
        DATE '2023-03-30', 
        DATE '2023-04-04', 
        DATE '2023-04-27', 
        DATE '2023-05-04', 
        DATE '2023-05-31', 
        DATE '2023-06-12', 
        DATE '2023-06-20', 
        DATE '2023-07-02', 
        DATE '2023-07-29', 
        DATE '2023-08-03', 
        DATE '2023-08-11', 
        DATE '2023-09-05', 
        DATE '2023-09-06', 
        DATE '2023-10-29', 
        DATE '2023-11-01', 
        DATE '2023-11-30', 
        DATE '2023-12-08', 
        DATE '2023-12-16', 
        DATE '2023-12-31'
    )