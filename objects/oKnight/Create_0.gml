hp = PLAYER_MAX_HP;
attack_cooldown = 0;
defend_cooldown = 0;

// Sprite state (visual)
sprite_index      = spr_knight_idle;  // drives the auto-advancing animation frame
image_speed       = 1;                // multiplier on the sprite's own 5fps
facing            = 1;                // 1 = face screen-right, -1 = face screen-left
attack_pose_timer = 0;                // frames left showing the attack pose
defend_pose_timer = 0;                // frames left showing the defend pose
perfect_parry_window = 0;             // active perfect parry frames
