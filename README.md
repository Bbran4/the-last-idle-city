# The Last Archer

A small active skill-based archery progression game for itch.io and Kongregate.

The player is an archer practicing for tournaments. Shoot targets, improve your technique, buy better equipment, expand your practice range, and eventually compete in increasingly difficult tournaments.

## Core Loop

**Practice → Improve Strength & Accuracy → Unlock Better Equipment → Expand Practice Range → Enter Tournament → Earn Prize Money → Purchase Upgrades → Practice More Efficiently → Enter More Difficult Tournaments**

The game combines player skill with character progression. A skilled player with weak equipment should still be able to perform well, while upgrades should improve capability without turning shooting into an automatic process.

## Development Roadmap

### Milestone 0 - Project Foundation

**Goal:** Establish a clean, working Godot 4.7 project.

- [x] Create and configure Godot 4.7 project
- [x] Configure project display settings
- [x] Configure initial input settings
- [x] Create main scene
- [x] Establish initial folder structure
- [x] Add initial game entry point
- [x] Confirm project launches without configuration errors
- [x] Confirm project is structured for a clean checkout

**Completion:** Project launches into a basic playable scene with no gameplay systems.

### Milestone 1 - Archer & Practice Range

**Goal:** Create the first visible game world.

- [x] Create main practice scene
- [x] Add archer on the left side of the screen
- [x] Add basic bow
- [x] Add first target
- [x] Position target at a sensible starting distance
- [x] Add basic background/environment
- [x] Establish simple camera/view layout
- [x] Ensure scene scales correctly with the window

**Completion:** Launch the game and see an archer, bow, and target in a functional practice range.

### Milestone 2 - Bow Drawing & Firing

**Goal:** Create the core hold, draw, and release interaction.

- [x] Detect left mouse button press
- [x] Begin drawing while the button is held
- [x] Add a visual draw-strength indicator
- [x] Increase draw strength while held
- [x] Respect the bow's maximum draw strength
- [x] Detect mouse release
- [x] Convert draw strength into arrow launch force
- [x] Fire an arrow on release
- [x] Prevent invalid or repeated shots during the draw cycle
- [x] Add basic shooting feedback

**Completion:** The player can hold the mouse button, draw the bow, and release it to fire an arrow.

### Milestone 3 - Arrow Physics & Target Hits

**Goal:** Give the arrow believable physical behavior and target interaction.

- [x] Create dedicated arrow scene
- [x] Add projectile movement
- [x] Add gravity and arrow arc
- [x] Rotate arrow along its flight path
- [x] Add target collision
- [x] Stop arrow on valid target impact
- [x] Keep arrows embedded in the target
- [x] Handle misses
- [x] Add impact feedback
- [x] Add testing/reset support for arrows

**Completion:** Arrows have believable flight and remain visibly embedded when they hit the target.

### Milestone 4 - Scoring & Bullseye

**Goal:** Make every shot produce a meaningful result.

- [ ] Add target scoring zones
- [ ] Detect exact impact area
- [ ] Add bullseye detection
- [ ] Calculate target score
- [ ] Display shot result
- [ ] Display current score
- [ ] Add visual scoring feedback
- [ ] Track shots fired
- [ ] Track successful hits
- [ ] Track bullseyes

**Completion:** Every shot clearly communicates its result and score.

### Milestone 5 - Strength Progression

**Goal:** Good draw and release technique develops the character's Strength.

- [ ] Add Strength stat
- [ ] Connect draw strength and shooting technique to Strength progression
- [ ] Award Strength XP for appropriate releases
- [ ] Prevent exploitative progression
- [ ] Add Strength levels
- [ ] Display Strength and XP
- [ ] Make Strength affect relevant capabilities
- [ ] Balance early progression

**Completion:** Practice meaningfully develops Strength.

### Milestone 6 - Accuracy Progression

**Goal:** Accurate shooting improves the character's ability to aim.

- [ ] Add Accuracy stat
- [ ] Award Accuracy XP for bullseyes
- [ ] Add Accuracy levels
- [ ] Display Accuracy and XP
- [ ] Define Accuracy's effect on aim assistance
- [ ] Balance progression
- [ ] Ensure Accuracy does not auto-aim

**Completion:** Bullseyes develop Accuracy and produce a tangible progression benefit.

### Milestone 7 - Aim Assistance

**Goal:** Provide the first visible benefit from Accuracy.

- [ ] Add trajectory line
- [ ] Make trajectory line react to bow and draw state
- [ ] Define unlock conditions
- [ ] Make prediction quality depend on Accuracy
- [ ] Improve prediction at higher Accuracy
- [ ] Preserve player skill requirements
- [ ] Add clear visual feedback
- [ ] Support multiple distances

**Completion:** Accuracy makes aiming easier without removing the need for skill.

### Milestone 8 - First Playable Practice Loop

**Goal:** Combine shooting and progression into a satisfying practice loop.

- [ ] Integrate bow, arrow, target, scoring, Strength, and Accuracy
- [ ] Add practice HUD
- [ ] Display Strength and Accuracy
- [ ] Display shot results
- [ ] Track practice statistics
- [ ] Add session/reset support
- [ ] Add progression feedback
- [ ] Perform early balance pass
- [ ] Playtest the full loop
- [ ] Remove unnecessary complexity

**Completion:** Repeated practice feels meaningful and satisfying.

> **Important checkpoint:** If shooting is not fun here, stop and improve it before continuing.

### Milestone 9 - Economy & Money

**Goal:** Introduce the upgrade economy.

- [ ] Add money system
- [ ] Display money
- [ ] Make tournament rewards the primary money source
- [ ] Add purchases
- [ ] Add upgrade UI
- [ ] Handle insufficient funds
- [ ] Add purchase feedback
- [ ] Keep economy separate from shooting logic

**Completion:** The game's economy functions independently from the shooting mechanics.

### Milestone 10 - Bows & Equipment

**Goal:** Create meaningful equipment progression.

- [ ] Create bow data structure
- [ ] Add starting bow
- [ ] Add bow tiers
- [ ] Define draw strength
- [ ] Define Strength requirements
- [ ] Define arrow velocity
- [ ] Define draw speed/time
- [ ] Add equipment modifiers
- [ ] Add purchase/unlock system
- [ ] Prevent equipping bows beyond requirements
- [ ] Allow owned bows to be equipped
- [ ] Make shooting behavior use equipped bow data

**Completion:** Money can buy better bows while Strength remains relevant.

### Milestone 11 - Practice Range Expansion

**Goal:** Expand the practice environment.

- [ ] Add additional target slots
- [ ] Add target purchases
- [ ] Add target distances
- [ ] Add smaller targets
- [ ] Add range upgrade data
- [ ] Add range upgrade UI
- [ ] Persist range upgrades
- [ ] Visually evolve the range
- [ ] Balance expansion costs

**Completion:** The practice range grows alongside the player.

### Milestone 12 - First Tournament

**Goal:** Introduce competition.

- [ ] Add tournament entry system
- [ ] Add tournament requirements
- [ ] Add rounds
- [ ] Add arrows/attempt limits
- [ ] Add tournament scoring
- [ ] Add tournament targets
- [ ] Add opponents
- [ ] Generate opponent scores
- [ ] Add round results
- [ ] Add tournament results
- [ ] Add tournament UI
- [ ] Add entry/restart flow

**Completion:** The player can complete a full tournament.

### Milestone 13 - Tournament Rewards

**Goal:** Connect tournament performance to long-term progression.

- [ ] Add prize structures
- [ ] Award tournament money
- [ ] Display rewards
- [ ] Unlock tournament progression
- [ ] Add harder tournaments
- [ ] Balance entry costs and rewards
- [ ] Maintain the relevance of practice

**Completion:** Tournament success unlocks stronger equipment and harder competition.

### Milestone 14 - Advanced Targets & Challenges

**Goal:** Add varied shooting challenges.

- [ ] Add moving targets
- [ ] Add long-distance targets
- [ ] Add timed challenges
- [ ] Add multi-target challenges
- [ ] Add smaller precision targets
- [ ] Add challenge-specific scoring
- [ ] Keep challenges compatible with the core shooting system

**Completion:** Players have multiple meaningful ways to practice.

### Milestone 15 - Advanced Archery Systems

**Goal:** Add optional depth only where it strengthens the core game.

- [ ] Evaluate wind
- [ ] Add wind if it improves gameplay
- [ ] Let Accuracy affect wind information
- [ ] Evaluate arrow types
- [ ] Add arrow types only if they create meaningful choices
- [ ] Evaluate Speed and Endurance
- [ ] Add only systems that strengthen the core loop

**Completion:** The game has additional depth without unrelated complexity.

### Milestone 16 - Progression Balance

**Goal:** Balance the complete gameplay loop.

- [ ] Balance Strength progression
- [ ] Balance Accuracy progression
- [ ] Balance aim assistance
- [ ] Balance bow costs
- [ ] Balance bow requirements
- [ ] Balance range costs
- [ ] Balance tournament entry costs
- [ ] Balance tournament rewards
- [ ] Balance tournament difficulty
- [ ] Balance overall pacing
- [ ] Remove or simplify weak systems

**Completion:** Progression feels deliberate and rewarding.

### Milestone 17 - UI, Audio & Visual Polish

**Goal:** Turn the functional game into a polished experience.

- [ ] Polish HUD
- [ ] Polish buttons and menus
- [ ] Improve target visuals
- [ ] Improve archer visuals
- [ ] Improve bow and arrow visuals
- [ ] Add animations
- [ ] Add impact effects
- [ ] Improve target feedback
- [ ] Improve stat feedback
- [ ] Improve tournament presentation
- [ ] Add sound effects
- [ ] Add music if appropriate
- [ ] Add settings
- [ ] Improve accessibility and readability

**Completion:** The game has a cohesive, polished presentation.

### Milestone 18 - Save System & Release Preparation

**Goal:** Prepare the game for distribution.

- [ ] Save player progression
- [ ] Save money
- [ ] Save equipment
- [ ] Save range upgrades
- [ ] Save tournament progression
- [ ] Add reliable loading
- [ ] Handle corrupt or missing saves
- [ ] Add reset-save functionality
- [ ] Test fresh games
- [ ] Test long-term progression
- [ ] Test multiple display resolutions
- [ ] Fix release bugs
- [ ] Optimize where necessary
- [ ] Create release build
- [ ] Prepare itch.io build
- [ ] Prepare Kongregate-compatible build if supported

**Completion:** A player can download, play, close, return, and continue reliably.

## MVP

The first playable MVP ends at **Milestone 8**.

The MVP contains:

- One archer
- One bow
- One target
- Mouse-controlled drawing
- Arrow physics
- Target collision
- Bullseye detection
- Strength progression
- Accuracy progression
- Basic aim assistance
- Basic practice HUD
- Clear shot feedback

The MVP does **not** require:

- Tournaments
- Economy
- Multiple bows
- Advanced targets
- Wind
- Save system

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

**Current Stage: Milestone 3 - Arrow Physics & Target Hits**

Milestones 0 through 3 are complete. The project now has a dedicated arrow scene with projectile movement, gravity, flight rotation, target collision, embedded arrows, miss handling, impact feedback, and an `R` reset control for testing.

The next major goal is:

> **Make every hit matter with scoring and bullseyes.**
