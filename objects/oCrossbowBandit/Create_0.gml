event_inherited();
enemy_type   = ENEMY_CROSSBOW;
spd          = BASE_ENEMY_SPEED * oGame.difficulty_multiplier * CROSSBOW_SPEED_MULT;
circle_angle = 90;             // default (top); the spawner overwrites with the true angle
state        = "approaching";  // "approaching" -> "shooting" -> "charging" (after its bolt is deflected)
shoot_timer  = CROSSBOW_SHOOT_INTERVAL;
// Inherits the default on_attacked (one-hit kill). While holding/shooting it sits way back out
// of melee reach; deflecting its bolt flips it to "charging" so it rushes in like a base bandit.

// Assign a fallback sprite so GameMaker doesn't cull the object for having a 0x0 bounding box.
var spr = asset_get_index("spr_crossbow_bandit_walk");
if (!sprite_exists(spr)) {
    spr = asset_get_index("spr_bandit_walk");
}
sprite_index = spr;
