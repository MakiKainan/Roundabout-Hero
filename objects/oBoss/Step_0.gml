// oBoss Step

// --- Entrance slide-in ---
if (!enter_done) {
    y += (target_y - y) * 0.08;
    if (abs(y - target_y) < 2) {
        y = target_y;
        enter_done = true;
        // Big entrance announcement
        array_push(oGame.floating_texts, {
            x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 60,
            text: "BOSS APPEARS!", color: c_red, alpha: 2.0
        });
        oGame.shake_frames = 20;
        oGame.shake_magnitude = 10;
    }
    exit;
}

// --- Hit flash tick ---
if (hit_flash > 0) hit_flash--;

// --- Attack cycle ---
attack_timer--;
if (attack_timer <= 0) {
    attack_timer = BOSS_ATTACK_INTERVAL;

    // Spawn ONE projectile from a random side of the upper arc
    var _start_angles = [SPAWN_ARC_START + 20, SPAWN_ARC_START + SPAWN_ARC_SPAN - 20]; // e.g. ~40° and ~120°
    var _sa    = _start_angles[irandom(1)];
    var _proj  = instance_create_layer(arena_x(_sa), arena_y(_sa), "Instances", oBossProjectile);
    
    _proj.circle_angle = _sa;
    _proj.angle_spd    = BOSS_PROJ_SPEED; // degrees per frame
    _proj.proj_type    = (irandom(1) == 0) ? PROJ_TYPE_FIRE : PROJ_TYPE_MAGIC;
    _proj.boss_id      = id;
    _proj.reflected    = false;
    _proj.has_hit      = false;
}

// --- Death check ---
if (hp <= 0) {
    // Massive death explosion
    repeat(30) {
        var _ex = ARENA_CENTER_X + irandom_range(-200, 200);
        var _ey = ARENA_CENTER_Y + irandom_range(-150, 150);
        part_particles_create(global.part_sys, _ex, _ey, global.part_explosion, 20);
    }
    oGame.shake_frames     = 40;
    oGame.shake_magnitude  = 20;
    oGame.ultimate_flash   = 0.8;
    oGame.combat_score    += 500;
    oGame.combo_count     += 10;
    array_push(oGame.floating_texts, {
        x: ARENA_CENTER_X, y: ARENA_CENTER_Y - 80,
        text: "BOSS DEFEATED! +500", color: c_yellow, alpha: 2.0
    });
    // Destroy all projectiles too
    with (oBossProjectile) instance_destroy();
    instance_destroy();
}
