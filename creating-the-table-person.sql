CREATE TABLE person (
    person_id RAW(16) DEFAULT sys_guid() PRIMARY KEY,  -- UUID for the primary key
    first_name VARCHAR2(1000) NOT NULL,               -- First name, must not be null
    middle_name VARCHAR2(1000),                       -- Middle name
    last_name VARCHAR2(1000) NOT NULL,                -- Last name, must not be null
    suffix VARCHAR2(1000),                            -- Suffix (e.g., Jr., Sr.)
    gender_string VARCHAR2(4000) NOT NULL,            -- Gender as a string, must not be null
    gender_id RAW(16),                                -- Foreign key referencing the gender table
    username VARCHAR2(1000) NOT NULL,                 -- Username, must be unique and not null
    birth_date TIMESTAMP(9) WITH TIME ZONE,           -- Birth date with time zone
    physical_address_string VARCHAR2(4000),           -- Physical address
    email_address_string VARCHAR2(1000),              -- Email address, must be unique
    phone_number_string VARCHAR2(4000) NOT NULL,      -- Phone number, must not be null
    description VARCHAR2(4000),                       -- Description of the person
    
    note VARCHAR2(4000),                              -- Note for specific record
    date_created TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9), -- Date created
    date_updated TIMESTAMP WITH TIME ZONE,            -- Date modified, set via trigger
    date_created_or_updated TIMESTAMP WITH TIME ZONE 
        GENERATED ALWAYS AS (COALESCE(date_updated, date_created)) VIRTUAL, -- Virtual column for date

    -- Unique constraint on the combination of first, middle, last name, and suffix
    CONSTRAINT unique_name_combination UNIQUE (first_name, middle_name, last_name, suffix),
    
    -- Foreign key constraint referencing the gender table
    CONSTRAINT fk_gender FOREIGN KEY (gender_id) REFERENCES gender (gender_id),

    -- Ensure username is unique
    CONSTRAINT unique_username UNIQUE (username),

    -- Ensure email address is unique
    CONSTRAINT unique_email_address UNIQUE (email_address_string)
);

-- Create a trigger to update the date_updated field before any update
CREATE OR REPLACE TRIGGER trg_person_date_updated
BEFORE UPDATE ON person
FOR EACH ROW
BEGIN
    :NEW.date_updated := systimestamp;
END;
/
CREATE OR REPLACE TRIGGER trg_set_gender_id_from_string
BEFORE INSERT OR UPDATE ON person
FOR EACH ROW
BEGIN
    -- Check if gender_string is set and update gender_id based on exact case-insensitive regex match
    IF :NEW.gender_string IS NOT NULL THEN
        -- Look up the gender_id from the gender table using exact case-insensitive regex
        SELECT gender_id
        INTO :NEW.gender_id
        FROM gender
        WHERE REGEXP_LIKE(gender, '^' || :NEW.gender_string || '$', 'i'); -- Case-insensitive exact regex match
    END IF;
END;
/
