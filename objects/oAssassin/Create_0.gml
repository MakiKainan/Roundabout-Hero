enemy_type = ENEMY_ASSASSIN;
spd = BASE_ENEMY_SPEED * oGame.difficulty_multiplier * 1.2;
backstep_state = false;
backstep_timer = 0;
circle_angle = point_direction(ARENA_CENTER_X, ARENA_CENTER_Y, x, y);
