# 🏰 Castle Archer

> **A simple incremental castle-defense game where you shoot enemies, earn coins, upgrade your archer, and survive increasingly ridiculous waves.**

Castle Archer is a small **2D Godot game written in GDScript**, designed to be achievable as a polished browser/indie game for **Kongregate and itch.io**.

The core loop is deliberately simple:

**Shoot → Earn → Upgrade → Survive → Repeat.**

The player begins as a single archer defending a castle. Enemies approach from both sides, the player fires arrows, earns coins from kills, and eventually unlocks upgrades, skills, automation, and additional archers.

The goal is to keep the project small, readable, fun, and actually finishable.

---

# 🎯 Current Gameplay Layout

The current battlefield is intentionally simple:

```text
        Enemies →     🏰 Castle + Archer     ← Enemies
                         CENTER
```

- The castle sits in the middle of the battlefield.
- The player archer is positioned at the castle.
- Enemies spawn from both the left and right sides.
- Enemies move toward the castle.
- The player automatically fires arrows toward the mouse cursor.
- Enemies deal damage when they reach the castle.
- Enemy kills award coins.
- When castle health reaches zero, the run ends.

The old `milestone1_test` scene has been removed. `main.tscn` is now the single gameplay scene.

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

The current implementation supports mouse aiming and automatic arrow firing. More progression systems will be layered on later.

---

# 💰 Early Progression Plan

The first progression beat is intentionally small.

The castle currently starts at **100 HP** during development testing. With the current early enemy rewards, the player should accumulate a small amount of gold before the castle is destroyed.

The intended first meaningful unlock is:

### First Passive Skill

**+1 Attack Damage**

This is **planned, not implemented yet**.

The idea is that the player's first failed run should teach them that the coins they earned matter and that they can come back stronger.

The exact unlock flow and cost will be implemented during the upgrade/progression milestone rather than prematurely adding a larger skill system.

---

# 🌊 Enemy Waves

Enemies arrive in progressively larger waves.

The current wave system supports:

- Multiple enemies per wave
- Increasing enemy counts
- Increasing enemy health by wave
- Wave display
- Wave completion detection
- A short delay before the next wave
- Automatic progression into the next wave
- Enemy coin rewards
- Castle defeat ending the run

The initial wave starts with **5 enemies**, and the enemy count currently increases by **1 per wave**.

Enemy health currently scales upward with the wave number.

Future enemy types will include concepts such as:

- Goblin
- Orc
- Archer
- Knight
- Berserker
- Siege Enemy

These will be added gradually. The game should not become a zoo of mechanics before the basic loop is fun.

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

The game will eventually have active skills such as:

- Power Shot
- Multi Shot
- Piercing Arrow
- Explosive Arrow
- Rapid Fire
- Rain of Arrows

There is also a planned **passive progression layer**, beginning with the first simple passive:

> **+1 Attack Damage**

The passive system should stay much smaller than a traditional RPG skill tree.

---

# 🤖 Automation

The game should gradually transition from active shooting into incremental/idle progression.

Planned automation includes:

- Auto Aim
- Automatic target selection
- Target priority
- Automatic firing
- Auto Aim upgrades
- Additional archers
- Archer recruitment
- Archer upgrades

Automation is intended to feel like a major progression milestone, not just another percentage bonus.

---

# 🏰 Castle Defense

The castle is the main objective.

Enemies reaching the castle deal damage.

Current castle systems include:

- Health
- Armor support
- Health regeneration support
- Damage handling
- Destruction/game-over state

Planned upgrades include:

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
- Coins are stored in the Economy autoload.

Planned uses include:

- Archer upgrades
- Castle upgrades
- Passive skills
- Active skills
- Additional archers
- Automation

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

**Status: Core combat complete**

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
- [ ] Add basic hit/death feedback

The basic combat interaction is working. The remaining work is feedback and polish.

---

## 🌊 Milestone 2 - Waves

**Status: Substantially implemented, needs final validation/polish**

- [x] Implement wave manager
- [x] Spawn multiple enemies per wave
- [x] Complete waves when all active enemies are gone
- [x] Increase enemy count between waves
- [x] Increase enemy health between waves
- [x] Add wave display
- [x] Add wave completion/incoming feedback
- [x] Add coin rewards for enemy kills
- [x] Start the next wave automatically
- [x] End the run when castle health reaches zero
- [ ] Balance wave pacing and difficulty
- [ ] Add final hit/death feedback

### Current wave configuration

- Starting wave: **1**
- Enemies on wave 1: **5**
- Enemy count growth: **+1 per wave**
- Wave break: **2 seconds**
- Enemy health scaling: **+15% per wave** relative to the starting enemy health
- Enemy base coin reward: **1 coin**

These numbers are development values and can be balanced later.

---

## 💰 Milestone 3 - Upgrades

**Status: Not started**

Planned:

- [ ] Build upgrade system
- [ ] Add Damage upgrade
- [ ] Add Attack Speed upgrade
- [ ] Add Critical Chance upgrade
- [ ] Add Critical Damage upgrade
- [ ] Add Arrow Speed upgrade
- [ ] Add Range upgrade
- [ ] Add Castle Health upgrade
- [ ] Display upgrade costs
- [ ] Implement sensible cost scaling
- [ ] Add first passive skill unlock
- [ ] First passive: **+1 Attack Damage**
- [ ] Add clear upgrade feedback

The first passive should be the player's first meaningful progression reward, but it should not be implemented until the core wave loop is stable.

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

Passive progression is tracked separately from active combat skills so the systems do not become unnecessarily tangled.

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

### Completed Foundation / Combat

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
- [x] Castle health
- [x] Castle destruction/game over
- [x] Wave system
- [x] Multiple enemies per wave
- [x] Wave scaling
- [x] Coin rewards
- [x] Basic wave/coin/castle UI
- [x] Removed obsolete Milestone 1 test scene

### Next Focus

- [ ] Validate and balance the current wave loop
- [ ] Finish basic hit/death feedback
- [ ] Build the first upgrade system
- [ ] Add first passive unlock: **+1 Attack Damage**
- [ ] Continue with broader upgrade progression

### Later

- [ ] Mini Bosses
- [ ] Major Bosses
- [ ] Active skills
- [ ] Auto Aim
- [ ] Additional archers
- [ ] Persistence
- [ ] Polish
- [ ] Release

**Do not build prestige, complex meta-progression, large skill trees, or complicated economy systems yet.**

The immediate goal is to prove that the basic loop is fun before adding layers on top of it.

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