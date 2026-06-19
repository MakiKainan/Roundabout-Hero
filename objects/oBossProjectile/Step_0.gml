// oBossProjectile Step

if (oGame.game_state != STATE_PLAYING) exit;
if (oGame.hit_stop_frames > 0) exit; // freeze with everything else

spin += 8;
lifetime--;
if (lifetime <= 0) { instance_destroy(); exit; }

// =========================================================
// PHASE 1: Travel along ellipse arc toward player (270 deg)
// =========================================================
if (!reflected) {
    // Move along the ellipse the same way enemies do
    var _player_angle = point_direction(ARENA_CENTER_X, ARENA_CENTER_Y, oKnight.x, oKnight.y);
    var _diff = angle_difference(_player_angle, circle_angle);

    if (abs(_diff) <= angle_spd) {
        circle_angle = _player_angle;
    } else {
        circle_angle += sign(_diff) * angle_spd;
    }

    x = arena_x(circle_angle);
    y = arena_y(circle_angle);

    // Check if the projectile has reached the player zone
    if (abs(angle_difference(_player_angle, circle_angle)) < 10
        && point_distance(x, y, oKnight.x, oKnight.y) <= ENEMY_CONTACT_DIST + 30) {

        if (!has_hit) {
            has_hit = true;
            var _parried = false;

            if (proj_type == PROJ_TYPE_FIRE && oKnight.attack_pose_timer > 0) {
                _parried = true;
            } else if (proj_type == PROJ_TYPE_MAGIC && oKnight.defend_pose_timer > 0) {
                _parried = true;
            }

            if (_parried) {
                // DEFLECT — fly straight back to boss center
                reflected = true;
                
                // Refund the cooldown since it successfully hit a projectile
                if (proj_type == PROJ_TYPE_FIRE) {
                    oKnight.attack_cooldown = 0;
                    oGame.combo_count++; // refund the combo drop from missing a normal enemy
                    oGame.combo_timer = 180;
                } else if (proj_type == PROJ_TYPE_MAGIC) {
                    oKnight.defend_cooldown = 0;
                }
                var _spd = BOSS_PROJ_SPEED * 2;
                if (instance_exists(boss_id)) {
                    refl_vx = lengthdir_x(_spd, point_direction(x, y, boss_id.x, boss_id.y));
                    refl_vy = lengthdir_y(_spd, point_direction(x, y, boss_id.x, boss_id.y));
                } else {
                    // boss gone — fly toward screen center
                    refl_vx = lengthdir_x(_spd, point_direction(x, y, ARENA_CENTER_X, ARENA_CENTER_Y - 120));
                    refl_vy = lengthdir_y(_spd, point_direction(x, y, ARENA_CENTER_X, ARENA_CENTER_Y - 120));
                }

                oGame.shake_frames    = 8;
                oGame.shake_magnitude = 5;
                oGame.combo_count++;
                oGame.combat_score   += 30;
                oKnight.adrenaline    = min(oKnight.adrenaline_max, oKnight.adrenaline + 20);
                audio_play_sound(snd_hit, 1, false);
                part_particles_create(global.part_sys, x, y, global.part_hit, 15);

                var _txt = (proj_type == PROJ_TYPE_FIRE) ? "DEFLECT!" : "REFLECT!";
                var _col = (proj_type == PROJ_TYPE_FIRE) ? c_orange : c_aqua;
                array_push(oGame.floating_texts, { x: x, y: y - 30, text: _txt, color: _col, alpha: 1.5 });

            } else {
                // MISS — damage player
                oKnight.hp--;
                oKnight.adrenaline    = max(0, oKnight.adrenaline - 30);
                oGame.combo_count     = max(0, oGame.combo_count - 5);
                oGame.shake_frames    = 15;
                oGame.shake_magnitude = 8;
                oGame.hit_stop_frames = 6;
                audio_play_sound(snd_hit, 1, false);
                part_particles_create(global.part_sys, oKnight.x, oKnight.y, global.part_hit, 15);
                if (oKnight.hp <= 0) { oGame.game_state = STATE_GAME_OVER; }
                instance_destroy();
                exit;
            }
        }
    }
}

// =========================================================
// PHASE 2: Reflected — fly straight toward boss
// =========================================================
if (reflected) {
    x += refl_vx;
    y += refl_vy;

    if (instance_exists(boss_id)) {
        if (point_distance(x, y, boss_id.x, boss_id.y) < 60) {
            boss_id.hp--;
            boss_id.hit_flash     = 20;
            oGame.shake_frames    = 15;
            oGame.shake_magnitude = 10;
            oGame.combat_score   += 50;
            oGame.combo_count    += 2;
            oKnight.adrenaline    = min(oKnight.adrenaline_max, oKnight.adrenaline + 20);
            audio_play_sound(snd_hit, 1, false);
            part_particles_create(global.part_sys, boss_id.x, boss_id.y, global.part_explosion, 15);

            array_push(oGame.floating_texts, {
                x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 80,
                text: "BOSS HIT!  " + string(boss_id.hp) + " HP left",
                color: c_yellow, alpha: 1.5
            });
            instance_destroy();
        }
    } else {
        instance_destroy(); // boss already dead
    }

    // Off-screen safety
    if (x < -200 || x > room_width + 200 || y < -200 || y > room_height + 200) {
        instance_destroy();
    }
}
