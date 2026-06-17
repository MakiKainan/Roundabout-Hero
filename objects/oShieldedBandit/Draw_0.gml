if (oGame.game_state == STATE_GAME_OVER) exit;

var spr = sprite_index;
if (sprite_exists(spr) && spr != -1) {
    var facing = (oKnight.x >= x) ? 1 : -1;
    draw_sprite_ext(spr, image_index, x, y, facing * SHIELDED_DRAW_SCALE, SHIELDED_DRAW_SCALE, 0, c_white, 1);
} else {
    // Fallback: blue (shield up) / aqua (vulnerable) rectangle
    if (is_vulnerable) {
        draw_set_color(c_aqua);
    } else {
        draw_set_color(c_blue);
    }
    draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2,
                   x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, false);
    draw_set_color(c_white);
    draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2,
                   x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, true);
}
