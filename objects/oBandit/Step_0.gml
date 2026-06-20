if (oGame.game_state != STATE_PLAYING) {
    image_speed = 0;
    exit;
}

if (oGame.hit_stop_frames > 0) {
    image_index -= image_speed;
    exit;
}

depth = -y;

if (state == "moving") {
    var spr = asset_get_index("spr_bandit_walk");
    if (sprite_exists(spr) && sprite_index != spr) {
        sprite_index = spr;
    }
    image_speed = 2; // Increased to fix choppy/delayed visual movement

    var player_angle = point_direction(ARENA_CENTER_X, ARENA_CENTER_Y, oKnight.x, oKnight.y);
    var diff = angle_difference(player_angle, circle_angle);
    var angular_spd = spd * (180 / pi) / ARENA_RADIUS;

    if (abs(diff) <= angular_spd) {
        circle_angle = player_angle;
    } else {
        circle_angle += sign(diff) * angular_spd;
    }

    x = arena_x(circle_angle);
    y = arena_y(circle_angle);

    // Stop and attack when very close to the player!
    if (point_distance(x, y, oKnight.x, oKnight.y) <= ENEMY_CONTACT_DIST + 5) {
        state = "attacking";

        // Deal damage IMMEDIATELY on contact
        oKnight.hp--;
        oKnight.adrenaline = max(0, oKnight.adrenaline - 30);
        oGame.combo_count = max(0, oGame.combo_count - 5);
        oGame.shake_frames = 15;
        oGame.shake_magnitude = 8;
        oGame.hit_stop_frames = 6;
        audio_play_sound(snd_hit, 1, false);
        part_particles_create(global.part_sys, oKnight.x, oKnight.y, global.part_hit, 15);
        if (oKnight.hp <= 0) {
            oGame.game_state = STATE_GAME_OVER;
        }

        var fight_spr = asset_get_index("spr_bandit_attack");
        if (sprite_exists(fight_spr)) {
            sprite_index = fight_spr;
            image_index = 0;
            image_speed = 1.5; // Play attack animation a bit faster for impact
        }
    }
} else if (state == "attacking") {
    // Wait until the fighting animation finishes its swing
    if (image_index + image_speed >= image_number) {
        // Destroy the bandit after the attack finishes playing
        instance_destroy();
    }
}
