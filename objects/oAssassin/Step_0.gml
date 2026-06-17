if (oGame.game_state != STATE_PLAYING) {
    image_speed = 0;
    exit;
}

depth = -y;

if (backstep_timer > 0) {
    backstep_timer--;
    exit;
}

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

if (point_distance(x, y, oKnight.x, oKnight.y) < ENEMY_CONTACT_DIST) {
    oKnight.hp--;
    oGame.shake_frames = 15;
    oGame.shake_magnitude = 8;
    part_particles_create(global.part_sys, oKnight.x, oKnight.y, global.part_hit, 15);
    instance_destroy();
    if (oKnight.hp <= 0) {
        oGame.game_state = STATE_GAME_OVER;
    }
}
