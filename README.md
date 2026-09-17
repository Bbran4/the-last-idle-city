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
| Right Mouse Button | Hold to draw bow |
| Left Mouse Button | Fire current draw strength |
| R | Reset practice session |
| Ctrl + Shift + R | Reset saved progression and reload |

The archer faces the mouse cursor and the bow follows the facing direction. Moving while aiming introduces a small amount of bow wobble, while crouching extends the trajectory preview by 20%. The trajectory preview is disabled while airborne.

Holding Right Mouse Button draws the bow. Releasing it does not fire. Left Mouse Button fires the current draw strength. Holding right mouse through shot recovery automatically begins the next draw when recovery finishes.

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
- [x] Arrow point, shaft and nock collision sections
- [x] Flying-arrow collision and knock-away behavior
- [x] Nock-hit arrow replacement behavior
- [x] Training dummy collision and arrow embedding

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
- [x] Tent is a standalone scene with editor-based visuals
- [x] Range decoration and progression markers
- [x] Training dummy at Range Level 3+
- [x] Persist range upgrades between sessions
- [ ] Final expansion balance pass

Current range progression:

| Range Level | New Challenge | Unlock Cost | Reward |
|---|---|---:|---:|
| 1 | Large close target | Free | 1 coin |
| 2 | Smaller target | 50 coins | 2 coins |
| 3 | Smaller/farther target | 100 coins | 3 coins |
| 4 | Ring Target | 250 coins | 5 coins |

The first three targets stop arrows on impact. The Ring Target rewards an arrow that passes cleanly through its opening and lets the arrow continue flying. Ring rewards are limited to once per arrow.

Range progression initially used a small dedicated save file. It is now migrated into the unified player save data, while existing range-only saves are still read for compatibility.

Accuracy XP now scales with the original shot distance. Point-blank hits provide the minimum XP, while shots reaching 1000 distance or more provide the base maximum of 25 XP. The Training Manual multiplier is then applied, with XP capped by the current progression rules.

### Milestone 12 - Pre-Tournament Foundation

**Goal:** Finish the practice experience and establish a stable foundation before introducing tournament rules. The tournament should be built on a polished, persistent practice loop rather than becoming a second unfinished system.**

- [x] Persist player progression between sessions
- [x] Save and load money, Strength, Accuracy, bows and range progression
- [x] Add a deliberate reset-save flow for testing
- [ ] Visually evolve the practice range with each range level
- [ ] Make the training tent a proper practice-range hub and establish its future customization role
- [ ] Finalize practice income and equipment costs
- [ ] Finalize Strength and Accuracy progression pacing
- [ ] Finalize range upgrade costs and target rewards
- [ ] Confirm shooting, movement and trajectory behavior remain stable
- [ ] Clean up prototype-only UI and development feedback
- [ ] Complete a focused long-session playtest

The unified save foundation uses `user://player_progress.cfg` and stores progression as versioned save data. Strength, Accuracy, economy, bow ownership/equipment and range progression now restore between sessions. `Ctrl + Shift + R` deliberately deletes saved progression and reloads a fresh game for testing.

**Design rule:** No tournament-specific complexity should be added until the practice loop can be saved, resumed and balanced reliably.

### Milestone 13 - First Tournament

**Goal:** Introduce the first structured competitive activity without replacing the core shooting mechanics.**

- [ ] Tournament entry system
- [ ] Tournament requirements
- [ ] Tournament rounds and attempt limits
- [ ] Tournament-specific target layouts
- [ ] Tournament scoring rules
- [ ] Opponent score generation
- [ ] Results and tournament UI
- [ ] Entry/restart flow
- [ ] Tournament rewards feed back into the existing economy

### Milestone 14 - Tournament Rewards & Progression

- [ ] Prize structures
- [ ] Tournament money
- [ ] Tournament progression
- [ ] Harder tournaments
- [ ] Entry/reward balancing
- [ ] Clear relationship between practice progression and tournament progression

### Milestone 15 - Advanced Targets & Challenges

- [ ] Moving targets
- [ ] Long-distance targets
- [ ] Timed challenges
- [ ] Multi-target challenges
- [ ] Precision targets

### Milestone 16 - Advanced Archery Systems

- [ ] Evaluate wind
- [ ] Evaluate arrow types
- [ ] Evaluate Speed and Endurance
- [ ] Add only systems that strengthen the core loop

### Milestone 17 - Progression Balance

- [ ] Balance Strength and Accuracy
- [ ] Balance trajectory assistance
- [ ] Balance bows and range costs
- [ ] Balance tournaments and rewards
- [ ] Balance overall pacing
- [ ] Test early, mid and long-term progression

### Milestone 18 - UI, Audio & Visual Polish

- [ ] Polish HUD and menus
- [ ] Improve archer, bow, arrow and target visuals
- [ ] Improve practice range and tent visuals
- [ ] Add animation and impact effects
- [ ] Add sound effects and music where appropriate
- [ ] Add settings and accessibility improvements

### Milestone 19 - Release Preparation

- [ ] Finalize save system and migration handling
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
11. Do not start tournament implementation until the practice loop is persistent and balanced.

## Current Status

**Current Stage: Milestone 12 - Pre-Tournament Foundation**

Milestones 0 through 10 are implemented. Milestone 11 has its core expansion gameplay implemented, including four range levels, multiple targets, target income, the ring challenge, side-scrolling movement, running, jumping, crouching, mouse-facing, bow flipping, movement wobble, distance-based Accuracy XP, the 20% crouch trajectory bonus, range decoration, the training dummy, and persistent range upgrades. Arrow interactions now also include explicit point/shaft/nock sections, flying-arrow collisions, nock replacement, and dummy embedding.

The tent is a standalone scene with its visuals represented by scene nodes rather than code-based drawing.

The core practice loop has been playtested. Strength and Accuracy live together in `PlayerStats`. Strength progression rewards meaningful draw and release practice. Accuracy improves from successful target hits and scales with shot distance.

The trajectory preview remains informational. It follows the current bow aim and shot conditions, improves with Accuracy, becomes 20% longer while crouching, and disappears while airborne. It never rotates the bow, bends the arrow, or selects a target automatically.

The unified save foundation now restores money, Strength, Accuracy, owned bows, equipped bow and range progression between sessions. Legacy range-only saves are migrated when the range is next saved. A deliberate `Ctrl + Shift + R` reset flow is available for testing.

### Next Step

**Finish the remaining Milestone 12 practice-foundation work, starting with visual range evolution and then the final economy/progression balance pass.**

The immediate priority remains the persistent practice loop, balance, visual range evolution and save reliability. Tournament mechanics stay deliberately out of scope until those foundations are stable.
