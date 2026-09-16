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

# 🛠️ Development Goals

The project will be developed in small milestones.

Each milestone should result in a playable improvement rather than building large amounts of invisible infrastructure.

The initial development focus should be:

1. Basic archer scene
2. Bow drawing mechanic
3. Mouse-controlled firing
4. Arrow physics
5. Target collision
6. Bullseye detection
7. Strength progression
8. Accuracy progression
9. Basic aim assistance
10. Money system
11. Bow upgrades
12. Additional practice targets
13. Basic tournament system
14. Tournament rewards
15. Progression balancing
16. Polish and presentation

---

# 🎯 Initial MVP

The first playable version should contain only the essentials:

* One archer
* One bow
* One target
* Mouse-controlled drawing
* Arrow physics
* Target collision
* Bullseye detection
* Strength progression
* Accuracy progression
* Basic visual feedback

If this is fun, everything else can be built on top of it.

---

# 📌 Project Status

**Current Stage:** Concept / Pre-Production

The game concept has been redesigned around **active archery gameplay and tournament progression**.

No major gameplay systems should be considered final until the basic shooting mechanic has been implemented and tested.

The most important question at this stage is simple:

> **Is firing an arrow fun?**

If the answer is yes, we build the tournament around it.
