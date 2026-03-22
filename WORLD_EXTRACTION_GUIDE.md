# StoryWorlds: Fictional Work → MUD Extraction Guide

How to decompose any book, film, or artwork into GoMUD content. This is the master checklist for converting a fictional work into a playable zone.

---

## 1. PLACES → Rooms

Every distinct location in the work becomes a room. Think about it as: "where does the camera linger?" or "where does the author spend a paragraph describing?"

### What to extract:
- **Named locations** — every place that has a name or is revisited
- **Transitional spaces** — hallways, paths, roads that connect major locations
- **Hidden/secret areas** — places characters discover or that are revealed later
- **Elevation changes** — towers, basements, cliffs, underwater (up/down exits)
- **Interior vs exterior** — a castle has an exterior courtyard AND interior rooms

### How to map it:
| Narrative Element | GoMUD Mechanic |
|---|---|
| Named location | Room YAML with title + rich description |
| How places connect physically | Exits (8 cardinal + up/down + custom named) |
| A place you can see but not yet reach | Custom named exit that's locked or quest-gated |
| A hidden place | Secret exit (`secret: true`, found via `search`) |
| A place that appears only sometimes | Temporary exit via script (`room.AddTemporaryExit`) |
| A place that requires an item to enter | Script checks `user.HasItemId()` before allowing movement |
| A place that only opens at certain times | Script checks `UtilIsDay()` or `UtilGetTime()` |
| A dangerous or cursed area | Mutator that applies buffs (poison, freezing, fire) |
| A dark or underground area | Biome: cave/dungeon/spiderweb (requires lightsource) |
| Weather or environmental mood | Zone-level `idlemessages` + room-level `idlemessages` |
| A place that changes over time | Mutators that spawn/decay, or `SetPermData` tracking state |
| A place you can only visit once | Script checks `user.GetMiscCharacterData()` and blocks re-entry |
| An instanced/private experience | `CreateInstancesFromRoomIds()` for solo dream sequences etc. |

### Spatial layout principles:
- **Sketch a top-down map first.** Place the entry room, then radiate outward.
- Use **cardinal directions that make geographic sense.** If a forest is west of a village, the exit from the village should be `west`.
- **Don't force a grid.** Use custom named exits for non-geographic connections: `enter cave`, `climb tree`, `dive`, `cross bridge`.
- **Use `exitmessage`** for dramatic transitions: "You push through the thick undergrowth and emerge into..."
- **Map symbol + legend** for every room — players use `map` command to orient themselves.
- **Biome per room** — matches the visual/atmospheric feel (forest, city, cave, water, etc.).

### Room description principles:
- Write in **second person present tense** ("You stand at...", "Before you stretches...")
- Embed **lookable nouns** in the description using `<ansi fg="itemname">noun</ansi>` tags
- Include **sensory details**: sight, sound, smell, touch, temperature
- Reference **visible exits** narratively ("A path winds north into the trees")
- Reference **NPCs present** with `<ansi fg="mobname">name</ansi>` tags
- Keep to **3-6 sentences** — enough to paint the scene, short enough to read on re-entry

---

## 2. CHARACTERS → Mobs

Every named character, creature, or significant presence becomes a mob. Think: "who would the player want to talk to, fight, or watch?"

### What to extract:
- **Named characters** — protagonists, antagonists, supporting cast
- **Unnamed but memorable types** — guards, merchants, creatures, crowds
- **Creatures/monsters** — anything the player might encounter or fight
- **Atmospheric presences** — animals, spirits, background characters that add life
- **Character relationships** — who likes/hates whom, alliances, rivalries

### How to map it:

| Narrative Element | GoMUD Mechanic |
|---|---|
| Named character with dialogue | Mob YAML + `onAsk` script for topic-based conversation |
| Character's appearance | Mob `description` field |
| Character personality/voice | `idlecommands` (say/emote lines), `onAsk` response style |
| Character who moves around | `maxwander` + `wander` in idlecommands, or `pathto` patrol |
| Character who stays put | `maxwander: 0`, spawn in specific room only |
| Friendly NPC | `hostile: false`, `hateraces: []`, `angrycommands: []` |
| Enemy/hostile creature | `hostile: true` or `forcehostile` in spawninfo |
| Boss character | Higher `level`, `combatcommands`, unique death script `onDie` |
| Character who gives quests | `questflags` in spawninfo, `onAsk`/`onGive` scripts |
| Character who sells things | `shop` block in mob YAML (items, buffs, pets) |
| Character who teaches skills | Room `skilltraining` or script-driven `user.TrainSkill()` |
| Character relationships | `conversations/<zone>/` YAML for ambient dialogue between NPCs |
| Character who reacts to items | `onShow` (react to being shown item) and `onGive` (react to receiving) |
| Character who changes based on story progress | `scripttag` for alternate scripts, or `GetTempData` branching |
| A guide/companion who follows you | `mob.CharmSet(userId, rounds)` — follows and teleports to player |
| Character who appears only at certain times | Spawn via room script checking `UtilIsDay()` or quest state |
| Group of characters (crowd/army/flock) | Multiple mobs spawned in same room, or single mob described as group |

### Character depth checklist:
For each major character, define:
1. **3-5 `idlecommands`** — things they say/do when idle (with `""` pauses between)
2. **3-5 `onAsk` topics** — subjects the player can ask about (story lore, directions, other characters)
3. **1 `onShow` reaction** — what happens when player shows them a significant item
4. **1 `onGive` reaction** — what happens when player gives them something
5. **Physical placement** — which room(s) they appear in, whether they wander
6. **Relationship mapping** — which other mobs they have conversations with

### NPC-to-NPC Conversations:
For each pair of characters who interact, create a conversation YAML:
```yaml
Supported:
  "character a": "character b"
Actions:
  - ["#1 sayto #2 dialogue line", "#2 emote reacts"]
  - ["#2 sayto #1 response", "#1 emote reaction"]
```
This creates ambient world-building that plays out when both characters are in the same room.

---

## 3. OBJECTS → Items

Every significant object, artifact, tool, or prop becomes an item. Think: "what would the player want to pick up, use, or interact with?"

### What to extract:
- **Plot-critical objects** — the ring, the sword, the map, the key
- **Iconic props** — things associated with a character or scene
- **Weapons and armor** — if combat exists in the world
- **Consumables** — food, drink, potions that appear in the story
- **Readable materials** — letters, books, inscriptions, signs
- **Keys and access items** — objects that unlock progression
- **Collectible souvenirs** — memorable items players can take home to the Library

### How to map it:

| Narrative Element | GoMUD Mechanic |
|---|---|
| Plot-critical object | Item with `questtoken` linking to quest progression |
| Iconic weapon | Weapon item with thematic `damage.diceroll` and `description` |
| Iconic clothing/armor | Armor item in appropriate slot with thematic `statmods` |
| A key that opens something | Key item with `keylockid` matching a locked exit |
| A letter/book/inscription | `type: readable`, `subtype: blobcontent`, with `onCommand_read` script |
| Food or drink from the world | Consumable with `buffids` (well-fed, drunk, poisoned, etc.) |
| A magical/special object | `type: object`, `subtype: usable`, with `onCommand_use` script |
| An object that does something when held | `wornbuffids` — applies buff while equipped |
| An object that reveals hidden things | Buff with `see-hidden` or `see-nouns` flag |
| An object that lights the way | Buff with `lightsource` flag |
| A cursed object | `cursed: true` — can't be unequipped normally |
| An object with limited uses | `uses: N` — depletes with use |
| An object that changes the environment | Script that calls `room.AddMutator()` or `room.AddTemporaryExit()` |
| A collectible/souvenir | Item with unique description, player brings back to Library |
| A musical instrument | Script with `onCommand_play` that triggers effects |
| A container of other things | `onCommand_open` script that calls `user.GiveItem(CreateItem(id))` |

### Object function categories:
1. **Portal objects** — transport player (our books/films/paintings, but also in-world portals like wardrobes, mirrors, doors)
2. **Progression objects** — keys, quest items, access tokens that gate movement
3. **Atmosphere objects** — readable lore, letters, signs that deepen the world
4. **Interaction objects** — things that respond to custom verbs (play, ring, shake, pour)
5. **Equipment objects** — wearable/wieldable items that change player capabilities
6. **Consumable objects** — food/drink/potions with temporary effects
7. **Souvenir objects** — collectibles that represent the world

---

## 4. SCENES → Scripted Events

Key scenes from the work become scripted interactions. Think: "what are the iconic moments a player would want to experience?"

### What to extract:
- **Iconic scenes** — moments everyone remembers from the work
- **Turning points** — plot moments that change the story's direction
- **Puzzles/challenges** — obstacles characters overcome
- **Revelations** — moments of discovery or understanding
- **Confrontations** — dramatic encounters (not necessarily combat)

### How to map it:

| Narrative Element | GoMUD Mechanic |
|---|---|
| Iconic scene that plays out | Room `onEnter` script with atmospheric text |
| Scene triggered by player action | `onCommand` script responding to custom verb |
| A puzzle to solve | Script checks for correct sequence of commands, unlocks exit/reward |
| A revelation/discovery | `onCommand_look` or `onCommand_search` revealing hidden content |
| A confrontation with a character | Mob `onAsk` or `onCommand` branching dialogue with consequences |
| A timed event | `UtilGetTime()` checks — scene only available at certain game-time |
| A scene with multiple outcomes | `user.SetMiscCharacterData()` to track choice, branch future interactions |
| A scene requiring an item | `user.HasItemId()` check before triggering scene content |
| A scene that changes the world | `room.SetPermData()` for permanent state change, mutator add/remove |
| A multi-stage sequence | Quest with ordered steps, each room advancing the quest |
| An overheard conversation | NPC-to-NPC conversation YAML that triggers when player is present |
| A recurring event | Room `onIdle` script or mutator with `respawnrate` |
| A choice that affects alignment | `user.ChangeAlignment(delta)` based on player decision |

### Scene design principles:
- **Don't force linearity.** Let players discover scenes in any order when possible.
- **Reward exploration** with hidden scenes (secret exits, item-gated rooms).
- **Use idle messages** to foreshadow scenes before the player triggers them.
- **Layer sensory details** — what you see, hear, smell, feel in the moment.
- **Let NPCs react** to player presence during scripted moments.

---

## 5. ATMOSPHERE → Environmental Systems

The overall mood, tone, and sensory feel of the work becomes environmental design. Think: "what does it feel like to BE in this world?"

### What to extract:
- **Weather/climate** — rain, snow, heat, storms, fog
- **Time of day significance** — scenes that happen at dawn, midnight, etc.
- **Sensory palette** — dominant colors, sounds, smells, textures
- **Emotional tone** — whimsical, foreboding, melancholy, adventurous
- **Environmental hazards** — things that can hurt or affect the player
- **Music/sound** — if the work has a soundtrack or sound associations

### How to map it:

| Narrative Element | GoMUD Mechanic |
|---|---|
| Constant weather (always rainy) | Zone-level `idlemessages` describing rain + mutator with buff |
| Weather that changes | Mutator with `spawndayonly`/`spawnnightonly` or `decayrate` |
| Darkness/underground | Biome: cave/dungeon (requires lightsource buff) |
| Underwater | Biome: water (requires swimming item) |
| Extreme cold | Mutator applying freezing buff to players |
| Extreme heat | Mutator applying thirsty/dehydration buff |
| Fire/burning | Wildfire mutator (applies on-fire buff, `decayrate`) |
| Poison/corruption | Mutator applying poison buff |
| Background music | `musicfile` on zone-config or per-room |
| Sensory atmosphere | 5+ `idlemessages` per room covering different senses |
| A world that feels alive | NPC-to-NPC conversations + mob `idlecommands` + wandering mobs |
| Time-sensitive atmosphere | Room script `onIdle` that varies messages by `UtilIsDay()` |
| Visual style (for art worlds) | ANSI color theming in descriptions using color patterns |

### Idle message design (aim for 5+ per room):
1. **A sight** — something the player sees (movement, light, color)
2. **A sound** — something the player hears (dialogue, nature, machinery)
3. **A smell or physical sensation** — temperature, texture, scent
4. **NPC/creature activity** — background characters doing things
5. **Environmental change** — weather shifting, light changing, something moving

---

## 6. NARRATIVE ARC → Quest System

The story's plot becomes a quest or series of quests. Think: "what is the player's journey through this world?"

### What to extract:
- **Main storyline** — the central conflict/journey
- **Side stories** — subplots, character arcs, optional adventures
- **Fetch quests** — objects that need to be found and delivered
- **Exploration goals** — places that need to be discovered
- **Character interactions** — conversations that advance understanding

### How to map it:

| Narrative Element | GoMUD Mechanic |
|---|---|
| Main quest line | Multi-step quest YAML with ordered stages |
| Optional side quest | Separate quest YAML, triggered by NPC or discovery |
| "Find the thing" | Quest step completed by obtaining item (`questtoken`) |
| "Go to the place" | Quest step completed by entering room (`questflags` on mob/room) |
| "Talk to the person" | Quest step completed by asking mob about topic (`onAsk` advances quest) |
| "Defeat the enemy" | Quest step completed by killing mob (tracked via `GetMobKills`) |
| "Make a choice" | Branching via `SetMiscCharacterData`, different outcomes |
| Quest rewards | Experience, gold, items, skills, buffs, access to new areas |
| Secret/hidden quest | `secret: true` in quest YAML — not shown in quest log |
| Lore collection | Readable items scattered through zone, tracked via persistent data |

### Quest design for StoryWorlds:
- **Primary quest** = "Experience the story" — visit key locations, meet key characters, witness key scenes. Completing it grants a souvenir item and XP.
- **Secret quests** = Deep-cut references and easter eggs for fans who know the work well.
- **Don't require combat** for primary quest completion (combat-optional design).

---

## 7. RELATIONSHIPS → Conversation System

Character dynamics become the conversation and dialogue systems. Think: "how do characters feel about each other, and how does the player learn about it?"

### What to extract:
- **Alliances** — who works together
- **Rivalries** — who opposes whom
- **Mentorship** — who teaches/guides whom
- **Romance** — love interests and tensions
- **Hierarchy** — who has power over whom
- **Secret connections** — hidden relationships

### How to map it:

| Narrative Element | GoMUD Mechanic |
|---|---|
| Two characters who talk to each other | Conversation YAML with dialogue |
| Character who gossips about another | `onAsk` script: ask about character X reveals info |
| Character who hates another character | `hates` list in mob YAML or hostile `onIdle` when both present |
| Character who follows/serves another | Mob with `pathto` patrol tracking another mob's location |
| Character duo (always together) | Both spawned in same room, conversation YAML between them |
| Hidden relationship revealed by item | `onShow` script: showing specific item triggers revelation dialogue |
| Relationship that changes | `scripttag` alternate scripts based on quest/story progress |

---

## 8. THEMES → Mechanical Expression

The work's deeper themes and motifs can be expressed through game mechanics. Think: "what is this story really about, and how can the player feel that?"

### How to map it:

| Theme | Mechanical Expression |
|---|---|
| Identity/transformation | Items that change player stats, buffs that alter perception |
| Power and corruption | Alignment system — choices shift player toward good or evil |
| Journey/homecoming | Quest arc from entry → exploration → climax → return to Library |
| Isolation/loneliness | Rooms with no NPCs, idle messages emphasizing emptiness |
| Community/belonging | Many NPCs, rich conversations, rooms full of activity |
| Time/mortality | `UtilGetTime()` mechanics, events that only happen once |
| Nature vs civilization | Biome contrasts (forest↔city), mutators (wildfire, growth) |
| Knowledge/discovery | Secret exits, hidden rooms, readable lore items, see-nouns buff |
| Madness/chaos | Contradictory idle messages, rooms that don't connect logically |
| Order/control | Strict room layouts, patrol routes, locked exits, hierarchy |

---

## Master Extraction Checklist

When adding a new fictional work, complete this checklist:

### Pre-work
- [ ] Identify the **entry point** — where does the player arrive in this world?
- [ ] Sketch a **rough map** of 5-20 key locations and how they connect
- [ ] List **5-10 major characters** with one sentence describing each
- [ ] List **3-5 iconic objects** that are central to the work
- [ ] List **3-5 iconic scenes** the player should experience
- [ ] Identify the **primary sensory palette** (colors, sounds, smells)
- [ ] Identify the **emotional tone** (whimsical, dark, adventurous, etc.)
- [ ] Choose a **biome** (or biomes) that match the world

### Build
- [ ] **Zone config** — name, root room, biome, zone-level idle messages
- [ ] **Entry room** — with `onEnter` arrival text and `return` command handler
- [ ] **All rooms** — title, description, exits, nouns, idle messages, biome, map symbol
- [ ] **All room scripts** — `return` handler in every room, custom verb interactions
- [ ] **Major character mobs** — descriptions, idle commands, ask topics, conversations
- [ ] **Mob scripts** — `onAsk`, `onShow`, `onGive`, `onIdle` for key characters
- [ ] **Conversation YAMLs** — ambient NPC-to-NPC dialogue for character pairs
- [ ] **Key items** — portal item for Library, quest items, keys, souvenirs, readables
- [ ] **Item scripts** — custom verb handlers for special objects
- [ ] **Quest(s)** — primary story quest + optional secret quests
- [ ] **Mutators** — environmental effects unique to this world
- [ ] **Portal item** — book/reel/painting in Library that transports player here
- [ ] **Spawn the portal** — add spawninfo to appropriate Library room

### Polish
- [ ] **5+ idle messages per room** — covering sight, sound, smell, NPC activity, environment
- [ ] **3+ idle commands per major NPC** — with pauses between
- [ ] **Nouns for lookable objects** in every room description
- [ ] **Sensory consistency** — same palette of colors/sounds/smells throughout zone
- [ ] **At least one secret** — hidden room, easter egg, or deep-cut reference
- [ ] **Souvenir item** — something the player can bring back to the Library
- [ ] **Test walk-through** — enter from Library, visit all rooms, interact with all NPCs, complete quest, return
