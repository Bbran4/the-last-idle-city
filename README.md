# ⚙️ THE LAST CITY

> **An idle civilization builder where exponential economic growth creates social and political problems that the player must solve, exploit, or suppress.**

The Last City is a **2D Godot game written in GDScript**. It takes the satisfying progression of games like AdVenture Capitalist, Underworld Idle, Idle Research, and Unnamed Space Idle, then adds a civilization layer where economic growth creates social and political consequences.

Start with a single Scrap Yard.

Build it up.

Grow the workforce.

Turn ruins into Materials.

Build an increasingly absurd industrial machine.

Then discover that running a civilization is considerably harder than making the numbers bigger.

---

## 🎯 Current Project Status

**Design phase complete enough to begin prototyping. Implementation is now underway.**

The core systems and design direction are documented below. Exact formulas, costs, balance values, UI polish, and later-game systems will be refined during implementation and playtesting.

**Engine:** Godot  
**Language:** GDScript  
**Presentation:** 2D  
**Current priority:** Build the smallest fun playable idle loop before expanding the civilization systems.

---

# 🚀 DEVELOPMENT ROADMAP

This section intentionally lives near the top of the README so it can be used as the project's working checklist without scrolling through the full design document.

## 🏁 Milestone 0 - Project Foundation

**Goal:** A clean Godot project with the architecture needed to build the game without creating technical debt immediately.

- [x] Establish the main scene and application structure
- [x] Create a basic 2D UI layout
- [x] Establish a reusable resource/data model
- [x] Create a central game state/autoload
- [x] Create a basic game clock/tick system
- [x] Add save/load support
- [x] Add basic number formatting for large idle-game values
- [x] Establish a simple folder/script naming convention
- [x] Confirm the project runs cleanly in a fresh Godot session

**Milestone complete when:** The project can start, maintain game state, tick reliably, save, load, and display a basic UI.

---

## ⛏️ Milestone 1 - The First Scrap Yard

**Goal:** Prove that the basic idle loop is fun.

- [x] Create the Scrap Yard production model
- [x] Add Materials as the first resource
- [x] Add Scrap Yard production per second
- [x] Add **Level Up** button
- [x] Make Level Up increase Scrap Yard productivity
- [x] Add production cost scaling
- [x] Add a manual production/click action
- [x] Make clicking contribute to Scrap Yard productivity
- [x] Add basic production display
- [x] Add basic cost display
- [x] Add a simple feedback animation when production occurs

**Milestone complete when:** The player can start with one Scrap Yard, click it, level it up, watch Materials increase, and immediately understand what to do.

---

## 📈 Milestone 2 - Idle Scaling & Scrap Yard Expansion

**Goal:** Establish the game's distinctive idle-building model.

- [x] Implement Scrap Yard levels
- [x] Implement automatic milestone expansions
- [x] Add milestone multipliers at selected levels
- [x] Add **Build New** button
- [x] Make Scrap Yard count a cumulative multiplier
- [x] Confirm 1 Scrap Yard = ×1, 2 = ×2, 3 = ×3, etc.
- [x] Ensure new Scrap Yards share the same level
- [x] Ensure there is only one Scrap Yard upgrade tree
- [x] Implement exponential/idle-style cost scaling
- [x] Display Level, Scrap Yard count, milestone multiplier, and total production clearly
- [x] Test large numbers and high levels

**Core rule:**

> **Level Up makes the operation better. Build New increases the number of operations.**

**Milestone complete when:** The player can grow one Scrap Yard operation from a tiny starting facility into a rapidly scaling industrial operation without managing individual copies.

---

## 👥 Milestone 3 - Population & Workforce

**Goal:** Introduce the game's first civilization-level system without turning it into a survival simulator.

- [x] Add Population
- [x] Add Workforce calculation
- [x] Implement percentage-based workforce allocation
- [x] Add allocation sliders
- [x] Make workforce counts automatically follow Population changes
- [x] Add allocation efficiency calculation
- [x] Implement Red → Orange → Green → Orange → Red allocation feedback
- [x] Make efficient allocation ranges dynamic
- [x] Connect Industrial Authority allocation to Scrap Yard productivity
- [x] Test Population growth changing workforce without requiring reassignment

**Core rule:**

> The player manages **percentages**, not individual worker counts.

No Food, Housing, Healthcare, or Education survival meters.

**Milestone complete when:** Population growth naturally changes the economy and the player can make meaningful workforce decisions without spreadsheet-style micromanagement.

---

## 🏭 Milestone 4 - Production Chains

**Goal:** Capture the layered idle-game progression of the inspiration games.

- [x] Add Reclamation Depot
- [x] Add Workshop
- [x] Add Factory
- [x] Create the first production chain
- [x] Make higher-tier operations accelerate lower-tier production
- [x] Apply the Level Up / Build New model to production operations where appropriate
- [x] Add production automation rules
- [x] Add increasingly large number scaling
- [x] Add simple production statistics
- [x] Add unlock requirements between tiers

**Production-chain automation rates:**

- Reclamation Depot: **0.10 Scrap Yard Levels/sec** per operation effectiveness
- Workshop: **0.05 Reclamation Depot Levels/sec** per operation effectiveness
- Factory: **0.025 Workshop Levels/sec** per operation effectiveness

Automation grants lower-tier levels without spending Materials. Fractional progress is retained until it reaches one complete level.

Initial chain:

```text
Scrap Yard
    ↓
Reclamation Depot
    ↓
Workshop
    ↓
Factory
    ↓
Industrial Plant
    ↓
Manufacturing Complex
```

**Milestone complete when:** The player has the satisfying feeling of building an interconnected idle production machine rather than repeatedly clicking one button.

---

## ⚡ Milestone 5 - Energy & Department Allocation

**Goal:** Introduce Energy and department allocation as an active part of the existing idle loop.

- [x] Add Energy
- [x] Create basic Energy production
- [x] Add Energy consumption
- [x] Connect Energy consumption to production systems
- [ ] Add Energy shortage states
- [ ] Add load-shedding behaviour
- [ ] Add Industrial / Civilian / Security / Scientific priority options
- [x] Add Central Government workforce allocation
- [x] Add basic department UI
- [x] Make Energy interact with the existing idle loop

**Deferred:** Energy shortage states, load shedding, and priority management are intentionally moved to a later milestone. They do not currently affect the core loop and will be added once there are meaningful systems for them to control.

**Milestone complete when:** Energy exists as a working production/consumption constraint and interacts with the existing production and workforce systems.

---

## 🛡️ Milestone 6 - Security & Unrest Prototype

**Goal:** Build the system that makes The Last City different from a conventional idle game.

- [ ] Add Security
- [ ] Add Threat
- [ ] Compare Security Capacity against Threat
- [ ] Add basic Unrest generation
- [ ] Add Unrest recovery
- [ ] Add Unrest states
- [ ] Connect Unrest to productivity
- [ ] Connect Unrest to workforce efficiency
- [ ] Add basic strikes/sabotage events
- [ ] Add Security workforce allocation
- [ ] Make high Security powerful but socially costly

Unrest states:

```text
0–10    Stable
10–25   Discontent
25–50   Tension
50–75   Unrest
75–100  Crisis
```

**Milestone complete when:** The player can create a highly productive civilization and then discover that the way they achieved it has consequences.

---

## 🏛️ Milestone 7 - Government Decisions

**Goal:** Let the player actively govern the problems their economy creates.

- [ ] Add Trust
- [ ] Add Compliance
- [ ] Keep Trust and Compliance as separate systems
- [ ] Add basic Government Directives
- [ ] Add meaningful positive/negative trade-offs
- [ ] Add Negotiate response
- [ ] Add Suppress response
- [ ] Add Manipulate response
- [ ] Add Ignore response
- [ ] Connect government choices to Unrest
- [ ] Connect government choices to productivity
- [ ] Connect government choices to Security
- [ ] Add the first civilization identity/archetype signals

**Milestone complete when:** The player is making government choices because the economy created a problem, not because the game presented another upgrade tree.

---

## 🧨 Milestone 8 - Crises

**Goal:** Turn civilization pressures into readable, consequential events.

- [ ] Add crisis risk calculations
- [ ] Add visible risk/warning indicators
- [ ] Add Power Grid Failure
- [ ] Add Worker Strike
- [ ] Add Sabotage
- [ ] Add Infrastructure Failure
- [ ] Add Security Incident
- [ ] Make crisis probability respond to player decisions
- [ ] Add crisis outcomes and recovery
- [ ] Add civilization report after major events

**Core rule:**

> Crises should feel like consequences, not random punishment.

**Milestone complete when:** The player can see a problem developing, understand why it is dangerous, and choose whether to intervene or accept the risk.

---

## 🔬 Milestone 9 - Research & Technology

**Goal:** Introduce technologies that change the rules rather than simply adding percentage bonuses.

- [ ] Add Research
- [ ] Add Scientific Directorate
- [ ] Create technology tree/data structure
- [ ] Add Automation technology
- [ ] Add Robotics
- [ ] Add AI
- [ ] Add advanced Energy technology
- [ ] Make technology alter existing systems
- [ ] Add technology prerequisites
- [ ] Add technology discovery UI

Example principle:

> Automation should reduce Labour requirements, not simply say “+10% production.”

**Milestone complete when:** Research changes what the player can do, not just how large the numbers become.

---

## 🤖 Milestone 10 - Automation & Offline Progress

**Goal:** Make the game properly idle.

- [ ] Add automatic purchasing where appropriate
- [ ] Add automatic production allocation
- [ ] Add department automation
- [ ] Add offline progress calculation
- [ ] Add offline civilization report
- [ ] Handle Energy conditions during offline time
- [ ] Handle Unrest during offline time
- [ ] Handle crises during offline time
- [ ] Add automation upgrades
- [ ] Add AI-directed systems as a later automation tier

**Milestone complete when:** The civilization continues meaningfully while the player is away.

---

## ⚡ Milestone 11 - Emergency Allocation

**Goal:** Add the game's active “push the big red button” mechanic.

- [ ] Add Emergency Allocation system
- [ ] Add Industrial Surge
- [ ] Add Labour Mobilization
- [ ] Add Power Priority
- [ ] Add Security Lockdown
- [ ] Add Scientific Emergency
- [ ] Add Energy/resource costs
- [ ] Add Worker fatigue
- [ ] Add Infrastructure wear
- [ ] Add Unrest consequences
- [ ] Add cooldown/duration rules

**Milestone complete when:** Emergency actions feel powerful enough to tempt the player and dangerous enough that they cannot be spammed without consequence.

---

## ☠️ Milestone 12 - Collapse & Legacy

**Goal:** Create the long-term incremental loop.

- [ ] Define Collapse conditions
- [ ] Add deliberate Collapse option
- [ ] Reset current civilization state
- [ ] Calculate Legacy earned
- [ ] Add Industrial Legacy
- [ ] Add Scientific Legacy
- [ ] Add Institutional Legacy
- [ ] Add Cultural Legacy
- [ ] Add Historical Legacy
- [ ] Apply Legacy to the next civilization
- [ ] Add new starting options from Legacy

**Milestone complete when:** Resetting a civilization feels like ending a chapter of history rather than pressing a generic prestige button.

---

## 🌍 Milestone 13 - First Vertical Slice

**Goal:** A complete small version of The Last City that can be played from beginning to Collapse.

The vertical slice should contain only enough content to prove the game works.

- [ ] Scrap Yard
- [ ] Population
- [ ] Workforce allocation
- [ ] Materials
- [ ] Energy
- [ ] Security
- [ ] Unrest
- [ ] One or two crises
- [ ] A few Government Directives
- [ ] A small Technology tree
- [ ] Offline progress
- [ ] Collapse
- [ ] Legacy
- [ ] Save/load
- [ ] Basic 2D presentation
- [ ] Basic sound/UI feedback

**Milestone complete when:** A new player can start a civilization, build it, encounter problems, govern those problems, Collapse, and understand why they would want to play again.

---

## ⚡ Milestone 14 - Advanced Energy Management

**Goal:** Add meaningful energy scarcity, prioritization, and load shedding once the civilization has enough systems for those mechanics to matter.

- [ ] Add Energy shortage states
- [ ] Define Powered / Strained / Shortage / Critical or Blackout states
- [ ] Add Industrial / Civilian / Security / Scientific priority options
- [ ] Add priority-based load shedding
- [ ] Make Energy priorities affect which systems continue operating during shortages
- [ ] Add clear player-facing Energy status feedback
- [ ] Ensure shortage behaviour works consistently during normal and offline simulation
- [ ] Balance Energy production and consumption around meaningful trade-offs

**Core rule:**

> Energy shortages should force the player to decide what keeps running, not simply punish the player by stopping everything.

**Milestone complete when:** The player can intentionally manage a constrained power grid and make meaningful choices about which parts of the civilization receive power.

---

# 📋 IMMEDIATE TASK LIST

These are the tasks to work on **now**. Do not jump ahead to the full civilization system.

### First Build

- [ ] Open the Godot project and confirm the project runs
- [ ] Create the main 2D scene
- [ ] Create the main game controller/autoload
- [ ] Create a simple resource state for Materials
- [ ] Create the game tick
- [ ] Create the Scrap Yard data/model
- [ ] Display Materials on screen
- [ ] Display Scrap Yard level
- [ ] Add **LEVEL UP** button
- [ ] Make Level Up spend Materials
- [ ] Make Level Up increase production
- [ ] Add Materials-per-second display
- [ ] Add a simple manual Scrap Yard click
- [ ] Make the game save and load

### Then

- [ ] Add Scrap Yard milestone levels
- [ ] Add automatic milestone multipliers
- [ ] Add **BUILD NEW** button
- [ ] Add Scrap Yard count multiplier
- [ ] Add large-number formatting
- [ ] Add basic production feedback
- [ ] Playtest the first 10 minutes
- [ ] Adjust costs and production based on feel

**Do not build the full six-department system yet.**

The first goal is to prove that the Scrap Yard itself is fun.

---

# 🧭 RULE FOR IMPLEMENTATION

When deciding whether to build a new feature, ask:

> **Does this make the core idle loop better, or are we building complexity because the design document says we can?**

The correct order is:

```text
Fun Core Loop
	  ↓
Reliable Systems
	  ↓
Production Scaling
	  ↓
Workforce
	  ↓
Civilization Problems
	  ↓
Government Decisions
	  ↓
Technology
	  ↓
Collapse / Legacy
	  ↓
More Content
```

Do not build late-game systems before the early game is fun.

---

# 🧭 THE CORE IDEA

The Last City takes inspiration from idle and incremental games such as:

- **AdVenture Capitalist** - simple production, automation, exponential growth, and prestige
- **Underworld Idle** - interconnected production chains and layered progression
- **Idle Research** - technology-driven progression and increasingly complex systems
- **Unnamed Space Idle** - deep automation, optimization, and long-term system interaction

But The Last City needs to be more than a combination of familiar idle mechanics.

### The unique layer is civilization.

The player is not simply optimizing numbers. They are governing a civilization while those numbers grow.

Economic decisions create social consequences.

Government decisions create economic consequences.

Technology changes the rules of the economy.

Security can suppress unrest while creating other problems.

Automation can increase production while reducing the need for workers.

Population growth creates a larger workforce, but also changes the social and political balance of the civilization.

The player is constantly balancing three overlapping games:

### 1. The Idle Machine

Production chains, automation, multipliers, exponential growth, offline progress, upgrades, and prestige.

### 2. The Civilization

Population, Labour, Energy, Security, Research, Compliance, unrest, morale, inequality, trust, and other social pressures.

### 3. The Government

Directives, emergency measures, crises, political choices, and long-term consequences.

The game becomes interesting when these three layers interfere with one another.

---

# 🧱 DESIGN PRINCIPLES

## Start Simple, Become Complex

The player should understand the first production loop within minutes.

## Build an Idle Game First

Numbers grow, production chains expand, automation becomes powerful, offline progress matters, and prestige creates long-term progression.

## Percentage-Based Workforce

The player allocates percentages of the available workforce rather than manually assigning fixed worker counts.

## Operation Scaling

> **Level Up makes an operation better. Build New increases the number of operations.**

Additional operations use a cumulative multiplier: 1 = ×1, 2 = ×2, 3 = ×3, etc.

Major level milestones can automatically expand an operation and provide large productivity multipliers.

## No Survival Simulation

The game does not require individual management of Food, Housing, Healthcare, or Education.

The civilization layer should remain broad and strategic rather than becoming a city survival simulator.

## More Is Not Always Better

Higher Security, Automation, Population, and Compliance should all create trade-offs.

## Social Systems Are Consequences

Unrest, Morale, Trust, Compliance, Crime, and Inequality are not just currencies. They represent what the player's economic and government choices have done to the civilization.

---

# 👥 CORE SYSTEMS

## Population

Population provides potential workforce and grows through broad civilization conditions.

## Workforce

```text
Available Workforce
= Population × Workforce Rate × Workforce Efficiency
```

Workforce is allocated through percentage sliders.

Allocation feedback uses:

**Red → Orange → Green → Orange → Red**

The green zone represents the current efficient range and can move as the civilization changes.

## Energy

Energy is a universal infrastructure resource. Shortages create load-shedding and priority decisions rather than instant death.

## Security

Security is measured against Threat. High Security can reduce crime, unrest, sabotage, and crisis risk, but consumes Labour and Energy and can damage Trust.

## Unrest

Unrest is the game's primary social pressure and a key differentiator from traditional idle games.

## Trust & Compliance

Trust measures legitimacy. Compliance measures obedience. They are deliberately separate.

## Morale

Morale modifies productivity and social stability rather than acting as a resource.

## Inequality

Inequality becomes more important later and creates economic advantages alongside social costs.

---

# 🏭 PRODUCTION MODEL

Production should preserve the satisfying exponential feel of classic idle games while making the physical growth of the civilization understandable.

For an operation such as the Scrap Yard:

```text
Production
= Base Production
× Level / Milestone Multipliers
× Number of Operations
× Technology
× Government / Other Modifiers
```

The exact formula will be tuned during prototyping.

### Scrap Yard

The Scrap Yard is the first production operation.

It has exactly two buttons:

**LEVEL UP**

- Improves the existing Scrap Yard operation.
- Increases its productivity.
- At selected levels, automatically doubles the operation's productivity through a milestone multiplier.
- Does not add a Scrap Yard building.

**BUILD NEW**

- Adds another Scrap Yard to the operation.
- Uses the same shared upgrade level.
- Increases the operation multiplier linearly.
- Is the only action that increases the Scrap Yard building count.

```text
1 Scrap Yard = ×1
2 Scrap Yards = ×2
3 Scrap Yards = ×3
4 Scrap Yards = ×4
```

New Scrap Yards do **not** each require their own upgrade tree.

---

# 🏭 DEPARTMENTS

The six departments unlock gradually.

| Department | Primary Resource | Purpose |
|---|---|---|
| Industrial Authority | Materials | Manufacturing and construction |
| Ministry of Labour | Labour | Workforce and population |
| Central Government | Energy | Power and infrastructure |
| Security Directorate | Security | Order and protection |
| Scientific Directorate | Research | Technology and advancement |
| Ministry of Information | Compliance | Information and social control |

Departments should never feel like six separate idle games. They feed one interconnected civilization.

---

# 🧨 CRISES

Crises should be partially predictable and tied to the conditions the player creates.

Examples:

- Worker strikes
- Power failures
- Sabotage
- Infrastructure failures
- Research accidents
- Information leaks
- Security incidents
- Riots

The player should be able to see warning signs and decide whether to intervene.

---

# ⚡ EMERGENCY ALLOCATION

Emergency Allocation provides temporary, powerful boosts.

Examples:

- Industrial Surge
- Labour Mobilization
- Power Priority
- Security Lockdown
- Scientific Emergency

Emergency actions can cause Energy costs, Worker fatigue, Infrastructure wear, Unrest, and increased Crisis risk.

---

# 📜 GOVERNMENT DIRECTIVES

Directives are permanent policies with meaningful trade-offs.

Examples:

```text
MANDATORY LABOUR
Industrial Production +25%
Morale -10%
Unrest Pressure +15%
Security Demand +10%
```

The goal is not Good vs Evil. The goal is choosing what the civilization gains and what it sacrifices.

Government identity should emerge from accumulated decisions rather than being selected as a starting class.

---

# 🔬 TECHNOLOGY

Technology should change rules rather than simply add percentage bonuses.

Examples:

- Automation reduces Labour requirements.
- Robotics changes how industrial systems operate.
- AI can automate workforce allocation.
- Nuclear and Fusion change Energy constraints.
- Synthetic Workforce replaces human Labour.
- Nanotechnology changes Materials production.
- Quantum Computing changes Research.
- Matter Manipulation changes endgame production.

---

# ☠️ COLLAPSE & LEGACY

Collapse is the major prestige/reset system.

The player ends or survives a civilization and carries knowledge, technology, institutions, discoveries, and new possibilities into the next civilization.

Legacy should create new options rather than simply becoming another permanent multiplier.

---

# 🚫 THINGS TO AVOID

### Six Separate Idle Games

Departments must feed one another.

### Spreadsheet Simulator

Complexity must remain readable.

### Traditional 4X Strategy Game

The core experience remains idle/incremental.

### Survival Simulator

No individual Food, Housing, Healthcare, or Education management in the core loop.

### Endless Currency Bloat

Prefer existing systems interacting over adding another resource for every mechanic.

### Generic Prestige

Collapse should feel like the end of a civilization and the beginning of another, not simply a reset button.

---

# 📌 ONE-SENTENCE VISION

> **The Last City is an idle civilization builder where exponential economic growth creates social and political problems that the player must solve, exploit, or suppress.**

# 📌 THE LONG-TERM FANTASY

> **I started with a scrap yard.**
>
> **Now I control the last functioning civilization on Earth.**
>
> **And somehow, keeping it alive is harder than building it.**
