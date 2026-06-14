game_state = STATE_PLAYING;
survival_timer = 0;

view_enabled = true;
view_visible[0] = true;
view_camera[0] = camera_create_view(0, 0, 1366, 768, 0, -1, -1, -1, 32, 32);
score = 0;
difficulty_multiplier = 1.0;
wave_number = 0;
wave_pause_timer = 0;
enemies_in_wave = 0;

spawn_queue = [];
spawn_timer = 0;

shake_frames = 0;
shake_magnitude = 0;

// Particle System
global.part_sys = part_system_create();
part_system_depth(global.part_sys, -100);

// Hit Particle Type
global.part_hit = part_type_create();
part_type_shape(global.part_hit, pt_shape_square);
part_type_size(global.part_hit, 0.1, 0.3, -0.01, 0);
part_type_color1(global.part_hit, c_red);
part_type_speed(global.part_hit, 2, 6, -0.1, 0);
part_type_direction(global.part_hit, 0, 359, 0, 0);
part_type_life(global.part_hit, 15, 30);

instance_create_layer(PLAYER_START_X, PLAYER_START_Y, "Instances", oKnight);
spawn_wave();
