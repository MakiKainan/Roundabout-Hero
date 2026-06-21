var _col = c_white;
var _text = "";
var _btn = "";
if (orb_type == "HEAL") { _col = c_lime; _text = "HEALING LIGHT"; _btn = "[Z / L-Click]"; }
else if (orb_type == "GOLD") { _col = c_yellow; _text = "GOLD RUSH"; _btn = "[X / R-Click]"; }
else if (orb_type == "RAGE") { _col = c_red; _text = "BLOODLUST"; _btn = "[SPACE]"; }

var _pulse = abs(sin(current_time * 0.005)) * 0.5 + 0.5;

draw_set_alpha(0.5 * _pulse);
draw_set_color(_col);
draw_circle(x, y, 40, false);

draw_set_alpha(1.0);
draw_set_color(c_white);
draw_circle(x, y, 20, false);
draw_set_color(_col);
draw_circle(x, y, 20, true);
draw_circle(x, y, 18, true);

// Clamp text X so it never bleeds offscreen, even with long names
var _text_x = clamp(x, 150, room_width - 150);

draw_set_halign(fa_center);
draw_set_color(_col);
draw_text_transformed(_text_x, y - 80, _text, 1.5, 1.5, 0);
draw_set_color(c_white);
draw_text_transformed(_text_x, y - 55, _btn, 1.2, 1.2, 0);
draw_set_halign(fa_left);
draw_set_color(c_white);
