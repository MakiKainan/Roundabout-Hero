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
        switch (active.enemy_type) {
            case ENEMY_BANDIT:
                oGame.shake_frames = 10;
                oGame.shake_magnitude = 5;
                oGame.hit_stop_frames = 4;
                oGame.combo_count++;
                oGame.combo_count++;
                oGame.combat_score += 10 + (oGame.combo_count * 2);
                audio_play_sound(snd_hit, 1, false);
                part_particles_create(global.part_sys, active.x, active.y, global.part_hit, 20);
                if (oGame.fever_mode) {
                    part_particles_create(global.part_sys, active.x, active.y, global.part_explosion, 5);
                    oGame.shake_frames = 15; oGame.shake_magnitude = 10;
                    var _ax = active.x; var _ay = active.y; var _aid = active.id;
                    with (par_enemy) {
                        if (id != _aid && point_distance(x, y, _ax, _ay) < 120) {
                            if (enemy_type == ENEMY_SHIELDED && !is_vulnerable) continue;
                            instance_destroy(); oGame.combo_count++; oGame.combat_score += 10; oGame.style_score += 15;
                        }
                    }
                }
                instance_destroy(active);
                adrenaline = min(adrenaline_max, adrenaline + 10);
                break;
            case ENEMY_SHIELDED:
                if (active.is_vulnerable) {
                    oGame.shake_frames = 10;
                    oGame.shake_magnitude = 5;
                    oGame.hit_stop_frames = 4;
                    oGame.combo_count++;
                    oGame.combo_timer = 180;
                    oGame.combat_score += 10 + (oGame.combo_count * 2);
                    oGame.style_score += 30;
                    audio_play_sound(snd_hit, 1, false);
                    part_particles_create(global.part_sys, active.x, active.y, global.part_hit, 20);
                    if (oGame.fever_mode) {
                        part_particles_create(global.part_sys, active.x, active.y, global.part_explosion, 5);
                        oGame.shake_frames = 15; oGame.shake_magnitude = 10;
                        var _ax = active.x; var _ay = active.y; var _aid = active.id;
                        with (par_enemy) {
                            if (id != _aid && point_distance(x, y, _ax, _ay) < 120) {
                                if (enemy_type == ENEMY_SHIELDED && !is_vulnerable) continue;
                                instance_destroy(); oGame.combo_count++; oGame.combat_score += 10; oGame.style_score += 15;
                            }
                        }
                    }
                    instance_destroy(active);
                    adrenaline = min(adrenaline_max, adrenaline + 10);
                } else {
                    // Shield absorbs — miss penalty
                    attack_cooldown = ATTACK_COOLDOWN_FRAMES;
                    oGame.combo_count = max(0, oGame.combo_count - 1);
                    oGame.combo_timer = 0;
                }
                break;
            case ENEMY_ASSASSIN:
                if (!active.backstep_state) {
                    active.backstep_state = true;
                    active.backstep_timer = ASSASSIN_BACKSTEP_FREEZE;
                    // Push back along the circle away from the player
                    var player_ang = point_direction(ARENA_CENTER_X, ARENA_CENTER_Y, x, y);
                    var adiff = angle_difference(player_ang, active.circle_angle);
                    var backstep_deg = ASSASSIN_BACKSTEP_DIST * (180 / pi) / ARENA_RADIUS;
                    active.circle_angle -= sign(adiff) * backstep_deg;
                    active.x = arena_x(active.circle_angle);
                    active.y = arena_y(active.circle_angle);
                } else {
                    oGame.shake_frames = 10;
                    oGame.shake_magnitude = 5;
                    oGame.hit_stop_frames = 4;
                    oGame.combo_count++;
                    oGame.combo_timer = 180;
                    oGame.combat_score += 10 + (oGame.combo_count * 2);
                    oGame.style_score += 30;
                    audio_play_sound(snd_hit, 1, false);
                    part_particles_create(global.part_sys, active.x, active.y, global.part_hit, 20);
                    if (oGame.fever_mode) {
                        part_particles_create(global.part_sys, active.x, active.y, global.part_explosion, 5);
                        oGame.shake_frames = 15; oGame.shake_magnitude = 10;
                        var _ax = active.x; var _ay = active.y; var _aid = active.id;
                        with (par_enemy) {
                            if (id != _aid && point_distance(x, y, _ax, _ay) < 120) {
                                if (enemy_type == ENEMY_SHIELDED && !is_vulnerable) continue;
                                instance_destroy(); oGame.combo_count++; oGame.combat_score += 10; oGame.style_score += 15;
                            }
                        }
                    }
                    instance_destroy(active);
                    adrenaline = min(adrenaline_max, adrenaline + 10);
                }
                break;
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

    if (active != noone
        && active.enemy_type == ENEMY_SHIELDED
        && point_distance(x, y, active.x, active.y) <= ATTACK_RANGE) {
        
        if (!active.is_vulnerable) {
            // Correct riposte — stun them, no cooldown
            active.is_vulnerable = true;
            array_push(oGame.floating_texts, {x: active.x, y: active.y - 40, text: "BLOCK!", color: c_aqua, alpha: 1.5});
        } else {
            // Failsafe use — already vulnerable
            defend_cooldown = DEFEND_COOLDOWN_FRAMES;
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
