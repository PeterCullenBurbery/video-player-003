select * from Kingdom_Rush.level_stage;
delete from Kingdom_Rush.level_stage;
create user no_write_instead_read_only1 identified by 1234;

select level_completion_id from Kingdom_Rush.level_completion fetch next 1 rows only;

ALTER SESSION SET CURRENT_SCHEMA = Kingdom_Rush;

select level_completion_id from level_completion fetch next 1 rows only;

SELECT
    level_completion_id
FROM
         level_completion lc
    JOIN level_stage ls ON lc.level_stage_id = ls.level_stage_id
WHERE
    REGEXP_LIKE ( ls.level_stage,
                  'Grimmsburg',
                  'i' );