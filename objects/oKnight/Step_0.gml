if (oGame.game_state != STATE_PLAYING) {
    image_speed = 0;
    exit;
}

if (oGame.hit_stop_frames > 0) {
    image_index -= image_speed;
    exit;
}

depth = -y;

if (attack_cooldown > 0) attack_cooldown--;
if (defend_cooldown > 0) defend_cooldown--;

// --- Visual state: face nearest enemy, tick pose timers ---
var near = instance_nearest(x, y, par_enemy);
if (near != noone && abs(near.x - x) > 8) {
    facing = (near.x >= x) ? 1 : -1;
}

if (attack_pose_timer > 0) attack_pose_timer--;
if (defend_pose_timer > 0) defend_pose_timer--;
if (perfect_parry_window > 0) perfect_parry_window--;

// Choose the pose sprite (priority: attack > defend > idle). Reset frame on state change.
if (attack_pose_timer > 0) {
    if (sprite_index != spr_knight_attack) {
        sprite_index = spr_knight_attack;
        image_index = 0;
    }
    image_speed = 3;
} else if (defend_pose_timer > 0) {
    if (sprite_index != spr_knight_defend) {
        sprite_index = spr_knight_defend;
        image_index = 0;
    }
    image_speed = 3;
} else {
    if (sprite_index != spr_knight_idle) {
        sprite_index = spr_knight_idle;
        image_index = 0;
    }
    image_speed = 1;
}

// Attack — Z or left mouse
if ((keyboard_check_pressed(ord("Z")) || mouse_check_button_pressed(mb_left))
    && attack_cooldown == 0) {

    attack_pose_timer = KNIGHT_ATTACK_POSE_FRAMES;
    defend_pose_timer = 0;
    sprite_index = spr_knight_attack;
    image_index = 0;
    audio_play_sound(snd_swing, 1, false);
    
    image_speed = 3;

    var active = instance_nearest(x, y, par_enemy);

    if (active != noone && point_distance(x, y, active.x, active.y) <= ATTACK_RANGE) {
        // Use OCP method on the active enemy
        if (variable_instance_exists(active, "on_attacked")) {
            active.on_attacked(id);
        }
    } else {
        // No enemy in range — miss
        attack_cooldown = ATTACK_COOLDOWN_FRAMES;
        oGame.combo_count = max(0, oGame.combo_count - 1);
        oGame.combo_timer = 0;
    }
}

// Defend — X or right mouse
if ((keyboard_check_pressed(ord("X")) || mouse_check_button_pressed(mb_right))
    && defend_cooldown == 0) {

    defend_pose_timer = KNIGHT_DEFEND_POSE_FRAMES;
    perfect_parry_window = 15;
    attack_pose_timer = 0;
    sprite_index = spr_knight_defend;
    image_index = 0;
    image_speed = 3;

    var active = instance_nearest(x, y, par_enemy);

    if (active != noone && point_distance(x, y, active.x, active.y) <= ATTACK_RANGE) {
        if (variable_instance_exists(active, "on_defended")) {
            active.on_defended(id);
        }
    } else {
        // Failsafe use — 5s cooldown
        defend_cooldown = DEFEND_COOLDOWN_FRAMES;
    }
}

// Ultimate Ability — Spacebar
if (keyboard_check_pressed(vk_space) && adrenaline >= adrenaline_max) {
    adrenaline = 0;
    
    oGame.ultimate_flash = 1.0;
    oGame.shake_frames = 30;
    oGame.shake_magnitude = 20;
    oGame.hit_stop_frames = 15;
    
    audio_play_sound(snd_hit, 1, false);
    array_push(oGame.floating_texts, {x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 100, text: "ULTIMATE UNLEASHED!", color: c_fuchsia, alpha: 2.0});
    
    with (par_enemy) {
        part_particles_create(global.part_sys, x, y, global.part_explosion, 20);
        oGame.combat_score += 20;
        oGame.combo_count++;
        instance_destroy();
    }
}
