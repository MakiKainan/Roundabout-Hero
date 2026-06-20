// Angle -> position on the arena ellipse. Single source of truth for the
// projection (lengthdir_x uses only cos, lengthdir_y only sin, so feeding
// different radii traces a true ellipse). Visual/perspective tweaks live here.
function arena_x(angle) { return ARENA_CENTER_X + lengthdir_x(ARENA_RADIUS_X, angle); }
function arena_y(angle) { return ARENA_CENTER_Y + lengthdir_y(ARENA_RADIUS_Y, angle); }

function spawn_wave() {
    wave_number++;

    // Every BOSS_WAVE_INTERVAL waves, spawn the boss instead of normal enemies
    if ((wave_number mod BOSS_WAVE_INTERVAL) == 0) {
        // Clear any leftover projectiles from previous boss fight
        with (oBossProjectile) instance_destroy();

        // Announce the boss wave
        oGame.spawn_queue   = [];
        enemies_in_wave     = 1;
        oGame.ultimate_flash = 0.3;
        oGame.shake_frames   = 20;
        oGame.shake_magnitude = 8;
        array_push(oGame.floating_texts, {
            x: ARENA_CENTER_X, y: ARENA_CENTER_Y,
            text: "BOSS WAVE " + string(wave_number) + "!", color: c_red, alpha: 2.0
        });

        // Spawn the boss at screen centre
        var _boss = instance_create_layer(ARENA_CENTER_X, -200, "Instances", oBoss);
        _boss.max_hp = BOSS_MAX_HP + (wave_number div BOSS_WAVE_INTERVAL - 1) * 5; // scales up each encounter
        _boss.hp     = _boss.max_hp;
        oGame.spawn_timer = 0;
        return;
    }

    var composition = get_wave_composition();
    enemies_in_wave = array_length(composition);

    var slot = SPAWN_ARC_SPAN / enemies_in_wave;
    oGame.spawn_queue = [];

    for (var i = 0; i < enemies_in_wave; i++) {
        var angle = SPAWN_ARC_START + slot * i + random(slot);

        var enemy_data = {
            type: composition[i],
            angle: angle,
            x: arena_x(angle),
            y: arena_y(angle)
        };
        array_push(oGame.spawn_queue, enemy_data);
    }

    // Occasionally send a healer pickup, but only when the player is actually hurt.
    if (instance_exists(oKnight) && oKnight.hp < PLAYER_MAX_HP && random(1) < HEALER_SPAWN_CHANCE) {
        var hang = SPAWN_ARC_START + random(SPAWN_ARC_SPAN);
        array_push(oGame.spawn_queue, { type: ENEMY_HEALER, angle: hang, x: arena_x(hang), y: arena_y(hang) });
    }

    oGame.spawn_timer = 0;
}

function get_wave_composition() {
    var t = floor(survival_timer / 60);   // seconds survived
    var result = [];
    var size;

    if (t < 30) {
        size = irandom_range(WAVE_SIZE_EARLY_MIN, WAVE_SIZE_EARLY_MAX);
        for (var i = 0; i < size; i++) {
            if (irandom(4) == 0) {
                result[i] = ENEMY_SHIELDED;   // ~20%
            } else {
                result[i] = ENEMY_BANDIT;
            }
        }
    } else {
        var grown_max = min(WAVE_SIZE_CAP, WAVE_SIZE_LATE_MAX + floor((t - 30) / 60));
        size = irandom_range(WAVE_SIZE_LATE_MIN, grown_max);
        for (var i = 0; i < size; i++) {
            var roll = irandom(5);            // 6 outcomes
            if (roll == 0) {
                result[i] = ENEMY_SHIELDED;   // ~17%
            } else if (roll == 1) {
                result[i] = ENEMY_ASSASSIN;   // ~17%, from 30s
            } else if (roll == 2) {
                result[i] = ENEMY_CROSSBOW;   // ~17%, from 30s
            } else {
                result[i] = ENEMY_BANDIT;     // ~50%
            }
        }
    }
    return result;
}

function get_enemy_object(type) {
    switch (type) {
        case ENEMY_BANDIT:   return oBandit;
        case ENEMY_SHIELDED: return oShieldedBandit;
        case ENEMY_ASSASSIN: return oAssassin;
        case ENEMY_CROSSBOW: return oCrossbowBandit;
        case ENEMY_HEALER:   return oHealer;
        default:             return oBandit;
    }
}
