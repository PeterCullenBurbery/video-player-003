CREATE TABLE level_completion (
    level_completion_id RAW(16) DEFAULT sys_guid() PRIMARY KEY,  -- UUID for the primary key
    is_successful NUMBER(1) DEFAULT 0 NOT NULL,                  -- Boolean indicating success (0 = fail, 1 = success)
    starting_lives NUMBER NOT NULL,                              -- Starting lives
    lives_remaining NUMBER,                                      -- Ending lives could be null if you lose all lives
    lives_lost NUMBER GENERATED ALWAYS AS (
        CASE 
            WHEN lives_remaining IS NULL THEN starting_lives       -- If all lives are lost, lives_lost = starting_lives
            ELSE starting_lives - lives_remaining                 -- Otherwise, calculate lives lost
        END
    ) VIRTUAL,                                                    -- Virtual column calculating lives lost
    last_wave NUMBER,                                             -- Last wave reached (nullable if won)
    
    play_mode_string VARCHAR2(1000) NOT NULL,                     -- Play mode string
    play_mode_id RAW(16),                                         -- Foreign key referencing play_mode
    
    level_stage_string VARCHAR2(1000) NOT NULL,                   -- Level stage string
    level_stage_id RAW(16),                                       -- Foreign key referencing level_stage
    
    difficulty_string VARCHAR2(1000) NOT NULL,                    -- Difficulty string
    difficulty_level_id RAW(16),                                  -- Foreign key referencing difficulty
    
    person_username_string VARCHAR2(1000) NOT NULL,               -- Person username string
    person_id RAW(16),                                            -- Foreign key referencing person
    
    YouTube_video_string VARCHAR2(1000),                          -- YouTube video string (optional)
    recording_file_string VARCHAR2(1000),                         -- Recording file string (optional)
    description VARCHAR2(4000),                                   -- Description of the level completion
    
    note VARCHAR2(4000),                                          -- Note for specific record
    date_created TIMESTAMP(9) WITH TIME ZONE DEFAULT systimestamp(9), -- Date created
    date_updated TIMESTAMP WITH TIME ZONE,                        -- Date modified, set via trigger
    date_created_or_updated TIMESTAMP WITH TIME ZONE 
        GENERATED ALWAYS AS (COALESCE(date_updated, date_created)) VIRTUAL -- Virtual column for date
);



-- Generate all 16 unique constraints based on the combinations of ids and strings
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_1 UNIQUE (
    level_stage_id, play_mode_id, difficulty_level_id, person_id, YouTube_video_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_2 UNIQUE (
    level_stage_id, play_mode_id, difficulty_level_id, person_id, recording_file_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_3 UNIQUE (
    level_stage_id, play_mode_id, difficulty_level_id, person_username_string, YouTube_video_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_4 UNIQUE (
    level_stage_id, play_mode_id, difficulty_level_id, person_username_string, recording_file_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_5 UNIQUE (
    level_stage_id, play_mode_string, difficulty_level_id, person_id, YouTube_video_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_6 UNIQUE (
    level_stage_id, play_mode_string, difficulty_level_id, person_id, recording_file_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_7 UNIQUE (
    level_stage_id, play_mode_string, difficulty_level_id, person_username_string, YouTube_video_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_8 UNIQUE (
    level_stage_id, play_mode_string, difficulty_level_id, person_username_string, recording_file_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_9 UNIQUE (
    level_stage_string, play_mode_id, difficulty_level_id, person_id, YouTube_video_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_10 UNIQUE (
    level_stage_string, play_mode_id, difficulty_level_id, person_id, recording_file_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_11 UNIQUE (
    level_stage_string, play_mode_id, difficulty_level_id, person_username_string, YouTube_video_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_12 UNIQUE (
    level_stage_string, play_mode_id, difficulty_level_id, person_username_string, recording_file_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_13 UNIQUE (
    level_stage_string, play_mode_string, difficulty_level_id, person_id, YouTube_video_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_14 UNIQUE (
    level_stage_string, play_mode_string, difficulty_level_id, person_id, recording_file_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_15 UNIQUE (
    level_stage_string, play_mode_string, difficulty_level_id, person_username_string, YouTube_video_string
);
ALTER TABLE level_completion ADD CONSTRAINT unique_combination_16 UNIQUE (
    level_stage_string, play_mode_string, difficulty_level_id, person_username_string, recording_file_string
);

-- Foreign key constraint for play_mode_id
ALTER TABLE level_completion ADD CONSTRAINT fk_play_mode FOREIGN KEY (play_mode_id) 
REFERENCES play_mode (play_mode_id);

-- Foreign key constraint for level_stage_id
ALTER TABLE level_completion ADD CONSTRAINT fk_level_stage FOREIGN KEY (level_stage_id) 
REFERENCES level_stage (level_stage_id);

-- Foreign key constraint for difficulty_level_id
ALTER TABLE level_completion ADD CONSTRAINT fk_difficulty FOREIGN KEY (difficulty_level_id) 
REFERENCES difficulty (difficulty_id);

-- Foreign key constraint for person_id
ALTER TABLE level_completion ADD CONSTRAINT fk_person FOREIGN KEY (person_id) 
REFERENCES person (person_id);

ALTER TABLE level_completion
ADD CONSTRAINT check_is_successful_not_negative
CHECK (is_successful IN (0, 1));

-- 1. Starting lives must be an integer
ALTER TABLE level_completion
ADD CONSTRAINT check_starting_lives_integer
CHECK (starting_lives = TRUNC(starting_lives));

-- 2. Starting lives must be strictly positive
ALTER TABLE level_completion
ADD CONSTRAINT check_starting_lives_positive
CHECK (starting_lives > 0);

-- 3. Ending lives must be an integer
ALTER TABLE level_completion
ADD CONSTRAINT check_lives_remaining_integer
CHECK (lives_remaining = TRUNC(lives_remaining));

-- 4. Ending lives must be strictly positive
ALTER TABLE level_completion
ADD CONSTRAINT check_lives_remaining_positive
CHECK (lives_remaining > 0);

-- 5. Ending lives cannot be greater than starting lives
ALTER TABLE level_completion
ADD CONSTRAINT check_lives_remaining_not_greater_than_starting
CHECK (lives_remaining <= starting_lives);

-- Create a trigger to update the date_updated field before any update
CREATE OR REPLACE TRIGGER trg_level_completion_date_updated
BEFORE UPDATE ON level_completion
FOR EACH ROW
BEGIN
    :NEW.date_updated := systimestamp;
END;
/

CREATE OR REPLACE TRIGGER trg_set_successful_based_on_lives
BEFORE INSERT OR UPDATE ON level_completion
FOR EACH ROW
BEGIN
    IF :NEW.lives_remaining IS NOT NULL THEN
        :NEW.is_successful := 1;  -- Set is_successful to true (1) if lives_remaining is not null
    END IF;
END;
/

-- Add unique constraint on YouTube_video_string
ALTER TABLE level_completion
ADD CONSTRAINT unique_youtube_video_string
UNIQUE (YouTube_video_string);

-- Add unique constraint on recording_file_string
ALTER TABLE level_completion
ADD CONSTRAINT unique_recording_file_string
UNIQUE (recording_file_string);

