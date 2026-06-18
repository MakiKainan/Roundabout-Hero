// Post-Draw: manually render the application_surface with chromatic aberration
var _surf = application_surface;
var _w = surface_get_width(_surf);
var _h = surface_get_height(_surf);

if (chromatic_frames > 0 && chromatic_max > 0) {
    // Intensity fades from full to zero as frames count down
    var _t = chromatic_frames / chromatic_max;
    var _shift = lerp(0, 10, _t); // Max 10px RGB channel split

    draw_set_blend_mode(bm_add);

    // Red channel -- shifted left
    draw_set_color(c_red);
    draw_surface_ext(_surf, -_shift, 0, 1, 1, 0, c_red, 0.5);
    // Blue channel -- shifted right
    draw_set_color(c_blue);
    draw_surface_ext(_surf, _shift, 0, 1, 1, 0, c_blue, 0.5);

    draw_set_blend_mode(bm_normal);

    // Green/base layer at normal blend
    draw_surface_ext(_surf, 0, 0, 1, 1, 0, c_lime, 0.5);
} else {
    // No effect -- draw normally
    draw_surface(_surf, 0, 0);
}
