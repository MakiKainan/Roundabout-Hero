if (game_state == STATE_PLAYING) {
    if (shake_frames > 0) {
        shake_frames--;
        var _x = irandom_range(-shake_magnitude, shake_magnitude);
        var _y = irandom_range(-shake_magnitude, shake_magnitude);
        camera_set_view_pos(view_camera[0], _x, _y);
        if (shake_frames <= 0) {
            camera_set_view_pos(view_camera[0], 0, 0);
        }
    }
}
