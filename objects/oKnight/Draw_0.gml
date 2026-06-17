if (oGame.game_state == STATE_GAME_OVER) exit;

// Player sprite — side profile, bottom-center origin lands feet on the rim.
// facing (+/-1) mirrors the art; sprite_index/image_index are set in Step.
draw_sprite_ext(sprite_index, image_index, x, y,
                facing * KNIGHT_DRAW_SCALE, KNIGHT_DRAW_SCALE,
                0, c_white, 1);

// HP hearts — top left
for (var i = 0; i < PLAYER_MAX_HP; i++) {
    if (i < hp) {
        draw_set_color(c_red);
        draw_rectangle(20 + i * 30, 20, 40 + i * 30, 40, false);
    } else {
        draw_set_color(c_dkgray);
        draw_rectangle(20 + i * 30, 20, 40 + i * 30, 40, true);
    }
}

// Cooldown indicators
draw_set_color(c_white);
if (attack_cooldown > 0) draw_text(20, 60, "ATK CD: " + string(ceil(attack_cooldown / 60)));
if (defend_cooldown > 0) draw_text(20, 80, "DEF CD: " + string(ceil(defend_cooldown / 60)));
