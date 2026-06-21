shooter_id = noone;   // the oCrossbowBandit that fired this; killed when the bolt is blocked
vx         = 0;
vy         = 0;
dir        = 0;       // facing, for drawing
lifetime   = 240;     // 4s safety despawn
has_hit    = false;

// Assign a dummy sprite index to give the arrow a bounding box 
// so GameMaker's renderer doesn't cull it as an empty object.
sprite_index = asset_get_index("spr_bandit_walk");
