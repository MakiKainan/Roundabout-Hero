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
var _time_seconds = floor(survival_timer / 60);
var mins = floor(_time_seconds / 60);
var secs = _time_seconds mod 60;
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

// Combo counter
if (combo_count > 1) {
    draw_set_color(c_yellow);
    // Slight shake or scaling based on timer could be done, simple text for now
    var c_scale = 1.0 + (combo_count * 0.05);
    c_scale = min(c_scale, 2.0); // Cap scale
    draw_text_transformed(20, 80, "COMBO x" + string(combo_count) + "!", c_scale, c_scale, 0);
}

// Floating texts
for (var i = 0; i < array_length(floating_texts); i++) {
    var ft = floating_texts[i];
    draw_set_alpha(ft.alpha);
    draw_set_color(ft.color);
    draw_set_halign(fa_center);
    draw_text_transformed(ft.x, ft.y, ft.text, 1.5, 1.5, 0);
}
draw_set_alpha(1.0);

// Style Meter
if (style_display_score >= 0.5) {
    var sm_x = room_width - 80;
    var sm_y = 120;
    
    var _col = c_white;
    var _scale = 1.0;
    switch (style_rank) {
        case "D": _col = c_ltgray; _scale = 0.8; break;
        case "C": _col = c_white; _scale = 1.0; break;
        case "B": _col = c_aqua; _scale = 1.2; break;
        case "A": _col = c_lime; _scale = 1.4; break;
        case "S": _col = c_orange; _scale = 1.6; break;
        case "SS": _col = c_red; _scale = 1.8; break;
        case "SSS": _col = c_fuchsia; _scale = 2.0; break;
    }
    
    var _tier_progress = (style_display_score mod 100) / 100;
    if (style_rank == "SSS" || style_display_score >= 600) {
        _tier_progress = 1.0;
        _col = choose(c_fuchsia, c_red, c_yellow); // Rainbow strobe for SSS
    }
    
    var _pulse = 1.0 + (_tier_progress * 0.15);
    _scale *= _pulse;
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    if (variable_global_exists("fnt_rogue")) draw_set_font(global.fnt_rogue);
    
    // Draw thick shadow
    draw_set_color(c_black);
    draw_text_transformed(sm_x + 3, sm_y + 3, style_rank, _scale, _scale, 0);
    draw_text_transformed(sm_x - 3, sm_y - 3, style_rank, _scale, _scale, 0);
    
    // Draw core
    draw_set_color(_col);
    draw_text_transformed(sm_x, sm_y, style_rank, _scale, _scale, 0);
    
    draw_set_font(-1); // reset to default
    draw_set_valign(fa_top);
    
    draw_set_color(c_black);
    draw_rectangle(sm_x - 60, sm_y + 10, sm_x + 60, sm_y + 20, false);
    draw_set_color(_col);
    draw_rectangle(sm_x - 60, sm_y + 10, sm_x - 60 + (120 * _tier_progress), sm_y + 20, false);
    draw_set_color(c_white);
    draw_rectangle(sm_x - 60, sm_y + 10, sm_x + 60, sm_y + 20, true);
    
    draw_set_halign(fa_left);
}
draw_set_alpha(1.0);
draw_set_halign(fa_left);

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

// Ultimate flash (drawn over everything)
if (ultimate_flash > 0) {
    draw_set_color(c_white);
    draw_set_alpha(ultimate_flash);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
}

