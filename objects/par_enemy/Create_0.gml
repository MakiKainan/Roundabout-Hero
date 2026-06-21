// Default Virtual Methods for par_enemy

// Called when the knight attacks this enemy
on_attacked = function(knight) {
    // Default: simple death and combo increment
    oGame.shake_frames = 10;
    oGame.shake_magnitude = 5;
    oGame.hit_stop_frames = 4;
    oGame.combo_count++;
    oGame.combo_count++; // Intentionally double incrementing based on original logic
    oGame.combat_score += 10 + (oGame.combo_count * 2);
    audio_play_sound(snd_hit, 1, false);
    if (oGame.combo_count >= 50) {
        part_particles_create(global.part_sys, x, y, global.part_star_red, 10);
        part_particles_create(global.part_sys, x, y, global.part_star_white, 10);
        part_particles_create(global.part_sys, x, y, global.part_star_blue, 10);
    } else {
        part_particles_create(global.part_sys, x, y, global.part_hit, 20);
    }
    
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
};

// Called when the knight uses the defend action on this enemy.
// Two-ring parry: the knight only calls this when we're already inside ATTACK_RANGE,
// so here we just split the inner (perfect) ring from the outer (imperfect) ring.
on_defended = function(knight) {
    var d = point_distance(x, y, knight.x, knight.y);

    if (d <= PERFECT_PARRY_RANGE) {
        // ---- PERFECT PARRY: defeat the enemy ----
        oGame.shake_frames = 20;
        oGame.shake_magnitude = 12;
        oGame.hit_stop_frames = 12;
        oGame.combo_count++;
        oGame.combo_timer = 180;
        oGame.combat_score += 50;
        oGame.style_score += 80;
        knight.adrenaline = min(knight.adrenaline_max, knight.adrenaline + 25);
        audio_play_sound(snd_hit, 1, false);
        if (oGame.combo_count >= 50) {
            part_particles_create(global.part_sys, x, y, global.part_star_red, 15);
            part_particles_create(global.part_sys, x, y, global.part_star_white, 15);
            part_particles_create(global.part_sys, x, y, global.part_star_blue, 15);
        } else {
            part_particles_create(global.part_sys, x, y, global.part_hit, 30);
            part_particles_create(global.part_sys, x, y, global.part_explosion, 10);
        }
        array_push(oGame.floating_texts, {x: x, y: y - 40, text: "PERFECT!", color: c_yellow, alpha: 1.5});

        if (oGame.fever_mode) {
            var _ax = x; var _ay = y; var _aid = id;
            with (par_enemy) {
                if (id != _aid && point_distance(x, y, _ax, _ay) < 150) {
                    if (variable_instance_exists(id, "is_vulnerable") && !is_vulnerable) continue;
                    instance_destroy(); oGame.combo_count++; oGame.combat_score += 10; oGame.style_score += 15;
                }
            }
        }
        instance_destroy();
    } else {
        // ---- IMPERFECT PARRY: knock the enemy back clear of the ring, slow it, lock defend ----
        var player_ang = point_direction(ARENA_CENTER_X, ARENA_CENTER_Y, knight.x, knight.y);
        var adiff = angle_difference(player_ang, circle_angle);
        var dir = (adiff >= 0) ? -1 : 1;   // step away from the player along the rim
        // walk outward 2 deg at a time until clear of the attack ring (safety-capped at a full lap)
        repeat (180) {
            circle_angle += dir * 2;
            x = arena_x(circle_angle);
            y = arena_y(circle_angle);
            if (point_distance(x, y, knight.x, knight.y) > ATTACK_RANGE + 12) break;
        }
        spd = max(spd * IMPERFECT_PARRY_SLOW, BASE_ENEMY_SPEED * 0.3);
        knight.defend_cooldown = IMPERFECT_PARRY_COOLDOWN;
        oGame.shake_frames = 8;
        oGame.shake_magnitude = 5;
        audio_play_sound(snd_hit, 1, false);
        array_push(oGame.floating_texts, {x: x, y: y - 40, text: "BLOCKED!", color: c_orange, alpha: 1.5});
    }
};
