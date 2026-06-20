// Arena
#macro ARENA_CENTER_X 683
#macro ARENA_CENTER_Y 360
#macro ARENA_RADIUS 280              // angular-speed / timing reference radius (NOT the draw size — keep fixed to preserve pacing)
#macro ARENA_RADIUS_X 640            // ellipse half-width  (near full-screen: spans x 43..1323 of 1366)
#macro ARENA_RADIUS_Y 140            // ellipse half-height (flat: ~4.6:1 ratio for strong perspective)

// Player — sits at the front rim of the ellipse (parametric angle 270)
// PLAYER_START_X must equal ARENA_CENTER_X so the player maps cleanly to 270 degrees
#macro PLAYER_START_X 683
#macro PLAYER_START_Y 500            // ARENA_CENTER_Y + ARENA_RADIUS_Y — anchor sits ON the front rim line (feet grounded; bottom-center sprite lands here)
#macro PLAYER_MAX_HP 3
#macro PLAYER_SIZE 34                // visual size (kept modest; arena is large but big squares looked chunky)

// Knight sprite poses (visual only)
#macro KNIGHT_ATTACK_POSE_FRAMES 40  // how long the attack pose shows after a swing — matches ~9 frames at 3x speed
#macro KNIGHT_DEFEND_POSE_FRAMES 40  // how long the defend pose shows after a block — matches ~9 frames at 3x speed
#macro KNIGHT_DRAW_SCALE 3          // visual scale of the 60x60 knight art (tune to taste)
#macro BANDIT_DRAW_SCALE 2.0        // visual scale of the bandit art (smaller than knight)
#macro SHIELDED_DRAW_SCALE 2.0      // visual scale of the shielded-bandit art (matches bandit; both 92x92)
#macro ASSASSIN_DRAW_SCALE 2.0      // matches bandit/shielded

// Combat
#macro ATTACK_RANGE 130              // tightened from 184 — the wide flat ellipse made the ring feel huge (smaller = closer hits, tighter reaction)
#macro ATTACK_COOLDOWN_FRAMES 180    // 3s miss penalty at 60fps
#macro DEFEND_COOLDOWN_FRAMES 300    // 5s failsafe penalty at 60fps

// Parry rework — two concentric rings around the knight
#macro PERFECT_PARRY_RANGE 70        // inner ring: Defend with an enemy inside this = perfect parry (kill). Must be < ATTACK_RANGE
#macro IMPERFECT_PARRY_SLOW 0.6      // speed kept after an imperfect-parry knockback (slows the enemy)
#macro IMPERFECT_PARRY_COOLDOWN 120  // 2s defend lockout after an imperfect parry
#macro ASSASSIN_BACKSTEP_DIST 180    // ~177px chord, clearly leaves attack range
#macro ASSASSIN_BACKSTEP_FREEZE 75   // frames frozen after backstep (~1.25s)

// Enemies
#macro ENEMY_SIZE 30                 // fallback-square size (bumped ~+7% per hitbox request; combat is distance-based, see ENEMY_CONTACT_DIST)
#macro BASE_ENEMY_SPEED 1.8
#macro ENEMY_CONTACT_DIST 46         // enemy hits the player within this distance of the front rim

// Crossbow bandit — ranged enemy that holds way back and fires bolts
#macro CROSSBOW_HOLD_ANGLE 120       // holds this many degrees of arc from the player (bigger = further back / higher up). ~half the arena
#macro CROSSBOW_SHOOT_INTERVAL 100   // frames between bolts (~1.7s)
#macro ARROW_SPEED 7                 // bolt travel speed (px/frame)
#macro CROSSBOW_SPEED_MULT 1.5       // moves/charges faster than a base bandit (gets to its hold spot quickly)

// Healer pickup
#macro HEALER_SPAWN_CHANCE 0.35      // chance per normal wave to send a healer (only when the player is hurt)

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
#macro WAVE_PAUSE_FRAMES 0          // 1.5s between waves
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
#macro ENEMY_CROSSBOW 3
#macro ENEMY_HEALER 4

// Boss
#macro BOSS_WAVE_INTERVAL 5         // Boss appears every 5 waves
#macro BOSS_MAX_HP 10               // Big boss health pool
#macro BOSS_ATTACK_INTERVAL 90      // Fires a single projectile every 1.5 seconds (90 frames)
#macro BOSS_PROJ_SPEED 0.5          // degrees per frame along the ellipse arc
#macro BOSS_DRAW_SCALE 4.0          // Big lad — 4x scale in the background
#macro PROJ_TYPE_FIRE 0             // Red fireball — reflected by Attack (Z)
#macro PROJ_TYPE_MAGIC 1            // Blue orb — reflected by Defend (X)
