if (oGame.game_state != STATE_PLAYING) {
    image_speed = 0;
    exit;
}

depth = -y;

if (state == "moving") {
    // Shield up = walk sprite; after a correct Defend riposte = exposed vulnerable sprite
    var spr = is_vulnerable ? asset_get_index("spr_shielded_vulnerable")
                            : asset_get_index("spr_shielded_walk");
    if (sprite_exists(spr) && sprite_index != spr) {
        sprite_index = spr;
    }
    image_speed = 2;

    var player_angle = point_direction(ARENA_CENTER_X, ARENA_CENTER_Y, oKnight.x, oKnight.y);
    var diff = angle_difference(player_angle, circle_angle);
    var angular_spd = spd * (180 / pi) / ARENA_RADIUS;

    // Vulnerable = stunned/exposed: freeze in place, the player finishes it with Attack
    if (!is_vulnerable) {
        if (abs(diff) <= angular_spd) {
            circle_angle = player_angle;
        } else {
            circle_angle += sign(diff) * angular_spd;
        }
    }

    x = arena_x(circle_angle);
    y = arena_y(circle_angle);

    // Reached the player — deal damage immediately, then play the attack swing
    if (point_distance(x, y, oKnight.x, oKnight.y) < ENEMY_CONTACT_DIST) {
        oKnight.hp--;
        oGame.combo_count = max(0, oGame.combo_count - 5);
        oGame.shake_frames = 15;
        oGame.shake_magnitude = 8;
        part_particles_create(global.part_sys, oKnight.x, oKnight.y, global.part_hit, 15);
        if (oKnight.hp <= 0) {
            oGame.game_state = STATE_GAME_OVER;
        }

        state = "attacking";
        var fight_spr = asset_get_index("spr_shielded_attack");
        if (sprite_exists(fight_spr)) {
            sprite_index = fight_spr;
            image_index = 0;
            image_speed = 1.5;
        } else {
            instance_destroy(); // no attack sprite imported — fall back to instant kill
        }
    }
} else if (state == "attacking") {
    // Wait until the swing finishes, then vanish
    if (image_index + image_speed >= image_number) {
        instance_destroy();
    }
}
