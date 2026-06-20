// oBoss — the giant background sorcerer
hp          = BOSS_MAX_HP;
max_hp      = BOSS_MAX_HP;
attack_timer = 60;  // First attack after 1 second so the entrance feels dramatic
enemy_type  = -1;   // Boss is not a normal enemy type

// Entrance: boss sinks in from above
enter_timer = 90;          // frames of entrance animation
enter_done  = false;
target_y    = ARENA_CENTER_Y - 120;  // rest position: high in the background
y           = -200;                  // start off-screen above

// Recoil when hit
hit_flash   = 0;           // frames of white flash when struck
