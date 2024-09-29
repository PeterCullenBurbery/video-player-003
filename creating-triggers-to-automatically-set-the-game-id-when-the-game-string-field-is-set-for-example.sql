CREATE OR REPLACE TRIGGER trg_set_game_id_from_string
BEFORE INSERT OR UPDATE ON level_stage
FOR EACH ROW
BEGIN
    -- Check if game_string is set and update game_id based on case-insensitive exact regex match
    IF :NEW.game_string IS NOT NULL THEN
        -- Look up the game_id from the game table using exact case-insensitive regex
        SELECT game_id
        INTO :NEW.game_id
        FROM game
        WHERE REGEXP_LIKE(game, '^' || :NEW.game_string || '$', 'i'); -- Case-insensitive exact regex match
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_set_play_mode_id_from_string
BEFORE INSERT OR UPDATE ON level_completion
FOR EACH ROW
BEGIN
    -- Check if play_mode_string is set and update play_mode_id based on case-insensitive exact regex match
    IF :NEW.play_mode_string IS NOT NULL THEN
        -- Look up the play_mode_id from the play_mode table using exact case-insensitive regex
        SELECT play_mode_id
        INTO :NEW.play_mode_id
        FROM play_mode
        WHERE REGEXP_LIKE(play_mode, '^' || :NEW.play_mode_string || '$', 'i'); -- Case-insensitive exact regex match
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_set_level_stage_id_from_string
BEFORE INSERT OR UPDATE ON level_completion
FOR EACH ROW
BEGIN
    -- Check if level_stage_string is set and update level_stage_id based on case-insensitive exact regex match
    IF :NEW.level_stage_string IS NOT NULL THEN
        -- Look up the level_stage_id from the level_stage table using exact case-insensitive regex
        SELECT level_stage_id
        INTO :NEW.level_stage_id
        FROM level_stage
        WHERE REGEXP_LIKE(level_stage, '^' || :NEW.level_stage_string || '$', 'i'); -- Case-insensitive exact regex match
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_set_difficulty_id_from_string
BEFORE INSERT OR UPDATE ON level_completion
FOR EACH ROW
BEGIN
    -- Check if difficulty_string is set and update difficulty_level_id based on case-insensitive exact regex match
    IF :NEW.difficulty_string IS NOT NULL THEN
        -- Look up the difficulty_level_id from the difficulty table using exact case-insensitive regex
        SELECT difficulty_id
        INTO :NEW.difficulty_level_id
        FROM difficulty
        WHERE REGEXP_LIKE(difficulty, '^' || :NEW.difficulty_string || '$', 'i'); -- Case-insensitive exact regex match
    END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_set_person_id_from_string
BEFORE INSERT OR UPDATE ON level_completion
FOR EACH ROW
BEGIN
    -- Check if person_username_string is set and update person_id based on case-insensitive exact regex match
    IF :NEW.person_username_string IS NOT NULL THEN
        -- Look up the person_id from the person table using exact case-insensitive regex
        SELECT person_id
        INTO :NEW.person_id
        FROM person
        WHERE REGEXP_LIKE(username, '^' || :NEW.person_username_string || '$', 'i'); -- Case-insensitive exact regex match
    END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_set_starting_lives_for_campaign
BEFORE INSERT OR UPDATE ON level_completion
FOR EACH ROW
BEGIN
    -- Check if play_mode_string is set to "campaign" (case-insensitive)
    IF REGEXP_LIKE(:NEW.play_mode_string, '^campaign$', 'i') THEN
        :NEW.starting_lives := 20;  -- Set starting_lives to 20 if play_mode is "campaign"
    END IF;
END;
/
