# Roundabout Hero — Gameplay Prototype Design

**Date:** 2026-06-13  
**Scope:** Core gameplay loop prototype using placeholder graphics (colored squares)  
**Engine:** GameMaker Studio 2 / GML  
**Goal:** Validate game flow — attack/defend timing, wave rhythm, difficulty curve — before adding art

---

## Overview

A lone knight (player) stands fixed at the bottom-center of a circular arena. Enemies spawn around the circle's edge in waves and walk toward the player. The player has two actions — Attack and Defend — and must read each enemy type and react correctly. Survival time is the score. Difficulty scales continuously as the player stays alive.

---

## Architecture

### Objects

| Object | Description |
|---|---|
| `oGame` | Controller. Owns game state, survival timer, score, wave spawner, and difficulty multiplier. |
| `oKnight` | Player. Fixed position at bottom-center of circle. Handles input, HP, and attack/defend state machine. |
| `oBandit` | Red square. Walks toward player. Dies in one Attack. |
| `oShieldedBandit` | Blue square. Walks toward player. Dies in one Defend (riposte). |
| `oAssassin` | Purple square. Walks toward player. First Attack triggers a backstep; second Attack kills it. |

### Room

- Single room, 1366×768
- Circle drawn each frame with `draw_circle()` — outline only, no fill
- No physics engine — all movement is manual position math
- Player square drawn at the bottom of the circle's circumference, fixed, never moves

---

## Combat System

The **active enemy** is whichever enemy is closest to the player by straight-line distance. If two enemies are equidistant, the one that spawned earlier takes priority. Only one enemy is interacted with at a time.

**"In range"** means the active enemy is within a proximity threshold (tunable constant, suggested starting value: 80px) of the player's position.

### Attack (Z / Left Click)

| Situation | Result |
|---|---|
| Active enemy is a `Bandit`, in range | Enemy dies instantly |
| Active enemy is a `ShieldedBandit`, in range | Miss (shield absorbs it) — Attack goes on cooldown |
| Active enemy is an `Assassin` in normal state, in range | Enemy backsteps (jumps back ~120px along its approach vector); player must Attack again to kill |
| Active enemy is an `Assassin` in backstep state, in range | Enemy dies instantly |
| Attack pressed with no enemy in range | Miss — Attack goes on cooldown |

### Defend (X / Right Click)

| Situation | Result |
|---|---|
| Active enemy is a `ShieldedBandit`, in range | Riposte — enemy dies instantly, **no cooldown** |
| Pressed at any other time (wrong enemy type, no enemy in range, or Attack is on cooldown) | Acts as a failsafe block — **Defend goes on 5-second cooldown** regardless of whether a hit was incoming |

### Damage to Player

Any enemy that reaches the player's position deals **1 HP** and despawns. Player has **3 HP**.

### Penalty Loop

Miss Attack timing → Attack on cooldown → only Defend available → if Defend is used sloppily (not a riposte), Defend also goes on cooldown → player is briefly locked out of both actions. Pure skill expression; no random elements.

---

## Enemy Behavior

All enemies spawn on the circle's edge at a random angle and move in a straight line toward the player's fixed position. They do not pathfind or avoid each other.

| Enemy | Color | Behavior |
|---|---|---|
| `oBandit` | Red | Walks in. Attack to kill. |
| `oShieldedBandit` | Blue | Walks in. Defend to riposte and kill. Attacking it without riposting first counts as a miss. |
| `oAssassin` | Purple | Walks in. First Attack makes it backstep. Second Attack kills it. Touching the player deals damage normally. |

Enemy speed at spawn = `base_speed * difficulty_multiplier`. Enemies already on screen keep their spawn-time speed.

---

## Wave & Difficulty Scaling

### Wave Structure

- Enemies spawn at the start of each wave
- When all enemies in a wave are dead, a **1–1.5 second pause** plays before the next wave
- During the pause, no enemies are on screen — player can breathe and anticipate

### Difficulty Table

| Time Survived | Enemy Speed | Wave Size | Enemy Mix |
|---|---|---|---|
| 0:00–1:00 | Base (1.0×) | 2–3 | Mostly Bandits, occasional Shielded Bandits |
| 1:00–2:00 | 1.2× | 3–4 | Bandits + Shielded Bandits + first Assassins |
| 2:00+ | +0.1× per 30s | 4–6 | Full mix, increasingly dense |

`oGame` tracks survival time and updates `difficulty_multiplier` continuously. Each newly spawned enemy reads the current multiplier at the moment it spawns.

---

## Game States

`oGame` owns a `game_state` variable (use a GML enum or constants).

| State | Description |
|---|---|
| `PLAYING` | Timer runs, waves spawn, input active |
| `WAVE_PAUSE` | 1–1.5s rest between waves; no enemies on screen |
| `GAME_OVER` | Timer frozen, score displayed, input disabled except R to restart |

### Transitions

- `PLAYING` → `WAVE_PAUSE`: all enemies in current wave are dead
- `WAVE_PAUSE` → `PLAYING`: pause timer elapses, next wave spawns
- `PLAYING` → `GAME_OVER`: player HP reaches 0
- `GAME_OVER` → `PLAYING`: player presses R (full reset: HP, timer, score, difficulty multiplier, wave counter)

---

## UI (Placeholder — Text and Squares Only)

| Element | Position | Display |
|---|---|---|
| HP | Top-left | 3 small squares — filled = alive, hollow = lost |
| Timer | Top-center | Survival time counting up (MM:SS) |
| Score | Top-right | Same value as timer in whole seconds |
| Game Over | Center screen | "GAME OVER" text + final score, "Press R to restart" |

---

## Controls

| Action | Key | Mouse |
|---|---|---|
| Attack | Z | Left Click |
| Defend | X | Right Click |
| Restart | R | — |

---

## Out of Scope for This Prototype

- Pixel art sprites or animations
- Sound effects and music
- Particle effects or visual feedback beyond color changes
- Leaderboard or persistent high score
- Mobile controls
- Pause menu
