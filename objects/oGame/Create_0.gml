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
hit_stop_frames = 0;
combo_count = 0;
combo_timer = 0;
combat_score = 0;
floating_texts = [];
fever_mode = false;
fever_pulse = 0;

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

// Explosion Particle Type
global.part_explosion = part_type_create();
part_type_shape(global.part_explosion, pt_shape_circle);
part_type_size(global.part_explosion, 0.5, 1.5, 0.05, 0);
part_type_color3(global.part_explosion, c_white, c_yellow, c_red);
part_type_speed(global.part_explosion, 5, 15, -0.2, 0);
part_type_direction(global.part_explosion, 0, 359, 0, 0);
part_type_life(global.part_explosion, 20, 40);
part_type_blend(global.part_explosion, true);

// Parallax background layers (imported sprite resources, back -> front)
global.bg_layers  = [spr_bg_0, spr_bg_1, spr_bg_2, spr_bg_3, spr_bg_4, spr_bg_5, spr_bg_6];
global.bg_speeds  = [0.2, 0.4, 0.7, 1.0, 1.5, 2.0, 3.0];
global.bg_offsets = [0, 0, 0, 0, 0, 0, 0];

// Fix floating sprites automatically by shifting their origin to the bottom-most visible pixel (their feet)
function auto_align_sprite_origin(spr) {
    if (sprite_exists(spr) && spr != -1) {
        var x_cen = sprite_get_width(spr) / 2;
        var y_bot = sprite_get_bbox_bottom(spr) + 1;
        sprite_set_offset(spr, x_cen, y_bot);
    }
}

auto_align_sprite_origin(spr_knight_idle);
// Force attack/defend sprites to share the EXACT same origin as the idle sprite
// This prevents them from jerking up/down if the sword swings lower than their feet!
sprite_set_offset(spr_knight_attack, sprite_get_xoffset(spr_knight_idle), sprite_get_yoffset(spr_knight_idle));
sprite_set_offset(spr_knight_defend, sprite_get_xoffset(spr_knight_idle), sprite_get_yoffset(spr_knight_idle));

var b_walk = asset_get_index("spr_bandit_walk");
var b_attack = asset_get_index("spr_bandit_attack");

auto_align_sprite_origin(b_walk);
if (sprite_exists(b_walk) && sprite_exists(b_attack)) {
    // Force the attack sprite to share the exact same origin as the walk sprite
    sprite_set_offset(b_attack, sprite_get_xoffset(b_walk), sprite_get_yoffset(b_walk));
}

// Shielded bandit: ground the walk sprite on its feet, then share that origin across states
var s_walk = asset_get_index("spr_shielded_walk");
var s_vuln = asset_get_index("spr_shielded_vulnerable");
var s_attack = asset_get_index("spr_shielded_attack");
auto_align_sprite_origin(s_walk);
if (sprite_exists(s_walk)) {
    if (sprite_exists(s_vuln)) {
        sprite_set_offset(s_vuln, sprite_get_xoffset(s_walk), sprite_get_yoffset(s_walk));
    }
    if (sprite_exists(s_attack)) {
        sprite_set_offset(s_attack, sprite_get_xoffset(s_walk), sprite_get_yoffset(s_walk));
    }
}

instance_create_layer(PLAYER_START_X, PLAYER_START_Y, "Instances", oKnight);
spawn_wave();
