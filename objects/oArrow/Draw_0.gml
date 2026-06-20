if (oGame.game_state == STATE_GAME_OVER) exit;

// Placeholder: reuse the boss's blue "magic" orb (the defend-with-X projectile).
// Swap for a real bolt sprite later.
var _radius = 16;
var _spin   = current_time * 0.3;
var _pulse  = abs(sin(current_time * 0.006)) * 0.35 + 0.65;

// Outer aura
draw_set_alpha(0.25);
draw_set_color(c_aqua);
draw_circle(x, y, _radius + 10, false);

// Glowing core
draw_set_alpha(_pulse);
draw_set_color(make_color_rgb(80, 0, 220));
draw_circle(x, y, _radius, false);
draw_set_color(c_aqua);
draw_circle(x, y, _radius * 0.45, false);

// Orbiting sparks
draw_set_alpha(1.0);
draw_set_color(c_aqua);
for (var fi = 0; fi < 6; fi++) {
    var _fang = _spin + fi * 60;
    draw_circle(x + lengthdir_x(_radius + 4, _fang), y + lengthdir_y(_radius + 4, _fang), 4, false);
}

// Defend prompt
draw_set_halign(fa_center);
draw_set_color(c_aqua);
draw_text(x, y + _radius + 6, "X");

// Reset shared draw state
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_color(c_white);
