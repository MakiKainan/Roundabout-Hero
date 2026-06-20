event_inherited();
enemy_type   = ENEMY_HEALER;
spd          = BASE_ENEMY_SPEED * oGame.difficulty_multiplier * 0.8;  // drifts a touch slower than a bandit
circle_angle = 90;             // default (top); the spawner overwrites with the true angle
state        = "moving";
// ponytail: is_vulnerable=false doubles as the "skip me" flag the fever chain-sweep already
// checks (same guard the shielded bandit uses) — keeps a stray chain explosion from eating the heal.
is_vulnerable = false;

// Heal the player and vanish. Shared by the Defend interaction and the "let it pass" path.
do_heal = function() {
    if (instance_exists(oKnight)) {
        oKnight.hp = min(PLAYER_MAX_HP, oKnight.hp + 1);
    }
    audio_play_sound(snd_hit, 1, false);
    part_particles_create(global.part_sys, x, y, global.part_explosion, 12);
    array_push(oGame.floating_texts, {x: x, y: y - 40, text: "+1 HP!", color: c_lime, alpha: 1.5});
    instance_destroy();
};

// Attacked = heal fails, it just disappears.
on_attacked = function(knight) {
    audio_play_sound(snd_swing, 1, false);
    part_particles_create(global.part_sys, x, y, global.part_hit, 10);
    array_push(oGame.floating_texts, {x: x, y: y - 40, text: "HEAL LOST!", color: c_gray, alpha: 1.5});
    instance_destroy();
};

// Defended near it = successful heal.
on_defended = function(knight) {
    do_heal();
};
