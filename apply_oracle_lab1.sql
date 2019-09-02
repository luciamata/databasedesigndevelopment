


-- Call the clean up script
@@/home/student/Data/cit225/oracle/lib1/utility/cleanup_oracle.sql

-- Call the create script
@@/home/student/Data/cit225/oracle/lib1/create/create_oracle_store2.sql

SPOOL apply_oracle_lab1.txt

SELECT   table_name
FROM     user_tables
WHERE    table_name NOT IN ('EMP','DEPT')
AND NOT  table_name LIKE 'DEMO%'
AND NOT  table_name LIKE 'APEX%'
ORDER BY table_name;

SPOOL OFF 
