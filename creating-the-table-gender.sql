CREATE TABLE gender (
    gender_id RAW(16) DEFAULT sys_guid() PRIMARY KEY,  -- UUID for the primary key
    gender VARCHAR2(4000) NOT NULL,                   -- Gender, must be unique and not null
    description VARCHAR2(4000),                       -- Description of the gender
    
    note VARCHAR2(4000),                              -- Note for specific record
    date_created TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9), -- Date created
    date_updated TIMESTAMP WITH TIME ZONE,            -- Date modified, set via trigger
    date_created_or_updated TIMESTAMP WITH TIME ZONE 
        GENERATED ALWAYS AS (COALESCE(date_updated, date_created)) VIRTUAL  -- Virtual column for date
);

-- Ensure gender is unique
ALTER TABLE gender ADD CONSTRAINT unique_gender UNIQUE (gender);

-- Create a trigger to update the date_updated field before any update
CREATE OR REPLACE TRIGGER trg_gender_date_updated
BEFORE UPDATE ON gender
FOR EACH ROW
BEGIN
    :NEW.date_updated := systimestamp;
END;
/
