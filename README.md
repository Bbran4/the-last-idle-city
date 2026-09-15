# 🏰 Castle Archer

> **A simple incremental castle-defense game where you shoot enemies, earn coins, upgrade your archer, and survive increasingly ridiculous waves.**

Castle Archer is a small 2D Godot game written in GDScript, designed for a polished browser/indie release on Kongregate and itch.io.

The core loop is deliberately simple:

**Shoot → Earn → Upgrade → Survive → Repeat.**

The goal is to keep the project small, readable, fun, and actually finishable.

---

# 🎯 Current Gameplay

```text
        Enemies →     🏰 Castle + Archer     ← Enemies
                              CENTER
```

- Castle sits in the center.
- Player archer is positioned at the castle.
- Enemies spawn from both sides and run along the ground toward the tower.
- Player aims with the mouse and automatically fires during active waves.
- The mouse determines the firing direction, while the target point is clamped to the archer's current maximum range.
- The archer fires even when no enemy is currently in range.
- Shots use up to **2.5° of random aim variance** while preserving the range limit.
- Arrow targets can never be farther away than the archer's current range.
- Arrows travel in a ballistic arc and fall toward the battlefield instead of moving in a straight line.
- Enemy kills award coins.
- Enemies reaching the castle deal damage.
- Castle reaching 0 HP ends the run.

Current starting combat values:

- **1 Damage**
- **1.0 attacks/sec**
- **800 Arrow Speed**
- **1000 Range**
- **5% Critical Chance**
- **2.0x Critical Damage**

Critical hits are active.

---

# 💰 Progression

The first progression layer is implemented.

## First Passive

After **6 total coins earned**:

**Sharpened Arrows: +1 Attack Damage**

## Purchasable Upgrades

| Upgrade | Effect | Cost |
|---|---:|---:|
| Damage | +1 Damage | 1 coin |
| Attack Speed | +0.1 attacks/sec | 2 coins |
| Critical Chance | +5% | 3 coins |
| Critical Damage | +0.5x | 4 coins |
| Arrow Speed | +100 | 5 coins |
| Range | +100 | 6 coins |
| Castle Health | +25 max/current HP | 7 coins |

Upgrades are available during the **5 second intermission between waves** and are hidden while a wave is active.

The current fixed costs are intentionally simple and are considered reasonably balanced for this development pass.

---

# 🌊 Waves

- Wave 1 starts with **5 enemies**.
- Enemy count increases by **1 per wave**.
- Enemy health starts at **3 HP**.
- Enemy health increases by **15% per wave**.
- A **5 second** intermission occurs between waves.
- During the intermission, enemy spawning is stopped, archer firing is halted, and the upgrade controls become available.
- Enemies spawn from both sides.
- Normal enemies award **1 coin**.
- Every **5th wave** contains a Mini Boss unless it is also a Major Boss wave.
- Every **10th wave** contains a Major Boss instead of a Mini Boss.
- Castle destruction ends the run.

The starting **1 Damage vs 3 HP** balance is intentional. Damage upgrades therefore create clear combat breakpoints.

---

# 🏹 Projectile & Movement Feel

- Arrows are fired using an initial ballistic velocity.
- Arrow trajectories form visible arcs instead of straight-line projectiles.
- Gravity continuously pulls arrows downward during flight.
- Arrows rotate to follow their current flight direction.
- Arrows expire when they hit the battlefield ground or exceed their flight-time limit.
- Enemies spawn on the tower's ground line.
- Enemies move horizontally toward the castle's ground position.
- The castle exposes a shared ground position so enemies and arrows can use the same battlefield reference.
- The archer fires continuously during active waves.
- The mouse controls the firing direction, but the target point is clamped to the archer's maximum range.
- Aim variance is applied after range clamping, keeping the firing distance bounded.
- Range upgrades directly increase how far the archer can send an arrow.

This keeps the combat readable while making the battlefield feel more like a lane defense game.

---

# ❤️ Enemy Health Bars

Enemy health bars are implemented for **all enemies and bosses**.

- Health bars are hidden by default.
- The first time an enemy takes damage, its health bar appears.
- The bar updates as the enemy takes additional damage.
- The bar remains visible for that enemy after it has been revealed.
- Health bars disappear when the enemy dies.
- Mini Bosses and Major Bosses use the same system automatically.

---

# 💥 Combat Feedback

Current feedback includes:

- Enemy health bars appear after the first hit.
- Enemies flash when hit.
- Enemies shrink and fade when killed.
- Bosses use stronger entrance and death animations.
- Wave status communicates incoming and cleared waves.
- Mini Boss and Major Boss waves announce themselves.
- Active boss health is displayed while a boss is alive.
- Boss enrage displays a warning.
- Major Boss shields display their remaining shield in the boss UI.
- Major Boss shields display as a pulsing blue circular glow around the boss.
- Upgrade purchases display confirmation.
- Passive unlocks display confirmation.
- Skill card choices appear during the appropriate intermission.
- Skill acquisition is confirmed in the wave status UI.
- Power Shot and Multi Shot activation/cooldown states are displayed in the UI.

---

# 👹 Bosses

Bosses are progression events rather than ordinary enemies with huge health pools.

## Mini Bosses

- Appear every **5 waves** except on Major Boss waves.
- Spawn alongside normal enemies.
- Have **10x normal enemy health** for that wave.
- Move at **45 speed** before enraging.
- Deal **25 castle damage** before enraging.
- Award **10 coins** when killed.
- Appear at **1.6x scale**.
- Enter with a scale-up and fade-in animation.
- Have a stronger death animation than normal enemies.
- Have the normal enemy health bar plus a dedicated UI health display.

### Mini Boss Enrage

At **50% health**:

- Movement speed increases from **45 to 80**.
- Castle damage increases from **25 to 35**.
- The boss pulses and changes appearance.
- The UI announces the enrage state.

## Major Bosses

- Appear every **10 waves**.
- Replace the Mini Boss on those waves.
- Have **20x normal enemy health** for that wave.
- Award **25 coins** when killed.
- Move at **40 speed** before enraging.
- Deal **40 castle damage** before enraging.
- Appear at **2.2x scale**.
- Have distinct entrance and death feedback.
- Use the dedicated boss health UI.

### Major Boss Enrage & Shield

At **50% health**, a Major Boss enters its special second phase:

- Movement speed changes to **70**.
- Castle damage increases to **60**.
- A shield activates with **25% of the boss's maximum health** as shield strength.
- Incoming damage is absorbed by the shield before it reaches boss health.
- The UI displays the remaining shield value.
- The UI announces the shield phase.
- The shield appears as a **pulsing blue circular glow** around the Major Boss.
- Once the shield is broken, the UI announces the enraged state and the boss remains in its stronger combat state.
- The phase happens once per boss.

The current boss values are considered balanced for this development pass. Further tuning can wait until broader progression is implemented.

---

# 🎯 Skills

Skills are implemented as **card choices** rather than a traditional RPG skill tree.

- After every **5 completed waves**, the player receives up to **3 skill cards** during the between-wave intermission.
- The cards are selected from skills the player does not already own.
- The player chooses one card to add that skill to their owned skill list.
- Duplicate skills are not offered.
- Major Boss waves do not trigger a second skill choice because they occur on the same 10-wave cadence.

## Active Skills

### Power Shot

Implemented as the first active skill.

- Activated manually from the UI during an active wave.
- Arms the next arrow.
- The next arrow deals **3x damage**.
- Critical hit calculation still applies.
- Has a **10 second cooldown**.
- Cannot be activated during intermission.
- The UI shows Ready, Armed, and cooldown states.

### Multi Shot

Implemented as the second active skill.

- Activated manually from the UI during an active wave.
- Arms the next attack.
- The next attack fires **3 arrows**.
- Arrows are spread across a **20° total firing arc**.
- Each arrow uses the normal damage and critical-hit rules.
- Has a **12 second cooldown**.
- Cannot be activated during intermission.
- The UI shows Ready, Armed, and cooldown states.

Planned remaining active skills:

- Piercing Arrow
- Explosive Arrow
- Rapid Fire
- Rain of Arrows

Skills remain intentionally smaller than a traditional RPG skill tree.

---

# 🤖 Automation

Planned progression includes:

- Auto Aim
- Automatic target selection
- Target priority
- Automatic firing
- Auto Aim upgrades
- Additional archers
- Archer recruitment
- Archer upgrades

Automation should feel like a major progression milestone rather than another small percentage bonus.

---

# 🏰 Castle Defense

Current castle systems:

- Health
- Armor support
- Health regeneration support
- Damage handling
- Destruction/game-over state
- Maximum Health upgrades
- Shared ground position for battlefield movement

Current development castle health is **100 HP**.

Planned upgrades include Armor, Health Regeneration, Damage Reduction, and Starting Health.

---

# 💵 Economy

Coins are the primary currency.

Currently:

- Enemies award coins when killed.
- Current coins are displayed.
- Total coins earned are tracked for progression unlocks.
- Coins buy the current upgrades.
- Mini Bosses award **10 coins**.
- Major Bosses award **25 coins**.

Avoid adding currencies or complicated scaling unless they genuinely improve progression.

---

# 🚀 DEVELOPMENT ROADMAP

## 🏁 Milestone 0 - Foundation

**Status: Mostly complete**

- [x] Main scene
- [x] Game state/controller
- [x] Folder/script structure
- [x] Basic UI
- [x] Clean startup
- [ ] Save/load foundation

## 🏹 Milestone 1 - First Arrow

**Status: Complete**

- [x] Castle
- [x] Player archer
- [x] Mouse aiming
- [x] Ballistic arrow firing/movement
- [x] Ground-based enemy movement
- [x] Enemy health/movement/death
- [x] Castle damage
- [x] Basic hit/death feedback
- [x] Range-clamped automatic firing

## 🌊 Milestone 2 - Waves

**Status: Complete for the current development pass**

- [x] Wave manager
- [x] Multiple enemies
- [x] Both spawn sides
- [x] Ground-line spawning
- [x] Wave completion
- [x] Enemy count scaling
- [x] Enemy health scaling
- [x] Wave UI
- [x] Coin rewards
- [x] Automatic next waves
- [x] Five-second between-wave intermission
- [x] Archer firing halted during intermission
- [x] Upgrade controls available only during intermission
- [x] Game over on castle destruction
- [x] Mini Boss every 5 waves
- [x] Major Boss every 10 waves

## 💰 Milestone 3 - Upgrades

**Status: Basic upgrade set complete**

- [x] Damage
- [x] Attack Speed
- [x] Critical Chance
- [x] Critical Damage
- [x] Arrow Speed
- [x] Range
- [x] Castle Health
- [x] First passive
- [x] Critical hit calculation
- [x] Basic upgrade feedback
- [x] Upgrades hidden during active waves
- [x] Upgrades available during intermission

Remaining polish can wait until later systems expose actual problems.

## 👹 Milestone 4 - Bosses

**Status: Complete for the current development pass**

- [x] Mini Boss every 5 waves
- [x] Major Boss every 10 waves
- [x] Mini Boss rewards
- [x] Major Boss rewards
- [x] Boss health display
- [x] Existing Enemy framework reused
- [x] Visual distinction between boss tiers
- [x] Enrage phase at 50% health
- [x] Mini Boss enrage speed/damage increase
- [x] Major Boss enrage behavior
- [x] Major Boss shield phase
- [x] Enrage UI feedback
- [x] Major Boss shield UI feedback
- [x] Major Boss blue shield glow
- [x] Enemy/boss health bars that appear after first damage
- [x] Stronger boss entrance feedback
- [x] Stronger boss death feedback
- [x] Initial balance pass

## ⚡ Milestone 5 - Skills

**Status: In progress**

- [x] Skill card selection after every 5 waves
- [x] Skill ownership/state
- [x] Basic skill card UI/feedback
- [x] Active skill system
- [x] Cooldowns
- [x] Power Shot
- [x] Multi Shot
- [ ] Piercing Arrow
- [ ] Explosive Arrow
- [ ] Rapid Fire
- [ ] Rain of Arrows

The first two active skills are intentionally small and manually activated. Each skill is being implemented and verified independently before moving to the next one.

## 🤖 Milestone 6 - Automation

**Status: Not started**

- [ ] Auto Aim
- [ ] Automatic targeting
- [ ] Target priority
- [ ] Automatic firing
- [ ] Auto Aim upgrades
- [ ] Additional archers
- [ ] Archer recruitment/upgrades

## 💾 Milestone 7 - Persistence & Polish

**Status: Not started**

- [ ] Save system
- [ ] Settings
- [ ] Audio
- [ ] Better animations
- [ ] UI polish
- [ ] Achievements
- [ ] Menus
- [ ] Pause
- [ ] Browser resolution testing
- [ ] Performance testing
- [ ] Final balancing

## 🌐 Milestone 8 - Release

**Status: Not started**

- [ ] Final balance
- [ ] Final UI/audio pass
- [ ] Browser testing
- [ ] Kongregate build
- [ ] itch.io build
- [ ] Store artwork/description
- [ ] Screenshots
- [ ] Gameplay video/GIF
- [ ] Publish

---

# 📋 IMMEDIATE TASK LIST

Work on one system at a time.

### Current Focus

**Milestone 5: Active skills**

- [x] Skill-card selection UI
- [x] Skill ownership/state
- [x] Active skill framework
- [x] Cooldown handling
- [x] Power Shot
- [x] Multi Shot
- [ ] Piercing Arrow
- [ ] Explosive Arrow
- [ ] Rapid Fire
- [ ] Rain of Arrows

### Later

- [ ] Auto Aim
- [ ] Additional archers
- [ ] Persistence
- [ ] Final polish
- [ ] Release

**Do not build prestige, complex meta-progression, large skill trees, or complicated economy systems yet.**

---

# 🧭 Design Rules

1. **Keep It Small.**
2. **Make Every Upgrade Feel Useful.**
3. **Bosses Must Be Events.** More health alone is not enough.
4. **Automation Is Progression.**
5. **Do Not Build Complexity Before Fun.**

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

---

# ⭐ The Goal

A player should immediately understand:

**Shoot. Earn. Upgrade. Defend. Repeat.**

Start with one archer, survive increasingly dangerous waves, and gradually build toward automation, skills, and a polished small-scale incremental game.
