CREATE TABLE play_mode (
    play_mode_id RAW(16) DEFAULT sys_guid() PRIMARY KEY,  -- UUID for the primary key
    play_mode VARCHAR2(4000) NOT NULL,                    -- Play mode, must be unique and not null
    description VARCHAR2(4000),                          -- Description of the play mode
    
    note VARCHAR2(4000),                                 -- Note for specific record
    date_created TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9), -- Date created
    date_updated TIMESTAMP WITH TIME ZONE,               -- Date modified, set via trigger
    date_created_or_updated TIMESTAMP WITH TIME ZONE 
        GENERATED ALWAYS AS (COALESCE(date_updated, date_created)) VIRTUAL  -- Virtual column for date
);

-- Ensure play_mode is unique
ALTER TABLE play_mode ADD CONSTRAINT unique_play_mode UNIQUE (play_mode);

-- Create a trigger to update the date_updated field before any update
CREATE OR REPLACE TRIGGER trg_play_mode_date_updated
BEFORE UPDATE ON play_mode
FOR EACH ROW
BEGIN
    :NEW.date_updated := systimestamp;
END;
/

























CREATE TABLE difficulty (
    difficulty_id RAW(16) DEFAULT sys_guid() PRIMARY KEY,  -- UUID for the primary key
    difficulty VARCHAR2(4000) NOT NULL,                   -- Difficulty level, must be unique and not null
    description VARCHAR2(4000),                           -- Description of the difficulty level
    
    note VARCHAR2(4000),                                  -- Note for specific record
    date_created TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9), -- Date created
    date_updated TIMESTAMP WITH TIME ZONE,                -- Date modified, set via trigger
    date_created_or_updated TIMESTAMP WITH TIME ZONE 
        GENERATED ALWAYS AS (COALESCE(date_updated, date_created)) VIRTUAL  -- Virtual column for date
);

-- Ensure difficulty is unique
ALTER TABLE difficulty ADD CONSTRAINT unique_difficulty UNIQUE (difficulty);

-- Create a trigger to update the date_updated field before any update
CREATE OR REPLACE TRIGGER trg_difficulty_date_updated
BEFORE UPDATE ON difficulty
FOR EACH ROW
BEGIN
    :NEW.date_updated := systimestamp;
END;
/
