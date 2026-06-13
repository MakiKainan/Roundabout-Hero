# Roundabout Hero

A fast-paced arcade action game where a lone knight defends against waves of enemies in an endless circular arena. Master pattern recognition and quick reflexes to survive as long as you can.

## Game Overview

**Roundabout Hero** is a skill-based arcade game inspired by classics like *Subway Surfers* and *Enter the Gungeon*. You play as a knight perpetually walking in a circle, facing incoming enemies with only two options: **Attack** or **Defend**. Each enemy type has unique mechanics, forcing you to learn patterns and react strategically.

As time passes, enemies spawn faster and faster until you fall—a pure test of skill and pattern recognition.

## Gameplay Mechanics

### Controls
- **Attack Button** – Strike the enemy in front of you
- **Defend Button** – Block incoming damage

### Enemy Types

**Bandit (Red)**
- Attacks head-on
- Simply attack to defeat it
- Attacking a Bandit is always the right choice

**Shielded Bandit (Blue)**
- Protected by a shield
- Defend first to riposte, then attack to defeat it

**Assassin (Purple)**
- Moves unpredictably
- When you attack, it backsteps away
- You must attack twice to defeat it—once to trigger the backstep, once to finish it

### Difficulty Progression

The game follows a **progressive difficulty curve**:
- **0:00–1:00** – Mostly Bandits with occasional Shielded Bandits (learning phase)
- **1:00–2:00** – More variety; Assassins begin appearing
- **2:00+** – Enemies spawn rapidly in mixed waves until you fall

Your score is determined by **survival time**. The longer you survive, the higher your score.

## Visual Style

Roundabout Hero uses **pixel art** inspired by:
- **Shovel Knight** – Clean silhouettes and readable character design
- **Enter the Gungeon** – Color-coded enemies and intense visual feedback
- **Loop Hero** – Minimalist aesthetic with elegant design

The game prioritizes **clarity at speed**—enemy colors, patterns, and animations are designed to be instantly recognizable even as the game accelerates.

## Technical Stack

- **Engine:** GameMaker Studio 2 (Latest)
- **Language:** GML (GameMaker Language)
- **Art:** AI-generated pixel art assets
- **Target Platform:** Windows 

## Project Structure

```
roundabout-hero/
├── sprites/             # Pixel art assets (knight, enemies, UI)
├── objects/             # GameMaker objects (oKnight, oEnemy, etc.)
├── rooms/               # Game room definitions
├── scripts/             # GML scripts and game logic
├── configs/             # Game constants and settings
└── README.md           # This file
```

## Getting Started

### Prerequisites
- GameMaker Studio 2 (Latest version recommended)
- Basic understanding of GameMaker workflow (optional but helpful)


### Game Controls

| Action | Control |
|--------|---------|
| Attack | **Z** / Left Mouse Click |
| Defend | **X** / Right Mouse Click |
| Restart | **R** (after game over) |

Controls can be customized in `configs/input_config.gml`

## Development Progress

- [x] Core game loop (knight movement, enemy spawning)
- [x] Three enemy types with unique mechanics
- [x] Difficulty scaling system
- [x] Collision detection and combat feedback
- [ ] Score tracking and game over state
- [ ] Audio effects and background music
- [ ] Visual polish (animations, particle effects)
- [ ] Leaderboard / high score system
- [ ] Mobile controls support
- [x] Pause menu

## Design Philosophy

Roundabout Hero prioritizes:

1. **Accessibility through clarity** – Simple mechanics, readable visuals, instant feedback
2. **Skill-based progression** – No RNG, no hidden mechanics; only player skill determines success
3. **Arcade purity** – Short play sessions, high replayability, one-hit-death tension
4. **Pattern recognition** – Each enemy type teaches a unique decision pattern
5. **Visual coherence** – Consistent pixel art style with color-coded enemy types

## Credits

**Developed by:** Kevin  
**Game Concept & Design:** Kevin  
**Art Assets:** AI-generated pixel art (Midjourney / Leonardo.AI)  
**Inspiration:** *Subway Surfers, Enter the Gungeon, Shovel Knight, Loop Hero*



## Feedback & Contributing

This is a portfolio project developed for educational purposes. Feedback and suggestions are welcome! Feel free to:
- Report bugs or edge cases
- Suggest game balance improvements
- Share gameplay videos or high scores

---

**Status:** In active development  
**Last Updated:** June 2026
