// If the current sprite exists (spr_bandit_walk or spr_bandit_attack), draw it. Otherwise fallback to rectangle
var spr = sprite_index;
if (sprite_exists(spr) && spr != -1) {
    var facing = (oKnight.x >= x) ? 1 : -1;
    draw_sprite_ext(spr, image_index, x, y, facing * KNIGHT_DRAW_SCALE, KNIGHT_DRAW_SCALE, 0, c_white, 1);
} else {
    draw_set_color(c_red);
    draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2,
                   x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, false);
}
