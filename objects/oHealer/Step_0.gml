if (oGame.game_state != STATE_PLAYING) { image_speed = 0; exit; }
if (oGame.hit_stop_frames > 0) exit;

depth = -y;

// Drift along the rim toward the player, like a bandit.
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

// Reached the player without being attacked — letting it pass heals you too.
if (point_distance(x, y, oKnight.x, oKnight.y) <= ENEMY_CONTACT_DIST) {
    do_heal();
}
