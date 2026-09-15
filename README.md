# 🏰 Castle Archer

> **A simple incremental castle-defense game where you shoot enemies, earn coins, upgrade your archer, and survive increasingly ridiculous waves.**

Castle Archer is a small **2D Godot game written in GDScript**, designed specifically to be achievable as a polished indie/browser game for **Kongregate and itch.io**.

You are the castle's archer.

Enemies are coming.

Shoot them.

Earn coins.

Buy upgrades.

Eventually recruit more archers, unlock Auto Aim, and turn one lonely defender into an increasingly absurd castle-defense machine.

The design goal is deliberately simple: **make a small game that is fun, understandable, and actually finishable.**

---

## 🎯 Core Gameplay Loop

```text
        Enemy Wave
            ↓
       Shoot Enemies
            ↓
        Earn Coins
            ↓
       Buy Upgrades
            ↓
         Next Wave
            ↓
       Every 10 Waves
            ↓
         Mini Boss
            ↓
       Every 50 Waves
            ↓
        Major Boss
            ↓
       Keep Going...
```

The player should understand the game within seconds:

**Shoot → Earn → Upgrade → Survive → Repeat.**

Everything else exists to make that loop more satisfying.

---

# 🏹 The Archer

The player begins with a single archer.

Early gameplay is active. The player aims and fires arrows at incoming enemies.

The archer can be upgraded through several simple statistics:

- Damage
- Attack Speed
- Arrow Speed
- Range
- Critical Hit Chance
- Critical Hit Damage

The player should always feel that their archer is becoming more powerful.

---

# 🎯 Skills

Skills provide powerful active abilities with cooldowns or other limitations.

Initial skill ideas:

### Power Shot

Fires a significantly stronger arrow.

### Multi Shot

Fires several arrows at once.

### Piercing Arrow

The arrow passes through multiple enemies.

### Explosive Arrow

The arrow explodes on impact and damages nearby enemies.

### Rapid Fire

Temporarily increases attack speed.

### Rain of Arrows

Fires a large number of arrows across an area.

Additional skills can be added later if the core game needs them.

---

# 🤖 Automation

The game should begin as an active aiming game and gradually become more automated.

## Auto Aim

Auto Aim eventually allows the archer to automatically target enemies.

Possible Auto Aim upgrades can improve:

- Target selection
- Targeting speed
- Accuracy
- Target priority
- Range

Automation should feel like a major progression milestone rather than simply another percentage upgrade.

---

# 🏹🏹 Additional Archers

Players can eventually recruit additional archers.

Each additional archer contributes damage to the castle defense.

For example:

```text
Archer 1
Archer 2
Archer 3
Archer 4
Archer 5
...
```

Additional archers can have their own upgrades or share global upgrades, depending on what produces the better gameplay experience.

The long-term fantasy is simple: start as one archer and eventually command an entire defensive force.

---

# 👹 Enemy Waves

Enemies arrive in waves and become progressively stronger.

Difficulty can increase through:

- Enemy Health
- Enemy Damage
- Enemy Movement Speed
- Enemy Quantity
- Enemy Armor
- Special Abilities

Initial enemy concepts:

### Goblin

Basic enemy with low health and damage.

### Orc

Slow but durable.

### Archer

Attacks the castle from range.

### Knight

High health and armor.

### Berserker

Fast enemy with high damage.

### Siege Enemy

Slow enemy designed to deal heavy damage to the castle.

New enemy types should be introduced gradually rather than dumping a zoo on the player immediately.

---

# 👹 Mini Bosses

Every **10 waves** contains a Mini Boss.

```text
Wave 10  → Mini Boss
Wave 20  → Mini Boss
Wave 30  → Mini Boss
Wave 40  → Mini Boss
Wave 50  → Major Boss
```

Mini Bosses should be noticeably stronger than normal enemies and can have:

- Increased health
- Increased damage
- Special abilities
- Unique appearances
- Larger rewards

Boss encounters should feel like meaningful milestones in the run.

---

# 💀 Major Bosses

Every **50 waves**, a Major Boss appears.

```text
Wave 50   → Major Boss
Wave 100  → Major Boss
Wave 150  → Major Boss
Wave 200  → Major Boss
...
```

Major Bosses should be substantially stronger than Mini Bosses.

Possible mechanics include:

- Multiple phases
- Special attacks
- Enemy summoning
- Temporary shields
- Regeneration
- Enrage mechanics

Defeating a Major Boss should provide a substantial reward and clearly mark progression.

---

# 🏰 Castle Defense

The castle is the player's main objective.

Enemies must be stopped before they reach the walls.

If enemies reach the castle, they deal damage.

If castle health reaches zero, the current run ends.

Initial castle upgrades can include:

- Maximum Health
- Armor
- Health Regeneration
- Damage Reduction
- Starting Health

The castle should remain visually simple and readable. The combat should be the star of the show.

---

# 💰 Coins

Coins are the primary currency.

Players earn coins by defeating enemies and completing waves.

Coins are spent on upgrades such as:

- Archer Damage
- Attack Speed
- Critical Chance
- Critical Damage
- Arrow Speed
- Range
- Castle Health
- Castle Defense
- Skills
- Additional Archers
- Automation

The economy should remain easy to understand:

> **Kill enemies → earn coins → buy upgrades → kill stronger enemies.**

Cost scaling should be added only where it improves progression. There should be no arbitrary complexity for the sake of having more numbers.

---

# ☠️ Defeat

If the castle's health reaches zero, the player loses the current run.

The exact long-term reset/prestige system is intentionally undecided.

Potential future systems include:

- Permanent upgrades
- Prestige
- Hero levels
- Relics
- Achievements
- Long-term progression

These should **not** be implemented until the core wave loop is fun.

---

# 🏆 Achievements

Achievements can reward progression milestones.

Possible achievements:

- Reach Wave 10
- Reach Wave 50
- Reach Wave 100
- Defeat your first Mini Boss
- Defeat your first Major Boss
- Unlock Auto Aim
- Recruit 5 Archers
- Fire 10,000 arrows
- Defeat 1,000 enemies
- Land a huge critical hit

Achievements are secondary to the core gameplay.

---

# 🎨 Art Direction

The visual style should be simple, readable, and achievable for a small project.

The screen should clearly communicate:

- Castle
- Archer
- Incoming enemies
- Arrows
- Enemy health
- Current wave
- Coins
- Skills
- Upgrades
- Castle health

Useful combat effects include:

- Arrow trails
- Hit effects
- Critical hit effects
- Enemy death effects
- Boss entrances
- Boss attacks
- Skill effects
- Coin feedback

Prioritize **clarity, responsiveness, and satisfying feedback over graphical complexity**.

---

# 🖥️ Target Platforms

Initial targets:

- **Kongregate**
- **itch.io**

The game should be browser-friendly and perform well on modest hardware.

Input should primarily support:

- Mouse
- Keyboard where useful

The interface should remain usable at common browser resolutions.

---

# 🚀 DEVELOPMENT ROADMAP

Development should remain deliberately small and sequential.

## 🏁 Milestone 0 - Foundation

**Goal:** Establish a clean Godot project and the minimum architecture required to build the game.

- [ ] Confirm Godot project opens and runs
- [ ] Establish main scene
- [ ] Establish basic game controller/state
- [ ] Establish simple folder/script structure
- [ ] Create basic UI layout
- [ ] Create game loop/tick where required
- [ ] Establish save/load foundation
- [ ] Confirm clean project startup

**Milestone complete when:** The project runs cleanly and provides a stable foundation for combat.

---

## 🏹 Milestone 1 - First Arrow

**Goal:** Make shooting an enemy fun.

- [ ] Create castle
- [ ] Create player archer
- [ ] Implement mouse aiming
- [ ] Implement arrow firing
- [ ] Implement arrow movement
- [ ] Create first enemy
- [ ] Implement enemy health
- [ ] Implement enemy movement toward castle
- [ ] Implement enemy death
- [ ] Implement castle health
- [ ] Implement enemy damage to castle
- [ ] Add basic hit/death feedback

**Milestone complete when:** A player can open the game, aim at an enemy, shoot it, kill it, and understand the objective immediately.

---

## 🌊 Milestone 2 - Waves

**Goal:** Turn individual enemies into an actual game loop.

- [ ] Implement wave system
- [ ] Spawn multiple enemies per wave
- [ ] Complete waves when all enemies are defeated
- [ ] Increase enemy difficulty between waves
- [ ] Add wave display
- [ ] Add wave completion feedback
- [ ] Add coin rewards
- [ ] Start the next wave
- [ ] Handle defeat when castle health reaches zero

**Milestone complete when:** The player can survive multiple waves and clearly understands that each wave is harder than the last.

---

## 💰 Milestone 3 - Upgrades

**Goal:** Establish satisfying progression.

- [ ] Create coin currency
- [ ] Create upgrade system
- [ ] Add Damage upgrade
- [ ] Add Attack Speed upgrade
- [ ] Add Critical Chance upgrade
- [ ] Add Critical Damage upgrade
- [ ] Add Arrow Speed upgrade
- [ ] Add Range upgrade
- [ ] Add Castle Health upgrade
- [ ] Display upgrade costs
- [ ] Implement upgrade cost scaling
- [ ] Add clear upgrade feedback

**Milestone complete when:** Players have a reason to spend their coins and can immediately feel the effect of upgrades.

---

## 👹 Milestone 4 - Bosses

**Goal:** Add major wave milestones.

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

**Milestone complete when:** Wave 10 and Wave 50 feel like genuine events rather than ordinary waves with more health.

---

## ⚡ Milestone 5 - Skills

**Goal:** Give the player active combat tools beyond ordinary arrows.

- [ ] Create skill system
- [ ] Create cooldown system
- [ ] Add Power Shot
- [ ] Add Multi Shot
- [ ] Add Piercing Arrow
- [ ] Add Explosive Arrow
- [ ] Add Rapid Fire
- [ ] Add Rain of Arrows
- [ ] Add skill UI
- [ ] Add skill feedback

**Milestone complete when:** Using a skill at the right moment feels powerful and useful.

---

## 🤖 Milestone 6 - Automation

**Goal:** Introduce the incremental/idle side of the game.

- [ ] Add Auto Aim unlock
- [ ] Implement automatic target selection
- [ ] Add target priority rules
- [ ] Add automatic firing
- [ ] Add Auto Aim upgrades
- [ ] Add additional archers
- [ ] Add archer recruitment costs
- [ ] Add archer upgrades
- [ ] Balance active and automated play

**Milestone complete when:** The player can transition naturally from active aiming into automated castle defense.

---

## 💾 Milestone 7 - Persistence & Polish

**Goal:** Make the game feel like a finished small game.

- [ ] Add reliable save system
- [ ] Add settings
- [ ] Add sound effects
- [ ] Add music
- [ ] Improve combat animations
- [ ] Improve UI feedback
- [ ] Add achievements
- [ ] Add basic menus
- [ ] Add pause functionality where appropriate
- [ ] Test browser resolutions
- [ ] Test performance
- [ ] Fix gameplay bugs
- [ ] Balance progression

**Milestone complete when:** The game feels polished enough to hand to someone who has never seen the project before.

---

## 🌐 Milestone 8 - Release

**Goal:** Publish the game.

- [ ] Final gameplay balance
- [ ] Final UI pass
- [ ] Final audio pass
- [ ] Browser testing
- [ ] Kongregate build
- [ ] itch.io build
- [ ] Create store/page artwork
- [ ] Write game description
- [ ] Create screenshots
- [ ] Create short gameplay video/GIF
- [ ] Publish
- [ ] Collect player feedback
- [ ] Fix critical launch issues

**Milestone complete when:** The game is publicly playable and stable on the target platforms.

---

# 📋 IMMEDIATE TASK LIST

Work on these tasks **now** and ignore later systems until they are needed.

### First Build

- [ ] Confirm Godot project runs
- [ ] Create main 2D scene
- [ ] Create castle
- [ ] Create archer
- [ ] Create first enemy
- [ ] Add enemy movement
- [ ] Add mouse aiming
- [ ] Add arrow firing
- [ ] Add arrow collision
- [ ] Add enemy health
- [ ] Add enemy death
- [ ] Add castle health
- [ ] Add basic combat UI

### Then

- [ ] Add waves
- [ ] Add coins
- [ ] Add upgrades
- [ ] Add Mini Bosses
- [ ] Add Major Bosses
- [ ] Add skills
- [ ] Add Auto Aim
- [ ] Add additional archers

**Do not build prestige, complex meta-progression, large skill trees, or complicated economy systems yet.**

The first goal is to prove that **shooting enemies and surviving waves is fun**.

---

# 🧭 Design Rules

## 1. Keep It Small

This is intentionally a small game.

Do not turn it into an RPG, city builder, tower-defense spreadsheet, or MMORPG wearing a castle hat.

If a feature does not make the core loop better, it probably does not belong in the first release.

## 2. Make Every Upgrade Feel Useful

Players should understand what an upgrade does and feel its impact.

Avoid meaningless +0.3% bonuses unless they serve a clear progression purpose.

## 3. Bosses Must Be Events

A boss should change the player's behaviour or require a meaningful response.

Simply giving an enemy 100x health is not a boss mechanic.

## 4. Automation Is Progression

Auto Aim and additional archers should feel like major achievements.

The player starts actively defending one castle wall and gradually builds a self-sustaining defensive machine.

## 5. Do Not Build Complexity Before Fun

The development order is:

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

Only after the core game works should additional systems be considered.

---

# ⭐ The Goal

The first version should be a small, polished game that can be understood almost immediately.

A player opens the game.

They see enemies approaching.

They shoot.

They earn coins.

They buy an upgrade.

They survive the next wave.

Then Wave 10 arrives.

**Boss.**

They survive.

The numbers get bigger.

They unlock Auto Aim.

Then another archer.

Then another.

Eventually the screen becomes an increasingly ridiculous storm of arrows, enemies, explosions, critical hits, and boss health bars.

That is the game.

**Shoot. Earn. Upgrade. Defend. Repeat.**

---

# 📌 Current Project Status

**Planning reset complete. Ready to begin implementation.**

The previous game concept has been discarded.

The README is now the primary design document and source of truth for the new project.

The next development target is **Milestone 0 - Foundation**, followed immediately by **Milestone 1 - First Arrow**.

The project should remain focused on producing a small, playable, publishable game rather than expanding into an unnecessarily large system.
