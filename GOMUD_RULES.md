# GoMUD Strict Naming & Format Rules

These rules are enforced by the engine at load time. Violating ANY of them causes a PANIC and the server won't start. Learned the hard way.

## 1. File Naming Convention

ALL data files must match `{id}-{ConvertForFilename(name)}.yaml`

**ConvertForFilename algorithm:**
- Lowercase everything
- Skip/remove apostrophes entirely (`'` → nothing)
- Replace anything that isn't a-z or 0-9 with underscore `_`

**Examples:**
| Name Field | Expected Filename |
|---|---|
| `Alice's Adventures in Wonderland` | `101-alices_adventures_in_wonderland.yaml` |
| `The Odyssey` | `102-the_odyssey.yaml` |
| `Blade Runner film reel` | `103-blade_runner_film_reel.yaml` |
| `piece of chalk` | `111-piece_of_chalk.yaml` |
| `Beetlejuice's business card` | `112-beetlejuices_business_card.yaml` |
| `Day-O banana` | `116-day_o_banana.yaml` |
| `a Sandworm` | `29-a_sandworm.yaml` |
| `the Mad Hatter` | `11-the_mad_hatter.yaml` |

**This applies to:** items, mobs, quests, mutators, buffs, spells, races, pets.

**Script files** follow the same pattern but with `.js` extension: `{id}-{name}.js`

**Mob scripts** go in `scripts/` subfolder within the mob zone folder: `mobs/{zone}/scripts/{id}-{name}.js`

## 2. Item Folder by ID Range

The engine determines item folder from the `itemid`:
| ID Range | Folder | Notes |
|---|---|---|
| 0-9999 | `other-0/` | Keys, quest items, readables, usable objects |
| 10000-19999 | `weapons-10000/` | Weapons only |
| 20000-29999 | `armor-20000/{type}/` | Armor, subfolder by slot (body, head, feet, etc.) |
| 30000+ | `consumables-30000/` | Potions, food, drinks, botanicals |

**Our items MUST use IDs < 10000** to stay in `other-0/`. Currently using 101-199.

## 3. Zone Folder Names

Zone folder names must match the zone config `name:` field, lowercased with spaces → underscores.

| Zone Config Name | Folder Must Be |
|---|---|
| `The Grand Library` | `the_grand_library/` |
| `Beetlejuice` | `beetlejuice/` |
| `Wonderland` | `wonderland/` |
| `Frost Lake` | `frost_lake/` |

## 3b. Containers Required for Container Spawns

If spawninfo uses `container: name`, the room MUST have a matching `containers:` block. Without it, items spawn invisibly and players can't retrieve them.

```yaml
# CORRECT — container defined, items accessible
containers:
  shelves: {}
spawninfo:
- itemid: 101
  container: shelves
  respawnrate: 1 real minutes

# WRONG — no containers block, items spawn but are unreachable
spawninfo:
- itemid: 101
  container: shelves
  respawnrate: 1 real minutes
```

Containers can also have locks: `shelves: {lock: {difficulty: 5}}`

Players interact with: `look in shelves`, `get item from shelves`, `put item in shelves`

## 4. Mob YAML Structure

Mobs use a NESTED `character:` block. Name, description, race, and level are NOT top-level fields.

```yaml
# CORRECT
mobid: 20
zone: beetlejuice
hostile: false
maxwander: 0
angrycommands: []
character:
  name: Adam Maitland
  description: >-
    A tall thin man in plaid flannel...
  raceid: 1
  level: 5

# WRONG - causes unmarshal error
mobid: 20
name: Adam Maitland        # NOT a top-level field
description: A tall man...  # NOT a top-level field
race: 1                     # wrong key name, wrong level
level: 5                    # NOT a top-level field
```

**Top-level mob fields:** `mobid`, `zone`, `hostile`, `maxwander`, `activitylevel`, `groups`, `hates`, `idlecommands`, `angrycommands`, `combatcommands`, `scripttag`, `questflags`, `itemdropchance`, `character`

**Under `character:`:** `name`, `description`, `raceid`, `level`, `alignment`, `gold`, `equipment`, `items`, `shop`, `spellbook`

**There is no `hateraces` field.** Use `hates:` (takes group name strings, not race IDs).

## 5. Room Nouns Format

Nouns are flat `key: string` pairs, NOT nested maps.

```yaml
# CORRECT
nouns:
  desk: A grand oak reception desk worn smooth by countless hands.
  fountain: >-
    A marble fountain with mercury-colored water that flows
    upward instead of down.

# WRONG - causes unmarshal error
nouns:
  desk:
    description: A grand oak reception desk...
```

## 6. Room Signs

The `sign:` field is `[]Sign` (array of Sign structs with VisibleUserId, DisplayText, Expires). Signs are created at RUNTIME via the `scribe` command. **Do NOT put sign/signtext blocks in room YAML files.** Use room descriptions, readable items, or NPC dialogue for welcome text instead.

## 7. Room Exits

Standard exit names: `north`, `south`, `east`, `west`, `northeast`, `northwest`, `southeast`, `southwest`, `up`, `down`

Custom named exits are any other string. They work as commands the player types.

Exit value is always a map: `{roomid: N}` with optional `secret`, `lock`, `exitmessage`, `mapdirection`.

```yaml
exits:
  north:
    roomid: 101
  enter:
    roomid: 103
    exitmessage: You push open the heavy door and step inside.
  trapdoor:
    roomid: 200
    secret: true
```

## 8. SpawnInfo Format

```yaml
spawninfo:
- mobid: 20                    # OR itemid: 101
  message: "spawn message"     # shown when entity spawns
  respawnrate: 3 real minutes  # respawn timing
  maxwander: 2                 # how far from spawn room
  idlecommands:                # what the mob says/does
  - say Hello there!
  - ""                         # empty string = pause/do nothing
  - emote waves
  - wander                     # move to adjacent room
  container: shelves           # for items: spawn inside container
  forcehostile: true           # override mob's hostile setting
```

## 9. Conversation YAML Format

```yaml
-
  Supported:
    "character a": ["character b"]    # initiator → [participants]
  Conversation:
    - ["#1 sayto #2 Hello there."]
    - ["#2 emote nods", "#2 sayto #1 Good day."]
```

Character names in Supported must be **lowercase** and match the mob's `character.name` field exactly (lowercased).

## 10. Quest YAML Format

```yaml
questid: 10
name: The Ghost with the Most
description: >-
  Quest description here.
secret: true                   # optional: hidden from quest log
reward:
  experience: 5000
  gold: 100
  item_id: 115
  playermessage: "Completion message."
steps:
- description: Step 1 description.
- description: Step 2 description.
```

Quest filename must match: `{questid}-{ConvertForFilename(name)}.yaml`

## 11. NPC Wander Rules

`maxwander` controls how many rooms from their spawn point a mob can travel. This MUST be thematically appropriate:

- **maxwander: 0** — NPC stays in their spawn room. Use for: characters tied to a location (Adam at his workbench, Juno at her desk, a receptionist, a shopkeeper, a sandworm in its desert).
- **maxwander: 1** — NPC moves to adjacent rooms only. Use for: domestic characters who move through a house, guards who patrol a small area.
- **maxwander: 2+** — NPC roams freely. Use VERY sparingly. Verify the mob can't wander into thematically wrong zones (e.g., a sandworm leaving Saturn to appear in the waiting room).

**Critical:** If a mob has `maxwander > 0`, verify ALL exits from their spawn room lead to places where the mob makes thematic sense. A sandworm with `maxwander: 2` whose room has an exit to the waiting room WILL eventually show up in the waiting room.

**The `wander` idle command:** Adding `wander` to idle commands makes the mob actively try to move. Without it, mobs with `maxwander > 0` still move but less frequently. Only use `wander` for mobs that should feel restless or mobile.

**SpawnInfo overrides:** `maxwander` in spawninfo overrides the mob YAML's `maxwander`. Both the mob definition AND the spawninfo need to agree.

## 12. Script Rules (ECMAScript 5.1)

- No `let` or `const` — use `var`
- No arrow functions — use `function()`
- No template literals — use string concatenation
- No destructuring, spread, Promise, async/await
- Script timeout: 50ms per call (room scripts), 1000ms for load
- Return `true` from `onCommand` to consume the command (prevent default handling)
- Return `false` to let the engine continue processing the command

## 12. ANSI Color Tags

```
<ansi fg="color">text</ansi>
```

Semantic names: `room-title`, `room-description`, `exit`, `secret-exit`, `mobname`, `username`, `itemname`, `stat`, `command`, `damage`, `healing`, `item`

Numeric: `0`-`15`

Named: `red`, `green`, `blue`, `yellow`, `cyan`, `magenta`, `white`, `black`

Inside YAML strings, escape the quotes: `<ansi fg=\"itemname\">text</ansi>`
Inside JS strings, same escaping applies.
