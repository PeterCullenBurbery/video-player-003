CREATE TABLE level_stage (
    level_stage_id RAW(16) DEFAULT sys_guid() PRIMARY KEY, -- UUID for the primary key
    level_stage VARCHAR2(4000) NOT NULL,                  -- Level stage name, must be unique in combination with game_id and game_string
    game_string VARCHAR2(1000) NOT NULL,                  -- Game string, unique in combination with level_stage
    level_type VARCHAR2(4000) NOT NULL,                   -- Level type, must not be null
    dlc NUMBER(1) DEFAULT 0 NOT NULL,                     -- DLC (boolean), stored as 0 (false) or 1 (true)
    level_number NUMBER NOT NULL,                         -- Level number, must be unique, an integer, and >= 1
    test_level NUMBER(1) DEFAULT 0 NOT NULL,              -- Test level (boolean), stored as 0 (false) or 1 (true)
    game_id RAW(16),                                      -- Game ID, references game table, may be null

    note VARCHAR2(4000),                                  -- Note for specific record
    date_created TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9), -- Date created
    date_updated TIMESTAMP WITH TIME ZONE,                -- Date modified, set via trigger
    date_created_or_updated TIMESTAMP WITH TIME ZONE 
        GENERATED ALWAYS AS (COALESCE(date_updated, date_created)) VIRTUAL  -- Virtual column for date
);

-- Ensure the combination of level_stage and game_id is unique
ALTER TABLE level_stage ADD CONSTRAINT unique_level_stage_game_id UNIQUE (level_stage, game_id);

-- Ensure the combination of level_stage and game_string is unique
ALTER TABLE level_stage ADD CONSTRAINT unique_level_stage_game_string UNIQUE (level_stage, game_string);

-- Ensure level_number is unique
ALTER TABLE level_stage ADD CONSTRAINT unique_level_number UNIQUE (level_number);

-- Add check constraint to ensure level_number is a positive integer
ALTER TABLE level_stage ADD CONSTRAINT check_level_number_positive
CHECK (level_number >= 1 AND level_number = TRUNC(level_number));

-- Add check constraint to ensure test_level is either 0 (false) or 1 (true)
ALTER TABLE level_stage ADD CONSTRAINT check_test_level_positive
CHECK (test_level IN (0, 1));

-- Add check constraint to ensure dlc is either 0 (false) or 1 (true)
ALTER TABLE level_stage ADD CONSTRAINT check_dlc_boolean
CHECK (dlc IN (0, 1));

-- Add foreign key constraint to reference game_id from the game table
ALTER TABLE level_stage ADD CONSTRAINT fk_game FOREIGN KEY (game_id) 
REFERENCES game (game_id);

-- Create a trigger to update the date_updated field before any update
CREATE OR REPLACE TRIGGER trg_level_stage_date_updated
BEFORE UPDATE ON level_stage
FOR EACH ROW
BEGIN
    :NEW.date_updated := systimestamp;
END;
/
