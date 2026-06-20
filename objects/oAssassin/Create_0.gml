event_inherited();
enemy_type = ENEMY_ASSASSIN;
spd = BASE_ENEMY_SPEED * oGame.difficulty_multiplier * 1.2;
backstep_state = false;
backstep_timer = 0;
circle_angle = 90;   // default (top); the spawner overwrites with the true angle
state = "moving";
backstep_anim = false;

on_attacked = function(knight) {
    if (!backstep_state) {
        backstep_state = true;
        backstep_timer = ASSASSIN_BACKSTEP_FREEZE;
        // Push back along the circle away from the player
        var player_ang = point_direction(ARENA_CENTER_X, ARENA_CENTER_Y, knight.x, knight.y);
        var adiff = angle_difference(player_ang, circle_angle);
        var backstep_deg = ASSASSIN_BACKSTEP_DIST * (180 / pi) / ARENA_RADIUS;
        circle_angle -= sign(adiff) * backstep_deg;
        x = arena_x(circle_angle);
        y = arena_y(circle_angle);
    } else {
        oGame.shake_frames = 10;
        oGame.shake_magnitude = 5;
        oGame.hit_stop_frames = 4;
        oGame.combo_count++;
        oGame.combo_timer = 180;
        oGame.combat_score += 10 + (oGame.combo_count * 2);
        oGame.style_score += 30;
        audio_play_sound(snd_hit, 1, false);
        part_particles_create(global.part_sys, x, y, global.part_hit, 20);
        if (oGame.fever_mode) {
            part_particles_create(global.part_sys, x, y, global.part_explosion, 5);
            oGame.shake_frames = 15; oGame.shake_magnitude = 10;
            var _ax = x; var _ay = y; var _aid = id;
            with (par_enemy) {
                if (id != _aid && point_distance(x, y, _ax, _ay) < 120) {
                    if (variable_instance_exists(id, "is_vulnerable") && !is_vulnerable) continue;
                    instance_destroy(); oGame.combo_count++; oGame.combat_score += 10; oGame.style_score += 15;
                }
            }
        }
        instance_destroy();
        knight.adrenaline = min(knight.adrenaline_max, knight.adrenaline + 10);
    }
};
