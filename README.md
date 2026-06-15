# Roundabout Hero

A fast-paced arcade action game where a lone knight defends against waves of enemies in an endless circular arena. Master pattern recognition and quick reflexes to survive as long as you can.

## Game Overview

**Roundabout Hero** is a skill-based arcade game inspired by classics like *Enter the Gungeon* and *Shovel Knight*. You play as a knight standing at the bottom of a circular arena, facing enemies that spawn at the top and ride the circle down toward you — with only two inputs: **Attack** or **Defend**. Each enemy type has unique mechanics, forcing you to learn patterns and react strategically.

As time passes, waves grow larger and faster until you fall — a pure test of skill and pattern recognition.

## Gameplay Mechanics

### Controls

| Action | Control |
|--------|---------|
| Attack | **Z** / Left Mouse Click |
| Defend | **X** / Right Mouse Click |
| Pause | **ESC** / **P** |
| Restart | **R** (after game over) |

### Enemy Types

**Bandit (Red)**
- Charges straight toward you along the circle
- One Attack in range defeats it

**Shielded Bandit (Blue)**
- Protected by a shield — attacking it wastes your time (miss penalty)
- Defend first to riposte (drops the shield), then Attack to finish it

**Assassin (Purple)**
- Your first Attack triggers a dramatic backstep — it leaps away along the circle, briefly freezing in place
- Land a second Attack during the freeze window to finish it; miss it and it resumes its advance

### Difficulty Progression

- **0:00 – 0:30** – 2-5 enemies per wave; Bandits and the occasional Shielded Bandit (learning phase, no Assassins)
- **0:30+** – 3-7 enemies per wave; Assassins enter the mix (~1 in 5 enemies); wave size continues to grow over time

Enemy speed increases with survival time. Your score is your **survival time** — the longer you last, the higher your score.

## Visual Feedback

- **Screen shake** on every hit taken
- **Particle burst** at the point of impact
- **Yellow ring** around the knight shows the active attack range
- **Wave counter** and **timer** always visible

## Technical Stack

- **Engine:** GameMaker Studio 2 (GMS2 2026)
- **Language:** GML (GameMaker Language)
- **Target Platform:** Windows

## Development Progress

- [x] Core game loop (fixed-position knight, circular enemy movement, wave spawning)
- [x] Three enemy types with unique mechanics (Bandit, Shielded Bandit, Assassin)
- [x] Upper-half spawn system — enemies always spawn at the top and travel down
- [x] Randomized wave sizing with time-based scaling
- [x] Difficulty scaling (speed multiplier over time)
- [x] Score tracking and game over overlay
- [x] Pause / resume (ESC or P)
- [x] Screen shake and particle effects on damage
- [x] Knight pixel art sprites — animated idle / attack / defend with directional facing
- [ ] Enemy pixel art sprites (currently colored squares)
- [ ] Sound effects and music
- [ ] Persistent high score / leaderboard
- [ ] Mobile controls

## Design Philosophy

1. **Two inputs, infinite depth** – Attack and Defend are the only controls; mastery comes from reading enemy types and timing, not complex inputs
2. **Skill-based progression** – No hidden mechanics; only pattern recognition and reaction speed determine how long you survive
3. **Arcade purity** – Short sessions, high replayability, score chasing
4. **Clarity at speed** – Color-coded enemies and instant visual feedback so decisions stay readable even as waves get dense

## Credits

**Developed by:** Kevin Sukias K & Gerald Adli
**Game Concept & Design:** Kevin Sukias K & Gerald Adli
**Inspiration:** *Enter the Gungeon, Shovel Knight, Loop Hero*

---

**Status:** In active development — v0.31  
**Last Updated:** June 2026
