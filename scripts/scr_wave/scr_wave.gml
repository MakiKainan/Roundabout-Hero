function spawn_wave() {
    wave_number++;
    var composition = get_wave_composition();
    enemies_in_wave = array_length(composition);

    for (var i = 0; i < enemies_in_wave; i++) {
        var angle = (360 / enemies_in_wave) * i + 45;
        var sx = ARENA_CENTER_X + lengthdir_x(ARENA_RADIUS + 20, angle);
        var sy = ARENA_CENTER_Y + lengthdir_y(ARENA_RADIUS + 20, angle);
        instance_create_layer(sx, sy, "Instances", get_enemy_object(composition[i]));
    }
}

function get_wave_composition() {
    var t = floor(survival_timer / 60);
    var result = [];
    var size;

    if (t < 60) {
        size = irandom_range(2, 3);
        for (var i = 0; i < size; i++) {
            if (irandom(4) == 0) {
                result[i] = ENEMY_SHIELDED;
            } else {
                result[i] = ENEMY_BANDIT;
            }
        }
    } else if (t < 120) {
        size = irandom_range(3, 4);
        for (var i = 0; i < size; i++) {
            var roll = irandom(5);
            if (roll == 0) {
                result[i] = ENEMY_SHIELDED;
            } else if (roll == 1) {
                result[i] = ENEMY_ASSASSIN;
            } else {
                result[i] = ENEMY_BANDIT;
            }
        }
    } else {
        size = irandom_range(4, min(6, 3 + floor((t - 120) / 30)));
        for (var i = 0; i < size; i++) {
            var roll = irandom(4);
            if (roll == 0) {
                result[i] = ENEMY_SHIELDED;
            } else if (roll == 1) {
                result[i] = ENEMY_ASSASSIN;
            } else {
                result[i] = ENEMY_BANDIT;
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
