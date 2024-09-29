CREATE OR REPLACE PROCEDURE assign_game_id_to_level_stage
IS
    CURSOR level_cursor IS
        SELECT level_stage_id, game_string
        FROM level_stage
        WHERE game_id IS NULL; -- Only process entries where game_id is not yet assigned

    game_id_value RAW(16); -- Variable to store the found game_id
BEGIN
    -- Loop through each level_stage with a null game_id
    FOR level_rec IN level_cursor
    LOOP
        -- Try to find a matching game based on the game_string, enforcing an exact match with ^ and $
        BEGIN
            SELECT game_id
            INTO game_id_value
            FROM game
            WHERE REGEXP_LIKE(game, '^' || level_rec.game_string || '$', 'i'); -- Exact match using ^ and $

            -- Update the level_stage's game_id with the found game_id
            UPDATE level_stage
            SET game_id = game_id_value
            WHERE level_stage_id = level_rec.level_stage_id;

            -- Commit the change
            COMMIT;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- No matching game found, skip the update for this entry
                NULL;
            WHEN TOO_MANY_ROWS THEN
                -- If multiple games match, handle the case appropriately (e.g., log an error)
                RAISE_APPLICATION_ERROR(-20001, 'Multiple matching games found for game_string: ' || level_rec.game_string);
        END;
    END LOOP;
END assign_game_id_to_level_stage;
/

execute assign_game_id_to_level_stage;