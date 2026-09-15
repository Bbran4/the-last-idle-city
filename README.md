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

Current starting combat values:

- **1 Damage**
- **1.0 attacks/sec**
- **800 Arrow Speed**
- **1000 Range**
- **5% Critical Chance**
- **2.0x Critical Damage**

The current implementation supports mouse aiming and automatic arrow firing.

Critical hits are active. Each arrow rolls against the archer's Critical Hit Chance and deals the configured Critical Hit Damage multiplier when successful.

---

# 💰 Current Progression

The first progression layer is now fully implemented.

## First Passive

After the player has earned **6 total coins**, the first passive automatically unlocks:

**Sharpened Arrows: +1 Attack Damage**

This is intentionally simple. It gives the player an immediate progression milestone without introducing a large skill tree.

## Purchasable Upgrades

The complete basic upgrade layer currently includes:

| Upgrade | Effect | Cost |
|---|---:|---:|
| Damage | +1 Damage | 1 coin |
| Attack Speed | +0.1 attacks/sec | 2 coins |
| Critical Chance | +5% critical chance | 3 coins |
| Critical Damage | +0.5x critical multiplier | 4 coins |
| Arrow Speed | +100 arrow speed | 5 coins |
| Range | +100 range | 6 coins |
| Castle Health | +25 max health and +25 current health | 7 coins |

With the starting damage of **1**, the Damage upgrade represents a full **100% increase** to base damage. The first passive then adds another +1 damage.

Critical Chance starts at **5%**, so the first Critical Chance purchase raises it to **10%**. Critical hits currently use the player's **2.0x Critical Damage** multiplier.

The Critical Damage upgrade raises the multiplier by **0.5x**, taking it from 2.0x to 2.5x per purchase.

The Arrow Speed upgrade increases projectile speed by **100**, making arrows reach their targets faster without changing damage or attack rate.

The Range upgrade increases the player's actual firing range by **100** per purchase.

The Castle Health upgrade increases both maximum and current castle health by **25**, so buying it immediately provides the extra survivability rather than leaving the new health capacity empty.

The current upgrade costs use a simple fixed progression. The basic set has now been played and is considered reasonably balanced for the current development pass. More detailed cost scaling will only be added if testing shows that fixed costs stop producing meaningful choices.

---

# 🌊 Enemy Waves

The wave system is currently playable and considered stable enough to move forward.

Current wave behavior:

- Wave 1 starts with **5 enemies**.
- Enemy count increases by **1 per wave**.
- Enemy health starts at **3 HP**.
- Enemy health increases by **15% per wave** relative to the starting enemy health.
- A **2 second** break occurs between cleared waves.
- Enemies spawn from both sides of the castle.
- Enemy kills award **1 coin** by default.
- Killing enemies progresses the current wave.
- The next wave starts automatically.
- Castle destruction ends the run.
- Every **10th wave** also contains a Mini Boss.

The **1 Damage vs 3 HP** starting balance is intentional. The player needs several hits to kill a basic enemy, while every +1 Damage upgrade has a clearly noticeable effect.

These values are development values and can still be adjusted as bosses, skills, and automation are introduced.

---

# 💥 Combat Feedback

Basic combat feedback is implemented.

- Enemies flash when hit.
- Enemies shrink and fade when killed.
- Wave status communicates incoming and cleared waves.
- Mini Boss waves announce themselves.
- Mini Boss health is displayed while active.
- Mini Boss defeat displays a reward message.
- Passive unlocks display a clear message.
- Damage upgrades display a clear confirmation.
- Attack Speed upgrades display a clear confirmation.
- Critical Chance upgrades display a clear confirmation.
- Critical Damage upgrades display a clear confirmation.
- Arrow Speed upgrades display a clear confirmation.
- Range upgrades display a clear confirmation.
- Castle Health upgrades display a clear confirmation.

More polished effects can be added later without changing the underlying combat architecture.

---

# 👹 Bosses

Bosses are progression events rather than ordinary enemies with huge health pools.

## Mini Bosses

The first Mini Boss system is now implemented.

- Appears every **10 waves**.
- Spawns alongside that wave's normal enemies.
- Uses the existing Enemy framework rather than a separate boss framework.
- Has **10x the normal enemy health** for that wave.
- Moves at **45 speed**, making it slower and more threatening as it approaches.
- Deals **25 castle damage** if it reaches the castle.
- Awards **10 coins** when killed.
- Appears at **1.6x scale** so it is visually distinct.
- Has a dedicated health display in the UI.

The Mini Boss is deliberately simple for the first implementation. Its main purpose is to create a noticeable wave event and give the player a high-value target without introducing a second combat system.

## Major Bosses

Every **50 waves**.

Major Bosses are not implemented yet.

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
- Maximum Health upgrades

The current development test value is **100 HP**.

The current Castle Health upgrade costs **7 coins** and adds **25 maximum health plus 25 current health** each time it is purchased.

Planned additional castle upgrades include:

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
- Coins can be spent on Damage, Attack Speed, Critical Chance, Critical Damage, Arrow Speed, Range, and Castle Health upgrades.
- Mini Bosses award **10 coins**.
- The first passive unlocks at 6 total coins earned.

The economy should remain understandable. Avoid adding currencies or complicated scaling unless they genuinely improve progression.

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

Detailed balance tuning will continue as later systems are introduced.

---

## 💰 Milestone 3 - Upgrades

**Status: Basic upgrade set complete**

### Completed

- [x] Build initial upgrade system
- [x] Add Damage upgrade
- [x] Add Attack Speed upgrade
- [x] Add Critical Chance upgrade
- [x] Add Critical Damage upgrade
- [x] Add Arrow Speed upgrade
- [x] Add Range upgrade
- [x] Add Castle Health upgrade
- [x] Add first passive unlock
- [x] First passive: **+1 Attack Damage**
- [x] Activate Critical Hit Chance in combat
- [x] Rebalance starting player damage to **1**
- [x] Rebalance starting enemy health to **3**
- [x] Add basic upgrade feedback

### Remaining polish

- [ ] Display broader upgrade progression
- [ ] Improve progression feedback
- [ ] Revisit cost scaling if future systems require it
- [ ] Rebalance values only when later systems expose problems

The complete basic upgrade set is now implemented and is considered reasonably balanced for the current development pass. We can now move to the next major progression system without adding unnecessary complexity to Milestone 3.

---

## 👹 Milestone 4 - Bosses

**Status: In progress, first Mini Boss implemented**

### Completed

- [x] Add Mini Boss system
- [x] Spawn Mini Boss every 10 waves
- [x] Add Mini Boss health display
- [x] Add Mini Boss rewards
- [x] Reuse the existing Enemy framework
- [x] Add basic Mini Boss visual distinction

### Remaining

- [ ] Add stronger boss entrance/death feedback
- [ ] Add at least one unique boss mechanic
- [ ] Add Major Boss system
- [ ] Spawn Major Boss every 50 waves
- [ ] Add Major Boss health bars
- [ ] Add Major Boss rewards

The first Mini Boss is intentionally simple. The next boss work should focus on making the event feel distinct rather than immediately adding many boss types.

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

### Completed Foundation / Combat / Waves / Upgrades

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
- [x] Damage upgrade
- [x] Attack Speed upgrade
- [x] Critical Chance upgrade
- [x] Critical Damage upgrade
- [x] Arrow Speed upgrade
- [x] Range upgrade
- [x] Castle Health upgrade
- [x] Critical hit calculation
- [x] Rebalanced starting damage and enemy health
- [x] Removed obsolete Milestone 1 test scene

### Next Focus

**Milestone 4: Mini Boss polish**

- [ ] Add stronger Mini Boss entrance/death feedback
- [ ] Add one unique Mini Boss mechanic
- [ ] Verify the Mini Boss feels like an event rather than just a large enemy

### Later

- [ ] Major Bosses
- [ ] Active skills
- [ ] Auto Aim
- [ ] Additional archers
- [ ] Persistence
- [ ] Final polish
- [ ] Release

**Do not build prestige, complex meta-progression, large skill trees, or complicated economy systems yet.**

The immediate goal is to make the first boss encounter feel meaningful while keeping the existing combat and progression systems intact.

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
