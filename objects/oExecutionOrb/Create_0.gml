event_inherited();
hp = 1;
max_hp = 1;
orb_type = "HEAL"; // HEAL, GOLD, RAGE
boss_id = noone;
circle_angle = 270;
hover_time = random(100);

on_attacked = function(knight) {
    if (oGame.game_state == STATE_BOON_CHOICE) {
        // Execute the finish
        if (orb_type == "HEAL") {
            oGame.shake_frames = 20;
            oGame.shake_magnitude = 10;
            if (instance_exists(oKnight)) oKnight.hp = PLAYER_MAX_HP;
            var _snd = audio_play_sound(snd_hit, 1, false);
            audio_sound_pitch(_snd, 1.5);
            array_push(oGame.floating_texts, {x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 80, text: "FULL HEAL!", color: c_lime, alpha: 3.0});
            repeat(50) part_particles_create(global.part_sys, ARENA_CENTER_X + irandom_range(-150, 150), ARENA_CENTER_Y + irandom_range(-150, 150), global.part_star_white, 10);
        } else if (orb_type == "GOLD") {
            oGame.shake_frames = 30;
            oGame.shake_magnitude = 15;
            oGame.combat_score += 5000;
            var _snd = audio_play_sound(snd_hit, 1, false);
            audio_sound_pitch(_snd, 1.5);
            array_push(oGame.floating_texts, {x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 80, text: "+5000 SCORE!", color: c_yellow, alpha: 3.0});
            repeat(50) part_particles_create(global.part_sys, ARENA_CENTER_X + irandom_range(-150, 150), ARENA_CENTER_Y + irandom_range(-150, 150), global.part_star_white, 10);
        } else if (orb_type == "RAGE") {
            oGame.shake_frames = 40;
            oGame.shake_magnitude = 20;
            oGame.style_score = 1000; // Instant SSS
            oGame.combo_count += 20;
            if (instance_exists(oKnight)) oKnight.adrenaline = oKnight.adrenaline_max;
            var _snd = audio_play_sound(snd_hit, 1, false);
            audio_sound_pitch(_snd, 2.0);
            array_push(oGame.floating_texts, {x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 80, text: "MAX RAGE + SSS!", color: c_red, alpha: 3.0});
            repeat(50) part_particles_create(global.part_sys, ARENA_CENTER_X + irandom_range(-150, 150), ARENA_CENTER_Y + irandom_range(-150, 150), global.part_star_red, 10);
        }
    }
    
    // Destroy all orbs
    with (oExecutionOrb) instance_destroy();
    
    // Resume time
    oGame.game_state = STATE_WAVE_PAUSE;
    oGame.wave_pause_timer = WAVE_PAUSE_FRAMES;
};
