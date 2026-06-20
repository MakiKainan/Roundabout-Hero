if (oGame.game_state != STATE_PLAYING) exit;
if (oGame.hit_stop_frames > 0) exit;   // freeze with everything else

lifetime--;
if (lifetime <= 0) { instance_destroy(); exit; }

x += vx;
y += vy;

// Reached the knight?
if (!has_hit && point_distance(x, y, oKnight.x, oKnight.y) <= ENEMY_CONTACT_DIST) {
    has_hit = true;

    if (oKnight.defend_pose_timer > 0) {
        // BLOCKED — reward; the deflected bolt makes the crossbowman charge in to melee
        oGame.combo_count++;
        oGame.combo_timer  = 180;
        oGame.combat_score += 30;
        oGame.style_score  += 40;
        oKnight.adrenaline = min(oKnight.adrenaline_max, oKnight.adrenaline + 15);
        oGame.shake_frames = 10;
        oGame.shake_magnitude = 6;
        audio_play_sound(snd_hit, 1, false);
        part_particles_create(global.part_sys, x, y, global.part_hit, 20);
        array_push(oGame.floating_texts, {x: oKnight.x, y: oKnight.y - 60, text: "BLOCKED!", color: c_aqua, alpha: 1.5});

        // Instead of dying, the shooter rushes the player like a base bandit (see oCrossbowBandit "charging").
        if (instance_exists(shooter_id)) {
            shooter_id.state = "charging";
        }
        instance_destroy();
        exit;
    } else {
        // MISS — the bolt hits the knight
        oKnight.hp--;
        oKnight.adrenaline = max(0, oKnight.adrenaline - 30);
        oGame.combo_count = max(0, oGame.combo_count - 5);
        oGame.shake_frames = 15;
        oGame.shake_magnitude = 8;
        oGame.hit_stop_frames = 6;
        audio_play_sound(snd_hit, 1, false);
        part_particles_create(global.part_sys, oKnight.x, oKnight.y, global.part_hit, 15);
        if (oKnight.hp <= 0) { oGame.game_state = STATE_GAME_OVER; }
        instance_destroy();
        exit;
    }
}

// Off-screen safety
if (x < -100 || x > room_width + 100 || y < -100 || y > room_height + 100) {
    instance_destroy();
}
