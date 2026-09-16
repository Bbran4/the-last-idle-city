# The Last Archer

A small active skill-based archery progression game for itch.io and Kongregate.

The player is an archer practicing for tournaments. Shoot targets, improve technique, buy better equipment, expand the practice range, and eventually compete in increasingly difficult tournaments.

## Core Loop

**Practice → Improve Strength & Accuracy → Unlock Better Equipment → Expand Practice Range → Enter Tournament → Earn Prize Money → Purchase Upgrades → Practice More Efficiently → Enter More Difficult Tournaments**

The game combines player skill with character progression. Upgrades improve capability without turning shooting into an automatic process.

## Current Controls

| Input | Action |
|---|---|
| A / D or Left / Right | Walk |
| Shift + movement | Run |
| Space | Jump |
| Ctrl / C | Crouch |
| Mouse | Aim |
| Left Mouse Button | Draw and release bow |
| R | Reset practice session |

The archer faces the mouse cursor and the bow follows the facing direction. Moving while aiming introduces a small amount of bow wobble, while crouching extends the trajectory preview by 20%. The trajectory preview is disabled while airborne.

## Development Roadmap

### Milestone 0 - Project Foundation

- [x] Godot 4.7 project and display configuration
- [x] Input configuration and main scene
- [x] Clean project structure
- [x] Reliable project launch

### Milestone 1 - Archer & Practice Range

- [x] Archer, bow, target, ground and practice environment
- [x] Functional world layout and scaling

### Milestone 2 - Bow Drawing & Firing

- [x] Mouse hold/release shooting
- [x] Draw strength and launch force
- [x] Draw feedback and shot validation

### Milestone 3 - Arrow Physics & Target Hits

- [x] Arrow scene and projectile physics
- [x] Gravity and flight rotation
- [x] Target collision and embedded arrows
- [x] Miss handling and reset support

### Milestone 4 - Scoring & Bullseye

- [x] Target zones and bullseye detection
- [x] Shot feedback and statistics
- [x] Direct coin rewards now replace the original score economy

### Milestone 5 - Strength Progression

- [x] Strength stat and XP
- [x] Draw/release progression
- [x] Strength levels affect launch capability

### Milestone 6 - Accuracy Progression

- [x] Accuracy stat and XP
- [x] Accuracy levels
- [x] Accuracy affects aim assistance without auto-aim

### Milestone 7 - Aim Assistance

- [x] Live trajectory prediction
- [x] Prediction reacts to aim, draw strength and shot distance
- [x] Accuracy improves prediction quality
- [x] No auto-aim or automatic target selection

### Milestone 8 - First Playable Practice Loop

- [x] Shooting, progression, feedback and reset loop
- [x] Practice HUD
- [x] Playtesting and early balance pass

**Completion: Done.**

### Milestone 9 - Economy & Money

- [x] Dedicated economy system
- [x] Coin display and purchases
- [x] Training Manual upgrade
- [x] Purchase validation and feedback
- [x] Target hits provide practice income
- [ ] Tournament rewards become the primary long-term money source

The Training Manual has five levels. Each level increases Strength and Accuracy XP gains by 10%. The range currently starts with 250 coins for development testing.

### Milestone 10 - Bows & Equipment

- [x] Data-driven bow resources
- [x] Training Bow
- [x] Recurve Bow
- [x] War Bow
- [x] Bow prices and Strength requirements
- [x] Purchase and equip flow
- [x] Switching between owned bows
- [x] Equipped bow data drives shooting behavior

Final bow prices will be balanced after the range and tournament economies are established.

### Milestone 11 - Practice Range Expansion

**Goal:** Make the practice range itself part of progression and income.

- [x] Multiple target slots
- [x] Target unlock costs
- [x] Progressively smaller/farther targets
- [x] Target reward tiers
- [x] Special ring target worth 5 coins
- [x] Range levels
- [x] Range upgrade UI
- [x] Side-scrolling movement
- [x] Walking
- [x] Running
- [x] Jumping
- [x] Crouching
- [x] Mouse-facing character and bow
- [x] Movement wobble while aiming
- [x] Distance-based Accuracy XP
- [x] 20% crouch trajectory bonus
- [ ] Persist range upgrades
- [ ] Visually evolve the range
- [ ] Final expansion balance pass

Current range progression:

| Range Level | New Challenge | Unlock Cost | Reward |
|---|---|---:|---:|
| 1 | Large close target | Free | 1 coin |
| 2 | Smaller target | 50 coins | 2 coins |
| 3 | Smaller/farther target | 100 coins | 3 coins |
| 4 | Ring Target | 250 coins | 5 coins |

The first three targets stop arrows on impact. The Ring Target rewards an arrow that passes cleanly through its opening and lets the arrow continue flying. Ring rewards are limited to once per arrow.

Accuracy XP now scales with the original shot distance. Point-blank hits provide the minimum XP, while shots reaching 1000 distance or more provide the base maximum of 25 XP. The Training Manual multiplier is then applied, with XP capped by the current progression rules.

### Milestone 12 - First Tournament

- [ ] Tournament entry system
- [ ] Tournament requirements
- [ ] Rounds and attempt limits
- [ ] Tournament scoring and targets
- [ ] Opponents and generated scores
- [ ] Results and tournament UI
- [ ] Entry/restart flow

### Milestone 13 - Tournament Rewards

- [ ] Prize structures
- [ ] Tournament money
- [ ] Tournament progression
- [ ] Harder tournaments
- [ ] Entry/reward balancing

### Milestone 14 - Advanced Targets & Challenges

- [ ] Moving targets
- [ ] Long-distance targets
- [ ] Timed challenges
- [ ] Multi-target challenges
- [ ] Precision targets

### Milestone 15 - Advanced Archery Systems

- [ ] Evaluate wind
- [ ] Evaluate arrow types
- [ ] Evaluate Speed and Endurance
- [ ] Add only systems that strengthen the core loop

### Milestone 16 - Progression Balance

- [ ] Balance Strength and Accuracy
- [ ] Balance trajectory assistance
- [ ] Balance bows and range costs
- [ ] Balance tournaments and rewards
- [ ] Balance overall pacing

### Milestone 17 - UI, Audio & Visual Polish

- [ ] Polish HUD and menus
- [ ] Improve archer, bow, arrow and target visuals
- [ ] Add animation and impact effects
- [ ] Add sound effects and music where appropriate
- [ ] Add settings and accessibility improvements

### Milestone 18 - Save System & Release Preparation

- [ ] Save player progression
- [ ] Save money, equipment and range upgrades
- [ ] Save tournament progression
- [ ] Reliable loading and reset-save support
- [ ] Test fresh games and long-term progression
- [ ] Test display resolutions
- [ ] Fix release bugs and optimize
- [ ] Prepare itch.io release
- [ ] Prepare Kongregate-compatible build if supported

## MVP

The first playable MVP ends at **Milestone 8**.

The MVP contains one archer, one bow, one target, mouse-controlled drawing, arrow physics, target collision, Strength progression, Accuracy progression, trajectory assistance, practice HUD and clear shot feedback.

Tournaments, economy, multiple bows, advanced targets, wind and saving are not required for the MVP.

### The MVP Question

> **Is firing an arrow fun?**

If the answer is not yes, improve the shooting experience before expanding the game.

## Development Rules

1. Build one milestone at a time.
2. Do not build future systems early unless required.
3. Keep shooting independent from progression and economy.
4. Prefer simple systems over unnecessary abstractions.
5. Every completed milestone should remain playable.
6. Playtest major mechanics before expanding.
7. If a feature makes the game less fun, reconsider or remove it.
8. Do not add complexity simply because other idle games traditionally use it.
9. Player skill must always matter.
10. The README is the roadmap, but gameplay testing can change the design.

## Current Status

**Current Stage: Milestone 11 - Practice Range Expansion**

Milestones 0 through 10 are implemented. Milestone 11 has its core expansion gameplay implemented, including four range levels, multiple targets, target income, the ring challenge, side-scrolling movement, running, jumping, crouching, mouse-facing, bow flipping, movement wobble, distance-based Accuracy XP, and the 20% crouch trajectory bonus.

The core practice loop has been playtested. Strength and Accuracy live together in `PlayerStats`. Strength progression rewards meaningful draw and release practice. Accuracy improves from successful target hits and scales with shot distance.

The trajectory preview remains informational. It follows the current bow aim and shot conditions, improves with Accuracy, becomes 20% longer while crouching, and disappears while airborne. It never rotates the bow, bends the arrow, or selects a target automatically.

The next goal is:

> **Finish Milestone 11 with persistent range progression, visual range evolution, and a final balance pass, then begin Milestone 12: First Tournament.**
