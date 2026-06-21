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
    var _current_range = ATTACK_RANGE + (oGame.combo_count >= 50 ? 40 : 0);

    if (active != noone && point_distance(x, y, active.x, active.y) <= _current_range) {
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
    var _current_range = ATTACK_RANGE + (oGame.combo_count >= 50 ? 40 : 0);

    if (active != noone && point_distance(x, y, active.x, active.y) <= _current_range) {
        if (variable_instance_exists(active, "on_defended")) {
            active.on_defended(id);
        }
    } else if (instance_number(oArrow) == 0) {
        // Whiffed with nothing to block — failsafe cooldown.
        // If a bolt is in flight, this press is a block attempt (oArrow reads defend_pose_timer); don't punish it.
        defend_cooldown = DEFEND_COOLDOWN_FRAMES;
    }
}

// Ultimate Ability — Spacebar
if (keyboard_check_pressed(vk_space) && adrenaline >= adrenaline_max) {
    adrenaline = 0;
    
    oGame.ultimate_flash = 1.0;
    oGame.shake_frames = 40;
    oGame.shake_magnitude = 25;
    oGame.hit_stop_frames = 20;
    
    var _screech = audio_play_sound(snd_swing, 1, false);
    audio_sound_pitch(_screech, 2.5); // High pitched eagle screech
    var _boom = audio_play_sound(snd_hit, 1, false);
    audio_sound_pitch(_boom, 0.4); // Deep rumble
    
    array_push(oGame.floating_texts, {x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 100, text: "TACTICAL FREEDOM!", color: c_fuchsia, alpha: 2.0});
    
    // Annihilate all enemies
    with (par_enemy) {
        part_particles_create(global.part_sys, x, y, global.part_explosion, 20);
        oGame.combat_score += 20;
        oGame.combo_count++;
        instance_destroy();
    }
    
    // Annihilate Boss Projectiles
    with (oBossProjectile) {
        part_particles_create(global.part_sys, x, y, global.part_explosion, 10);
        instance_destroy();
    }
    
    // Annihilate Death Orb
    with (oDeathOrb) {
        part_particles_create(global.part_sys, x, y, global.part_explosion, 30);
        oGame.combat_score += 500;
        instance_destroy();
    }
    
    // Annihilate Arrows
    with (oArrow) {
        part_particles_create(global.part_sys, x, y, global.part_explosion, 5);
        instance_destroy();
    }
}
