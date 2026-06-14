if (oGame.game_state != STATE_PLAYING) exit;

if (attack_cooldown > 0) attack_cooldown--;
if (defend_cooldown > 0) defend_cooldown--;

// Attack — Z or left mouse
if ((keyboard_check_pressed(ord("Z")) || mouse_check_button_pressed(mb_left))
    && attack_cooldown == 0) {

    var active = instance_nearest(x, y, par_enemy);

    if (active != noone && point_distance(x, y, active.x, active.y) <= ATTACK_RANGE) {
        switch (active.enemy_type) {
            case ENEMY_BANDIT:
                instance_destroy(active);
                break;
            case ENEMY_SHIELDED:
                if (active.is_vulnerable) {
                    instance_destroy(active);
                } else {
                    // Shield absorbs — miss penalty
                    attack_cooldown = ATTACK_COOLDOWN_FRAMES;
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
                    instance_destroy(active);
                }
                break;
        }
    } else {
        // No enemy in range — miss
        attack_cooldown = ATTACK_COOLDOWN_FRAMES;
    }
}

// Defend — X or right mouse
if ((keyboard_check_pressed(ord("X")) || mouse_check_button_pressed(mb_right))
    && defend_cooldown == 0) {

    var active = instance_nearest(x, y, par_enemy);

    if (active != noone
        && active.enemy_type == ENEMY_SHIELDED
        && point_distance(x, y, active.x, active.y) <= ATTACK_RANGE) {
        
        if (!active.is_vulnerable) {
            // Correct riposte — stun them, no cooldown
            active.is_vulnerable = true;
        } else {
            // Failsafe use — already vulnerable
            defend_cooldown = DEFEND_COOLDOWN_FRAMES;
        }
    } else {
        // Failsafe use — 5s cooldown
        defend_cooldown = DEFEND_COOLDOWN_FRAMES;
    }
}
