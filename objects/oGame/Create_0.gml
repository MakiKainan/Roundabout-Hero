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

instance_create_layer(PLAYER_START_X, PLAYER_START_Y, "Instances", oKnight);
spawn_wave();
