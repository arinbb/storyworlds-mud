# StoryWorlds Zone Framework

A comprehensive guide for creating rich, interactive fictional world zones in the StoryWorlds MUD. Each zone is an immersive homage to its source material — exploration and atmosphere over combat.

## Core Philosophy

**Celebrate, don't replicate.** The goal is never to reproduce a work of art but to honor its complexity through spatialized, text-based worlds — rooms, objects, and characters that evoke the spirit of the original. A zone should make players want to experience the source material, not replace the need to.

**Embed knowledge, don't lecture.** Historical context, artist biography, production trivia, and cultural significance should be woven naturally into the world — through NPC dialogue, item descriptions, room nouns, and idle messages. A bartender who mentions the year. A prop that references real production details. A noun description that teaches you something without ever breaking the fourth wall. Players should leave knowing more about the work than when they entered, without ever feeling like they were in a classroom.

**Every medium has its own language.** Books become rooms you read your way through. Films become scenes you step into. Paintings become landscapes of brushstrokes. Music becomes synesthetic spaces where sound has texture, color, and weight. Poetry becomes houses of feeling. Each portal type should transform the source material into spatial experience in a way that honors how that medium works.

## Architecture Overview

```
Library Hub (rooms 1-99)
  ├── Book Stacks (room 2)      → Books, Poetry collections (portal items)
  ├── Screening Room (room 3)   → Film Reels (portal items)
  ├── Gallery (room 4)          → Paintings (portal items)
  ├── Mezzanine Lounge (room 5) → Curiosities, overview
  ├── Deep Stacks (room 6)      → Rare/powerful books
  └── Listening Room (room 7)   → Vinyl LPs, Cassettes, CDs (portal items)

Each media item transports player to a zone:
  Wonderland (100-199)       Starry Night (500-599)
  The Odyssey (200-299)      Beetlejuice (600-699)
  Blade Runner (300-399)     Those Winter Sundays (700-799)
  Princess Bride (400-499)   Pee-wee's Big Adventure (800-899)
```

## What Makes a Great StoryWorlds Zone

A successful zone captures the **feeling** of the source material, not just the plot. Players should recognize the world through atmosphere, character interactions, and interactive details. Key principles:

1. **Atmosphere first** — 5+ idle messages per room (sight, sound, smell, NPC activity, environment)
2. **Nouns everywhere** — every notable object in a description should be a lookable noun
3. **Interactive verbs** — custom commands that let players engage with the world (dance, search, light, touch, squeeze)
4. **NPCs that feel alive** — idle commands, onAsk dialogue with 5+ topics, onShow reactions, NPC-to-NPC conversations
5. **Easter eggs** — hidden interactions that reward exploration with XP (one-time per player via MiscCharacterData)
6. **Mutators** — zone-wide environmental effects with thematic buffs
7. **Secrets** — hidden exits, rooms only found by searching or doing something clever
8. **Souvenirs** — collectible items that evoke the source material

## Room ID & Mob ID Allocation

| Range     | Zone                    | Mob IDs  |
|-----------|-------------------------|----------|
| 1-99      | Library Hub             | 100+     |
| 100-199   | Wonderland              | 10-19    |
| 200-299   | The Odyssey             | —        |
| 300-399   | Blade Runner            | —        |
| 400-499   | The Princess Bride      | —        |
| 500-599   | Starry Night            | 40-49    |
| 600-699   | Beetlejuice             | 20-39    |
| 700-799   | Those Winter Sundays    | 60-69    |
| 800-899   | Pee-wee's Big Adventure | 70-79    |
| 900+      | Tutorial (system)       | 1-9      |

## Step-by-Step Zone Creation

### Step 1: Decompose the Source Material

Before writing any YAML, extract these 8 categories from the fictional work:

1. **PLACES → Rooms** — every distinct location becomes a room. Sketch a top-down map first. Use cardinal directions for geography, custom named exits for thematic connections. 10-20 rooms per zone is ideal.

2. **CHARACTERS → Mobs** — every named character, creature, or significant presence. Non-combat NPCs need: 3-5 idle commands, 3-5 ask topics, onShow/onGive reactions.

3. **OBJECTS → Items** — plot-critical objects, iconic props, collectible souvenirs. Portal object (transport), progression objects (gate movement), atmosphere objects (lore).

4. **SCENES → Scripted Events** — iconic moments become room scripts. onEnter for arrival scenes, onCommand for triggered scenes, onIdle for recurring atmospheric events.

5. **ATMOSPHERE → Environmental Systems** — weather via mutators, darkness via biome, sensory palette via ANSI color theming, time-sensitivity via UtilIsDay().

6. **NARRATIVE ARC → Quest System** — primary quest = "experience the story" (visit locations, meet characters, witness scenes). Secret quests for deep-cut references. Don't require combat for primary quest.

7. **RELATIONSHIPS → Conversation System** — character dynamics via conversation YAMLs, onAsk gossip, paired spawning.

8. **THEMES → Mechanical Expression** — the source material's themes should manifest as game mechanics. Examples: isolation → empty rooms with eerie idle messages, madness → contradictory connections, love → invisible labor (Those Winter Sundays).

### Step 2: Create the Zone Structure

```bash
mkdir -p engine/_datafiles/world/storyworlds/rooms/<zone_name>
mkdir -p engine/_datafiles/world/storyworlds/mobs/<zone_name>/scripts
mkdir -p engine/_datafiles/world/storyworlds/conversations/<zone_name>
```

### Step 3: Zone Config

```yaml
name: <Display Name>
roomid: <first room ID>
autoscale:
  minimum: 1
  maximum: 5
defaultbiome: <biome>
mutators:
- mutatorid: <zone-mutator-id>
idlemessages:
- <6+ zone-wide atmospheric messages>
```

**Zone mutators** apply environmental effects to the entire zone. Create a matching mutator YAML in `mutators/` and buff YAML+JS in `buffs/`. Good buff flags for exploration zones:
- `see-nouns` — players notice more lookable objects
- `see-hidden` — secret exits become visible
- `nightvision` / `lightsource` — see in dark biomes
- `superhearing` — hear more ambient sounds
- `warmed` — counter cold environments

### Step 4: Room YAML Files

```yaml
roomid: <id>
zone: <Zone Display Name>
title: <Room Title>
description: >-
  Rich description using ANSI tags for interactive elements:
  <ansi fg="itemname">lookable nouns</ansi>
  <ansi fg="exit">visible exits</ansi>
  <ansi fg="secret-exit">hidden exits</ansi>
mapsymbol: <single char>
maplegend: <legend text>
biome: <biome type>
exits:
  north:
    roomid: <id>
    exitmessage: <what player sees when leaving>
  <custom_exit_name>:
    roomid: <id>
    secret: true  # hidden, found via search
nouns:
  <object>: >-
    Detailed description. Every notable item mentioned in the room
    description should have a noun entry. This is where the real
    depth of the world lives — players who look at things are rewarded
    with rich detail, lore, and atmosphere.
containers:
  <container_name>: {}
spawninfo:
- mobid: <id>
  message: "Spawn message when mob first appears."
- itemid: <id>
  container: <container_name>
  respawnrate: 1 real minutes
idlemessages:
- <sight — what the player sees happening>
- <sound — what they hear>
- <smell or sensation — what they feel>
- <NPC or creature activity>
- <environmental change — weather, light, movement>
- <thematic detail specific to the source material>
```

**Critical rules:**
- Nouns are flat `key: string` pairs, NOT nested maps
- No `sign:` or `signtext:` in room YAML (signs are runtime-only)
- Zone name in YAML must match zone-config.yaml `name:` field exactly
- Idle messages with colons must be single-quoted: `'A voice says: "hello"'`

### Step 5: Room Script Files (.js)

Every room needs a `.js` file. At minimum, the return handler:

```javascript
var LIBRARY_ROOM = 1;
function onCommand(cmd, rest, user, room) {
    if (cmd == "return") {
        SendUserMessage(user.UserId(), "<ansi fg=\"cyan\">[Thematic departure description]</ansi>");
        SendRoomMessage(room.RoomId(), user.GetCharacterName(true) + " [what others see].", user.UserId());
        user.MoveRoom(LIBRARY_ROOM);
        return true;
    }
    return false;
}
```

**Entry room** also needs `onEnter`:
```javascript
function onEnter(user, room) {
    SendUserMessage(user.UserId(), "");
    SendUserMessage(user.UserId(), "<ansi fg=\"14\">[Arrival description]</ansi>");
    SendUserMessage(user.UserId(), "");
    SendUserMessage(user.UserId(), "<ansi fg=\"3\">(Type 'return' at any time to go back to the Grand Library.)</ansi>");
    return false;
}
```

**ES5.1 ONLY** — no let/const, no arrow functions, no template literals.

### Step 6: Interactive Room Scripts (the good stuff)

This is what makes zones come alive. Custom verb handlers let players interact with the world:

```javascript
// Easter egg with one-time XP reward
if (cmd == "search" && rest.indexOf("basement") >= 0) {
    SendUserMessage(user.UserId(), "<ansi fg=\"yellow\">There's no basement at the Alamo!</ansi>");
    if (user.GetMiscCharacterData("easter_key") != "found") {
        user.SetMiscCharacterData("easter_key", "found");
        user.GrantXP(200, "discovering the secret");
    }
    return true;
}

// Interactive object that does something fun
if (cmd == "squeeze" && rest.indexOf("chicken") >= 0) {
    SendUserMessage(user.UserId(), "<ansi fg=\"yellow\">The rubber chicken honks.</ansi>");
    SendRoomMessage(room.RoomId(), user.GetCharacterName(true) + " squeezes a rubber chicken.", user.UserId());
    return true;
}

// Temporary exit that opens from interaction
if (cmd == "pull" && rest.indexOf("lever") >= 0) {
    room.AddTemporaryExit("hidden passage", "Hidden Passage", 305, "10 real minutes");
    SendRoomMessage(room.RoomId(), "A hidden passage grinds open in the wall!");
    return true;
}
```

**Common interactive verbs to support:** look, search, touch, use, open, read, push, pull, turn, light, play, dance, drink, eat, squeeze, knock, wear, try, talk, listen, smell

### Step 7: Mob YAML Files

```yaml
mobid: <id>
zone: <zone_folder_name>  # lowercase with underscores
hostile: false
maxwander: <0-2>  # 0=stays put, 1-2=wanders nearby
idlecommands:
  - "say <dialogue>"
  - "emote <action>"
  - ''  # empty = pause (creates natural rhythm)
  - ''
activitylevel: <15-30>  # higher = more frequent idle actions
character:
  name: <Character Name>
  description: >-
    Rich physical description. What do they look like? What are they
    doing? What mood do they project? Use sensory details.
  raceid: 1  # human (or 27 for ghostly spirit, etc.)
  level: <5-20>
```

**File naming:** `{id}-{name_converted}.yaml` — lowercase, skip apostrophes, non-alphanumeric → underscore. The `name` inside `character:` determines the filename the engine expects.

### Step 8: Mob Scripts (onAsk, onShow, onGive)

```javascript
function onAsk(mob, room, eventDetails) {
    var question = eventDetails.askText.toLowerCase();

    // 5-7 topic handlers covering the character's knowledge
    if (question.indexOf("topic") >= 0) {
        mob.Command("say Response line 1.");
        mob.Command("emote does something.", 2.0);  // delayed action
        mob.Command("say Response line 2.", 3.5);    // further delay
        return true;
    }

    // Default response — character stays in character
    var defaults = [
        "say Default response 1.",
        "say Default response 2."
    ];
    var pick = Math.floor(Math.random() * defaults.length);
    mob.Command(defaults[pick]);
    return true;
}

function onShow(mob, room, eventDetails) {
    var showText = String(eventDetails);
    if (showText.indexOf("item_name") >= 0) {
        mob.Command("say Reaction to seeing the item.");
        return true;
    }
    mob.Command("emote looks at what you show them with interest.");
    return true;
}
```

### Step 9: NPC-to-NPC Conversations

Create `conversations/<zone>/1.yaml` for ambient NPC dialogue:

```yaml
-
  Supported:
    "character a": ["character b"]  # names must be lowercase
  Conversation:
    - ["#1 say Opening line from character A."]
    - ["#2 emote reacts", "#2 say Response from character B."]
    - ["#1 say Follow-up line."]
    - ["#2 say Closing response."]
```

Conversations trigger randomly when matching mobs share a room.

### Step 10: Portal Items

**Supported verbs by medium:**
- Books: `read`, `open`, `use`, `enter`
- Film reels: `load`, `play`, `use`, `watch`, `enter`
- Paintings: `gaze`, `use`, `enter`, `touch`, `step`
- Poetry: `read`, `open`, `use`, `enter`
- Vinyl LPs: `play`, `spin`, `use`, `enter`, `listen`
- Cassette tapes: `play`, `insert`, `use`, `enter`, `listen`
- CDs: `play`, `insert`, `use`, `enter`, `listen`

`enter` is the universal verb that works for all portal types.

Portal item script template:
```javascript
var DEST_ROOM = <entry_room_id>;
var ENTER_MSG_SELF = "<immersive transition description>";
var ENTER_MSG_ROOM = "<what others see>";

function onCommand_use(user, item, room) { return enterWorld(user, item, room); }
function onCommand_enter(user, item, room) { return enterWorld(user, item, room); }
// ... add medium-specific verbs

function enterWorld(user, item, room) {
    SendUserMessage(user.UserId(), "");
    SendUserMessage(user.UserId(), "<ansi fg=\"<color>\">" + ENTER_MSG_SELF + "</ansi>");
    SendRoomMessage(room.RoomId(), user.GetCharacterName(true) + "<ansi fg=\"<color>\">" + ENTER_MSG_ROOM + "</ansi>", user.UserId());
    user.MoveRoom(DEST_ROOM);
    return true;
}
```

Spawn the portal item in the Library:
- Books/Poetry → room 2 (Book Stacks), container: shelves
- Films → room 3 (Screening Room), container: shelves
- Art → room 4 (Gallery), container: wall
- Audio (LPs/Cassettes/CDs) → room 7 (Listening Room), container: shelf

### Step 11: Mutators & Buffs

Create a zone-wide mutator for atmospheric effects:

**Mutator YAML** (`mutators/<name>.yaml`):
```yaml
mutatorid: <zone-name>
namemodifier:
  behavior: append
  text: (<short descriptor>)
  colorpattern: <color>
descriptionmodifier:
  behavior: append
  text: <atmospheric sentence>
  colorpattern: <color>
alertmodifier:
  text: <periodic alert message>
  colorpattern: <color>
playerbuffids: [<buff_id>]
```

**Buff YAML** (`buffs/<id>-<name>.yaml`):
```yaml
buffid: <id>
name: <Buff Name>
description: <what the player feels>
secret: false
triggerrate: 10 real minutes
triggercount: 1
flags:
  - see-nouns     # notice more details
  - nightvision   # see in dark biomes
  - superhearing  # hear more ambient sounds
```

**Buff script** (`buffs/<id>-<name>.js`):
```javascript
function onStart(actor) {
    SendUserMessage(actor.UserId(), "<ansi fg=\"14\">You feel the zone's atmosphere wash over you...</ansi>");
}
function onEnd(actor) {
    SendUserMessage(actor.UserId(), "<ansi fg=\"8\">The feeling fades.</ansi>");
}
```

Reference the mutator in zone-config.yaml:
```yaml
mutators:
- mutatorid: <zone-name>
```

### Step 12: Quest

```yaml
questid: <id>
name: <Quest Name>
description: >-
  Brief description of the journey.
reward:
  experience: <3000-5000>
  item_id: <souvenir_item_id>
  playermessage: >-
    Completion message with souvenir description.
steps:
- description: <step 1 — usually "enter the world">
- description: <step 2 — meet a character or find something>
- description: <step 3 — discover a key location>
- description: <step 4 — interact with something iconic>
```

### Step 13: Souvenir Item

```yaml
itemid: <id>
name: <souvenir name>
namesimple: <one word>
displayname: a <ansi fg="itemname"><souvenir name></ansi>
description: >-
  A tangible reminder of the world. Should evoke the source
  material's emotional core. Include sensory details.
type: object
subtype: usable
uses: 0
value: 1
```

## Music Zone Design

Music zones are unique — they translate audio art into spatial experience. Each room represents a track, and the design can take several approaches:

- **Abstract/Synesthetic:** Sound becomes physical. Distortion is weather, melody is landscape, rhythm is architecture. A guitar riff might be a wall of fire. A cello note might be a still lake. The room IS the music.
- **Era-Representative:** The world the music came from. A 1977 punk club, a 1960s coffeehouse, a 1993 recording studio. Period-accurate details, cultural context embedded naturally.
- **Narrative/Concept:** For concept albums with stories (The Wall, Ziggy Stardust, Tommy), rooms follow the album's narrative arc.

**Embedding music knowledge:** Production details become room nouns (the mixing board, the specific guitar model). Historical context lives in NPC dialogue (the sound engineer mentioning analog vs digital). Cultural significance is embedded in room descriptions (what the era looked and felt like). Players learn about the music and its context by exploring, not by reading liner notes.

**Audio portal items** come in three era-appropriate formats:
- **Vinyl LP** (pre-1980s) — turntable in the Listening Room
- **Cassette Tape** (1970s-1990s) — tape deck in the Listening Room
- **CD** (1990s-2000s) — CD player in the Listening Room

Choose the format that matches the album's original or most iconic release format.

## Generic NPCs

Not every NPC needs a proper name. Use generic NPCs to add life and atmosphere:
- "A Hotel Guest" (ghostly 1920s partygoer in The Shining)
- "A Sound Engineer" (Steve Albini analog in In Utero)
- "A Villager", "A Student", "A Bartender", "A Guard"

Generic NPCs can wander, have idle commands, and even have onAsk topics. They add population density without requiring named characters from the source material.

## Multiplayer Safety Checklist

- Guard mob spawning: `if (room.GetMobs(id).length == 0) room.SpawnMob(id);`
- Quest gates: use `user.HasQuest()`, NEVER room PermData for player-specific progression
- Easter egg XP: one-time per player via `user.GetMiscCharacterData("key") != "found"`
- Important items: create via `user.GiveItem(CreateItem(id))`, not floor spawns
- Easter egg hints: always provide in-game hints (NPC idle chatter, room idle messages) so players can discover secrets without external knowledge

## File Naming Rules (CRITICAL — server PANICs on violations)

1. **Items/Quests:** `{id}-{ConvertForFilename(name)}.yaml` — lowercase, skip apostrophes, non-alphanumeric → underscore
2. **Items < 10000** go in `other-0/`. 10000-19999 = weapons, 20000-29999 = armor, 30000+ = consumables
3. **Zone folders** must match zone config `name:` lowercased with spaces → underscores
4. **Mob YAML:** `name`, `description`, `raceid`, `level` go INSIDE `character:` block
5. **Room nouns:** flat `key: string` pairs, NOT nested maps
6. **No sign/signtext in room YAML** — signs are runtime-only
7. **Idle messages with colons** must be single-quoted
8. **Conversation names** must be lowercase in Supported map

## Biome Reference

| Biome     | Dark? | Notes                              |
|-----------|-------|------------------------------------|
| cave      | Yes   | Underground, needs lightsource     |
| dungeon   | Yes   | Confined, dark                     |
| city      | No    | Urban, lit                         |
| house     | No    | Interior, domestic                 |
| forest    | No    | Natural, wooded                    |
| land      | No    | Open country                       |
| road      | No    | Paths, highways                    |
| shore     | No    | Coastline                          |
| water     | No    | Requires swimming                  |
| desert    | No    | Arid                               |
| mountains | No    | Peaks, passes                      |
| farmland  | No    | Agricultural (burnable)            |
| cliffs    | No    | Precipices                         |
| snow      | No    | Cold landscapes                    |
| swamp     | Yes   | Wetlands, murky                    |

## Color Reference for ANSI Tags

Semantic colors: `room-title`, `room-description`, `exit`, `secret-exit`, `mobname`, `username`, `itemname`, `stat`, `command`, `damage`, `healing`, `spell-helpful`

Numeric colors: 0-15. Common choices:
- `3` = dark cyan (hints, instructions)
- `6` = cyan (cold, water, ice themes)
- `14` = bright cyan/yellow (magical, ethereal)
- `yellow` = warmth, discovery, treasure
- `green` = nature, Pee-wee, whimsy
- `blue` = sci-fi, rain, night
- Color patterns for mutators: `flame`, `ice`, `rainbow`, `blue-white`
