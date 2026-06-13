if (backstep_state) {
    draw_set_color(make_color_rgb(200, 100, 200));
} else {
    draw_set_color(make_color_rgb(120, 0, 180));
}
draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2,
               x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, false);
