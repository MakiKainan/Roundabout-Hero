// Draw Parallax Backgrounds
if (variable_global_exists("bg_layers")) {
    for (var i = 0; i < array_length(global.bg_layers); i++) {
        var spr = global.bg_layers[i];
        if (sprite_exists(spr) && spr != -1) {
            var sh = max(1, sprite_get_height(spr));
            var scale = 768 / sh; // Scale to fit screen height
            draw_sprite_tiled_ext(spr, 0, global.bg_offsets[i], 0, scale, scale, c_white, 1.0);
        }
    }
}

// Arena ellipse (perspective platform)
// Draw only the outline so the background shows completely through the arena!
draw_set_color(c_ltgray);
draw_ellipse(ARENA_CENTER_X - ARENA_RADIUS_X, ARENA_CENTER_Y - ARENA_RADIUS_Y,
             ARENA_CENTER_X + ARENA_RADIUS_X, ARENA_CENTER_Y + ARENA_RADIUS_Y, true);  // Outline

// Attack range ring around player
if (instance_exists(oKnight)) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.25);
    draw_circle(oKnight.x, oKnight.y, ATTACK_RANGE, true);
    draw_set_alpha(1.0);
}

// Timer — top center
var mins = floor(score / 60);
var secs = score mod 60;
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(ARENA_CENTER_X, 20, "TIME: " + string(mins) + ":" + (secs < 10 ? "0" : "") + string(secs));

// Score — top right
draw_set_halign(fa_right);
draw_text(room_width - 20, 20, "SCORE: " + string(score));

// Wave counter — below HP hearts
draw_set_halign(fa_left);
draw_set_color(c_ltgray);
draw_text(20, 50, "WAVE: " + string(wave_number));

// Game over overlay
if (game_state == STATE_GAME_OVER) {
    draw_set_color(c_black);
    draw_set_alpha(0.65);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);

    draw_set_color(c_red);
    draw_set_halign(fa_center);
    draw_text_transformed(ARENA_CENTER_X, ARENA_CENTER_Y - 50, "GAME OVER", 2, 2, 0);

    draw_set_color(c_white);
    draw_text(ARENA_CENTER_X, ARENA_CENTER_Y + 10, "Score: " + string(score));
    draw_text(ARENA_CENTER_X, ARENA_CENTER_Y + 45, "Press R to restart");
    draw_set_halign(fa_left);
}

// Pause overlay
if (game_state == STATE_PAUSED) {
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text_transformed(ARENA_CENTER_X, ARENA_CENTER_Y - 20, "PAUSED", 2, 2, 0);
    draw_text(ARENA_CENTER_X, ARENA_CENTER_Y + 20, "Press ESC or P to resume");
    draw_set_halign(fa_left);
}

