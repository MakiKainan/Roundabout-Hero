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
    combat_score = 0;
    combo_count = 0;
    combo_timer = 0;
    fever_mode = false;
    fever_pulse = 0;
    style_score = 0;
    style_rank = "D";
    style_display_score = 0;
    ultimate_flash = 0;
    if (instance_exists(oKnight)) {
        oKnight.adrenaline = 0;
    }
    difficulty_multiplier = 1.0;
    wave_number = 0;
    wave_pause_timer = 0;
    enemies_in_wave = 0;

    instance_create_layer(PLAYER_START_X, PLAYER_START_Y, "Instances", oKnight);
    spawn_wave();
    exit;
}

if (game_state == STATE_PLAYING) {
    // Style Meter Logic
    style_score = combo_count * 30; // 30 points per combo means ~20 combo for SSS
    style_display_score += (style_score - style_display_score) * 0.1;

    if (style_score < 100) style_rank = "D";
    else if (style_score < 200) style_rank = "C";
    else if (style_score < 300) style_rank = "B";
    else if (style_score < 400) style_rank = "A";
    else if (style_score < 500) style_rank = "S";
    else if (style_score < 600) style_rank = "SS";
    else style_rank = "SSS";

    // Floating text update
    for (var i = array_length(floating_texts) - 1; i >= 0; i--) {
        floating_texts[i].y -= 1;
        floating_texts[i].alpha -= 0.02;
        if (floating_texts[i].alpha <= 0) {
            array_delete(floating_texts, i, 1);
        }
    }

    if (hit_stop_frames > 0) {
        hit_stop_frames--;
        exit;
    }

    if (combo_count >= 5) {
        if (!fever_mode) {
            fever_mode = true;
            array_push(floating_texts, {x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 100, text: "FEVER MODE!", color: c_red, alpha: 2.0});
        }
    } else {
        fever_mode = false;
    }

    if (fever_mode) {
        fever_pulse += 0.1;
    }

    if (ultimate_flash > 0) {
        ultimate_flash = max(0, ultimate_flash - 0.05);
    }

    survival_timer++;
    score = combat_score + floor(survival_timer / 60);

    // Parallax scrolling
    var bg_mult = fever_mode ? 2.5 : 1.0;
    if (variable_global_exists("bg_layers")) {
        for (var i = 0; i < array_length(global.bg_layers); i++) {
            global.bg_offsets[i] -= (global.bg_speeds[i] * bg_mult); // Move left
        }
    }

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
