event_inherited();
enemy_type = ENEMY_BANDIT;
spd = BASE_ENEMY_SPEED * oGame.difficulty_multiplier;
circle_angle = 90;   // default (top); the spawner overwrites with the true angle
state = "moving";
windup_timer = 0;
