# 🏰 Castle Archer

> **A simple incremental castle-defense game where you shoot enemies, earn coins, upgrade your archer, and survive increasingly ridiculous waves.**

Castle Archer is a small **2D Godot game written in GDScript**, designed for a polished browser/indie release on **Kongregate and itch.io**.

The core loop is deliberately simple:

**Shoot → Earn → Upgrade → Survive → Repeat.**

The goal is to keep the project small, readable, fun, and actually finishable.

---

# 🎯 Current Gameplay Layout

```text
		Enemies →     🏰 Castle + Archer     ← Enemies
						 CENTER
```

- The castle sits in the middle of the battlefield.
- The player archer is positioned at the castle.
- Enemies spawn from both the left and right sides.
- Enemies move toward the castle.
- The player aims with the mouse and automatically fires arrows.
- Enemy kills award coins.
- Enemies reaching the castle deal damage.
- Castle health reaching zero ends the run.

`main.tscn` is the single gameplay scene. The obsolete `milestone1_test` scene and controller have been removed.

---

# 🏹 The Archer

The player begins with one archer.

Current combat stats include:

- Damage
- Attack Speed
- Arrow Speed
- Range
- Critical Hit Chance
- Critical Hit Damage

The current implementation supports mouse aiming and automatic arrow firing.

---

# 💰 Current Progression

The first progression layer is now in place.

## First Passive

After the player has earned **6 total coins**, the first passive automatically unlocks:

**Sharpened Arrows: +1 Attack Damage**

This is intentionally simple. It gives the player an immediate progression milestone without introducing a large skill tree.

## First Purchasable Upgrade

The first upgrade is:

**Damage +1 for 1 coin**

The upgrade system is intentionally small and will be expanded with additional stats later.

---

# 🌊 Enemy Waves

The wave system is currently playable and considered stable enough to move forward.

Current wave behavior:

- Wave 1 starts with **5 enemies**.
- Enemy count increases by **1 per wave**.
- Enemy health increases by **15% per wave** relative to the starting enemy health.
- A **2 second** break occurs between cleared waves.
- Enemies spawn from both sides of the castle.
- Enemy kills award **1 coin** by default.
- Killing enemies progresses the current wave.
- The next wave starts automatically.
- Castle destruction ends the run.

These values are development values. Detailed balancing can happen later after more progression systems exist.

---

# 💥 Combat Feedback

Basic combat feedback is now implemented.

- Enemies flash when hit.
- Enemies shrink and fade when killed.
- Wave status communicates incoming and cleared waves.
- Passive unlocks display a clear message.
- Damage upgrades display a clear confirmation.

More polished effects can be added later without changing the underlying combat architecture.

---

# 👹 Bosses

Bosses are planned as progression events rather than ordinary enemies with huge health pools.

## Mini Bosses

Every **10 waves**:

```text
Wave 10 → Mini Boss
Wave 20 → Mini Boss
Wave 30 → Mini Boss
...
```

## Major Bosses

Every **50 waves**:

```text
Wave 50  → Major Boss
Wave 100 → Major Boss
Wave 150 → Major Boss
...
```

Boss systems are not implemented yet.

---

# 🎯 Skills

Planned active skills include:

- Power Shot
- Multi Shot
- Piercing Arrow
- Explosive Arrow
- Rapid Fire
- Rain of Arrows

Passive progression is separate from active combat skills. The first passive is **Sharpened Arrows: +1 Damage**.

The skill system should remain much smaller than a traditional RPG skill tree.

---

# 🤖 Automation

The game will eventually transition from active shooting into incremental/idle progression.

Planned automation includes:

- Auto Aim
- Automatic target selection
- Target priority
- Automatic firing
- Auto Aim upgrades
- Additional archers
- Archer recruitment
- Archer upgrades

Automation should feel like a major progression milestone rather than another percentage bonus.

---

# 🏰 Castle Defense

The castle is the main objective.

Current castle systems include:

- Health
- Armor support
- Health regeneration support
- Damage handling
- Destruction/game-over state

The current development test value is **100 HP**.

Planned castle upgrades include:

- Maximum Health
- Armor
- Health Regeneration
- Damage Reduction
- Starting Health

---

# 💵 Economy

Coins are the primary currency.

Currently:

- Enemies award coins when killed.
- The UI displays the current coin total.
- Total coins earned are tracked for progression unlocks.
- Coins can be spent on the first Damage upgrade.
- The first passive unlocks at 6 total coins earned.

The economy should remain understandable. Avoid adding currencies or complicated scaling unless they genuinely improve progression.

---

# 🎨 Art Direction

The current art is intentionally placeholder/development art.

The final game should prioritize:

- Clear castle silhouette
- Readable archer
- Obvious enemy movement
- Visible arrows
- Clear health and coin feedback
- Satisfying hit/death effects
- Boss presentation

Clarity and responsiveness matter more than graphical complexity.

---

# 🚀 DEVELOPMENT ROADMAP

Development remains deliberately sequential.

## 🏁 Milestone 0 - Foundation

**Status: Mostly complete**

- [x] Confirm Godot project opens and runs
- [x] Establish main scene
- [x] Establish basic game controller/state
- [x] Establish folder/script structure
- [x] Create basic UI layout
- [ ] Create dedicated game loop/tick where required
- [ ] Establish save/load foundation
- [x] Confirm clean project startup

Save/load and a dedicated tick are intentionally deferred until they are actually needed.

---

## 🏹 Milestone 1 - First Arrow

**Status: Complete**

- [x] Create castle
- [x] Create player archer
- [x] Implement mouse aiming
- [x] Implement arrow firing
- [x] Implement arrow movement
- [x] Create first enemy
- [x] Implement enemy health
- [x] Implement enemy movement toward castle
- [x] Implement enemy death
- [x] Implement castle health
- [x] Implement enemy damage to castle
- [x] Add basic hit/death feedback

The first combat loop is complete.

---

## 🌊 Milestone 2 - Waves

**Status: Complete for the current development pass**

- [x] Implement wave manager
- [x] Spawn multiple enemies per wave
- [x] Spawn enemies from both sides
- [x] Complete waves when all active enemies are gone
- [x] Increase enemy count between waves
- [x] Increase enemy health between waves
- [x] Add wave display
- [x] Add wave completion/incoming feedback
- [x] Add coin rewards for enemy kills
- [x] Start the next wave automatically
- [x] End the run when castle health reaches zero
- [x] Validate the current wave loop

Detailed balance tuning is intentionally deferred until more upgrade progression exists.

---

## 💰 Milestone 3 - Upgrades

**Status: In progress**

### Completed

- [x] Build initial upgrade system
- [x] Add Damage upgrade
- [x] Add first passive unlock
- [x] First passive: **+1 Attack Damage**
- [x] Add basic upgrade feedback

### Remaining

- [ ] Add Attack Speed upgrade
- [ ] Add Critical Chance upgrade
- [ ] Add Critical Damage upgrade
- [ ] Add Arrow Speed upgrade
- [ ] Add Range upgrade
- [ ] Add Castle Health upgrade
- [ ] Display broader upgrade progression
- [ ] Implement sensible cost scaling
- [ ] Balance upgrade values
- [ ] Add stronger progression feedback

The upgrade system should remain simple. Every upgrade should have an obvious effect and a clear purpose.

---

## 👹 Milestone 4 - Bosses

**Status: Not started**

- [ ] Add Mini Boss system
- [ ] Spawn Mini Boss every 10 waves
- [ ] Add Mini Boss health bars
- [ ] Add Mini Boss rewards
- [ ] Add Major Boss system
- [ ] Spawn Major Boss every 50 waves
- [ ] Add Major Boss health bars
- [ ] Add Major Boss rewards
- [ ] Add at least one unique boss mechanic
- [ ] Add boss entrance/death feedback

---

## ⚡ Milestone 5 - Skills

**Status: Not started**

- [ ] Create active skill system
- [ ] Create cooldown system
- [ ] Add Power Shot
- [ ] Add Multi Shot
- [ ] Add Piercing Arrow
- [ ] Add Explosive Arrow
- [ ] Add Rapid Fire
- [ ] Add Rain of Arrows
- [ ] Add skill UI
- [ ] Add skill feedback

---

## 🤖 Milestone 6 - Automation

**Status: Not started**

- [ ] Add Auto Aim unlock
- [ ] Implement automatic target selection
- [ ] Add target priority rules
- [ ] Add automatic firing mode
- [ ] Add Auto Aim upgrades
- [ ] Add additional archers
- [ ] Add archer recruitment costs
- [ ] Add archer upgrades
- [ ] Balance active and automated play

---

## 💾 Milestone 7 - Persistence & Polish

**Status: Not started**

- [ ] Add reliable save system
- [ ] Add settings
- [ ] Add sound effects
- [ ] Add music
- [ ] Improve combat animations
- [ ] Improve UI feedback
- [ ] Add achievements
- [ ] Add menus
- [ ] Add pause functionality where appropriate
- [ ] Test browser resolutions
- [ ] Test performance
- [ ] Fix gameplay bugs
- [ ] Balance progression

---

## 🌐 Milestone 8 - Release

**Status: Not started**

- [ ] Final gameplay balance
- [ ] Final UI pass
- [ ] Final audio pass
- [ ] Browser testing
- [ ] Kongregate build
- [ ] itch.io build
- [ ] Store/page artwork
- [ ] Game description
- [ ] Screenshots
- [ ] Short gameplay video/GIF
- [ ] Publish
- [ ] Collect player feedback
- [ ] Fix critical launch issues

---

# 📋 IMMEDIATE TASK LIST

Work on one system at a time. Do not jump ahead simply because a later system is already described in the README.

### Completed Foundation / Combat / Waves

- [x] Main gameplay scene
- [x] Castle in the center
- [x] Player positioned at the castle
- [x] Enemies spawn from both sides
- [x] Enemy movement toward castle
- [x] Mouse aiming
- [x] Automatic arrow firing
- [x] Arrow collision
- [x] Enemy health
- [x] Enemy death
- [x] Hit/death feedback
- [x] Castle health
- [x] Castle destruction/game over
- [x] Wave system
- [x] Multiple enemies per wave
- [x] Wave scaling
- [x] Coin rewards
- [x] Basic wave/coin/castle UI
- [x] First upgrade system
- [x] First passive: +1 Attack Damage
- [x] Removed obsolete Milestone 1 test scene

### Next Focus

- [ ] Add Attack Speed upgrade
- [ ] Add Critical Chance upgrade
- [ ] Add Critical Damage upgrade
- [ ] Add Arrow Speed upgrade
- [ ] Add Range upgrade
- [ ] Add Castle Health upgrade
- [ ] Continue broader upgrade progression
- [ ] Balance upgrade costs and effects

### Later

- [ ] Mini Bosses
- [ ] Major Bosses
- [ ] Active skills
- [ ] Auto Aim
- [ ] Additional archers
- [ ] Persistence
- [ ] Final polish
- [ ] Release

**Do not build prestige, complex meta-progression, large skill trees, or complicated economy systems yet.**

The immediate goal is to make the first progression layer feel good before adding another major system.

---

# 🧭 Design Rules

## 1. Keep It Small

This is intentionally a small game. Do not turn it into an RPG, city builder, tower-defense spreadsheet, or MMORPG wearing a castle hat.

## 2. Make Every Upgrade Feel Useful

Players should understand what an upgrade does and feel its impact.

## 3. Bosses Must Be Events

A boss should change the player's behaviour or require a meaningful response. More health alone is not enough.

## 4. Automation Is Progression

Auto Aim and additional archers should feel like major achievements.

## 5. Do Not Build Complexity Before Fun

```text
Fun Shooting
    ↓
Fun Waves
    ↓
Fun Upgrades
    ↓
Bosses
    ↓
Skills
    ↓
Automation
    ↓
Polish
    ↓
Release
```

Only add complexity when the existing layer is working and enjoyable.

---

# ⭐ The Goal

A player should be able to open Castle Archer and immediately understand what to do:

**Shoot. Earn. Upgrade. Defend. Repeat.**

Start with one archer.

Build a stronger defender.

Survive increasingly dangerous waves.

Eventually automate the defense and build a ridiculous storm of arrows, enemies, critical hits, skills, bosses, and additional archers.

But first: make the first few minutes fun.
