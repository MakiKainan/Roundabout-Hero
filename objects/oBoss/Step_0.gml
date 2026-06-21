// oBoss Step

// --- Entrance slide-in ---
if (!enter_done) {
    y += (target_y - y) * 0.08;
    if (abs(y - target_y) < 2) {
        y = target_y;
        enter_done = true;
        // Big entrance announcement
        array_push(oGame.floating_texts, {
            x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 60,
            text: "BOSS APPEARS!", color: c_red, alpha: 2.0
        });
        oGame.shake_frames = 20;
        oGame.shake_magnitude = 10;
    }
    exit;
}

// --- Death Execution Loop ---
if (is_dying) {
    if (mash_timer > 0) {
        // Freeze the rest of the game
        oGame.hit_stop_frames = 2; 
        mash_timer--;
        
        // Listen for mashing
        if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(ord("X")) || mouse_check_button_pressed(mb_left)) {
            mash_count++;
            
            // Massive juice per hit
            oGame.shake_frames = 10;
            oGame.shake_magnitude = 15 + min(mash_count, 20);
            audio_play_sound(snd_swing, 1, false);
            var _snd = audio_play_sound(snd_hit, 1, false);
            audio_sound_pitch(_snd, 1.0 + (mash_count * 0.05));
            
            // Add slash to array
            var _ang = random(360);
            var _len = 150 + random(100);
            var _cx = x + random_range(-50, 50);
            var _cy = y + random_range(-50, 50);
            array_push(slashes, {
                x1: _cx - lengthdir_x(_len, _ang),
                y1: _cy - lengthdir_y(_len, _ang),
                x2: _cx + lengthdir_x(_len, _ang),
                y2: _cy + lengthdir_y(_len, _ang),
                frames: 10
            });
            
            part_particles_create(global.part_sys, _cx, _cy, global.part_hit, 15);
        }
        
        // Update slash fade times
        for (var i = array_length(slashes) - 1; i >= 0; i--) {
            slashes[i].frames--;
            if (slashes[i].frames <= 0) {
                array_delete(slashes, i, 1);
            }
        }
    } else {
        // Climax Explosion
        repeat(50) {
            var _ex = x + irandom_range(-250, 250);
            var _ey = y + irandom_range(-200, 200);
            part_particles_create(global.part_sys, _ex, _ey, global.part_explosion, 20);
        }
        oGame.shake_frames     = 60;
        oGame.shake_magnitude  = 30;
        oGame.ultimate_flash   = 1.0;
        
        var _score_reward = 500 + (mash_count * 50);
        oGame.combat_score    += _score_reward;
        oGame.combo_count     += mash_count * 5;
        if (instance_exists(oKnight)) oKnight.adrenaline = oKnight.adrenaline_max; // Full rage meter!
        
        array_push(oGame.floating_texts, {
            x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 80,
            text: "ANNIHILATED! +" + string(_score_reward), color: c_fuchsia, alpha: 3.0
        });
        
        var _nuke_snd = audio_play_sound(snd_hit, 1, false);
        audio_sound_pitch(_nuke_snd, 0.3); // Nuke
        
        instance_destroy();
    }
    exit; // Do not process normal boss logic
}

// --- Hit flash tick ---
if (hit_flash > 0) hit_flash--;

// --- Attack cycle ---
// Don't count down the timer if a Death Orb exists, OR if we are about to launch a Death Volley and there are still normal projectiles on screen.
var _waiting_for_clear = (((attack_counter + 1) % 3 == 0) && instance_exists(oBossProjectile));

if (!instance_exists(oDeathOrb) && !_waiting_for_clear) {
    attack_timer--;
    if (attack_timer <= 0) {
    attack_timer = BOSS_ATTACK_INTERVAL;

    attack_counter++;
    
    if (attack_counter % 3 == 0) {
        // --- DEATH VOLLEY! ---
        var _orb = instance_create_layer(ARENA_CENTER_X, y, "Instances", oDeathOrb);
        _orb.boss_id = id;
        
        // Massive warning
        oGame.shake_frames = 20;
        oGame.shake_magnitude = 8;
        array_push(oGame.floating_texts, {
            x: ARENA_CENTER_X, y: y - 50,
            text: "DEATH VOLLEY!", color: c_fuchsia, alpha: 2.0
        });
        var _warn_snd = audio_play_sound(snd_hit, 1, false);
        audio_sound_pitch(_warn_snd, 0.6); // Deep warning sound
        
    } else {
        // --- NORMAL PROJECTILE ---
        // Spawn ONE projectile from a random side of the upper arc
        var _start_angles = [SPAWN_ARC_START + 20, SPAWN_ARC_START + SPAWN_ARC_SPAN - 20]; // e.g. ~40° and ~120°
        var _sa    = _start_angles[irandom(1)];
        var _proj  = instance_create_layer(arena_x(_sa), arena_y(_sa), "Instances", oBossProjectile);
        
        _proj.circle_angle = _sa;
        _proj.angle_spd    = BOSS_PROJ_SPEED; // degrees per frame
        _proj.proj_type    = (irandom(1) == 0) ? PROJ_TYPE_FIRE : PROJ_TYPE_MAGIC;
        _proj.boss_id      = id;
        _proj.reflected    = false;
        _proj.has_hit      = false;
    }
}
}

// --- Death check ---
if (hp <= 0 && !is_dying) {
    is_dying = true;
    mash_timer = 180; // 3 seconds of mashing
    mash_count = 0;
    
    // Clear all projectiles to focus entirely on the execution
    with (oBossProjectile) instance_destroy();
    with (oDeathOrb) instance_destroy();
    
    // Initial stagger
    oGame.shake_frames = 20;
    oGame.shake_magnitude = 10;
    var _stag_snd = audio_play_sound(snd_hit, 1, false);
    audio_sound_pitch(_stag_snd, 0.5);
    
    // Push Boss back slightly into the background
    y -= 30;
}
