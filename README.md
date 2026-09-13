# ⚙️ THE LAST CITY

> **An idle civilization builder where exponential economic growth creates social and political problems that the player must solve, exploit, or suppress.**

The Last City is a dystopian steampunk incremental game about rebuilding the last functioning civilization on Earth.

Start with a single scrap yard.

Assign workers.

Process the ruins into useful materials.

Build a functioning city.

Then discover that keeping millions of people alive requires energy, security, science, information, and increasingly questionable government decisions.

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

Population growth creates a larger workforce while also creating greater demands for food, energy, housing, security, and infrastructure.

The player is constantly balancing three overlapping games:

### 1. The Idle Machine

Production chains, automation, multipliers, exponential growth, offline progress, upgrades, and prestige.

### 2. The Civilization

Population, Labour, Energy, Security, Research, Compliance, housing, infrastructure, unrest, morale, and other social pressures.

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

- Assign workers
- Build production facilities
- Expand population
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
Population + Labour
        ↓
Assign Labour to Scrap Yards
        ↓
Produce Materials
        ↓
Purchase Production Buildings
        ↓
Buildings produce lower-tier buildings
        ↓
Expand Housing and Infrastructure
        ↓
Population grows
        ↓
More Population → More Labour
        ↓
Unlock new Departments
        ↓
Create interconnected production chains
        ↓
Manage Energy, Security, Research and Compliance
        ↓
Manage Unrest and other social pressures
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

Citizens provide the potential workforce of the civilization, but they also create demands.

Population growth can require:

- Housing
- Food
- Energy
- Security
- Healthcare
- Infrastructure
- Employment
- Social stability

As the civilization grows, population becomes both an enormous economic advantage and an enormous responsibility.

## Labour

Labour is an allocated resource rather than something that is simply spent.

Example:

```text
Population:        100
Available Labour:  100

Scrap Yard:         25 workers
Workshop:           15 workers
Power Station:      20 workers
Security:           10 workers
Research:            5 workers

Unassigned Labour:  25
```

Moving workers between departments changes production.

This creates meaningful decisions even before the deeper government systems appear.

## Materials

Materials are produced by the Industrial Authority.

The initial production loop is:

```text
Population
    ↓
Labour
    ↓
Scrap Yard
    ↓
Materials
    ↓
Buildings
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

---

# 👷 Ministry of Labour

**Primary Resource:** Labour

**Core Systems:**

- Workforce allocation
- Population growth
- Worker efficiency
- Education
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
Professional Academy
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
- Mandatory Education
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

Medicine → Genetics → Augmentation → Synthetic Biology

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
Civic Education Bureau
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

## Example: The Labour Problem

Suppose the civilization needs more Labour.

The player might:

### Improve Living Conditions

- Build housing
- Improve healthcare
- Increase food production
- Increase education
- Improve worker efficiency

**Result:**

Population ↑

Labour availability ↑

Unrest ↓

Production ↑

Cost ↑↑

### Introduce Mandatory Labour

- Increase required working hours
- Force population into critical industries
- Reduce worker freedom

**Result:**

Labour ↑↑

Production ↑

Unrest ↑

Security demand ↑

### Invest in Automation

- Research robotics
- Build automated infrastructure
- Replace workers with machines

**Result:**

Labour requirement ↓

Production ↑

Research demand ↑

Energy demand ↑

Potential unemployment and social unrest ↑

There is no single correct answer.

The player is choosing what kind of civilization they are building.

---

# 🔥 Unrest

**Unrest is not just another number.**

It should be an emergent consequence of the player's economic, social, and governmental decisions.

Unrest can be influenced by:

- Poor working conditions
- Food shortages
- Housing shortages
- Unemployment
- Excessive taxation or resource extraction
- Forced labour
- Excessive surveillance
- Inequality
- Government propaganda
- Security policy
- Population growth
- Major crises
- Previous government decisions

High Unrest can cause:

- Strikes
- Riots
- Sabotage
- Reduced productivity
- Infrastructure damage
- Government instability
- Production interruptions
- Major crises

But the player can respond in different ways.

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

# 🧨 Crises

The city should occasionally experience crises.

Possible crises include:

- Worker strikes
- Power shortages
- Factory fires
- Disease outbreaks
- Infrastructure failures
- Food shortages
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

The goal is for crises to feel like consequences of running a civilization rather than random events pasted onto an idle game.

---

# ⚡ Emergency Allocation

Emergency Allocation is the game's active temporary-boost system.

Energy accumulates over time into an emergency reserve.

The player can spend that reserve to temporarily redirect civilization resources toward a particular goal.

## Example Orders

| Emergency Order | Effect | Example Duration |
|---|---|---:|
| **Industrial Surge** | Industry production massively increased | 60 sec |
| **Labour Mobilization** | Available Labour massively increased | 60 sec |
| **Power Priority** | Energy generation massively increased | 60 sec |
| **Security Lockdown** | Security massively increased; movement restricted | 60 sec |
| **Scientific Emergency** | Research massively increased | 60 sec |

Emergency Orders should become more powerful and more specialized as departments and technologies are unlocked.

They should also have consequences.

For example:

> **Industrial Surge** may produce an enormous amount of Materials, but pulling Labour away from Security and Research could create a future crisis.

The player should constantly be asking:

> **Use it now, or save it for the next bottleneck?**

---

# 📜 Government Directives

Directives are permanent government policies.

They are purchased using a permanent government resource such as Authority.

Unlike Emergency Allocation, Directives do not expire.

They change how the civilization operates.

## Industrial Directives

- Industrial Priority
- Five-Year Production Plan
- Mechanization Initiative
- Automated Workforce
- National Manufacturing Act
- Total Industrialization

## Labour Directives

- Universal Education
- Worker Training
- Mandatory Service
- Productivity Standards
- Human Optimization
- Engineered Workforce

## Information Directives

- Public Broadcasting
- Civic Education
- Controlled Media
- Unified Narrative
- Information Monopoly
- Total Information Control

## Security Directives

- Expanded Police
- National Surveillance
- Internal Security Act
- Predictive Policing
- Emergency Powers
- Permanent Emergency

## Scientific Directives

- National Science Fund
- Research Priority
- Open Laboratories
- National AI Initiative
- Human Enhancement Program
- Accelerated Evolution

Directives should contain meaningful trade-offs.

A stronger state should not simply be a stronger state.

For example, a policy might:

- Increase industrial output
- Increase Energy consumption
- Reduce population growth
- Increase Unrest
- Reduce Trust
- Increase Compliance
- Reduce another department's effectiveness

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
- Poorer population growth

### Technocratic Civilization

Heavy investment in:

- Research
- Education
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

### Welfare Civilization

Heavy investment in:

- Housing
- Healthcare
- Food
- Education
- Population growth
- Worker conditions

Possible strengths:

- Large population
- Low Unrest
- High Morale
- Large potential workforce

Possible weaknesses:

- Huge resource consumption
- Greater infrastructure requirements
- Difficult late-game population management

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

Some industrial buildings can operate without workers.

### Artificial Intelligence

Production buildings receive autonomous bonuses.

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

# 🧬 Population and Social Growth

Population growth should become increasingly complicated as civilization advances.

Early population growth can be relatively simple.

Later, it should depend on factors such as:

```text
Housing
Food
Energy
Healthcare
Security
Employment
Morale
Unrest
Government Directives
Technology
```

This creates an important design tension:

> **A larger population gives you more Labour, but every new citizen also creates another set of needs the civilization must satisfy.**

Population should therefore feel powerful without becoming an automatic free upgrade.

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

Eventually, the player moves from manually managing individual buildings to managing enormous automated production networks.

The scale should become absurd.

A player who once worried about whether they could afford their second Scrap Yard should eventually be worrying about whether a planetary industrial network can supply enough Materials to maintain civilization.

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
- Reduced Labour requirements create unemployment.
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
- Labour
- Scrap Yards
- Materials
- Basic construction
- First housing

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

### A Resource Hoarding Simulator

Resources should interact and create decisions.

### A Simple Good/Evil System

Authoritarian policies should sometimes be effective.

Democratic or welfare policies should sometimes be expensive.

Technology should sometimes create new problems.

There should be trade-offs rather than obvious morality buttons.

### Endless Currency Bloat

Avoid creating dozens of resources simply because another system needs a number.

Whenever possible, existing systems should interact instead.

---

# 🧪 Design Questions Still To Solve

The following systems need proper formulas and balancing during the design/prototyping phase:

- How Population generates Labour
- Population growth rates
- Housing requirements
- Food and basic needs
- Worker assignment efficiency
- Energy consumption and shortages
- Security calculations
- Unrest generation and recovery
- Compliance and Trust relationships
- Morale and productivity
- Inequality
- Crisis probability and severity
- Technology costs and effects
- Production scaling
- Offline progress
- Automation thresholds
- Emergency Allocation costs
- Directive trade-offs
- Collapse timing
- Legacy progression
- What carries between civilizations

These should be treated as design problems rather than implementation assumptions.

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
