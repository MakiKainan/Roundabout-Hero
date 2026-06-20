if (oGame.game_state != STATE_PLAYING) exit;
if (oGame.hit_stop_frames > 0) exit;

pulse += 0.2;

// Move orb
y += lengthdir_y(current_speed, direction);

// Bounds check (safety)
if (y < -200 || y > room_height + 200) {
    instance_destroy();
    exit;
}

// -------------------------------------------------------------------
// TRAVELING TOWARDS PLAYER
// -------------------------------------------------------------------
if (direction == 270 && instance_exists(oKnight)) {
    if (point_distance(x, y, oKnight.x, oKnight.y) <= ENEMY_CONTACT_DIST + 40) {
        
        // Did the player swing, defend, or use ultimate?
        var _deflected = false;
        if (oKnight.attack_pose_timer > 0 || oKnight.defend_pose_timer > 0 || oGame.ultimate_flash > 0.5) {
            _deflected = true;
        }
        
        if (_deflected) {
            // SUCCESSFUL VOLLEY!
            direction = 90;
            volley_count++;
            current_speed *= 1.25;
            
            // Clear player cooldowns
            oKnight.attack_cooldown = 0;
            oKnight.defend_cooldown = 0;
            oGame.combo_timer = 180;
            oGame.combo_count++;
            
            // Juice
            oGame.shake_frames = 10 + (volley_count * 5);
            oGame.shake_magnitude = 5 + (volley_count * 3);
            oGame.hit_stop_frames = 8 + volley_count;
            
            var _snd = audio_play_sound(snd_hit, 1, false);
            audio_sound_pitch(_snd, 1.0 + (volley_count * 0.15));
            
            part_particles_create(global.part_sys, x, y, global.part_hit, 20 + (volley_count * 5));
            array_push(oGame.floating_texts, { x: x, y: y - 50, text: "VOLLEY " + string(volley_count) + "!", color: c_red, alpha: 2.0 });
            
        } else {
            // MISS! Player takes massive damage
            oKnight.hp -= 2;
            oKnight.adrenaline = 0;
            oGame.combo_count = 0;
            oGame.shake_frames = 30;
            oGame.shake_magnitude = 15;
            oGame.hit_stop_frames = 15;
            audio_play_sound(snd_hit, 1, false);
            part_particles_create(global.part_sys, oKnight.x, oKnight.y, global.part_explosion, 30);
            if (oKnight.hp <= 0) { oGame.game_state = STATE_GAME_OVER; }
            instance_destroy();
            exit;
        }
    }
}

// -------------------------------------------------------------------
// TRAVELING TOWARDS BOSS
// -------------------------------------------------------------------
if (direction == 90 && instance_exists(boss_id)) {
    if (y <= boss_id.y + 60) {
        
        if (volley_count <= max_volleys) {
            // BOSS DEFLECTS IT BACK!
            direction = 270;
            volley_count++;
            current_speed *= 1.25;
            
            // Juice
            boss_id.hit_flash = 10;
            oGame.shake_frames = 10 + (volley_count * 5);
            oGame.shake_magnitude = 5 + (volley_count * 3);
            oGame.hit_stop_frames = 6 + volley_count;
            
            var _snd = audio_play_sound(snd_hit, 1, false);
            audio_sound_pitch(_snd, 1.0 + (volley_count * 0.15));
            
            part_particles_create(global.part_sys, x, y, global.part_hit, 20 + (volley_count * 5));
            
        } else {
            // BOSS CAN'T HANDLE THE SPEED! DETONATION!
            boss_id.hp -= 5;
            boss_id.hit_flash = 30;
            
            oGame.shake_frames = 45;
            oGame.shake_magnitude = 25;
            oGame.hit_stop_frames = 20;
            oGame.combat_score += 500;
            oKnight.adrenaline = min(oKnight.adrenaline_max, oKnight.adrenaline + 50);
            
            audio_play_sound(snd_hit, 1, false);
            audio_sound_pitch(snd_hit, 0.5); // Deep bass explosion
            
            part_particles_create(global.part_sys, boss_id.x, boss_id.y, global.part_explosion, 50);
            array_push(oGame.floating_texts, {
                x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 120,
                text: "DEVASTATING BLOW! -5 HP",
                color: c_fuchsia, alpha: 3.0
            });
            
            instance_destroy();
        }
    }
}
