game_state = STATE_PLAYING;
survival_timer = 0;
score = 0;
difficulty_multiplier = 1.0;
wave_number = 0;
wave_pause_timer = 0;
enemies_in_wave = 0;

instance_create_layer(PLAYER_START_X, PLAYER_START_Y, "Instances", oKnight);
spawn_wave();
