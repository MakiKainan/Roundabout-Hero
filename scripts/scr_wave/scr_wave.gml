// Angle -> position on the arena ellipse. Single source of truth for the
// projection (lengthdir_x uses only cos, lengthdir_y only sin, so feeding
// different radii traces a true ellipse). Visual/perspective tweaks live here.
function arena_x(angle) { return ARENA_CENTER_X + lengthdir_x(ARENA_RADIUS_X, angle); }
function arena_y(angle) { return ARENA_CENTER_Y + lengthdir_y(ARENA_RADIUS_Y, angle); }

function spawn_wave() {
    wave_number++;
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
            var roll = irandom(4);            // 5 outcomes, 20% each
            if (roll == 0) {
                result[i] = ENEMY_SHIELDED;   // ~20%
            } else if (roll == 1) {
                result[i] = ENEMY_ASSASSIN;   // ~20%, now from 30s
            } else {
                result[i] = ENEMY_BANDIT;     // ~60%
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
        default:             return oBandit;
    }
}
