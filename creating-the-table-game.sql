CREATE TABLE game (
    game_id RAW(16) DEFAULT sys_guid() PRIMARY KEY, -- UUID for the primary key
    game VARCHAR2(4000) NOT NULL,                   -- Name of the game, must be unique
    description VARCHAR2(4000),                     -- Description of the game
    release_date TIMESTAMP(9) WITH TIME ZONE,       -- Release date with time zone
    acronym VARCHAR2(4000),                         -- Acronym for the game, must be unique
    names VARCHAR2(4000),                           -- Additional names for the game
    number_value NUMBER NOT NULL,                   -- New column for storing a numerical value, cannot be null

    note VARCHAR2(4000),                            -- Note for specific record
    date_created TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9), -- Date created
    date_updated TIMESTAMP(9) WITH TIME ZONE,       -- Date modified, set via trigger
    date_created_or_updated TIMESTAMP(9) WITH TIME ZONE 
        GENERATED ALWAYS AS (COALESCE(date_updated, date_created)) VIRTUAL  -- Virtual column for date
);

-- Ensure game is unique
ALTER TABLE game ADD CONSTRAINT unique_game UNIQUE (game);

-- Ensure acronym is unique
ALTER TABLE game ADD CONSTRAINT unique_acronym UNIQUE (acronym);

-- Create a trigger to update the date_updated field before any update
CREATE OR REPLACE TRIGGER trg_game_date_updated
BEFORE UPDATE ON game
FOR EACH ROW
BEGIN
    :NEW.date_updated := systimestamp;
END;
/
