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

// Boss — drawn here so it appears above parallax, behind enemies/player
if (instance_exists(oBoss)) {
    with (oBoss) {
        var _bob = sin(current_time * 0.002) * 6;
        var _cx  = x;
        var _cy  = y + _bob;

        // Shadow
        draw_set_color(c_black);
        draw_set_alpha(0.4);
        draw_ellipse(_cx - 100, _cy + 120, _cx + 100, _cy + 140, false);
        draw_set_alpha(1.0);

        var _body_col = (hit_flash > 0 && (hit_flash mod 4 < 2)) ? c_white : make_color_rgb(30, 0, 60);
        var _robe_col = (hit_flash > 0 && (hit_flash mod 4 < 2)) ? c_white : make_color_rgb(60, 0, 100);

        // Robe
        draw_set_color(_robe_col);
        draw_triangle(_cx - 90, _cy + 110, _cx + 90, _cy + 110, _cx, _cy - 90, false);

        // Body
        draw_set_color(_body_col);
        draw_rectangle(_cx - 30, _cy - 80, _cx + 30, _cy + 60, false);

        // Head
        draw_set_color(_body_col);
        draw_circle(_cx, _cy - 100, 42, false);

        // Glowing eyes
        var _eye_pulse = abs(sin(current_time * 0.004)) * 0.6 + 0.4;
        draw_set_alpha(_eye_pulse);
        draw_set_color(c_orange);
        draw_circle(_cx - 15, _cy - 104, 8, false);
        draw_circle(_cx + 15, _cy - 104, 8, false);
        draw_set_alpha(1.0);

        // Crown
        draw_set_color(make_color_rgb(200, 150, 0));
        draw_triangle(_cx - 30, _cy - 138, _cx - 20, _cy - 115, _cx - 10, _cy - 138, false);
        draw_triangle(_cx - 10, _cy - 148, _cx,      _cy - 120, _cx + 10, _cy - 148, false);
        draw_triangle(_cx + 10, _cy - 138, _cx + 20, _cy - 115, _cx + 30, _cy - 138, false);

        // Floating hands
        var _hand_bob = sin(current_time * 0.003) * 10;
        draw_set_color(make_color_rgb(120, 0, 180));
        draw_circle(_cx - 110, _cy + _hand_bob, 18, false);
        draw_circle(_cx + 110, _cy + _hand_bob, 18, false);

        // HP bar
        var _bar_w  = 200;
        var _bar_x  = _cx - _bar_w / 2;
        var _bar_y  = _cy - 175;
        var _hp_frac = hp / max_hp;
        draw_set_color(c_dkgray);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + 12, false);
        draw_set_color(merge_color(c_red, c_lime, _hp_frac));
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w * _hp_frac, _bar_y + 12, false);
        draw_set_color(c_white);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + 12, true);

        draw_set_halign(fa_center);
        draw_set_color(c_red);
        draw_text(_cx, _bar_y - 20, "THE SORCERER LORD");
        draw_set_color(c_white);
        draw_text(_cx, _bar_y - 5,  "HP: " + string(hp) + " / " + string(max_hp));
        draw_set_halign(fa_left);
        
        // Death Execution Slashes & Prompt
        if (is_dying) {
            draw_set_halign(fa_center);
            
            // Draw Slashes
            for (var i = 0; i < array_length(slashes); i++) {
                var _s = slashes[i];
                var _alpha = _s.frames / 10.0;
                
                // Glow
                draw_set_alpha(_alpha * 0.5);
                draw_set_color(c_red);
                draw_line_width(_s.x1, _s.y1, _s.x2, _s.y2, 12);
                
                // Core
                draw_set_alpha(_alpha);
                draw_set_color(c_white);
                draw_line_width(_s.x1, _s.y1, _s.x2, _s.y2, 4);
            }
            
            // Draw MASH Prompt
            draw_set_alpha(1.0);
            draw_set_color(c_red);
            var _pulse = 1.5 + abs(sin(current_time * 0.015)) * 0.5;
            draw_text_transformed(_cx, _cy + 40, "MASH Z!", _pulse, _pulse, random_range(-2, 2));
            
            draw_set_color(c_white);
            draw_text_transformed(_cx, _cy + 80, string(mash_count) + " HITS", 1.5, 1.5, 0);
            
            draw_set_halign(fa_left);
        }
    }
}

// Boss projectiles — drawn here in correct order
with (oBossProjectile) {
    var _radius = 18;
    var _trail  = 8;

    if (proj_type == PROJ_TYPE_FIRE) {
        var _pulse = abs(sin(current_time * 0.008)) * 0.4 + 0.6;
        draw_set_alpha(0.35);
        draw_set_color(c_orange);
        draw_circle(x - lengthdir_x(_trail, direction), y - lengthdir_y(_trail, direction), _radius * 0.9, false);
        draw_set_alpha(0.2);
        draw_circle(x - lengthdir_x(_trail * 2, direction), y - lengthdir_y(_trail * 2, direction), _radius * 0.6, false);
        draw_set_alpha(_pulse);
        draw_set_color(c_red);
        draw_circle(x, y, _radius, false);
        draw_set_color(c_yellow);
        draw_circle(x, y, _radius * 0.55, false);
        draw_set_alpha(1.0);
        draw_set_color(c_orange);
        for (var fi = 0; fi < 4; fi++) {
            var _fang = spin + fi * 90;
            draw_triangle(
                x + lengthdir_x(_radius + 6, _fang), y + lengthdir_y(_radius + 6, _fang),
                x + lengthdir_x(_radius - 4, _fang - 20), y + lengthdir_y(_radius - 4, _fang - 20),
                x + lengthdir_x(_radius - 4, _fang + 20), y + lengthdir_y(_radius - 4, _fang + 20),
                false);
        }
        draw_set_color(c_red);
        draw_set_halign(fa_center);
        draw_text(x, y + _radius + 6, "Z");
    } else {
        var _pulse = abs(sin(current_time * 0.006)) * 0.35 + 0.65;
        draw_set_alpha(0.25);
        draw_set_color(c_aqua);
        draw_circle(x, y, _radius + 10, false);
        draw_set_alpha(_pulse);
        draw_set_color(make_color_rgb(80, 0, 220));
        draw_circle(x, y, _radius, false);
        draw_set_color(c_aqua);
        draw_circle(x, y, _radius * 0.45, false);
        draw_set_alpha(1.0);
        draw_set_color(c_aqua);
        for (var fi = 0; fi < 6; fi++) {
            var _fang = spin + fi * 60;
            draw_circle(x + lengthdir_x(_radius + 4, _fang), y + lengthdir_y(_radius + 4, _fang), 4, false);
        }
        draw_set_color(c_aqua);
        draw_set_halign(fa_center);
        draw_text(x, y + _radius + 6, "X");
    }
    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
}

// Death Orb (drawn massive and scary)
with (oDeathOrb) {
    var _pulse = abs(sin(current_time * 0.01 + pulse)) * 0.3 + 0.7;
    var _base_rad = 35 + (volley_count * 2);
    
    // Aura
    draw_set_alpha(_pulse * 0.5);
    draw_set_color(c_fuchsia);
    draw_circle(x + random_range(-5, 5), y + random_range(-5, 5), _base_rad * 1.5, false);
    draw_set_color(c_red);
    draw_circle(x, y, _base_rad * 1.2, false);
    
    // Core
    draw_set_alpha(1.0);
    draw_set_color(c_black);
    draw_circle(x, y, _base_rad, false);
    
    // Outer rim
    draw_set_color(c_red);
    draw_circle(x, y, _base_rad, true);
    draw_circle(x, y, _base_rad - 1, true);
    draw_circle(x, y, _base_rad - 2, true);
    
    // Trailing shadow
    draw_set_alpha(0.3);
    draw_set_color(c_black);
    draw_circle(x - lengthdir_x(_base_rad, direction), y - lengthdir_y(_base_rad, direction), _base_rad * 0.8, false);
    
    // Hint text for player
    if (direction == 270) {
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(x, y - 10, "Z/X");
        draw_set_halign(fa_left);
    }
    
    draw_set_alpha(1.0);
}


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

