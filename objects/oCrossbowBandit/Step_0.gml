if (oGame.game_state != STATE_PLAYING) { image_speed = 0; exit; }
if (oGame.hit_stop_frames > 0) { image_index -= image_speed; exit; }

depth = -y;

var spr = asset_get_index("spr_crossbow_bandit_walk");
if (sprite_exists(spr) && sprite_index != spr) sprite_index = spr;

var player_angle = point_direction(ARENA_CENTER_X, ARENA_CENTER_Y, oKnight.x, oKnight.y);
var diff = angle_difference(player_angle, circle_angle);
var angular_spd = spd * (180 / pi) / ARENA_RADIUS;

if (state == "approaching" || state == "shooting") {
    // Update position continuously so it follows the rim correctly
    if (abs(diff) > CROSSBOW_HOLD_ANGLE) {
        state = "approaching";
        image_speed = 2;
        if (abs(diff) <= angular_spd) {
            circle_angle = player_angle;
        } else {
            circle_angle += sign(diff) * angular_spd;
        }
    } else {
        state = "shooting";
        image_speed = 1;
        // Optionally back away if the player gets closer than the hold angle
        if (abs(diff) < CROSSBOW_HOLD_ANGLE - 5) {
            circle_angle -= sign(diff) * angular_spd * 0.8;
        }
    }
    
    x = arena_x(circle_angle);
    y = arena_y(circle_angle);

    if (state == "shooting") {
        shoot_timer--;
        if (shoot_timer <= 0) {
            shoot_timer = CROSSBOW_SHOOT_INTERVAL;
            var ang   = point_direction(x, y, oKnight.x, oKnight.y);
            var arrow = instance_create_layer(x, y, "Instances", oArrow);
            arrow.shooter_id = id;
            arrow.dir = ang;
            arrow.vx  = lengthdir_x(ARROW_SPEED, ang);
            arrow.vy  = lengthdir_y(ARROW_SPEED, ang);
            audio_play_sound(snd_swing, 1, false);
        }
    }
} else if (state == "charging") {
    // Bolt was deflected — now behaves like a base bandit: rush the player and melee on contact.
    image_speed = 2;

    if (abs(diff) <= angular_spd) {
        circle_angle = player_angle;
    } else {
        circle_angle += sign(diff) * angular_spd;
    }
    x = arena_x(circle_angle);
    y = arena_y(circle_angle);

    if (point_distance(x, y, oKnight.x, oKnight.y) <= ENEMY_CONTACT_DIST + 5) {
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
    }
}
