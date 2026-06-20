event_inherited();
enemy_type = ENEMY_SHIELDED;
spd = BASE_ENEMY_SPEED * oGame.difficulty_multiplier;
circle_angle = 90;   // default (top); the spawner overwrites with the true angle
is_vulnerable = false;
state = "moving";    // "moving" | "attacking" (plays spr_shielded_attack on contact, then dies)

on_attacked = function(knight) {
    if (is_vulnerable) {
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
    } else {
        // Shield absorbs — miss penalty
        knight.attack_cooldown = ATTACK_COOLDOWN_FRAMES;
        oGame.combo_count = max(0, oGame.combo_count - 1);
        oGame.combo_timer = 0;
    }
};

on_defended = function(knight) {
    if (!is_vulnerable) {
        // Correct riposte — stun them, no cooldown
        is_vulnerable = true;
        array_push(oGame.floating_texts, {x: x, y: y - 40, text: "BLOCK!", color: c_aqua, alpha: 1.5});
    } else {
        // Failsafe use — already vulnerable
        knight.defend_cooldown = DEFEND_COOLDOWN_FRAMES;
    }
};
