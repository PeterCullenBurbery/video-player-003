create user no_write_instead_read_only identified by 1234;
GRANT CREATE SESSION TO no_write_instead_read_only;
GRANT SELECT ANY TABLE TO no_write_instead_read_only;


select level_completion_id from level_completion fetch next 1 rows only;