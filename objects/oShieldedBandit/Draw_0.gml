if (oGame.game_state == STATE_GAME_OVER) exit;

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
