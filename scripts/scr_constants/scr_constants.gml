// Arena
#macro ARENA_CENTER_X 683
#macro ARENA_CENTER_Y 360
#macro ARENA_RADIUS 280

// Player — sits at the bottom of the circle
#macro PLAYER_START_X 683
#macro PLAYER_START_Y 624
#macro PLAYER_MAX_HP 3
#macro PLAYER_SIZE 24

// Combat
#macro ATTACK_RANGE 80
#macro ATTACK_COOLDOWN_FRAMES 90     // 1.5s miss penalty at 60fps
#macro DEFEND_COOLDOWN_FRAMES 300    // 5s failsafe penalty at 60fps
#macro ASSASSIN_BACKSTEP_DIST 120

// Enemies
#macro ENEMY_SIZE 20
#macro BASE_ENEMY_SPEED 1.8
#macro ENEMY_CONTACT_DIST 20

// Wave
#macro WAVE_PAUSE_FRAMES 90          // 1.5s between waves

// Game states
#macro STATE_PLAYING 0
#macro STATE_WAVE_PAUSE 1
#macro STATE_GAME_OVER 2

// Enemy type identifiers
#macro ENEMY_BANDIT 0
#macro ENEMY_SHIELDED 1
#macro ENEMY_ASSASSIN 2
