# ⚙️ THE LAST CITY

> **An idle civilization builder where exponential economic growth creates social and political problems that the player must solve, exploit, or suppress.**

The Last City is a dystopian steampunk incremental game about rebuilding the last functioning civilization on Earth.

Start with a single Scrap Yard.

Build it up.

Process the ruins into useful Materials.

Grow the workforce.

Build increasingly advanced production chains.

Then discover that keeping a civilization functioning creates problems that cannot be solved by simply making the numbers bigger.

Eventually, civilization will collapse.

The question is what survives it.

---

## 🎯 Current Project Status

**Design / idea phase. Nothing has been implemented yet.**

This README is the living design document for the game's vision, systems, progression, and design philosophy. Numbers, formulas, balance, UI, implementation details, and individual mechanics are expected to change as the design develops.

The goal at this stage is to establish the game's identity before building it.

---

# 🧭 The Core Idea

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

# 🧱 Design Pillars

## Start Simple, Become Complex

The player should understand the first production loop within minutes.

New systems should be introduced gradually. The game should not begin with six departments, dozens of resources, and a wall of locked content.

The player should discover the civilization one system at a time.

## Build an Idle Game First

The underlying experience should still deliver the satisfying rhythm of a great incremental game:

- Numbers grow
- Production chains expand
- Buildings automate
- Upgrades become increasingly powerful
- New tiers become absurdly large
- Offline progress matters
- Prestige creates long-term growth
- The player constantly has another meaningful goal

The civilization systems should add depth without destroying that satisfying idle-game rhythm.

## Every Department Has a Purpose

Each department should have a distinct identity, resource, and gameplay function.

Departments should not feel like six copies of the same resource generator.

## Production Chains Matter

Buildings produce lower-tier buildings, creating cascading production and satisfying exponential growth.

The player should eventually look back at the original Scrap Yard and realize that it has become the foundation of a civilization-scale industrial machine.

## Resources Interact

The civilization should function as one interconnected system.

- Industry needs Labour.
- Labour comes from Population.
- Industry and civilization need Energy.
- Science changes how other systems work.
- Security protects production and population.
- Information influences population behaviour.
- Government decisions deliberately distort the system.
- Social conditions feed back into production.

## More Is Not Always Better

This is one of the most important design principles.

Higher Security should not simply be better.

More Automation should not simply be better.

Faster Population Growth should not simply be better.

Higher Compliance should not simply be better.

A powerful civilization should also create new problems.

## Temporary Power Should Feel Powerful

Emergency Allocation provides short bursts of extreme productivity.

The player should constantly face decisions such as:

> **Use it now, or save it for the next bottleneck?**

## Progression Should Reveal the World

Major unlocks should reveal new systems, technology, history, and consequences.

The player should gradually discover what happened to Earth and why the surviving civilization became the way it is.

## Collapse Has Meaning

Prestige is not a generic reset.

The player deliberately causes or survives a civilization-scale collapse and carries knowledge, technology, and Legacy into the next civilization.

The next run should feel like the civilization learned something from the previous one.

---

# 🏙️ Core Concept

You are the administrator of a surviving human settlement on Earth.

The world outside the city is largely ruined.

Your job is to keep the settlement functioning while expanding its industrial, social, scientific, and governmental capabilities.

The player will:

- Grow Population
- Manage Workforce allocation
- Build and upgrade production operations
- Generate Materials
- Produce Energy
- Maintain Security
- Develop technology
- Control public information
- Issue government Directives
- Respond to emergencies
- Manage social stability
- Survive or initiate The Collapse
- Carry permanent Legacy into the next civilization

The game never needs to leave Earth.

Instead, the scale becomes increasingly ridiculous:

**Scrap Yard → District → City → Region → Nation → Planetary Civilization**

The central fantasy is:

> **"I started with a scrap yard. Now I control the last functioning civilization on Earth."**

---

# 🔄 Core Gameplay Loop

```text
Population
    ↓
Workforce
    ↓
Allocate Workforce by percentage
    ↓
Production
    ↓
Materials / Energy / Security / Research / Compliance
    ↓
Upgrade production operations
    ↓
Build additional production operations
    ↓
Unlock new Departments
    ↓
Create interconnected production chains
    ↓
Manage social pressures
    ↓
Use Emergency Allocation for temporary surges
    ↓
Purchase Directives and permanent upgrades
    ↓
Research technologies that change system rules
    ↓
Respond to civilization crises
    ↓
Reach major civilization milestones
    ↓
Initiate / endure The Collapse
    ↓
Earn Legacy
    ↓
Begin the next civilization with permanent advantages
    ↓
Repeat at a greater scale
```

---

# 👥 Foundational Resources

## Population

Population is the number of people living in the civilization.

It is **not simply another currency**.

Population provides the potential workforce of the civilization and influences the scale of the society.

Population growth should remain relatively simple rather than becoming a survival simulation.

Population should not require the player to manage individual needs such as food, housing, or healthcare.

Instead, population growth is influenced by broad civilization-level conditions such as:

- Morale
- Unrest
- Security
- Government policy
- Technology
- Major crises

A larger population creates a larger potential workforce, but the civilization must still decide how that workforce is used.

## Labour / Workforce

The player does **not** assign individual numbers of workers to buildings.

Instead, the available workforce is divided using **percentage-based allocation sliders**.

Example:

```text
Available Workforce: 100,000

Industrial Authority     50%
Security Directorate     20%
Central Government       15%
Scientific Directorate   10%
Information Ministry      5%
```

If the workforce grows to 150,000, the same percentages automatically scale:

```text
Available Workforce: 150,000

Industrial Authority     50% = 75,000
Security Directorate     20% = 30,000
Central Government       15% = 22,500
Scientific Directorate   10% = 15,000
Information Ministry      5% =  7,500
```

This means population growth automatically feeds into the existing allocation without requiring the player to repeatedly reassign raw worker counts.

### Workforce Allocation UI

Each allocation slider should visually communicate how effective the current percentage is.

The allocation range can transition through:

**Red → Orange → Green → Orange → Red**

The green region represents the department's current efficient allocation range.

The optimal range is not fixed. It can move as the civilization changes.

For example:

- Automation may reduce the Labour required by Industry.
- A growing threat may increase the ideal Security allocation.
- A major research project may temporarily increase the ideal Scientific allocation.
- A crisis may change the optimal allocation of several departments at once.

The player therefore solves an allocation problem rather than a worker-count problem.

### Workforce Efficiency

A simplified model is:

```text
Available Workforce = Population × Workforce Rate × Workforce Efficiency
```

The player allocates percentages of that available workforce between departments.

The system should reward finding the productive range rather than simply putting as many workers as possible into one department.

## Materials

Materials are produced by the Industrial Authority.

The initial production loop is:

```text
Population
    ↓
Workforce
    ↓
Scrap Yard
    ↓
Materials
    ↓
Production Upgrades
    ↓
More Production
```

There is no separate Scrap currency.

Scrap is the thematic source of Materials. Scrap Yards process abandoned vehicles, machinery, buildings, and infrastructure directly into usable Materials.

---

# 🏭 The Six Departments

The civilization eventually contains six major departments.

| Department | Primary Resource | Core Specialty |
|---|---|---|
| **Industrial Authority** | Materials | Manufacturing and construction |
| **Ministry of Labour** | Labour | Workforce and population |
| **Central Government** | Energy | Power and infrastructure |
| **Security Directorate** | Security | Order and protection |
| **Scientific Directorate** | Research | Technology and advancement |
| **Ministry of Information** | Compliance | Information and social control |

Departments unlock gradually.

The player should never begin with all six.

---

# 🏭 Industrial Authority

**Primary Resource:** Materials

**Theme:** Reclamation, manufacturing, construction, and automation.

The Industrial Authority is the starting production system.

## Production Chain

Only the lowest production building directly creates the department's primary resource.

Higher buildings produce the production building directly beneath them.

```text
The Foundry
    ↓
Autonomous Industry
    ↓
Industrial Network
    ↓
Automated Factory
    ↓
Manufacturing Complex
    ↓
Industrial Plant
    ↓
Factory
    ↓
Workshop
    ↓
Reclamation Depot
    ↓
Scrap Yard
    ↓
Materials
```

| Tier | Building | Produces |
|---:|---|---|
| 1 | **Scrap Yard** | Materials |
| 2 | **Reclamation Depot** | Scrap Yards |
| 3 | **Workshop** | Reclamation Depots |
| 4 | **Factory** | Workshops |
| 5 | **Industrial Plant** | Factories |
| 6 | **Manufacturing Complex** | Industrial Plants |
| 7 | **Automated Factory** | Manufacturing Complexes |
| 8 | **Industrial Network** | Automated Factories |
| 9 | **Autonomous Industry** | Industrial Networks |
| 10 | **The Foundry** | Autonomous Industry |

As the chain grows, advanced tiers introduce Energy and Research requirements.

## Scrap Yard Progression Model

The Scrap Yard uses a different progression model from a traditional idle-game building counter.

The player does not buy 25 independent Scrap Yards just to make the number go up.

Instead, the player manages a **Scrap Yard operation**.

There are only two buttons:

### **LEVEL UP**

Leveling up improves the productivity of the existing Scrap Yard operation.

Every level increases its production.

At certain milestone levels, the Scrap Yard automatically expands as part of leveling up. The player does not need a separate expansion button.

Example milestone structure:

| Scrap Yard Level | Effect |
|---:|---|
| 1 | Base operation |
| 25 | Automatic expansion → **×2 productivity** |
| 100 | Automatic expansion → **×2 productivity** |
| 450 | Automatic expansion → **×2 productivity** |
| 1,000 | Automatic expansion → **×2 productivity** |
| 2,500 | Automatic expansion → **×2 productivity** |

The exact milestone levels and values will be balanced later.

The important rule is that **leveling up improves the existing operation, while milestone levels automatically make that operation larger and more productive.**

### **BUILD NEW**

Building a new Scrap Yard adds another equivalent Scrap Yard to the operation.

The player does not receive a separate upgrade tree for the new yard.

If the player owns:

```text
1 Scrap Yard  = ×1 productivity
2 Scrap Yards = ×2 productivity
3 Scrap Yards = ×3 productivity
4 Scrap Yards = ×4 productivity
5 Scrap Yards = ×5 productivity
```

The multiplier is **linear and cumulative**, not compounding.

The player upgrades the single shared Scrap Yard operation, while the number of Scrap Yards acts as a production multiplier.

For example:

```text
Scrap Yard Level:          450
Scrap Yards:                 4×
Milestone Multiplier:        ×8
Technology Multiplier:       ×3
---------------------------------
Final Production Multiplier: ×96
```

The player therefore gets the familiar idle-game satisfaction of continuously upgrading one operation while still seeing the civilization physically expand through additional sites.

This principle should apply broadly to other production buildings where appropriate:

> **Level Up makes the operation better. Build New increases the number of operations.**

---

# 👷 Ministry of Labour

**Primary Resource:** Labour

**Core Systems:**

- Workforce allocation
- Population growth
- Worker efficiency
- Specialization
- Automation
- Human augmentation

Labour exists from the beginning.

The Ministry of Labour is unlocked later and provides advanced control over the workforce rather than introducing Labour itself.

## Production Chain

```text
Population Productivity Complex
    ↓
Human Optimization Centre
    ↓
Labour Administration
    ↓
Workforce Directorate
    ↓
Professional Institute
    ↓
Technical Institute
    ↓
Training Centre
    ↓
Labour Bureau
    ↓
Employment Office
    ↓
Worker Barracks
    ↓
Labour
```

## Potential Technologies

- Worker Training
- Productivity Standards
- Workforce Specialization
- Mechanized Labour
- Worker Augmentation
- Neural Interfaces
- Synthetic Workforce

---

# ⚡ Central Government

**Primary Resource:** Energy

**Core Systems:**

- Power generation
- Infrastructure
- Energy distribution
- Emergency Allocation
- Government authority

## Production Chain

```text
The Eternal Generator
    ↓
Stellar Energy Collector
    ↓
Planetary Energy Grid
    ↓
Orbital Power Array
    ↓
Fusion Facility
    ↓
Nuclear Station
    ↓
National Grid
    ↓
Power Plant
    ↓
Power Station
    ↓
Steam Generator
    ↓
Energy
```

## Technology Progression

```text
Steam
  ↓
Electricity
  ↓
Nuclear
  ↓
Fusion
  ↓
Orbital Power
  ↓
Planetary Grid
  ↓
Stellar Energy
```

---

# 🛡️ Security Directorate

**Primary Resource:** Security

**Core Systems:**

- Crime prevention
- Unrest management
- Surveillance
- Crisis response
- Internal security
- Population control

Security becomes increasingly important as the population grows.

## Production Chain

```text
The Protectorate
    ↓
National Security Grid
    ↓
Autonomous Enforcement Centre
    ↓
Surveillance Command
    ↓
Tactical Directorate
    ↓
Internal Security Office
    ↓
Security Bureau
    ↓
Patrol Division
    ↓
Police Station
    ↓
Watch Post
    ↓
Security
```

Security buildings consume Labour and Energy.

High Security can reduce:

- Crime
- Unrest
- Sabotage
- Production interruptions
- Crisis severity

But excessive security can create negative social consequences.

Security is therefore not a simple "more is better" stat.

---

# 🔬 Scientific Directorate

**Primary Resource:** Research

**Core Systems:**

- Technology
- Breakthroughs
- Automation
- Advanced energy
- Biology
- Artificial intelligence

Science should differ from the other departments.

Its production chain generates Research, but its major purpose is to **change the rules of the other departments**.

## Production Chain

```text
Continuum Project
    ↓
Singularity Research Facility
    ↓
Artificial Intelligence Institute
    ↓
Applied Science Directorate
    ↓
Advanced Research Centre
    ↓
National Laboratory
    ↓
University
    ↓
Research Institute
    ↓
Laboratory
    ↓
Research Office
    ↓
Research
```

## Technology Branches

### Industrial

Automation → Robotics → Nanotechnology

### Biological

Genetics → Augmentation → Synthetic Biology

### Computational

Computers → AI → Neural Networks → General Intelligence

### Energy

Nuclear → Fusion → Exotic Energy

### Theoretical

Quantum Physics → Spacetime → Matter Manipulation → Consciousness

---

# 📡 Ministry of Information

**Primary Resource:** Compliance

**Core Systems:**

- Public sentiment
- Propaganda
- Influence
- Social control
- Information management
- Population behaviour

This is where the dystopian nature of the game becomes explicit.

The player should initially be encouraged to think of Compliance as a useful and positive measure.

Later, the meaning becomes increasingly uncomfortable.

## Production Chain

```text
The Narrative
    ↓
Cognitive Management Network
    ↓
Narrative Control Centre
    ↓
Behavioural Directorate
    ↓
Social Analytics Division
    ↓
Ministry of Truth
    ↓
Civic Information Bureau
    ↓
State News Network
    ↓
Information Office
    ↓
Public Broadcast Station
    ↓
Compliance
```

---

# 🔗 Cross-Department Production

Departments should never operate as six independent idle games.

The economy should become increasingly interconnected.

A simplified example:

```text
                    INDUSTRIAL AUTHORITY
                            │
                         Materials
                            │
                            ▼
                        Buildings
                       /          \
                      /            \
                     ▼              ▼
                 Labour         Government
                    │                │
                    ▼                ▼
               Population          Energy
                    │                │
                    └───────┬────────┘
                            ▼
                         Security
                            │
                            ▼
                          Science
                            │
                            ▼
                       Technology
                            │
                            ▼
                       Information
                            │
                            ▼
                        Compliance
```

The actual dependency graph should become much more interconnected as the game progresses.

---

# 🧠 The Civilization Layer

This is the primary feature that separates The Last City from a conventional idle game.

The civilization should have a social state that responds to the player's choices.

Potential social pressures include:

- **Unrest** - dissatisfaction and willingness to resist
- **Compliance** - willingness to follow government directives
- **Crime** - criminal activity and instability
- **Morale** - workforce and population wellbeing
- **Inequality** - uneven distribution of resources and opportunity
- **Trust** - confidence in the government and its institutions

These should not simply be additional currencies.

They should be **consequences of the player's civilization-building strategy**.

## Population, Labour, and Society

Population creates the potential workforce, but the player does not micromanage individual citizens.

The important question is how much of the available workforce should be directed toward each department.

This is handled through percentage sliders rather than fixed worker counts.

The allocation system should make the consequences readable at a glance:

- **Red:** severely underallocated or overallocated
- **Orange:** usable but inefficient
- **Green:** current efficient range

The green range can move as the civilization changes.

This creates a living optimization problem without turning the game into a spreadsheet.

---

# 🔥 Unrest

**Unrest is not just another number.**

It should be an emergent consequence of the player's economic, social, and governmental decisions.

Unrest can be influenced by:

- Poor working conditions
- Unemployment
- Excessive resource extraction
- Forced Labour
- Excessive surveillance
- Inequality
- Government propaganda
- Security policy
- Population growth
- Major crises
- Previous government decisions
- Low Trust
- Low Morale

High Unrest can cause:

- Strikes
- Riots
- Sabotage
- Reduced productivity
- Infrastructure damage
- Government instability
- Production interruptions
- Major crises

### Unrest States

| Unrest | State |
|---:|---|
| 0–10 | Stable |
| 10–25 | Discontent |
| 25–50 | Tension |
| 50–75 | Unrest |
| 75–100 | Crisis |

The exact thresholds may change during balancing, but the principle should remain: unrest escalates through recognizable stages rather than acting as a hidden random penalty.

The player can respond in different ways.

### Negotiate

Spend resources to address the underlying problem.

- Unrest ↓
- Trust ↑
- Production may temporarily ↓

### Suppress

Use Security to force the problem back down.

- Unrest ↓ immediately
- Security demand ↑
- Trust ↓
- Potential future unrest ↑

### Manipulate

Use the Ministry of Information to influence public sentiment.

- Compliance ↑
- Immediate unrest may ↓
- Trust may ↓
- Long-term consequences may appear

### Ignore

Do nothing.

The problem can spread.

This creates a layer of decision-making that is unusual for an idle game without turning the game into a traditional strategy game.

---

# ⚖️ Compliance and Trust

Compliance and Trust are deliberately separate systems.

**Compliance:** Will people obey?

**Trust:** Do people believe the government is legitimate or acting in their interests?

This creates different civilization states:

| Trust | Compliance | Civilization Character |
|---|---|---|
| High | High | Stable and cooperative |
| High | Low | Supportive but difficult to govern |
| Low | High | Authoritarian and controlled |
| Low | Low | Unstable and approaching collapse |

Security can increase Compliance without increasing Trust.

Information control can increase Compliance while damaging Trust.

Government investment can increase Trust while sometimes reducing short-term efficiency.

There should be no universally optimal combination.

---

# 🙂 Morale and Productivity

Morale is a modifier, not another resource to collect.

A simplified model is:

```text
Worker Productivity =
Base Productivity
× Technology
× Morale
× Working Conditions
```

Morale can be affected by:

- Unrest
- Trust
- Government policy
- Workload
- Security conditions
- Major crises
- Successful government decisions

This lets social conditions feed directly back into the idle economy.

---

# ⚖️ Inequality

Inequality should become more important in the mid-game rather than overwhelming the opening.

Low Inequality can provide:

- Higher Trust
- Lower Unrest
- Higher Morale
- Greater social stability

High Inequality can provide certain economic advantages, but at a social cost:

- Potentially greater investment efficiency
- Higher industrial concentration
- Lower Trust
- Higher Unrest
- Higher Crime
- Lower Morale

The goal is not to create a morality meter.

The goal is to create an uncomfortable optimization problem.

---

# 🧨 Crises

The city should occasionally experience crises.

Possible crises include:

- Worker strikes
- Power shortages
- Factory fires
- Infrastructure failures
- Riots
- Sabotage
- Industrial accidents
- Research accidents
- Information leaks
- Security incidents
- Mass unrest

Crises should be influenced by the player's previous decisions rather than being completely random interruptions.

For example:

```text
Low Security
     ↓
Higher chance of unrest

High Security
     ↓
Lower unrest
     ↓
Higher Labour consumption
     ↓
Potential Compliance / Trust penalty
```

Crisis risk should be visible enough that the player can understand why something is becoming dangerous.

A crisis should feel like a consequence of running the civilization, not a random punishment pasted onto an idle game.

---

# ⚡ Energy

Energy is a universal infrastructure resource.

It is consumed by systems such as:

- Industry
- Security
- Research
- Information
- Advanced technologies

Energy shortages should not instantly destroy the civilization.

Instead, the player can manage priorities and load shedding.

Possible priorities include:

- Industrial Priority
- Civilian Priority
- Security Priority
- Scientific Priority

Government policy can influence which systems receive power during shortages.

This turns Energy into an infrastructure decision rather than a survival meter.

---

# ⚡ Emergency Allocation

Emergency Allocation is the game's active temporary-boost system.

The player can temporarily redirect civilization resources toward a particular goal.

## Example Orders

| Emergency Order | Effect | Example Duration |
|---|---|---:|
| **Industrial Surge** | Industry production massively increased | 60 sec |
| **Labour Mobilization** | Available Labour massively increased | 60 sec |
| **Power Priority** | Energy generation massively increased | 60 sec |
| **Security Lockdown** | Security massively increased | 60 sec |
| **Scientific Emergency** | Research massively increased | 60 sec |

Emergency Orders should become more powerful and specialized as departments and technologies are unlocked.

They should also have consequences.

For example, an Industrial Surge might produce an enormous amount of Materials while pulling Labour and Energy away from other departments.

Repeated emergency use can also increase:

- Unrest
- Worker fatigue
- Infrastructure wear
- Crisis risk

The player should constantly be asking:

> **Use it now, or save it for the next bottleneck?**

---

# 📜 Government Directives

Directives are permanent government policies.

Unlike Emergency Allocation, Directives do not expire.

They change how the civilization operates.

Examples include:

### Industrial

- Industrial Priority
- Five-Year Production Plan
- Mechanization Initiative
- Automated Workforce
- National Manufacturing Act
- Total Industrialization

### Labour

- Worker Training
- Mandatory Service
- Productivity Standards
- Human Optimization
- Engineered Workforce

### Information

- Public Broadcasting
- Civic Information
- Controlled Media
- Unified Narrative
- Information Monopoly
- Total Information Control

### Security

- Expanded Police
- National Surveillance
- Internal Security Act
- Predictive Policing
- Emergency Powers
- Permanent Emergency

### Scientific

- National Science Fund
- Research Priority
- Open Laboratories
- National AI Initiative
- Human Enhancement Program
- Accelerated Evolution

Directives should contain meaningful trade-offs.

For example:

```text
MANDATORY LABOUR

Industrial Production     +25%
Morale                    -10%
Unrest Pressure           +15%
Security Demand           +10%
```

Or:

```text
INDUSTRIAL PRIORITY

Industrial Production     +50%
Civilian Energy           -20%
Dissatisfaction           +5%
```

Or:

```text
INFORMATION CONTROL

Unrest Generation         -20%
Compliance                +15%
Trust                     -10%
```

The player's government should become a reflection of how they chose to solve problems.

---

# 🏛️ Civilization Archetypes

The game should not use traditional character classes.

Instead, the player's **civilization becomes their build**.

Two players can reach the same stage of the game with radically different civilizations.

### Authoritarian Industrial State

Heavy investment in:

- Security
- Surveillance
- Mandatory Labour
- Controlled media
- Industrial production
- Emergency powers

Possible strengths:

- Extremely efficient production
- Low crime
- High Compliance
- Strong crisis suppression

Possible weaknesses:

- Low Trust
- Higher social pressure
- Greater dependence on Security
- Poorer population stability

### Technocratic Civilization

Heavy investment in:

- Research
- Automation
- AI
- Advanced Energy
- Information systems

Possible strengths:

- High worker efficiency
- Strong automation
- Powerful Research
- Lower Labour requirements

Possible weaknesses:

- Massive Energy demand
- Dependence on advanced infrastructure
- Vulnerability to technological failures

### Social Investment Civilization

Heavy investment in:

- Worker conditions
- Morale
- Trust
- Population stability
- Social systems

Possible strengths:

- Low Unrest
- High Morale
- High Trust
- Stable workforce

Possible weaknesses:

- Higher resource expenditure
- Slower short-term industrial expansion
- Greater difficulty exploiting extreme production policies

These are examples, not fixed classes.

The player should create their own civilization through accumulated choices.

---

# 🔬 Technology

Technology is primarily unlocked through Research.

Technology can occasionally provide new production tiers, but its more important role is changing how the civilization functions.

Examples:

### Automation

Factories require less Labour.

### Robotics

Some industrial buildings can operate with minimal human Labour.

### Artificial Intelligence

Production buildings receive autonomous bonuses and departments can eventually allocate Labour automatically.

### Nuclear Power

Massively increases Energy production.

### Fusion

Removes many late-game Energy constraints.

### Genetic Engineering

Increases population growth and worker efficiency.

### Nanotechnology

Introduces advanced Materials.

### Synthetic Workforce

Allows machines to replace a portion of Labour.

### Quantum Computing

Massively increases Research efficiency.

### Matter Manipulation

Endgame production technology.

Technology should increasingly change the rules rather than merely adding larger numbers.

---

# 🧬 Population Growth

Population growth should remain relatively simple compared with a survival simulator.

There are no separate Food, Housing, Healthcare, or Education meters in the core design.

Population growth can instead be influenced by broad civilization conditions:

```text
Base Population Growth
× Morale
× Security
× Social Stability
× Government Modifiers
× Technology
```

Unrest, major crises, and extreme government policies can reduce or disrupt growth.

The important relationship is:

> **Population creates potential Labour, while civilization conditions determine how effectively that potential becomes a workforce.**

A larger population is therefore powerful without requiring the player to micromanage individual citizen needs.

---

# 🏗️ Production Philosophy

The production system should retain the satisfying exponential structure of classic idle games.

A simple early chain might look like:

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

Each tier accelerates the previous tier.

But individual building tiers should not necessarily mean the player owns dozens of separate upgrade trees.

The core production philosophy is:

> **Level Up makes an operation more productive. Build New adds another equivalent operation.**

For a building such as the Scrap Yard:

```text
1 Scrap Yard = ×1
2 Scrap Yards = ×2
3 Scrap Yards = ×3
4 Scrap Yards = ×4
```

This multiplier is cumulative, not compounding.

Certain levels of an operation can also trigger automatic expansion milestones that provide large productivity multipliers.

This preserves the familiar idle-game number growth while making the physical scale of the civilization feel meaningful.

---

# 🧠 Automation

Automation is essential to the idle-game experience.

The player should gradually move from:

**Manual management**

→ **Building automation**

→ **Department automation**

→ **Civilization automation**

→ **AI-directed civilization**

But automation should create new choices rather than simply removing gameplay.

For example:

- Automation reduces Labour requirements.
- Reduced Labour requirements can create unemployment.
- Unemployment can create Unrest.
- AI can reduce the need for human decision-making.
- Reduced human participation can affect Trust.
- Automated systems require Energy and Research.
- Highly automated civilizations become vulnerable to infrastructure or information failures.

The better the technology becomes, the stranger the civilization's problems should become.

---

# 🌍 Progression Scale

The game should gradually move through increasingly large scales.

```text
Scrap Yard
    ↓
District
    ↓
City
    ↓
Region
    ↓
Nation
    ↓
Planetary Civilization
```

The player should never need to leave Earth for the game to feel enormous.

The fantasy is not exploration of the galaxy.

It is watching one ruined planet become completely dominated by the civilization the player built.

---

# 🏛️ Unlock Philosophy

Departments should unlock gradually.

The player should not begin with six tabs and a wall of locked content.

The early game should feel like discovering the systems of the city.

A rough progression might be:

### Early Game

- Population
- Workforce
- Scrap Yards
- Materials
- Basic production

### Developing City

- Production chains
- Energy
- First crises
- Security
- Emergency Allocation

### Industrial Civilization

- Research
- Technology
- Advanced automation
- Population systems
- Government Directives

### Advanced Civilization

- Information control
- Complex social pressures
- AI
- Advanced Energy
- Large-scale crises

### Endgame

- Planetary infrastructure
- Extreme automation
- Civilization-scale government
- Matter manipulation and other exotic technologies
- The Collapse
- Legacy

These stages are placeholders and should be refined during design and prototyping.

---

# ☠️ The Collapse

Eventually, civilization should reach a point where maintaining the current system becomes impossible, unstable, or strategically undesirable.

The player can initiate or endure **The Collapse**.

Collapse is the game's major prestige/reset system, but it should feel fundamentally different from a generic prestige mechanic.

The player should feel that they are ending one civilization and learning from it.

Possible reasons to collapse:

- The civilization has reached a natural technological limit.
- The player has pushed a system too far.
- A civilization-scale crisis becomes unavoidable.
- The player deliberately sacrifices the current civilization to gain Legacy.
- The player wants to rebuild using a radically different strategy.

The Collapse should leave permanent consequences or knowledge behind.

---

# 🏺 Legacy

Legacy is the permanent progression carried between civilizations.

It should represent what survives the collapse:

- Knowledge
- Technology
- Institutional memory
- Permanent upgrades
- Historical discoveries
- New starting options
- New government policies
- New production possibilities

Legacy should make each civilization faster, stranger, and deeper without simply turning every future run into a larger collection of multipliers.

Possible Legacy categories include:

### Industrial Legacy

Improved starting production and manufacturing knowledge.

### Scientific Legacy

Permanent technology discoveries and research advantages.

### Institutional Legacy

New government systems and permanent administrative improvements.

### Cultural Legacy

Improved social systems and civilization stability.

### Historical Legacy

New civilization paths, events, and discoveries.

---

# 🎮 What Should Make The Last City Unique?

The game's identity should ultimately come from the interaction between **idle growth and civilization management**.

The player should experience familiar incremental satisfaction:

> Build → automate → multiply → unlock → prestige → repeat.

But underneath that familiar loop is another question:

> **What kind of civilization did you build to get there?**

The most important systems for achieving this are:

## 1. Unrest

The population reacts to how the civilization is run.

## 2. Crises

Problems emerge from the conditions the player creates.

## 3. Government Decisions

The player can solve problems through investment, reform, technology, manipulation, or suppression.

## 4. Workforce Allocation

The player governs the civilization through percentage-based workforce allocation rather than tedious worker counting.

## 5. Operation Scaling

Production operations become more productive through levels, automatically expand at major milestones, and can be duplicated through additional operations that act as cumulative multipliers.

These systems should create situations where there is no universally optimal choice.

That is the heart of the game.

---

# 🚫 Things To Avoid

The project should actively avoid becoming:

### Six Separate Idle Games

Each department should feed the larger civilization.

### A Spreadsheet Simulator

Complexity should emerge gradually and remain readable.

### A Traditional 4X Strategy Game

The core experience is still idle/incremental.

### A Survival Simulator

The player should not be required to manage individual citizen needs such as food, housing, healthcare, or education.

### A Resource Hoarding Simulator

Resources should interact and create decisions.

### A Simple Good/Evil System

Authoritarian policies should sometimes be effective.

Social investment should sometimes be expensive.

Technology should sometimes create new problems.

There should be trade-offs rather than obvious morality buttons.

### Endless Currency Bloat

Avoid creating dozens of resources simply because another system needs a number.

Whenever possible, existing systems should interact instead.

---

# 🧪 Design Questions Still To Solve

The following questions have now been answered at the **core design level**. Exact formulas, values, and balance will still need to be tested during prototyping.

## Population and Workforce

### 1. How does Population generate Labour?

Population creates potential workforce.

```text
Available Workforce
= Population × Workforce Rate × Workforce Efficiency
```

The player allocates that workforce using department percentage sliders.

The player does not assign fixed numbers of workers.

### 2. How does Population grow?

Population grows naturally and is modified by broad civilization conditions rather than individual survival needs.

Relevant modifiers include:

- Morale
- Security
- Social Stability
- Government policy
- Technology
- Major crises

There are no core Food, Housing, Healthcare, or Education requirements.

### 3. How are workers assigned?

Through **percentage-based allocation sliders**.

If the workforce changes, the assigned worker counts automatically change while the player's percentages remain intact.

Each department's slider displays an efficiency colour:

**Red → Orange → Green → Orange → Red**

The green zone represents the current efficient allocation range and can move as the civilization changes.

### 4. How does worker efficiency work?

Workers provide diminishing returns when a department is pushed beyond its efficient range.

The player is encouraged to find the productive sweet spot rather than simply assigning everything to the department producing the most valuable resource.

---

## Production and Buildings

### 5. What happens when the player buys more of a building?

There are two distinct actions:

**Level Up** improves the productivity of the existing operation.

**Build New** adds another equivalent operation and increases the operation's cumulative multiplier.

For example:

```text
1 building = ×1
2 buildings = ×2
3 buildings = ×3
4 buildings = ×4
```

Additional buildings do **not** compound each other.

### 6. How do building milestones work?

Certain levels automatically trigger major expansion/productivity milestones.

The player does not need a separate Expansion button.

For example, a Scrap Yard might receive a **×2 productivity multiplier** at levels 25, 100, 450, and later milestones.

The exact milestones will be balanced during prototyping.

### 7. How does the Scrap Yard specifically work?

The player starts with one Scrap Yard operation.

The two available actions are:

- **Level Up:** increase the productivity level of the existing operation.
- **Build New:** increase the number of Scrap Yards contributing to the operation.

The player only needs to upgrade one shared Scrap Yard level.

Example:

```text
Level:              450
Scrap Yards:          4×
Milestone bonuses:   ×8
Technology:           ×3
```

The four Scrap Yards operate at the same shared level, so the player never has to manage four separate upgrade trees.

---

## Energy and Security

### 8. How does Energy work?

Energy is a universal infrastructure resource consumed by Industry, Security, Research, Information, and advanced technology.

Energy shortages should trigger load shedding and priority decisions rather than instant destruction.

### 9. How does Security work?

Security is evaluated against the level of Threat.

Conceptually:

```text
Threat
= Population + Unrest + Crime + Inequality + External Threats
```

versus:

```text
Security Capacity
= Security Production × Technology × Government Policy
```

When Threat exceeds Security Capacity, crime, sabotage, and crisis risk increase.

High Security is powerful but can consume Labour, Energy, and Trust.

---

## Social Systems

### 10. How is Unrest generated and recovered?

Unrest is an emergent social pressure influenced by:

- Unemployment
- Poor working conditions
- Inequality
- Forced Labour
- Excessive surveillance
- Low Morale
- Low Trust
- Government policies
- Crises
- Security failures

Unrest recovers through effective governance, negotiation, stability, successful policies, and time.

The player can Negotiate, Suppress, Manipulate, or Ignore problems.

### 11. How do Compliance and Trust relate?

They are separate.

Compliance measures obedience.

Trust measures legitimacy and confidence in the government.

Security and Information can increase Compliance without increasing Trust.

### 12. How does Morale affect productivity?

Morale acts as a production modifier rather than a currency.

Low Morale reduces productivity and can increase Unrest.

High Morale improves productivity and stability.

### 13. How does Inequality work?

Inequality becomes more important in the mid-game.

Higher inequality can create certain economic advantages while increasing Crime, Unrest, and loss of Trust.

Lower inequality supports stability and Trust but may require greater investment.

---

## Crises and Technology

### 14. How are crises generated?

Crisis risk should be partially predictable and connected to civilization conditions.

Examples:

- Power failure risk
- Worker strike risk
- Sabotage risk
- Infrastructure failure risk
- Research accident risk
- Information leak risk

The player should be able to see warning signs and intervene before every crisis.

### 15. What should Technology do?

Technology should primarily **change rules**, not simply add percentage bonuses.

Examples include:

- Automation reducing Labour requirements
- Robotics operating industrial systems
- AI automating allocation
- Nuclear and Fusion power changing Energy constraints
- Synthetic Workforce replacing human Labour
- Nanotechnology changing Materials production
- Quantum Computing changing Research
- Matter Manipulation changing endgame production

### 16. How should production scale?

Production should preserve the exponential feel of classic idle games through:

- Levels
- Milestone multipliers
- Additional building counts
- Production chains
- Automation
- Technology
- Government modifiers

The player should always have multiple layers of progression without needing to manually manage hundreds of identical buildings.

---

## Offline Progress and Automation

### 17. How should Offline Progress work?

The civilization continues while the player is away.

Offline progress should account for:

- Production
- Population growth
- Energy conditions
- Workforce allocation
- Automation
- Social pressure
- Crises

On return, the player should receive a civilization report rather than simply a large resource number.

Example:

```text
12 hours have passed.

Materials        +4.2B
Research         +18.4M
Population       +42,000

Two factories temporarily shut down.
Industrial unrest increased.
A security incident was contained.
Civilization remains stable.
```

### 18. When should Automation unlock?

Automation should progress gradually:

```text
Manual management
        ↓
Building automation
        ↓
Department automation
        ↓
Civilization automation
        ↓
AI-directed civilization
```

The player should gradually surrender control as the civilization becomes more advanced.

---

## Emergency Allocation and Government

### 19. What should Emergency Allocation cost?

Emergency actions should have a meaningful immediate cost and a civilization-level cost.

Possible costs include:

- Energy
- Worker fatigue
- Infrastructure wear
- Unrest
- Crisis risk

Emergency Allocation should be powerful enough to be tempting but dangerous enough that it cannot simply be spammed.

### 20. How should Directives work?

Every Directive should answer:

> **What are you willing to sacrifice for this advantage?**

Directives should create meaningful trade-offs rather than being simple upgrades.

### 21. How should Government types emerge?

The game should not force the player to select a class at the beginning.

Government identity should emerge from accumulated Directives and decisions.

A player can gradually become authoritarian, technocratic, socially focused, industrialist, or something more unusual.

---

## Collapse and Legacy

### 22. When should Collapse happen?

Collapse should not simply occur when a single meter reaches 100%.

It should become a strategic choice or an unavoidable consequence of pushing the civilization too far.

The player may continue the current civilization or sacrifice it for a stronger Legacy run.

### 23. What is Legacy?

Legacy represents knowledge and institutional memory that survives the Collapse.

Possible categories include:

- Industrial Legacy
- Scientific Legacy
- Institutional Legacy
- Cultural Legacy
- Historical Legacy

Legacy should provide new possibilities, not just permanent numerical multipliers.

### 24. What carries between civilizations?

Carries:

- Knowledge
- Technology discoveries
- Legacy upgrades
- Government unlocks
- Historical discoveries
- Permanent automation improvements
- New starting options
- New civilization paths

Does not carry:

- Population
- Buildings
- Materials
- Energy
- Current Workforce
- Current Security
- Current Unrest
- Temporary Directives

The new civilization starts over, but the player is smarter.

---

# 🛠️ Current Development Philosophy

This project is currently about **figuring out the game before building the game**.

The priority is:

1. Establish the core fantasy.
2. Define the systems that make the game unique.
3. Map the relationships between those systems.
4. Determine the player experience from the first minute through the first Collapse.
5. Prototype the smallest possible version.
6. Test whether the core loop is actually fun.
7. Expand only after the foundation works.

The first prototype does not need all six departments.

It needs to prove that this loop works:

```text
Idle Production
      ↓
Growth
      ↓
New Problem
      ↓
Player Decision
      ↓
Economic Consequence
      ↓
Social Consequence
      ↓
New Growth
```

If that loop is fun, The Last City has something worth building.

---

# 📌 One-Sentence Vision

> **The Last City is an idle civilization builder where exponential economic growth creates social and political problems that the player must solve, exploit, or suppress.**

---

# 📌 The Long-Term Fantasy

> **I started with a scrap yard.**
>
> **Now I control the last functioning civilization on Earth.**
>
> **And somehow, keeping it alive is harder than building it.**
