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
- [x] Training dummy nock replacement behavior

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

The Training Manual has five levels. Each level increases Strength and Accuracy XP gains by 10%. The current development starting balance remains 250 coins so the practice systems can be tested without an artificial grind.

Training Manual costs are now 125, 250, 375, 500 and 625 coins for levels 1 through 5.

### Milestone 10 - Bows & Equipment

- [x] Data-driven bow resources
- [x] Training Bow
- [x] Recurve Bow
- [x] War Bow
- [x] Bow prices and Strength requirements
- [x] Purchase and equip flow
- [x] Switching between owned bows
- [x] Equipped bow data drives shooting behavior

Current practice-phase bow prices are 100 coins for the Recurve Bow and 250 coins for the War Bow. These remain subject to the later tournament economy pass.

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
- [x] Visual range evolution
- [x] Practice economy and range-cost balance pass

Current range progression:

| Range Level | New Challenge | Unlock Cost | Reward |
|---|---|---:|---:|
| 1 | Large close target | Free | 1 coin |
| 2 | Smaller target | 75 coins | 2 coins |
| 3 | Smaller/farther target | 175 coins | 3 coins |
| 4 | Ring Target | 350 coins | 5 coins |

The first three targets stop arrows on impact. The Ring Target rewards an arrow that passes cleanly through its opening and lets the arrow continue flying. Ring rewards are limited to once per arrow, and a successful ring pass no longer produces a later false MISS when the arrow eventually reaches the ground.

The training dummy uses the same embedded-arrow interaction model as targets. An arrow embedded in the dummy can be replaced by a new arrow striking its nock, while the old arrow is removed.

Range progression initially used a small dedicated save file. It is now migrated into the unified player save data, while existing range-only saves are still read for compatibility.

Accuracy XP now scales with the original shot distance. Point-blank hits provide the minimum XP, while shots reaching 1000 distance or more provide the base maximum of 25 XP. The Training Manual multiplier is then applied, with XP capped by the current progression rules.

### Milestone 12 - Pre-Tournament Foundation

**Goal:** Finish the practice experience and establish a stable foundation before introducing tournament rules. The tournament should be built on a polished, persistent practice loop rather than becoming a second unfinished system.**

- [x] Persist player progression between sessions
- [x] Save and load money, Strength, Accuracy, bows and range progression
- [x] Add a deliberate reset-save flow for testing
- [x] Visually evolve the practice range with each range level
- [x] Make the training tent a proper practice-range hub and establish its future customization role
- [x] Finalize practice income and equipment costs for the current practice phase
- [x] Finalize Strength and Accuracy progression pacing
- [x] Finalize range upgrade costs and target rewards for the current practice phase
- [x] Confirm shooting, movement and trajectory behavior remain stable
- [x] Clean up prototype-only UI and development feedback
- [x] Complete a focused long-session playtest

The unified save foundation uses `user://player_progress.cfg` and stores progression as versioned save data. Strength, Accuracy, economy, bow ownership/equipment and range progression now restore between sessions. `Ctrl + Shift + R` deliberately deletes saved progression and reloads a fresh game for testing.

The training tent is now a functional practice-range hub. It can be approached and opened with `E`, providing the existing bow equipment flow while leaving room for future customization systems.

The current practice economy deliberately creates choices between equipment, Training Manuals and range expansion. Range upgrades now cost 75, 175 and 350 coins, while the Recurve and War Bows cost 100 and 250 coins respectively. The target rewards remain 1, 2, 3 and 5 coins. These values are intended as the stable practice-phase baseline before tournament rewards are introduced.

Recent stability work also hardened projectile interactions around the training dummy and ring target. Embedded dummy arrows are tracked explicitly, nock replacement works against both targets and the dummy, and successful ring passes no longer report a contradictory MISS after the reward has already been granted.

The player-facing HUD has now been cleaned of prototype session telemetry. The temporary shots/hits/bullseyes counter and duplicate session coin counter have been removed from the visible interface. Persistent coins, Strength, Accuracy, shooting feedback, progression feedback, training upgrades, range upgrades and the tent interaction remain available.

**Milestone 12 is now complete.**

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

**Current Stage: Milestone 13 - First Tournament**

Milestones 0 through 12 are now complete. The practice foundation includes persistent progression, four range levels, multiple targets, target income, the ring challenge, side-scrolling movement, running, jumping, crouching, mouse-facing, movement wobble, distance-based Accuracy XP, the 20% crouch trajectory bonus, range decoration, the training dummy, the training tent hub, bows and equipment, and stable projectile interactions.

The arrow system includes explicit point/shaft/nock sections, flying-arrow collisions, nock replacement, target embedding, dummy embedding and dummy nock replacement. Successful ring passes score normally without producing a later contradictory MISS.

Strength and Accuracy progression has been finalized for the practice phase. The trajectory preview remains informational, follows the current bow aim and shot conditions, improves with Accuracy, becomes 20% longer while crouching, and disappears while airborne. It never rotates the bow, bends the arrow, or selects a target automatically.

The unified save foundation restores money, Strength, Accuracy, owned bows, equipped bow and range progression between sessions. Legacy range-only saves are migrated when the range is next saved. A deliberate `Ctrl + Shift + R` reset flow remains available for development testing.

The player-facing HUD has been cleaned up so prototype session telemetry is no longer presented as part of the game interface. The visible HUD now focuses on persistent progression, economy, active shooting feedback, upgrades and contextual tent interaction.

### Next Step

**Milestone 13 - First Tournament.**

The next development phase introduces the first structured competitive activity while keeping the existing shooting mechanics at its center. Tournament entry, requirements, rounds, attempts, scoring, results and the first tournament reward loop will be added one focused system at a time.
