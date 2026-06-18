if (oGame.game_state == STATE_GAME_OVER) exit;

var spr = sprite_index;
if (sprite_exists(spr) && spr != -1) {
    var facing = (oKnight.x >= x) ? 1 : -1;
    draw_sprite_ext(spr, image_index, x, y, facing * ASSASSIN_DRAW_SCALE, ASSASSIN_DRAW_SCALE, 0, c_white, 1);
} else {
    if (backstep_state) { draw_set_color(make_color_rgb(200, 100, 200)); }
    else { draw_set_color(make_color_rgb(120, 0, 180)); }
    draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2, x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, false);
    draw_set_color(c_white);
}
