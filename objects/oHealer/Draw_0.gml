if (oGame.game_state == STATE_GAME_OVER) exit;

var spr = sprite_index;
if (sprite_exists(spr) && spr != -1) {
    var facing = (oKnight.x >= x) ? 1 : -1;
    draw_sprite_ext(spr, image_index, x, y, facing * BANDIT_DRAW_SCALE, BANDIT_DRAW_SCALE, 0, c_white, 1);
} else {
    // Fallback: green square with a white cross (heal pickup)
    draw_set_color(c_lime);
    draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2,
                   x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, false);
    draw_set_color(c_white);
    draw_rectangle(x - 3, y - ENEMY_SIZE/2 + 4, x + 3, y + ENEMY_SIZE/2 - 4, false);
    draw_rectangle(x - ENEMY_SIZE/2 + 4, y - 3, x + ENEMY_SIZE/2 - 4, y + 3, false);
}
