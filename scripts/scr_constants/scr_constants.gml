// Arena
#macro ARENA_CENTER_X 683
#macro ARENA_CENTER_Y 360
#macro ARENA_RADIUS 280              // angular-speed / timing reference radius (NOT the draw size — keep fixed to preserve pacing)
#macro ARENA_RADIUS_X 640            // ellipse half-width  (near full-screen: spans x 43..1323 of 1366)
#macro ARENA_RADIUS_Y 140            // ellipse half-height (flat: ~4.6:1 ratio for strong perspective)

// Player — sits at the front rim of the ellipse (parametric angle 270)
// PLAYER_START_X must equal ARENA_CENTER_X so the player maps cleanly to 270 degrees
#macro PLAYER_START_X 683
#macro PLAYER_START_Y 463            // ARENA_CENTER_Y + ARENA_RADIUS_Y - 37 (37px gap < ENEMY_CONTACT_DIST)
#macro PLAYER_MAX_HP 3
#macro PLAYER_SIZE 34                // visual size (kept modest; arena is large but big squares looked chunky)

// Combat
#macro ATTACK_RANGE 184              // scaled ~2.3x with ARENA_RADIUS_X to keep the same angular hit window
#macro ATTACK_COOLDOWN_FRAMES 90     // 1.5s miss penalty at 60fps
#macro DEFEND_COOLDOWN_FRAMES 300    // 5s failsafe penalty at 60fps
#macro ASSASSIN_BACKSTEP_DIST 180    // ~177px chord, clearly leaves attack range
#macro ASSASSIN_BACKSTEP_FREEZE 75   // frames frozen after backstep (~1.25s)

// Enemies
#macro ENEMY_SIZE 28                 // visual size (smaller than contact dist, purely cosmetic)
#macro BASE_ENEMY_SPEED 1.8
#macro ENEMY_CONTACT_DIST 46         // scaled ~2.3x; front-rim contact gap (37px) stays inside this

// Spawn arc — upper half of the circle (90 = top, 270 = bottom/player)
#macro SPAWN_ARC_START 20            // degrees; lower edge of upper-half arc
#macro SPAWN_ARC_SPAN  140           // 20..160, keeps enemies clear of the player

// Wave size
#macro WAVE_SIZE_EARLY_MIN 2
#macro WAVE_SIZE_EARLY_MAX 5
#macro WAVE_SIZE_LATE_MIN  3
#macro WAVE_SIZE_LATE_MAX  7          // base max after 30s, grows over time
#macro WAVE_SIZE_CAP       12         // hard ceiling for the scaled max

// Wave
#macro WAVE_PAUSE_FRAMES 90          // 1.5s between waves
#macro ENEMY_SPAWN_DELAY_FRAMES 25   // ~0.4s between enemies

// Game states
#macro STATE_PLAYING 0
#macro STATE_WAVE_PAUSE 1
#macro STATE_GAME_OVER 2
#macro STATE_PAUSED 3

// Enemy type identifiers
#macro ENEMY_BANDIT 0
#macro ENEMY_SHIELDED 1
#macro ENEMY_ASSASSIN 2
