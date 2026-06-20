// oBossProjectile Create
proj_type    = PROJ_TYPE_FIRE; // overridden by boss on spawn
boss_id      = noone;
reflected    = false;
lifetime     = 600;  // 10 second safety limit
spin         = 0;    // visual rotation

// Arc movement (same system as enemies)
circle_angle = 30;   // starting angle on ellipse — overridden by boss
angle_spd    = 3.5;  // degrees per frame (fast, harder to dodge)
has_hit      = false; // has already dealt damage this pass

// After reflect: straight-line back to boss center
refl_vx = 0;
refl_vy = 0;
