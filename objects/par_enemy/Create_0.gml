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
};

// Called when the knight uses the defend action on this enemy
on_defended = function(knight) {
    // Default: Failsafe use — 5s cooldown
    knight.defend_cooldown = DEFEND_COOLDOWN_FRAMES;
};
