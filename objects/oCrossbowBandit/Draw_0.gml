if (oGame.game_state == STATE_GAME_OVER) exit;

var spr = sprite_index;
if (sprite_exists(spr) && spr != -1) {
    var facing = (oKnight.x >= x) ? 1 : -1;
    draw_sprite_ext(spr, image_index, x, y, facing * BANDIT_DRAW_SCALE, BANDIT_DRAW_SCALE, 0, c_white, 1);
} else {
    // Fallback: yellow square
    draw_set_color(c_yellow);
    draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2,
                   x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, false);
    draw_set_color(c_white);
    draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2,
                   x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, true);
}
