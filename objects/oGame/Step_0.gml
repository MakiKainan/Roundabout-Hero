// Pause Toggle
if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"))) {
    if (game_state == STATE_PLAYING) {
        game_state = STATE_PAUSED;
    } else if (game_state == STATE_PAUSED) {
        game_state = STATE_PLAYING;
    }
}

// Restart
if (game_state == STATE_GAME_OVER && keyboard_check_pressed(ord("R"))) {
    with (par_enemy) instance_destroy();
    with (oKnight)   instance_destroy();

    game_state = STATE_PLAYING;
    survival_timer = 0;
    score = 0;
    difficulty_multiplier = 1.0;
    wave_number = 0;
    wave_pause_timer = 0;
    enemies_in_wave = 0;

    instance_create_layer(PLAYER_START_X, PLAYER_START_Y, "Instances", oKnight);
    spawn_wave();
    exit;
}

if (game_state == STATE_PLAYING) {


    survival_timer++;
    score = floor(survival_timer / 60);

    if (survival_timer == 3600) {
        difficulty_multiplier = 1.2;
    } else if (survival_timer == 7200) {
        difficulty_multiplier = 1.3;
    } else if (survival_timer > 7200 && (survival_timer mod 1800) == 0) {
        difficulty_multiplier += 0.1;
    }

    if (array_length(spawn_queue) > 0) {
        if (spawn_timer > 0) {
            spawn_timer--;
        } else {
            var enemy_data = spawn_queue[0];
            array_delete(spawn_queue, 0, 1);
            var inst = instance_create_layer(enemy_data.x, enemy_data.y, "Instances", get_enemy_object(enemy_data.type));
            inst.circle_angle = enemy_data.angle;
            spawn_timer = ENEMY_SPAWN_DELAY_FRAMES;
        }
    } else if (instance_number(par_enemy) == 0) {
        game_state = STATE_WAVE_PAUSE;
        wave_pause_timer = WAVE_PAUSE_FRAMES;
    }
}

if (game_state == STATE_WAVE_PAUSE) {
    wave_pause_timer--;
    if (wave_pause_timer <= 0) {
        game_state = STATE_PLAYING;
        spawn_wave();
    }
}
