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

- [x] Add target scoring zones
- [x] Detect exact impact area
- [x] Add bullseye detection
- [x] Calculate target score
- [x] Display shot result
- [x] Display current score
- [x] Add visual scoring feedback
- [x] Track shots fired
- [x] Track successful hits
- [x] Track bullseyes

**Completion:** Every shot clearly communicates its result and score.

### Milestone 5 - Strength Progression

**Goal:** Good draw and release technique develops the character's Strength.

- [x] Add Strength stat
- [x] Connect draw strength and shooting technique to Strength progression
- [x] Award Strength XP for appropriate releases
- [x] Prevent exploitative progression
- [x] Add Strength levels
- [x] Display Strength and XP
- [x] Make Strength affect relevant capabilities
- [x] Balance early progression

**Completion:** Practice meaningfully develops Strength.

### Milestone 6 - Accuracy Progression

**Goal:** Accurate shooting improves the character's ability to aim.

- [x] Add Accuracy stat
- [x] Award Accuracy XP for target hits
- [x] Add Accuracy levels
- [x] Display Accuracy and XP
- [x] Define Accuracy's effect on aim assistance
- [x] Balance progression
- [x] Ensure Accuracy does not auto-aim

**Completion:** Successful target hits develop Accuracy and prepare the stat for visible trajectory assistance.

### Milestone 7 - Aim Assistance

**Goal:** Provide the first visible benefit from Accuracy without taking control away from the player.

- [x] Add trajectory line
- [x] Make trajectory line react to bow aim and draw state
- [x] Define unlock conditions and progression behavior
- [x] Make prediction quality depend on Accuracy
- [x] Improve prediction visibility at higher Accuracy
- [x] Preserve player skill requirements
- [x] Add clear visual feedback
- [x] Support different shot distances through live trajectory simulation

**Completion:** Accuracy provides a trajectory preview that helps the player judge an arrow's arc. The player still controls the aim completely. There is no auto-aim and the preview never changes the arrow's actual trajectory.

### Milestone 8 - First Playable Practice Loop

**Goal:** Combine shooting and progression into a satisfying practice loop.

- [x] Integrate bow, arrow, target, scoring, Strength, and Accuracy
- [x] Add practice HUD
- [x] Display Strength and Accuracy
- [x] Display shot results
- [x] Track practice statistics
- [x] Add session/reset support
- [x] Add progression feedback
- [x] Perform early balance pass
- [x] Playtest the full loop
- [x] Remove unnecessary complexity

**Completion:** The practice loop is playable and has been playtested. Shooting, progression, trajectory assistance, feedback, and session reset work together without introducing auto-aim.

### Milestone 9 - Economy & Money

**Goal:** Introduce the upgrade economy.

- [x] Add money system
- [x] Display money
- [ ] Make tournament rewards the primary money source
- [x] Add purchases
- [x] Add upgrade UI
- [x] Handle insufficient funds
- [x] Add purchase feedback
- [x] Keep economy separate from shooting logic

**Current implementation:** The economy is represented by a dedicated `PlayerEconomy` system. The practice range starts with 250 coins so the economy can be tested before tournaments exist. The first upgrade is a Training Manual with five levels. Each level costs more and increases Strength and Accuracy XP gains by 10%.

There is currently no gameplay method for earning money. The starting bankroll is a temporary testing aid and is not intended to represent the final economy. Tournament rewards will become the primary long-term source of money when tournaments are implemented.

**Completion:** The economy and purchase infrastructure work independently from shooting. Tournament reward integration remains for Milestones 12-13.

### Milestone 10 - Bows & Equipment

**Goal:** Create meaningful equipment progression.

- [x] Create bow data structure
- [x] Add starting bow
- [x] Add bow tiers
- [x] Define draw strength
- [x] Define Strength requirements
- [x] Define arrow velocity
- [x] Define draw speed/time
- [x] Add equipment modifiers
- [x] Add purchase/unlock system
- [x] Prevent equipping bows beyond requirements
- [x] Allow owned bows to be equipped
- [x] Make shooting behavior use equipped bow data

**Current implementation:** Bow definitions are stored as individual Godot `.tres` resources rather than being hard-coded into gameplay logic. The current equipment set contains the Training Bow, Recurve Bow, and War Bow. Each bow defines its own draw strength, draw speed, launch velocity, Strength requirement, price, and visual properties.

The equipment panel displays available bows, purchase costs, Strength requirements, ownership, and the currently equipped bow. Purchasing a valid bow deducts coins, marks the bow as owned, and equips it immediately. Owned bows can be equipped again as long as the player's Strength meets the requirement. The active bow's resource data drives the actual shooting behavior and visuals.

Bow prices are currently tuned for development testing because there is no gameplay income yet. Final equipment prices will be balanced after tournament rewards and the broader economy are implemented.

**Completion:** The player can purchase and equip different bows, and the equipped bow directly affects shooting behavior.

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
- Basic trajectory assistance
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

**Current Stage: Milestone 10 - Bows & Equipment**

Milestones 0 through 9 are implemented, with tournament income intentionally deferred until the tournament systems are built. The core practice loop has been playtested. Strength and Accuracy live together in the central `PlayerStats` script. Strength progression rewards meaningful draw and release practice. Accuracy improves from every successful target hit rather than requiring a bullseye.

Strength starts at level 1 with 0 XP. Valid releases begin at 60% draw strength. XP scales with release quality up to 25 XP for a full draw, while weak releases receive no XP. XP is awarded once per arrow release. Early levels require 100 XP, with the requirement increasing by 25 XP per level. Strength affects launch capability by adding 25 launch-speed points per Strength level above level 1.

Accuracy starts at level 1 with 0 XP. Each successful target hit awards 25 Accuracy XP. Accuracy uses the same 100 XP starting requirement and 25 XP growth per level. Accuracy affects the trajectory preview rather than steering the bow or arrow.

The trajectory preview is a visual simulation of the actual shot arc. It follows the current bow aim, draw strength, launch speed, and gravity. Higher Accuracy increases the useful prediction window and improves line visibility. The player still controls the aim completely. The system does not rotate the bow, alter the mouse aim, bend the arrow, or select a target automatically.

Milestone 9 adds a separate economy layer with coins, purchase validation, upgrade feedback, and a Training Manual upgrade. The Training Manual has five levels and increases both Strength and Accuracy XP gains by 10% per level. The practice range currently starts with 250 coins for development testing. There is no current gameplay income source, so equipment prices are temporarily tuned low enough to allow equipment testing. Tournament rewards will become the primary long-term money source later.

Milestone 10 adds data-driven bow equipment using individual `.tres` resources. The player can purchase and equip the Training Bow, Recurve Bow, and War Bow. Each bow has independent performance and visual data, while Strength requirements prevent the player from equipping equipment that is currently beyond their progression.

The next goal is:

> **Build Milestone 11: Practice Range Expansion.**
