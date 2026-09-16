# 🏹 The Last Archer

**The Last Archer** is a small archery practice and progression game built around a simple idea:

> **Practice. Improve. Compete. Become the champion.**

You begin as an inexperienced archer practicing alone with a basic bow and a single target.

As you practice, your archery skills improve. Better timing makes your shots stronger. Accurate shots improve your aim. Better equipment lets you fire faster and farther.

Eventually, practice leads to competition.

Enter tournaments, defeat increasingly skilled opponents, earn prize money, purchase better equipment, expand your practice range, and work your way toward becoming the greatest archer in the tournament.

The game is designed to be small, accessible, and satisfying, with a mixture of **active skill-based gameplay, incremental progression, and idle-style upgrades**.

---

# 🎯 Core Gameplay

The player controls an archer positioned on the **left side of the screen**, firing arrows toward targets.

The basic shooting mechanic is deliberately simple:

1. **Hold the left mouse button** to draw the bow.
2. Holding the button increases the bow's draw strength.
3. **Release the mouse button** to fire.
4. The arrow travels toward the target.
5. The quality of the shot determines the result.

The player should immediately understand the mechanic without needing a tutorial.

**Hold. Aim. Release.**

---

# 🏹 Archery Skill

Practice is the primary way the player improves their character.

Several statistics develop through gameplay.

## Strength

Strength represents how much force the archer can generate when drawing the bow.

Releasing the bow at the correct draw point provides additional strength progression.

Higher strength allows the player to:

* Draw stronger bows
* Fire arrows at greater velocity
* Use heavier equipment
* Eventually compete with more demanding bows

Strength should improve naturally through repeated practice rather than simply being a number purchased from a menu.

---

## 🎯 Accuracy

Accuracy represents the archer's ability to consistently place arrows where intended.

Hitting the **bullseye** provides accuracy progression.

As accuracy improves, the player receives increasingly useful visual assistance when aiming.

The goal is for accuracy to feel like something the player has **earned through becoming a better archer**, rather than simply purchasing an aim upgrade.

---

# 👁️ Aim Assistance

Accuracy provides a visible aiming aid.

At low accuracy, the player must rely almost entirely on their own judgement.

As accuracy improves, a trajectory/aiming line gradually becomes available.

This could eventually develop into:

* A basic trajectory line
* More accurate trajectory prediction
* Impact prediction
* Wind compensation
* Advanced targeting information

The assistance should support the player without completely removing the skill involved in aiming.

The ultimate goal is for progression to make the player feel increasingly capable.

---

# 🏆 Tournaments

Practice eventually leads to competition.

Once the player reaches the required level of progression, tournaments become available.

Tournaments provide a structured goal beyond endlessly practicing against targets.

A tournament could involve:

* Multiple rounds
* Different target distances
* Different target sizes
* Limited arrows
* Increasingly difficult opponents
* Score-based competition
* Prize money

Winning tournaments provides the money needed to continue improving the player's equipment and practice range.

---

# 💰 Money

Money is primarily earned through tournament performance.

Prize money can be spent on improving the player's archery setup.

Possible purchases include:

* Better bows
* Better arrows
* Additional targets
* Practice equipment
* Training upgrades
* Range improvements
* Tournament entry upgrades

Money should create a meaningful progression loop:

**Practice → Improve → Compete → Earn → Upgrade → Practice Better**

---

# 🏹 Bows

Different bows provide different characteristics.

A better bow does not simply mean a universally better weapon.

Each bow should have its own requirements and advantages.

Possible bow statistics include:

* Maximum draw strength
* Draw speed
* Arrow velocity
* Accuracy modifier
* Strength requirement
* Draw time
* Special characteristics

For example:

> A powerful tournament bow may fire extremely fast arrows but require significantly more strength to use effectively.

This creates an interesting progression choice.

The player may own a powerful bow but still need to train enough strength before they can properly use it.

---

# 🎯 Practice Range

The player's practice range can be expanded over time.

The starting setup is intentionally simple:

**One archer.  
One bow.  
One target.**

As the player progresses, additional targets and training equipment can be purchased.

Possible improvements include:

* Additional targets
* Targets at different distances
* Smaller targets
* Moving targets
* Multiple targets
* Long-distance targets
* Strength training equipment
* Accuracy training equipment

The practice range should visually evolve alongside the player's progression.

---

# 📈 Progression

The game uses a combination of **player skill** and **character progression**.

The player becomes better because they learn the shooting mechanics.

The character becomes better because they practice and develop statistics.

These two systems should complement each other.

A highly skilled player with weak equipment should still be able to perform well.

A heavily upgraded archer should still require the player to actually shoot accurately.

---

# 🔄 Core Progression Loop

The primary gameplay loop is:

```text
Practice
   ↓
Improve Strength & Accuracy
   ↓
Unlock Better Equipment
   ↓
Expand Practice Range
   ↓
Enter Tournament
   ↓
Earn Prize Money
   ↓
Purchase Upgrades
   ↓
Practice More Efficiently
   ↓
Enter More Difficult Tournaments
```

The game should always give the player something meaningful to work toward.

---

# 🥇 Tournament Progression

Tournaments should gradually increase in difficulty.

Early tournaments may feature:

* Short distances
* Large targets
* Few rounds
* Weak opponents

Later tournaments can introduce:

* Greater distances
* Smaller targets
* Moving targets
* Stronger opponents
* More rounds
* Higher entry costs
* Larger rewards

Eventually, the player reaches the highest level of competition.

The ultimate objective is to become the **champion archer**.

---

# 🌱 Future Progression Ideas

The following systems are potential additions and are **not yet finalized**.

## Wind

Environmental wind could affect arrow trajectory.

Higher accuracy could eventually allow the player to receive information about wind direction and strength.

---

## Different Arrow Types

Different arrows could provide different characteristics.

Potential examples:

* Standard arrows
* Heavy arrows
* Lightweight arrows
* Long-distance arrows
* Precision arrows

---

## Target Variety

Targets could eventually introduce additional challenges.

Examples:

* Standard stationary targets
* Smaller targets
* Moving targets
* Long-distance targets
* Timed targets
* Multi-target challenges

---

## Training

Additional training activities could improve specific statistics.

For example:

**Strength Training**

Improves maximum draw strength.

**Accuracy Training**

Improves accuracy and aim assistance.

**Speed Training**

Improves draw and release speed.

**Endurance Training**

Allows the player to maintain performance through longer competitions.

These systems are subject to further design.

---

# 🎮 Design Philosophy

The game should remain **small and focused**.

The core experience should always revolve around shooting a bow.

Upgrades and progression should enhance that experience rather than bury it beneath dozens of menus and disconnected systems.

The player should be able to sit down, pick up the mouse, and immediately understand what they are doing.

### Simple to learn.

### Satisfying to master.

### Meaningful progression.

---

# 🛠️ Development Roadmap

The project is being rebuilt from a **completely blank implementation**. The previous scripts, scenes, and data files have been removed.

Development will happen in small, playable milestones. Each milestone should leave the project in a working state before the next layer is added.

The order below is intentional. The shooting mechanic must prove itself before large progression systems are built around it.

---

## Milestone 0 - Project Foundation

**Goal:** Create a clean, working Godot project ready for development.

### Tasks

- [ ] Create/configure the Godot 4.7 project
- [ ] Configure project display and input settings
- [ ] Create the main scene
- [ ] Establish the initial folder structure
- [ ] Add the initial game entry point
- [ ] Confirm the project launches without errors
- [ ] Confirm the project runs correctly from a clean checkout

**Completion Criteria:** The project launches into a basic playable scene with no gameplay systems yet.

---

## Milestone 1 - Archer & Practice Range

**Goal:** Build the first visible version of the game world.

### Tasks

- [ ] Create the main practice scene
- [ ] Add the archer on the left side of the screen
- [ ] Add a basic bow
- [ ] Add the first target
- [ ] Position the target at a sensible starting distance
- [ ] Add basic background/environment elements
- [ ] Establish a simple camera/view layout
- [ ] Make sure the scene scales correctly with the game window

**Completion Criteria:** The player can launch the game and see an archer, bow, and target in a functional practice range.

---

## Milestone 2 - Bow Drawing & Firing

**Goal:** Implement the core interaction: hold, draw, release.

### Tasks

- [ ] Detect left mouse button press
- [ ] Begin drawing the bow while the button is held
- [ ] Display a visual draw-strength indicator
- [ ] Increase draw strength while holding the button
- [ ] Respect the bow's maximum draw strength
- [ ] Detect mouse button release
- [ ] Convert draw strength into arrow launch force
- [ ] Fire an arrow on release
- [ ] Prevent invalid/repeated shots during the draw cycle
- [ ] Add basic shooting feedback

**Completion Criteria:** The player can hold the mouse button, draw the bow, release it, and fire an arrow.

---

## Milestone 3 - Arrow Physics & Target Hits

**Goal:** Make arrows behave like physical projectiles and interact with the target.

### Tasks

- [ ] Create the arrow scene
- [ ] Add projectile movement
- [ ] Add gravity/arc behaviour
- [ ] Rotate the arrow to follow its flight direction
- [ ] Detect collision with the target
- [ ] Stop the arrow when it hits a valid surface
- [ ] Allow arrows to remain visibly embedded in targets
- [ ] Handle arrows that miss the target
- [ ] Add basic impact feedback
- [ ] Add a way to reset/clear fired arrows during testing

**Completion Criteria:** Arrows fly through the scene with believable projectile behaviour and can visibly hit the target.

---

## Milestone 4 - Scoring & Bullseye

**Goal:** Turn target hits into meaningful results.

### Tasks

- [ ] Create target scoring zones
- [ ] Detect the exact area struck by an arrow
- [ ] Implement bullseye detection
- [ ] Implement a basic target score
- [ ] Display the shot result
- [ ] Display the current score
- [ ] Add visual feedback for different hit qualities
- [ ] Track shots fired
- [ ] Track successful hits
- [ ] Track bullseyes

**Completion Criteria:** Every shot produces a clear result, with the bullseye providing the highest accuracy result.

---

## Milestone 5 - Strength Progression

**Goal:** Connect good shooting technique to character development.

### Tasks

- [ ] Create the player's Strength statistic
- [ ] Define the relationship between draw strength and Strength progression
- [ ] Reward appropriate releases with Strength experience
- [ ] Prevent unlimited/incorrect Strength progression from a single shot
- [ ] Implement Strength levels
- [ ] Display current Strength
- [ ] Display Strength progression/experience
- [ ] Allow Strength to affect the archer's capabilities
- [ ] Balance early Strength progression

**Completion Criteria:** Practicing and successfully managing the bow's draw develops the player's Strength over time.

---

## Milestone 6 - Accuracy Progression

**Goal:** Make accurate shooting improve the archer's ability to aim.

### Tasks

- [ ] Create the player's Accuracy statistic
- [ ] Reward bullseyes with Accuracy experience
- [ ] Implement Accuracy levels
- [ ] Display current Accuracy
- [ ] Display Accuracy progression/experience
- [ ] Define how Accuracy affects aiming assistance
- [ ] Balance early Accuracy progression
- [ ] Ensure Accuracy improves the character without automatically aiming for the player

**Completion Criteria:** Consistently hitting the bullseye develops Accuracy and provides tangible progression.

---

## Milestone 7 - Aim Assistance

**Goal:** Introduce the first visible benefit of increasing Accuracy.

### Tasks

- [ ] Create the trajectory/aiming line
- [ ] Make the line respond to the current bow/draw state
- [ ] Define when the line becomes available
- [ ] Tie aim assistance quality to Accuracy
- [ ] Improve trajectory prediction as Accuracy increases
- [ ] Ensure the line does not completely remove aiming skill
- [ ] Add visual feedback when aim assistance improves
- [ ] Test the system at multiple distances

**Completion Criteria:** Accuracy progression visibly makes aiming easier while preserving player skill.

---

## Milestone 8 - First Playable Practice Loop

**Goal:** Combine shooting and progression into the first genuinely playable version.

### Tasks

- [ ] Combine bow, arrow, target, scoring, Strength, and Accuracy systems
- [ ] Add a clean practice HUD
- [ ] Show Strength and Accuracy
- [ ] Show shot results
- [ ] Show basic practice statistics
- [ ] Add a simple session/reset flow
- [ ] Improve shooting feedback
- [ ] Balance early progression
- [ ] Playtest the core loop
- [ ] Remove unnecessary complexity discovered during testing

**Completion Criteria:** The player can repeatedly practice, improve Strength and Accuracy, and feel a meaningful difference as their archer develops.

> **This is the first major gameplay checkpoint. If shooting is not fun here, stop and improve it before continuing.**

---

## Milestone 9 - Economy & Money

**Goal:** Introduce the game's upgrade economy.

### Tasks

- [ ] Create the money system
- [ ] Create money display
- [ ] Define how tournament rewards generate money
- [ ] Create purchase handling
- [ ] Create basic upgrade UI
- [ ] Prevent purchases without sufficient funds
- [ ] Add purchase feedback
- [ ] Keep the economy separate from core shooting logic

**Completion Criteria:** The game has a functioning economy ready to support equipment and range upgrades.

---

## Milestone 10 - Bows & Equipment

**Goal:** Give the player meaningful equipment progression.

### Tasks

- [ ] Create a bow data structure
- [ ] Create the starting bow
- [ ] Create additional bow tiers
- [ ] Define bow draw strength
- [ ] Define bow strength requirements
- [ ] Define arrow velocity
- [ ] Define draw speed/time
- [ ] Define any bow-specific modifiers
- [ ] Create bow purchase/unlock system
- [ ] Prevent the player from using bows beyond their Strength capability
- [ ] Allow the player to equip owned bows
- [ ] Update shooting behaviour based on the equipped bow

**Completion Criteria:** Players can earn money, purchase better bows, and feel the difference between equipment while Strength remains relevant.

---

## Milestone 11 - Practice Range Expansion

**Goal:** Expand the practice environment and create more reasons to keep practicing.

### Tasks

- [ ] Create additional target slots
- [ ] Allow players to purchase additional targets
- [ ] Add different target distances
- [ ] Add smaller target sizes
- [ ] Create range upgrade data
- [ ] Create range upgrade UI
- [ ] Make purchased upgrades persist during the session
- [ ] Visually improve the range as it expands
- [ ] Balance the cost of range expansion

**Completion Criteria:** The practice range grows alongside the player's progression and provides increasingly varied practice opportunities.

---

## Milestone 12 - First Tournament

**Goal:** Turn practice into competition.

### Tasks

- [ ] Create the tournament entry system
- [ ] Define tournament requirements
- [ ] Create tournament rounds
- [ ] Define arrows/attempts per round
- [ ] Create tournament scoring rules
- [ ] Create tournament targets
- [ ] Create basic opponents
- [ ] Implement opponent scores
- [ ] Determine round results
- [ ] Determine tournament results
- [ ] Create tournament UI
- [ ] Add tournament entry/restart flow

**Completion Criteria:** A developed archer can enter a complete tournament and receive a final result.

---

## Milestone 13 - Tournament Rewards

**Goal:** Connect tournament success to the wider progression system.

### Tasks

- [ ] Create tournament prize structures
- [ ] Award money based on tournament results
- [ ] Display tournament rewards
- [ ] Add tournament progression/unlocks
- [ ] Add increasingly difficult tournaments
- [ ] Balance entry costs and rewards
- [ ] Ensure tournaments provide meaningful progression without replacing practice

**Completion Criteria:** Winning tournaments provides money and unlocks the path toward stronger equipment and harder competition.

---

## Milestone 14 - Advanced Targets & Challenges

**Goal:** Expand the shooting challenges after the core game is proven.

### Tasks

- [ ] Add moving targets
- [ ] Add long-distance targets
- [ ] Add timed challenges
- [ ] Add multi-target challenges
- [ ] Add smaller precision targets
- [ ] Create challenge-specific scoring rules
- [ ] Ensure new challenges remain compatible with the core shooting system

**Completion Criteria:** The player has multiple meaningful ways to practice and demonstrate archery skill.

---

## Milestone 15 - Advanced Archery Systems

**Goal:** Add optional depth to the archery simulation.

### Tasks

- [ ] Evaluate wind mechanics
- [ ] Add wind direction/strength if the system improves gameplay
- [ ] Connect wind information to Accuracy progression
- [ ] Evaluate different arrow types
- [ ] Add arrow types only if they create meaningful choices
- [ ] Evaluate additional character statistics such as Speed or Endurance
- [ ] Add only systems that strengthen the core gameplay loop

**Completion Criteria:** Advanced mechanics add depth without turning the game into a collection of unrelated systems.

---

## Milestone 16 - Progression Balance

**Goal:** Balance the complete gameplay loop.

### Tasks

- [ ] Balance Strength progression
- [ ] Balance Accuracy progression
- [ ] Balance aim assistance
- [ ] Balance bow costs
- [ ] Balance bow requirements
- [ ] Balance range upgrade costs
- [ ] Balance tournament entry costs
- [ ] Balance tournament rewards
- [ ] Balance tournament difficulty
- [ ] Review progression pacing
- [ ] Remove or simplify systems that do not contribute to the game

**Completion Criteria:** Progression feels deliberate, understandable, and rewarding from the first practice session through advanced tournaments.

---

## Milestone 17 - UI, Audio & Visual Polish

**Goal:** Turn the functional game into a polished experience.

### Tasks

- [ ] Finalize HUD layout
- [ ] Improve buttons and menus
- [ ] Improve target visuals
- [ ] Improve archer visuals
- [ ] Improve bow and arrow visuals
- [ ] Add shooting animations
- [ ] Add arrow impact effects
- [ ] Add target hit feedback
- [ ] Add Strength/Accuracy progression feedback
- [ ] Add tournament presentation
- [ ] Add sound effects
- [ ] Add music if appropriate
- [ ] Add settings/options
- [ ] Improve accessibility and readability

**Completion Criteria:** The game feels cohesive and polished rather than like a development prototype.

---

## Milestone 18 - Save System & Release Preparation

**Goal:** Prepare the game for distribution.

### Tasks

- [ ] Implement save data
- [ ] Save player progression
- [ ] Save money
- [ ] Save equipment
- [ ] Save range upgrades
- [ ] Save tournament progression
- [ ] Implement reliable loading
- [ ] Handle corrupted/missing save data safely
- [ ] Add reset-save option
- [ ] Test fresh-game progression
- [ ] Test long-term progression
- [ ] Test different display resolutions
- [ ] Fix remaining bugs
- [ ] Optimize performance
- [ ] Prepare release build
- [ ] Prepare itch.io build
- [ ] Prepare Kongregate-compatible build if supported by the final technology/runtime requirements

**Completion Criteria:** A new player can download the game, play through it, close it, return later, and continue their progression reliably.

---

# 🎯 Initial MVP

The first playable MVP ends at **Milestone 8**.

It should contain:

* One archer
* One bow
* One target
* Mouse-controlled drawing
* Arrow physics
* Target collision
* Bullseye detection
* Strength progression
* Accuracy progression
* Basic aim assistance
* Basic practice HUD
* Clear shot feedback

The MVP does **not** need tournaments, an economy, multiple bows, advanced targets, wind, or a save system.

The purpose of the MVP is to answer one question:

> **Is firing an arrow fun?**

If the answer is yes, the rest of the game can be built around that foundation.

---

# 🚧 Development Rules

To keep the project focused, development should follow these rules:

1. **Build one milestone at a time.**
2. **Do not build future systems early unless they are required by the current milestone.**
3. **Keep the core shooting mechanic independent from progression and economy systems.**
4. **Prefer simple systems over unnecessary abstractions.**
5. **Every completed milestone must remain playable.**
6. **Playtest major mechanics before expanding them.**
7. **If a feature makes the game less fun, reconsider or remove it.**
8. **Do not add complexity simply because an idle game traditionally has it.**
9. **The player's skill must always matter.**
10. **The README is the development roadmap, but gameplay testing can change the design when necessary.**

---

# 📌 Project Status

**Current Stage:** Milestone 0 - Project Foundation

The project has been reset to a **completely blank implementation**. Previous gameplay scripts, scenes, and data files have been removed so the new game can be built cleanly around the archery concept.

The current priority is to establish the project foundation and then build the shooting mechanic from the ground up.

The first major gameplay goal remains:

> **Hold. Aim. Release. Hit the target.**

Everything else comes after that.
