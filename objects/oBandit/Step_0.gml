if (oGame.game_state != STATE_PLAYING) exit;

var player_angle = point_direction(ARENA_CENTER_X, ARENA_CENTER_Y, oKnight.x, oKnight.y);
var diff = angle_difference(player_angle, circle_angle);
var angular_spd = spd * (180 / pi) / ARENA_RADIUS;

if (abs(diff) <= angular_spd) {
    circle_angle = player_angle;
} else {
    circle_angle += sign(diff) * angular_spd;
}

x = ARENA_CENTER_X + lengthdir_x(ARENA_RADIUS, circle_angle);
y = ARENA_CENTER_Y + lengthdir_y(ARENA_RADIUS, circle_angle);

if (point_distance(x, y, oKnight.x, oKnight.y) < ENEMY_CONTACT_DIST) {
    oKnight.hp--;
    instance_destroy();
    if (oKnight.hp <= 0) {
        oGame.game_state = STATE_GAME_OVER;
    }
}
