# Roundabout Hero — Gameplay Prototype Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a fully playable Roundabout Hero prototype using colored squares — three enemy types, wave-based spawning, Attack/Defend combat, difficulty scaling, and game over/restart.

**Architecture:** A single controller object (`oGame`) owns game state, wave spawning, timer, and difficulty. The player (`oKnight`) sits fixed at the arena's bottom-center and resolves all combat from input. All three enemy types inherit from `par_enemy` so nearest-enemy queries work across types. No physics — all movement is manual position math using `point_direction` + `lengthdir_x/y`.

**Tech Stack:** GameMaker Studio 2 (2026.x), GML

---

## File Map

```
scripts/
  scr_constants/scr_constants.gml      ← all #macro constants
  scr_constants/scr_constants.yy
  scr_wave/scr_wave.gml                ← spawn_wave(), get_wave_composition(), get_enemy_object()
  scr_wave/scr_wave.yy

objects/
  par_enemy/par_enemy.yy               ← parent object, no events (grouping only)
  oGame/Create_0.gml                   ← init state, spawn player, call spawn_wave()
  oGame/Step_0.gml                     ← timer, difficulty, wave management, restart
  oGame/Draw_0.gml                     ← arena circle, UI, game over overlay
  oGame/oGame.yy
  oKnight/Create_0.gml                 ← HP, cooldown vars
  oKnight/Step_0.gml                   ← input, combat resolution, cooldown tick
  oKnight/Draw_0.gml                   ← player square, HP hearts, cooldown indicators
  oKnight/oKnight.yy
  oBandit/Create_0.gml                 ← enemy_type, speed
  oBandit/Step_0.gml                   ← move toward player, contact damage
  oBandit/Draw_0.gml                   ← red square
  oBandit/oBandit.yy
  oShieldedBandit/Create_0.gml
  oShieldedBandit/Step_0.gml
  oShieldedBandit/Draw_0.gml
  oShieldedBandit/oShieldedBandit.yy
  oAssassin/Create_0.gml
  oAssassin/Step_0.gml
  oAssassin/Draw_0.gml
  oAssassin/oAssassin.yy

Roundabout Hero.yyp                    ← add all new resources
rooms/Room1/Room1.yy                   ← add oGame instance
```

---

## Task 1: Project Constants

**Files:**
- Create: `scripts/scr_constants/scr_constants.gml`
- Create: `scripts/scr_constants/scr_constants.yy`
- Modify: `Roundabout Hero.yyp`

- [ ] **Step 1: Create the constants script**

Create `scripts/scr_constants/scr_constants.gml`:
```gml
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
```

- [ ] **Step 2: Create the script .yy file**

Create `scripts/scr_constants/scr_constants.yy`:
```json
{
  "$GMScript": "",
  "%Name": "scr_constants",
  "isDnD": false,
  "isCompatibility": false,
  "name": "scr_constants",
  "parent": {
    "name": "Roundabout Hero",
    "path": "Roundabout Hero.yyp"
  },
  "resourceType": "GMScript",
  "resourceVersion": "2.0"
}
```

- [ ] **Step 3: Register in `Roundabout Hero.yyp`**

In `Roundabout Hero.yyp`, add to the `"resources"` array:
```json
{"id": {"name": "scr_constants", "path": "scripts/scr_constants/scr_constants.yy"}}
```

- [ ] **Step 4: Verify**

Open the project in GMS2. It should load without errors and `scr_constants` should appear in the Asset Browser under Scripts.

- [ ] **Step 5: Commit**

```
git add scripts/ "Roundabout Hero.yyp"
git commit -m "feat: add game constants"
```

---

## Task 2: Arena and oGame shell

**Files:**
- Create: `objects/oGame/oGame.yy`
- Create: `objects/oGame/Create_0.gml`
- Create: `objects/oGame/Step_0.gml`
- Create: `objects/oGame/Draw_0.gml`
- Modify: `Roundabout Hero.yyp`
- Modify: `rooms/Room1/Room1.yy`

- [ ] **Step 1: Create `objects/oGame/oGame.yy`**

```json
{
  "$GMObject": "",
  "%Name": "oGame",
  "eventList": [
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":0,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":3,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":8,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"}
  ],
  "managed": true,
  "name": "oGame",
  "overriddenProperties": [],
  "parent": {"name": "Roundabout Hero", "path": "Roundabout Hero.yyp"},
  "parentObjectId": null,
  "persistent": false,
  "physicsAngularDamping": 0.1,
  "physicsCollisionBitMask": 4294967295,
  "physicsDensity": 0.5,
  "physicsFriction": 0.2,
  "physicsGroup": 1,
  "physicsKinematic": false,
  "physicsLinearDamping": 0.1,
  "physicsObject": false,
  "physicsRestitution": 0.1,
  "physicsShape": 1,
  "physicsShapePoints": [],
  "physicsStartAwake": true,
  "resourceType": "GMObject",
  "resourceVersion": "2.0",
  "solid": false,
  "spriteId": null,
  "spriteMaskId": null,
  "visible": true
}
```

- [ ] **Step 2: Create `objects/oGame/Create_0.gml` (shell)**

```gml
game_state = STATE_PLAYING;
survival_timer = 0;
score = 0;
difficulty_multiplier = 1.0;
wave_number = 0;
wave_pause_timer = 0;
enemies_in_wave = 0;
```

- [ ] **Step 3: Create `objects/oGame/Step_0.gml` (timer only)**

```gml
if (game_state == STATE_PLAYING) {
    survival_timer++;
    score = floor(survival_timer / 60);
}
```

- [ ] **Step 4: Create `objects/oGame/Draw_0.gml` (arena only)**

```gml
draw_set_color(c_dkgray);
draw_circle(ARENA_CENTER_X, ARENA_CENTER_Y, ARENA_RADIUS, true);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(ARENA_CENTER_X, 20, "TIME: " + string(score));
draw_set_halign(fa_left);
```

- [ ] **Step 5: Register oGame in `Roundabout Hero.yyp`**

Add to `"resources"`:
```json
{"id": {"name": "oGame", "path": "objects/oGame/oGame.yy"}}
```

- [ ] **Step 6: Add oGame to Room1**

In `rooms/Room1/Room1.yy`, update the `"Instances"` layer's `"instances"` array:
```json
{
  "$GMRInstance": "",
  "%Name": "inst_oGame",
  "colour": 4294967295,
  "frozen": false,
  "hasCreationCode": false,
  "ignore": false,
  "imageIndex": 0,
  "imageSpeed": 1.0,
  "inheritCode": false,
  "inheritedItemId": null,
  "inheritItemSettings": false,
  "isDnd": false,
  "name": "inst_oGame",
  "objectId": {"name": "oGame", "path": "objects/oGame/oGame.yy"},
  "properties": [],
  "resourceType": "GMRInstance",
  "resourceVersion": "2.0",
  "rotation": 0.0,
  "scaleX": 1.0,
  "scaleY": 1.0,
  "x": 0.0,
  "y": 0.0
}
```

Also update `"instanceCreationOrder"`:
```json
"instanceCreationOrder": [
  {"name": "inst_oGame", "path": "rooms/Room1/Room1.yy"}
]
```

- [ ] **Step 7: Verify**

Run the game. You should see a dark gray circle outline in the center of the screen and "TIME: 0" counting up each second. No errors.

- [ ] **Step 8: Commit**

```
git add objects/oGame/ rooms/ "Roundabout Hero.yyp"
git commit -m "feat: arena and oGame controller shell"
```

---

## Task 3: Player object (oKnight)

**Files:**
- Create: `objects/oKnight/oKnight.yy`
- Create: `objects/oKnight/Create_0.gml`
- Create: `objects/oKnight/Step_0.gml`
- Create: `objects/oKnight/Draw_0.gml`
- Modify: `objects/oGame/Create_0.gml`
- Modify: `Roundabout Hero.yyp`

- [ ] **Step 1: Create `objects/oKnight/oKnight.yy`**

```json
{
  "$GMObject": "",
  "%Name": "oKnight",
  "eventList": [
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":0,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":3,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":8,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"}
  ],
  "managed": true,
  "name": "oKnight",
  "overriddenProperties": [],
  "parent": {"name": "Roundabout Hero", "path": "Roundabout Hero.yyp"},
  "parentObjectId": null,
  "persistent": false,
  "physicsAngularDamping": 0.1,
  "physicsCollisionBitMask": 4294967295,
  "physicsDensity": 0.5,
  "physicsFriction": 0.2,
  "physicsGroup": 1,
  "physicsKinematic": false,
  "physicsLinearDamping": 0.1,
  "physicsObject": false,
  "physicsRestitution": 0.1,
  "physicsShape": 1,
  "physicsShapePoints": [],
  "physicsStartAwake": true,
  "resourceType": "GMObject",
  "resourceVersion": "2.0",
  "solid": false,
  "spriteId": null,
  "spriteMaskId": null,
  "visible": true
}
```

- [ ] **Step 2: Create `objects/oKnight/Create_0.gml`**

```gml
hp = PLAYER_MAX_HP;
attack_cooldown = 0;
defend_cooldown = 0;
```

- [ ] **Step 3: Create `objects/oKnight/Step_0.gml` (cooldown tick only — combat added in Task 6)**

```gml
if (oGame.game_state != STATE_PLAYING) exit;

if (attack_cooldown > 0) attack_cooldown--;
if (defend_cooldown > 0) defend_cooldown--;
```

- [ ] **Step 4: Create `objects/oKnight/Draw_0.gml`**

```gml
// Player square
draw_set_color(c_white);
draw_rectangle(x - PLAYER_SIZE/2, y - PLAYER_SIZE/2,
               x + PLAYER_SIZE/2, y + PLAYER_SIZE/2, false);

// HP hearts — top left
for (var i = 0; i < PLAYER_MAX_HP; i++) {
    if (i < hp) {
        draw_set_color(c_red);
        draw_rectangle(20 + i * 30, 20, 40 + i * 30, 40, false);
    } else {
        draw_set_color(c_dkgray);
        draw_rectangle(20 + i * 30, 20, 40 + i * 30, 40, true);
    }
}

// Cooldown indicators
draw_set_color(c_white);
if (attack_cooldown > 0) draw_text(20, 60, "ATK CD: " + string(ceil(attack_cooldown / 60)));
if (defend_cooldown > 0) draw_text(20, 80, "DEF CD: " + string(ceil(defend_cooldown / 60)));
```

- [ ] **Step 5: Update `objects/oGame/Create_0.gml` to spawn the player**

Add at the end of Create_0.gml:
```gml
instance_create_layer(PLAYER_START_X, PLAYER_START_Y, "Instances", oKnight);
```

- [ ] **Step 6: Register oKnight in `Roundabout Hero.yyp`**

Add to `"resources"`:
```json
{"id": {"name": "oKnight", "path": "objects/oKnight/oKnight.yy"}}
```

- [ ] **Step 7: Verify**

Run the game. A white square should appear at the bottom of the circle. Three red HP squares show at the top-left. No errors.

- [ ] **Step 8: Commit**

```
git add objects/oKnight/ objects/oGame/Create_0.gml "Roundabout Hero.yyp"
git commit -m "feat: player object with HP display"
```

---

## Task 4: Enemy parent, Bandit, and enemy stubs

> **Note:** `oShieldedBandit` and `oAssassin` are created here as stubs (`.yy` only, no event files) so the wave script in Task 5 can reference them. Their full behavior is added in Tasks 7 and 8.

**Files:**
- Create: `objects/par_enemy/par_enemy.yy`
- Create: `objects/oBandit/oBandit.yy`
- Create: `objects/oBandit/Create_0.gml`
- Create: `objects/oBandit/Step_0.gml`
- Create: `objects/oBandit/Draw_0.gml`
- Create: `objects/oShieldedBandit/oShieldedBandit.yy` (stub)
- Create: `objects/oAssassin/oAssassin.yy` (stub)
- Modify: `Roundabout Hero.yyp`

- [ ] **Step 1: Create `objects/par_enemy/par_enemy.yy`**

```json
{
  "$GMObject": "",
  "%Name": "par_enemy",
  "eventList": [],
  "managed": true,
  "name": "par_enemy",
  "overriddenProperties": [],
  "parent": {"name": "Roundabout Hero", "path": "Roundabout Hero.yyp"},
  "parentObjectId": null,
  "persistent": false,
  "physicsAngularDamping": 0.1,
  "physicsCollisionBitMask": 4294967295,
  "physicsDensity": 0.5,
  "physicsFriction": 0.2,
  "physicsGroup": 1,
  "physicsKinematic": false,
  "physicsLinearDamping": 0.1,
  "physicsObject": false,
  "physicsRestitution": 0.1,
  "physicsShape": 1,
  "physicsShapePoints": [],
  "physicsStartAwake": true,
  "resourceType": "GMObject",
  "resourceVersion": "2.0",
  "solid": false,
  "spriteId": null,
  "spriteMaskId": null,
  "visible": true
}
```

- [ ] **Step 2: Create `objects/oBandit/oBandit.yy`**

```json
{
  "$GMObject": "",
  "%Name": "oBandit",
  "eventList": [
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":0,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":3,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":8,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"}
  ],
  "managed": true,
  "name": "oBandit",
  "overriddenProperties": [],
  "parent": {"name": "Roundabout Hero", "path": "Roundabout Hero.yyp"},
  "parentObjectId": {"name": "par_enemy", "path": "objects/par_enemy/par_enemy.yy"},
  "persistent": false,
  "physicsAngularDamping": 0.1,
  "physicsCollisionBitMask": 4294967295,
  "physicsDensity": 0.5,
  "physicsFriction": 0.2,
  "physicsGroup": 1,
  "physicsKinematic": false,
  "physicsLinearDamping": 0.1,
  "physicsObject": false,
  "physicsRestitution": 0.1,
  "physicsShape": 1,
  "physicsShapePoints": [],
  "physicsStartAwake": true,
  "resourceType": "GMObject",
  "resourceVersion": "2.0",
  "solid": false,
  "spriteId": null,
  "spriteMaskId": null,
  "visible": true
}
```

- [ ] **Step 3: Create `objects/oBandit/Create_0.gml`**

```gml
enemy_type = ENEMY_BANDIT;
spd = BASE_ENEMY_SPEED * oGame.difficulty_multiplier;
```

- [ ] **Step 4: Create `objects/oBandit/Step_0.gml`**

```gml
if (oGame.game_state != STATE_PLAYING) exit;

var dir = point_direction(x, y, oKnight.x, oKnight.y);
x += lengthdir_x(spd, dir);
y += lengthdir_y(spd, dir);

if (point_distance(x, y, oKnight.x, oKnight.y) < ENEMY_CONTACT_DIST) {
    oKnight.hp--;
    instance_destroy();
    if (oKnight.hp <= 0) {
        oGame.game_state = STATE_GAME_OVER;
    }
}
```

- [ ] **Step 5: Create `objects/oBandit/Draw_0.gml`**

```gml
draw_set_color(c_red);
draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2,
               x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, false);
```

- [ ] **Step 6: Create `objects/oShieldedBandit/oShieldedBandit.yy` (stub — no events yet)**

```json
{
  "$GMObject": "",
  "%Name": "oShieldedBandit",
  "eventList": [],
  "managed": true,
  "name": "oShieldedBandit",
  "overriddenProperties": [],
  "parent": {"name": "Roundabout Hero", "path": "Roundabout Hero.yyp"},
  "parentObjectId": {"name": "par_enemy", "path": "objects/par_enemy/par_enemy.yy"},
  "persistent": false,
  "physicsAngularDamping": 0.1,
  "physicsCollisionBitMask": 4294967295,
  "physicsDensity": 0.5,
  "physicsFriction": 0.2,
  "physicsGroup": 1,
  "physicsKinematic": false,
  "physicsLinearDamping": 0.1,
  "physicsObject": false,
  "physicsRestitution": 0.1,
  "physicsShape": 1,
  "physicsShapePoints": [],
  "physicsStartAwake": true,
  "resourceType": "GMObject",
  "resourceVersion": "2.0",
  "solid": false,
  "spriteId": null,
  "spriteMaskId": null,
  "visible": true
}
```

- [ ] **Step 7: Create `objects/oAssassin/oAssassin.yy` (stub — no events yet)**

```json
{
  "$GMObject": "",
  "%Name": "oAssassin",
  "eventList": [],
  "managed": true,
  "name": "oAssassin",
  "overriddenProperties": [],
  "parent": {"name": "Roundabout Hero", "path": "Roundabout Hero.yyp"},
  "parentObjectId": {"name": "par_enemy", "path": "objects/par_enemy/par_enemy.yy"},
  "persistent": false,
  "physicsAngularDamping": 0.1,
  "physicsCollisionBitMask": 4294967295,
  "physicsDensity": 0.5,
  "physicsFriction": 0.2,
  "physicsGroup": 1,
  "physicsKinematic": false,
  "physicsLinearDamping": 0.1,
  "physicsObject": false,
  "physicsRestitution": 0.1,
  "physicsShape": 1,
  "physicsShapePoints": [],
  "physicsStartAwake": true,
  "resourceType": "GMObject",
  "resourceVersion": "2.0",
  "solid": false,
  "spriteId": null,
  "spriteMaskId": null,
  "visible": true
}
```

- [ ] **Step 8: Register all four objects in `Roundabout Hero.yyp`**

Add to `"resources"`:
```json
{"id": {"name": "par_enemy",       "path": "objects/par_enemy/par_enemy.yy"}},
{"id": {"name": "oBandit",         "path": "objects/oBandit/oBandit.yy"}},
{"id": {"name": "oShieldedBandit", "path": "objects/oShieldedBandit/oShieldedBandit.yy"}},
{"id": {"name": "oAssassin",       "path": "objects/oAssassin/oAssassin.yy"}}
```

- [ ] **Step 9: Verify — temporary spawn test**

Temporarily add to the end of `objects/oGame/Create_0.gml`:
```gml
instance_create_layer(ARENA_CENTER_X, ARENA_CENTER_Y - ARENA_RADIUS, "Instances", oBandit);
```
Run the game. A red square should walk from the top of the circle toward the white player square, then despawn and remove one HP block. Remove the temporary line after confirming.

- [ ] **Step 10: Commit**

```
git add objects/par_enemy/ objects/oBandit/ objects/oShieldedBandit/ objects/oAssassin/ "Roundabout Hero.yyp"
git commit -m "feat: enemy parent, Bandit, and stub objects for ShieldedBandit/Assassin"
```

---

## Task 5: Wave spawner

**Files:**
- Create: `scripts/scr_wave/scr_wave.gml`
- Create: `scripts/scr_wave/scr_wave.yy`
- Modify: `objects/oGame/Create_0.gml`
- Modify: `objects/oGame/Step_0.gml`
- Modify: `Roundabout Hero.yyp`

- [ ] **Step 1: Create `scripts/scr_wave/scr_wave.gml`**

> **Note:** `get_wave_composition()` only spawns Bandits here. It is updated in Task 7 to add ShieldedBandits, and again in Task 8 to add Assassins, once those objects have their Create events and `enemy_type` variable set.

```gml
function spawn_wave() {
    wave_number++;
    var composition = get_wave_composition();
    enemies_in_wave = array_length(composition);

    for (var i = 0; i < enemies_in_wave; i++) {
        // Space enemies evenly, offset 45° so none spawn directly on the player
        var angle = (360 / enemies_in_wave) * i + 45;
        var sx = ARENA_CENTER_X + lengthdir_x(ARENA_RADIUS, angle);
        var sy = ARENA_CENTER_Y + lengthdir_y(ARENA_RADIUS, angle);
        instance_create_layer(sx, sy, "Instances", get_enemy_object(composition[i]));
    }
}

function get_wave_composition() {
    // ShieldedBandits and Assassins added in Tasks 7 and 8 respectively
    var t = floor(survival_timer / 60);
    var result = [];
    var size = irandom_range(2, 3);
    for (var i = 0; i < size; i++) result[i] = ENEMY_BANDIT;
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
```

- [ ] **Step 2: Create `scripts/scr_wave/scr_wave.yy`**

```json
{
  "$GMScript": "",
  "%Name": "scr_wave",
  "isDnD": false,
  "isCompatibility": false,
  "name": "scr_wave",
  "parent": {"name": "Roundabout Hero", "path": "Roundabout Hero.yyp"},
  "resourceType": "GMScript",
  "resourceVersion": "2.0"
}
```

- [ ] **Step 3: Update `objects/oGame/Create_0.gml` to call spawn_wave()**

Add at the end:
```gml
spawn_wave();
```

Full file should now read:
```gml
game_state = STATE_PLAYING;
survival_timer = 0;
score = 0;
difficulty_multiplier = 1.0;
wave_number = 0;
wave_pause_timer = 0;
enemies_in_wave = 0;

instance_create_layer(PLAYER_START_X, PLAYER_START_Y, "Instances", oKnight);
spawn_wave();
```

- [ ] **Step 4: Update `objects/oGame/Step_0.gml` with wave management and difficulty scaling**

Replace with:
```gml
if (game_state == STATE_PLAYING) {
    survival_timer++;
    score = floor(survival_timer / 60);

    // Difficulty steps
    if (survival_timer == 3600) {
        difficulty_multiplier = 1.2;
    } else if (survival_timer == 7200) {
        difficulty_multiplier = 1.3;
    } else if (survival_timer > 7200 && (survival_timer mod 1800) == 0) {
        difficulty_multiplier += 0.1;
    }

    // Advance wave when all enemies are cleared
    if (instance_number(par_enemy) == 0) {
        game_state = STATE_WAVE_PAUSE;
        wave_pause_timer = WAVE_PAUSE_FRAMES;
    }
}

if (game_state == STATE_WAVE_PAUSE) {
    wave_pause_timer--;
    if (wave_pause_timer <= 0) {
        game_state = STATE_PLAYING;
        spawn_wave();
    }
}
```

- [ ] **Step 5: Register scr_wave in `Roundabout Hero.yyp`**

Add to `"resources"`:
```json
{"id": {"name": "scr_wave", "path": "scripts/scr_wave/scr_wave.yy"}}
```

- [ ] **Step 6: Verify**

Run the game. Red squares should spawn around the circle and walk toward the player. After they all reach the player (or are defeated), a 1.5-second pause should occur and then a new wave spawns. Timer counts up. No errors in output log.

- [ ] **Step 7: Commit**

```
git add scripts/scr_wave/ objects/oGame/ "Roundabout Hero.yyp"
git commit -m "feat: wave spawner with difficulty scaling"
```

---

## Task 6: Attack combat

**Files:**
- Modify: `objects/oKnight/Step_0.gml`
- Modify: `objects/oGame/Draw_0.gml`

- [ ] **Step 1: Replace `objects/oKnight/Step_0.gml` with full Attack input**

```gml
if (oGame.game_state != STATE_PLAYING) exit;

if (attack_cooldown > 0) attack_cooldown--;
if (defend_cooldown > 0) defend_cooldown--;

// Attack — Z or left mouse
if ((keyboard_check_pressed(ord("Z")) || mouse_check_button_pressed(mb_left))
    && attack_cooldown == 0) {

    var active = instance_nearest(x, y, par_enemy);

    if (active != noone && point_distance(x, y, active.x, active.y) <= ATTACK_RANGE) {
        switch (active.enemy_type) {
            case ENEMY_BANDIT:
                instance_destroy(active);
                break;
            case ENEMY_SHIELDED:
                // Shield absorbs — miss
                attack_cooldown = ATTACK_COOLDOWN_FRAMES;
                break;
            case ENEMY_ASSASSIN:
                if (!active.backstep_state) {
                    active.backstep_state = true;
                    active.backstep_timer = 45;
                    var away = point_direction(x, y, active.x, active.y);
                    active.x += lengthdir_x(ASSASSIN_BACKSTEP_DIST, away);
                    active.y += lengthdir_y(ASSASSIN_BACKSTEP_DIST, away);
                } else {
                    instance_destroy(active);
                }
                break;
        }
    } else {
        // No enemy in range — miss
        attack_cooldown = ATTACK_COOLDOWN_FRAMES;
    }
}
```

- [ ] **Step 2: Add attack range debug ring to `objects/oGame/Draw_0.gml`**

Add after the arena circle draw:
```gml
if (instance_exists(oKnight)) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.25);
    draw_circle(oKnight.x, oKnight.y, ATTACK_RANGE, true);
    draw_set_alpha(1.0);
}
```

- [ ] **Step 3: Verify**

Run the game. Press Z when a red bandit is inside the yellow ring — it should disappear. Press Z with no enemy in range — "ATK CD: 1" should appear top-left and count down. No errors.

- [ ] **Step 4: Commit**

```
git add objects/oKnight/Step_0.gml objects/oGame/Draw_0.gml
git commit -m "feat: Attack input and combat resolution"
```

---

## Task 7: Shielded Bandit and Defend

**Files:**
- Modify: `objects/oShieldedBandit/oShieldedBandit.yy` (add events)
- Create: `objects/oShieldedBandit/Create_0.gml`
- Create: `objects/oShieldedBandit/Step_0.gml`
- Create: `objects/oShieldedBandit/Draw_0.gml`
- Modify: `objects/oKnight/Step_0.gml`

- [ ] **Step 1: Update `objects/oShieldedBandit/oShieldedBandit.yy` to add events**

Replace the file:
```json
{
  "$GMObject": "",
  "%Name": "oShieldedBandit",
  "eventList": [
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":0,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":3,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":8,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"}
  ],
  "managed": true,
  "name": "oShieldedBandit",
  "overriddenProperties": [],
  "parent": {"name": "Roundabout Hero", "path": "Roundabout Hero.yyp"},
  "parentObjectId": {"name": "par_enemy", "path": "objects/par_enemy/par_enemy.yy"},
  "persistent": false,
  "physicsAngularDamping": 0.1,
  "physicsCollisionBitMask": 4294967295,
  "physicsDensity": 0.5,
  "physicsFriction": 0.2,
  "physicsGroup": 1,
  "physicsKinematic": false,
  "physicsLinearDamping": 0.1,
  "physicsObject": false,
  "physicsRestitution": 0.1,
  "physicsShape": 1,
  "physicsShapePoints": [],
  "physicsStartAwake": true,
  "resourceType": "GMObject",
  "resourceVersion": "2.0",
  "solid": false,
  "spriteId": null,
  "spriteMaskId": null,
  "visible": true
}
```

- [ ] **Step 2: Create `objects/oShieldedBandit/Create_0.gml`**

```gml
enemy_type = ENEMY_SHIELDED;
spd = BASE_ENEMY_SPEED * oGame.difficulty_multiplier;
```

- [ ] **Step 3: Create `objects/oShieldedBandit/Step_0.gml`**

```gml
if (oGame.game_state != STATE_PLAYING) exit;

var dir = point_direction(x, y, oKnight.x, oKnight.y);
x += lengthdir_x(spd, dir);
y += lengthdir_y(spd, dir);

if (point_distance(x, y, oKnight.x, oKnight.y) < ENEMY_CONTACT_DIST) {
    oKnight.hp--;
    instance_destroy();
    if (oKnight.hp <= 0) {
        oGame.game_state = STATE_GAME_OVER;
    }
}
```

- [ ] **Step 4: Create `objects/oShieldedBandit/Draw_0.gml`**

```gml
draw_set_color(c_blue);
draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2,
               x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, false);
draw_set_color(c_white);
draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2,
               x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, true);
```

- [ ] **Step 5: Update `get_wave_composition()` in `scripts/scr_wave/scr_wave.gml` to include ShieldedBandits**

Replace only the `get_wave_composition` function:
```gml
function get_wave_composition() {
    // Assassins added in Task 8
    var t = floor(survival_timer / 60);
    var result = [];
    var size;

    if (t < 60) {
        size = irandom_range(2, 3);
        for (var i = 0; i < size; i++)
            result[i] = (irandom(4) == 0) ? ENEMY_SHIELDED : ENEMY_BANDIT;
    } else {
        size = irandom_range(3, 4);
        for (var i = 0; i < size; i++) {
            var roll = irandom(3);
            result[i] = (roll == 0) ? ENEMY_SHIELDED : ENEMY_BANDIT;
        }
    }
    return result;
}
```

- [ ] **Step 6: Add Defend input to `objects/oKnight/Step_0.gml`**

Add after the Attack block:
```gml
// Defend — X or right mouse
if ((keyboard_check_pressed(ord("X")) || mouse_check_button_pressed(mb_right))
    && defend_cooldown == 0) {

    var active = instance_nearest(x, y, par_enemy);

    if (active != noone
        && active.enemy_type == ENEMY_SHIELDED
        && point_distance(x, y, active.x, active.y) <= ATTACK_RANGE) {
        // Correct riposte — no cooldown
        instance_destroy(active);
    } else {
        // Failsafe use — 5s cooldown
        defend_cooldown = DEFEND_COOLDOWN_FRAMES;
    }
}
```

- [ ] **Step 6: Verify**

Run the game until a blue square appears. Press X when it is inside the yellow ring — it should disappear with no cooldown triggered. Press X with a Bandit as the nearest enemy — "DEF CD: 5" should appear. No errors.

- [ ] **Step 7: Commit**

```
git add objects/oShieldedBandit/ objects/oKnight/Step_0.gml
git commit -m "feat: ShieldedBandit and Defend/riposte mechanic"
```

---

## Task 8: Assassin

**Files:**
- Modify: `objects/oAssassin/oAssassin.yy` (add events)
- Create: `objects/oAssassin/Create_0.gml`
- Create: `objects/oAssassin/Step_0.gml`
- Create: `objects/oAssassin/Draw_0.gml`

- [ ] **Step 1: Update `objects/oAssassin/oAssassin.yy` to add events**

Replace the file:
```json
{
  "$GMObject": "",
  "%Name": "oAssassin",
  "eventList": [
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":0,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":3,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"},
    {"$GMEvent":"","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":8,"isDnd":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0"}
  ],
  "managed": true,
  "name": "oAssassin",
  "overriddenProperties": [],
  "parent": {"name": "Roundabout Hero", "path": "Roundabout Hero.yyp"},
  "parentObjectId": {"name": "par_enemy", "path": "objects/par_enemy/par_enemy.yy"},
  "persistent": false,
  "physicsAngularDamping": 0.1,
  "physicsCollisionBitMask": 4294967295,
  "physicsDensity": 0.5,
  "physicsFriction": 0.2,
  "physicsGroup": 1,
  "physicsKinematic": false,
  "physicsLinearDamping": 0.1,
  "physicsObject": false,
  "physicsRestitution": 0.1,
  "physicsShape": 1,
  "physicsShapePoints": [],
  "physicsStartAwake": true,
  "resourceType": "GMObject",
  "resourceVersion": "2.0",
  "solid": false,
  "spriteId": null,
  "spriteMaskId": null,
  "visible": true
}
```

- [ ] **Step 2: Create `objects/oAssassin/Create_0.gml`**

```gml
enemy_type = ENEMY_ASSASSIN;
spd = BASE_ENEMY_SPEED * oGame.difficulty_multiplier * 1.2;
backstep_state = false;
backstep_timer = 0;
```

- [ ] **Step 3: Create `objects/oAssassin/Step_0.gml`**

```gml
if (oGame.game_state != STATE_PLAYING) exit;

if (backstep_timer > 0) {
    backstep_timer--;
    exit;
}

var dir = point_direction(x, y, oKnight.x, oKnight.y);
x += lengthdir_x(spd, dir);
y += lengthdir_y(spd, dir);

if (point_distance(x, y, oKnight.x, oKnight.y) < ENEMY_CONTACT_DIST) {
    oKnight.hp--;
    instance_destroy();
    if (oKnight.hp <= 0) {
        oGame.game_state = STATE_GAME_OVER;
    }
}
```

- [ ] **Step 4: Create `objects/oAssassin/Draw_0.gml`**

```gml
// Lighter purple in backstep state — visual cue that it's vulnerable
draw_set_color(backstep_state ? make_color_rgb(200, 100, 200) : make_color_rgb(120, 0, 180));
draw_rectangle(x - ENEMY_SIZE/2, y - ENEMY_SIZE/2,
               x + ENEMY_SIZE/2, y + ENEMY_SIZE/2, false);
```

- [ ] **Step 5: Update `get_wave_composition()` in `scripts/scr_wave/scr_wave.gml` to include Assassins**

Replace only the `get_wave_composition` function:
```gml
function get_wave_composition() {
    var t = floor(survival_timer / 60);
    var result = [];
    var size;

    if (t < 60) {
        size = irandom_range(2, 3);
        for (var i = 0; i < size; i++)
            result[i] = (irandom(4) == 0) ? ENEMY_SHIELDED : ENEMY_BANDIT;
    } else if (t < 120) {
        size = irandom_range(3, 4);
        for (var i = 0; i < size; i++) {
            var roll = irandom(5);
            result[i] = (roll == 0) ? ENEMY_SHIELDED : (roll == 1) ? ENEMY_ASSASSIN : ENEMY_BANDIT;
        }
    } else {
        size = irandom_range(4, min(6, 3 + floor((t - 120) / 30)));
        for (var i = 0; i < size; i++) {
            var roll = irandom(4);
            result[i] = (roll == 0) ? ENEMY_SHIELDED : (roll == 1) ? ENEMY_ASSASSIN : ENEMY_BANDIT;
        }
    }
    return result;
}
```

- [ ] **Step 6: Verify**

Play until an Assassin appears (after ~1:00). Press Z while it's in range — it should jump back and turn lighter purple. Press Z again — it should die. Let one reach you — lose 1 HP. No errors.

- [ ] **Step 7: Commit**

```
git add objects/oAssassin/
git commit -m "feat: Assassin with backstep mechanic"
```

---

## Task 9: Game Over, full UI, and restart

**Files:**
- Modify: `objects/oGame/Draw_0.gml`
- Modify: `objects/oGame/Step_0.gml`

- [ ] **Step 1: Update `objects/oGame/Step_0.gml` with restart input**

Add at the very top (before all other code):
```gml
if (game_state == STATE_GAME_OVER && keyboard_check_pressed(ord("R"))) {
    with (par_enemy) instance_destroy();
    with (oKnight)   instance_destroy();

    game_state = STATE_PLAYING;
    survival_timer = 0;
    score = 0;
    difficulty_multiplier = 1.0;
    wave_number = 0;
    wave_pause_timer = 0;
    enemies_in_wave = 0;

    instance_create_layer(PLAYER_START_X, PLAYER_START_Y, "Instances", oKnight);
    spawn_wave();
    exit;
}
```

- [ ] **Step 2: Replace `objects/oGame/Draw_0.gml` with full UI**

```gml
// Arena
draw_set_color(c_dkgray);
draw_circle(ARENA_CENTER_X, ARENA_CENTER_Y, ARENA_RADIUS, true);

// Attack range ring
if (instance_exists(oKnight)) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.25);
    draw_circle(oKnight.x, oKnight.y, ATTACK_RANGE, true);
    draw_set_alpha(1.0);
}

// Timer — top center
var mins = floor(score / 60);
var secs = score mod 60;
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(ARENA_CENTER_X, 20, "TIME: " + string(mins) + ":" + (secs < 10 ? "0" : "") + string(secs));

// Score — top right
draw_set_halign(fa_right);
draw_text(room_width - 20, 20, "SCORE: " + string(score));

// Wave — below HP
draw_set_halign(fa_left);
draw_set_color(c_ltgray);
draw_text(20, 110, "WAVE: " + string(wave_number));

// Game over overlay
if (game_state == STATE_GAME_OVER) {
    draw_set_color(c_black);
    draw_set_alpha(0.65);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);

    draw_set_color(c_red);
    draw_set_halign(fa_center);
    draw_text_transformed(ARENA_CENTER_X, ARENA_CENTER_Y - 50, "GAME OVER", 2, 2, 0);

    draw_set_color(c_white);
    draw_text(ARENA_CENTER_X, ARENA_CENTER_Y + 10, "Score: " + string(score));
    draw_text(ARENA_CENTER_X, ARENA_CENTER_Y + 45, "Press R to restart");
    draw_set_halign(fa_left);
}
```

- [ ] **Step 3: Verify**

Run the full game loop:
- Let enemies drain your HP to zero — a dark overlay should appear with "GAME OVER", final score, and "Press R to restart"
- Press R — everything resets: HP back to 3, timer to 0, score to 0, wave 1 spawns
- Survive past 1:00 — Assassins should begin appearing
- Survive past 2:00 — waves of 4–6 mixed enemies

No errors in the output log throughout.

- [ ] **Step 4: Commit**

```
git add objects/oGame/
git commit -m "feat: game over state, restart, and complete UI"
```

---

## Prototype complete

At this point the prototype is fully playable:
- Three enemy types with distinct combat interactions
- Wave-based spawning with inter-wave breather
- Continuous difficulty scaling tied to survival time
- Correct Attack miss penalty and Defend failsafe penalty
- Score display, HP hearts, wave counter
- Game over and full restart

Next steps (out of scope for this plan): pixel art sprites, sound effects, particle feedback, animations, persistent high score, pause menu.
