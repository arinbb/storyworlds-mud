# StoryWorlds MUD - Project Instructions

## Project Overview
A GoMUD-based MUD where players explore fictional worlds from movies, books, and artwork. The home zone is the **Grand Library** — a hub with Book Stacks, a Screening Room, and a Gallery. Players pick up media objects (books, film reels, paintings) and interact with them to be transported into that fictional world as its own GoMUD zone.

**Design priorities:** Exploration and atmosphere over combat. Rich descriptions, idle messages, NPC conversations, and interactive scenes that are homages to the complexity of their source material. Battles exist but are secondary.

## File Structure
```
engine/                          # GoMUD engine (cloned from GoMudEngine/GoMud)
  _datafiles/
    config.yaml                  # Engine default config
    world/storyworlds/           # OUR CUSTOM WORLD - all content goes here
      rooms/<zone>/              # Zone folders with room YAML + JS
      mobs/<zone>/scripts/       # Mob definitions + scripts
      items/                     # weapons-10000/, armor-20000/, consumables-30000/, other-0/
      buffs/                     # Buff YAML + JS
      spells/                    # Spell YAML + JS
      quests/                    # Quest YAML
      conversations/<zone>/      # NPC-to-NPC ambient dialogue
      mutators/                  # Environmental modifiers
      biomes/                    # Biome definitions
      races/                     # Race definitions
      pets/                      # Pet definitions
      templates/                 # UI rendering templates
config.yaml                      # Our config override (CONFIG_PATH=../../config.yaml)
ZONE_FRAMEWORK.md                # Detailed zone creation guide with templates
```

## Room ID Allocation
| Range     | Zone                | Status      |
|-----------|---------------------|-------------|
| 1-99      | Library Hub         | Built       |
| 100-199   | Wonderland          | Built       |
| 200-299   | The Odyssey         | Portal item exists |
| 300-399   | Blade Runner        | Portal item exists |
| 400-499   | The Princess Bride  | Portal item exists |
| 500-599   | Starry Night        | Built       |
| 600-699   | Beetlejuice         | Built       |
| 700-799   | Those Winter Sundays | Built      |
| 800-899   | Pee-wee's Big Adventure | Built    |
| 900-903   | Tutorial (system)   | Inherited   |
| 950-969   | The Shining         | Built       |
| 970-989   | The Hobbit          | Built       |
| 1100-1112 | In Utero (Nirvana)  | Built       |
| 1200-1212 | A Confederacy of Dunces | Built   |
| 1300-1312 | Buffalo '66         | Built       |
| 1400-1415 | Matilda             | Built       |
| 1500-1510 | Goodnight Moon      | Built       |
| 1520-1535 | Wayne's World       | Built       |
| 1550-1568 | Jurassic Park       | Built       |
| 1600-1614 | Die Die My Darling  | Built       |
| 1700-1715 | Blonde on Blonde    | Built       |
| 1740-1753 | On the Road         | Built       |
| 1720-1735 | The Sopranos        | Built       |
| 1800-1815 | Crime and Punishment | Built      |
| 1820-1835 | Stardew Valley      | Built       |
| 1840-1855 | Far Cry 5           | Built       |
| 1860-1875 | Super Mario Bros    | Built       |
| 1880-1895 | The Monkey Wrench Gang | Built     |
| 1940-1955 | Back to the Future  | Built       |
| 1900-1912 | The Little Prince   | Built       |
| 1960-1975 | Nineteen Eighty Four | Built      |
| 1980-1993 | Forbidden Planet    | Built       |
| 2000-2015 | Seinfeld            | Built       |
| 2020-2033 | Harold and Maude    | Built       |
| 2040-2055 | Its Always Sunny    | Built       |
| 2060-2073 | The Andy Griffith Show | Built    |
| 2100-2114 | Up in Smoke         | Built       |
| 2120-2133 | Paris Texas         | Built       |
| 2140-2153 | Northern Exposure   | Built       |
| 2200+     | Future worlds       | Available   |

## Mob ID Allocation
| Range     | Zone           |
|-----------|----------------|
| 1-9       | System (rat, guard, guide - inherited) |
| 10-19     | Wonderland     |
| 20-39     | Beetlejuice    |
| 40-49     | Starry Night   |
| 50-59     | (available)    |
| 60-69     | Those Winter Sundays |
| 70-79     | Pee-wee's Big Adventure |
| 80-89     | The Shining          |
| 90-99     | The Hobbit           |
| 100+      | Library (Librarian=100) |
| 200-209   | In Utero (Nirvana)   |
| 201-209   | A Confederacy of Dunces |
| 210-216   | Buffalo '66              |
| 220-228   | Matilda                  |
| 230-233   | Goodnight Moon           |
| 240-248   | Wayne's World            |
| 250-260   | Jurassic Park            |
| 270-276   | Die Die My Darling       |
| 280-286   | Blonde on Blonde         |
| 290-298   | The Sopranos             |
| 300-305   | On the Road              |
| 310-317   | Crime and Punishment     |
| 320-330   | Stardew Valley           |
| 335-344   | Far Cry 5                |
| 350-358   | Super Mario Bros         |
| 360-366   | The Monkey Wrench Gang   |
| 370-375   | The Little Prince        |
| 390-399   | Back to the Future       |
| 400-408   | Nineteen Eighty Four     |
| 410-415   | Forbidden Planet         |
| 420-428   | Seinfeld                 |
| 430-434   | Harold and Maude         |
| 440-448   | Its Always Sunny         |
| 450-457   | The Andy Griffith Show   |
| 460-467   | Up in Smoke              |
| 470-475   | Paris Texas              |
| 480-488   | Northern Exposure        |

## Item ID Allocation
| Range       | Type                |
|-------------|---------------------|
| 1-99        | System/keys/misc    |
| 10001-19999 | Weapons             |
| 20001-29999 | Armor               |
| 30001-39999 | Consumables         |
| 101-109     | Portal Books/Film Reels/Paintings |
| 110-199     | Story world souvenirs/collectibles |
| 134         | Stardew Valley game disc (Game Disc portal type) |
| 136         | Far Cry 5 game disc (Game Disc portal type) |
| 200-219     | Story world souvenirs (extended range) |
| 215         | Stardew star fruit (souvenir) |
| 220         | Edens Gate pin (Far Cry 5 souvenir) |
| 137         | Super Mario Bros game cartridge (Game Disc portal type) |
| 225         | Mushroom Kingdom gold coin (Super Mario Bros souvenir) |
| 141         | Back to the Future film reel (portal) |
| 245         | Flux capacitor keychain (Back to the Future souvenir) |

## Backlog (planned, not yet built)
| Work                        | Medium      | Portal Type    | Notes                                      |
|-----------------------------|-------------|----------------|--------------------------------------------|
| The Wire                    | TV Series   | Film Reel      | Baltimore, corners, docks, city hall        |
| The Office                  | TV Series   | Film Reel      | Dunder Mifflin Scranton, mundane comedy     |
| Best in Show                | Film        | Film Reel      | Dog show mockumentary, Mayflower Kennel Club|
| Billy Madison               | Film        | Film Reel      | Back to school comedy, academic decathlon   |
| Harvest (Neil Young)        | Album (1972)| Vinyl LP       | Laurel Canyon, heart of gold, old man       |
| Siamese Dream (Smashing Pumpkins)| Album (1993)| CD        | Shoegaze, distortion, Chicago, Billy Corgan |
| Six Feet Under              | TV Series   | Film Reel      | Fisher & Sons funeral home, death, family   |

## Running the Server
```bash
cd engine
CONFIG_PATH=../config.yaml go run .
# Connect: telnet localhost 33333
# Web: http://localhost/webclient
# Default login: admin / password
```

---

## GoMUD Engine Capabilities Reference

### Core Architecture
- **Runtime:** ECMAScript 5.1 (goja). Script timeout: 50ms per room script call.
- **Timing:** 50ms turns, 4s rounds, 900 rounds/game-day. 1 real hour = 1 game day. Night = 8 of 24 game hours.
- **ANSI colors:** `<ansi fg="color">text</ansi>` — semantic names: room-title, room-description, exit, secret-exit, mobname, username, itemname, stat, command, damage, healing, spell-helpful. Also numeric 0-15 and named colors.

### Zone/Room System
- **Zones** = folders under `rooms/<zone>/` containing `zone-config.yaml` + numbered `.yaml` room files + optional `.js` scripts
- **Zone config fields:** `name`, `roomid` (root), `autoscale` {minimum, maximum}, `mutators`, `musicfile`, `defaultbiome`, `idlemessages`
- **Room YAML fields:** `roomid`, `zone`, `title`, `description`, `biome`, `mapsymbol`, `maplegend`, `musicfile`, `pvp`, `isbank`, `ischaracterroom`, `isstorage`
- **Nouns:** lookable objects in `nouns:` map with description
- **Containers:** named containers with optional `lock.difficulty` and `recipes` (crafting)
- **Signs:** `sign.signtext` for readable signs with ANSI formatting
- **Persistent data:** `longtermdatastore` for persistent key-value per room

### Exit System
- **Standard:** north/south/east/west/ne/nw/se/sw/up/down
- **Custom named exits:** any string (boat, gateway, shadows, vault, bushes, canal)
- **Exit properties:** `roomid`, `secret` (hidden, found via search), `lock` {difficulty, relockinterval, trapbuffids}, `exitmessage`, `mapdirection`
- **Temporary exits:** `room.AddTemporaryExit(simpleName, fancyName, roomId, duration)` — created by scripts, expire automatically
- **Map direction overrides:** `north`, `south-x2`, `east-gap`, `west-gap2`, `northeast`, etc.

### Item System
- **Types:** weapon, body/head/feet/gloves/belt/legs/neck/offhand/ring, key, potion, drink, food, botanical, object, readable
- **Subtypes:** wearable, drinkable, edible, usable, blobcontent, bludgeoning/slashing/stabbing/cleaving/shooting/whipping
- **Properties:** `itemid`, `name`, `namesimple`, `displayname`, `description`, `type`, `subtype`, `uses` (0=unlimited), `value`, `keylockid`, `questtoken`, `cursed`, `breakchance`, `hands`
- **Combat:** `damage.diceroll` (1d6, 2d10+1, 3@1d2 for multi-attack), `damagereduction`
- **Modifiers:** `statmods` {strength, speed, smarts, vitality, mysticism, perception, healthmax, manamax, etc.}, `wornbuffids`, `buffids`, `critbuffids`
- **Item script hooks:** `onFound`, `onLost`, `onCommand`, `onCommand_{verb}` (use, read, open, play, sweep, etc.), `onPurchase`

### Mob System
- **Mob YAML:** `mobid`, `zone`, `name`, `description`, `hostile`, `maxwander`, `hates`, `hateraces`, `angrycommands`, `activitylevel`, `groups`
- **Character block:** `raceid`, `level`, `alignment`, `gold`, equipment, items, shop, spellbook
- **Shop types:** items, buffs, pets, mob companions, trade-for-item
- **Combat commands:** callforhelp, sneak, backstab, suicide, vanish, portal home
- **Patrol routes:** `mob.Command("pathto room1 room2 room3 home")` with `onPath` waypoint events
- **Dynamic adjectives:** `mob.SetAdjective("patrolling", true/false)`
- **Charmed mobs:** `mob.CharmSet(userId, rounds)` — follow and teleport to owner
- **Alternate scripts:** `scripttag` in spawninfo loads `scripts/{id}-{name}-{tag}.js`
- **Mob script hooks:** `onLoad`, `onIdle`, `onGive`, `onShow`, `onAsk` (eventDetails.askText), `onCommand`, `onHurt`, `onDie`, `onPath`, `onPlayerDowned`

### SpawnInfo (rooms)
```yaml
spawninfo:
- mobid: XX              # OR itemid: XX
  message: "spawn message"
  name: "override name"
  level: 10              # OR levelmod: +5
  forcehostile: false
  maxwander: 2
  respawnrate: 5 real minutes
  idlecommands: [say hello, "", emote waves, wander]
  scripttag: alternate   # loads alternate script
  questflags: [4-start, 4-return]
  buffids: [1, 5]
  container: chest       # spawn items into container
  gold: 50               # spawn gold
```

### Room Script Hooks
- `onLoad(room)` — room first loaded
- `onEnter(user, room)` — player enters (return false = suppress room description)
- `onExit(user, room)` — player leaves
- `onIdle(room)` — each round with players present (return true = suppress generic idle)
- `onCommand(cmd, rest, user, room)` — any command (return true = consumed)
- `onCommand_{cmd}(rest, user, room)` — specific command handler

### Global Script API
- **Messaging:** `SendBroadcast(msg)`, `SendUserMessage(userId, msg)`, `SendRoomMessage(roomId, msg, excludeUserId)`, `SendRoomExitsMessage(roomId, msg, quiet, excludeUserId)`
- **Retrieval:** `GetUser(id)`, `GetMob(instanceId)`, `GetRoom(roomId)`, `ActorNames(actors[])`
- **Creation:** `CreateItem(id)`, `CreateEmptyRoomInstances(qty)`, `CreateInstancesFromRoomIds(ids[])`, `CreateInstancesFromZone(name)`
- **Maps:** `GetMap(roomId, zoom, height, width, title, showSecrets, markers...)`
- **Time:** `UtilIsDay()`, `UtilGetTime()` → {Day, Hour, Hour24, Minute, AmPm, Night, DayStart, NightStart}
- **Dice:** `UtilDiceRoll(qty, sides)`
- **Search:** `UtilFindMatchIn(search, items[])`, `UtilStripPrepositions(text)`
- **Color:** `UtilApplyColorPattern(text, pattern, wordsOnly?)`
- **Config:** `UtilGetConfig()`, `ExpandCommand(cmd)`

### Actor API (Users & Mobs — 90+ methods)
- **Identity:** `UserId()`, `InstanceId()`, `MobTypeId()`, `GetCharacterName(colored?)`, `ShorthandId()`, `GetRace()`, `GetSize()`, `GetLevel()`
- **Stats:** `GetStat(name)`, `GetStatMod(name)`, `GetHealth()`, `GetHealthMax()`, `GetHealthPct()`, `SetHealth(n)`, `AddHealth(n)`, `GetMana()`, `AddMana(n)`
- **Resources:** `AddGold(amt, bankAmt?)`, `GrantXP(amt, reason)`, `GiveTrainingPoints(n)`, `GiveStatPoints(n)`, `GiveExtraLife(n)`
- **Skills/Spells:** `TrainSkill(name, level)`, `GetSkillLevel(name)`, `HasSpell(name)`, `LearnSpell(name)`
- **Quests:** `HasQuest(id)`, `GiveQuest(id)`
- **Items:** `HasItemId(id, excludeWorn?)`, `GetBackpackItems()`, `GiveItem(item)`, `TakeItem(item)`, `Uncurse()`
- **Buffs:** `HasBuff(id)`, `GiveBuff(id, source)`, `HasBuffFlag(flag)`, `CancelBuffWithFlag(flag)`, `RemoveBuff(id)`
- **Charm:** `IsCharmed()`, `GetCharmedUserId()`, `CharmSet(userId, rounds)`, `CharmRemove()`, `GetCharmCount()`, `GetMaxCharmCount()`
- **Movement:** `GetRoomId()`, `MoveRoom(roomId)`, `SetResetRoomId(roomId)`, `IsHome()`
- **Data:** `SetTempData(key, val)`, `GetTempData(key)`, `SetMiscCharacterData(key, val)`, `GetMiscCharacterData(key)`, `GetMiscCharacterDataKeys()`
- **Commands:** `Command(cmd, waitRounds?)`, `CommandFlagged(cmd, flags, wait?)`, `Sleep(seconds)`
- **Combat:** `IsAggro()`, `GetMobKills(mobId)`, `GetRaceKills(raceId)`
- **Alignment:** `GetAlignment()`, `GetAlignmentName()`, `ChangeAlignment(delta)`
- **Taming:** `IsTameable()`, `GetTameMastery(raceId)`, `GetChanceToTame(raceId)`
- **Timers:** `TimerSet(name, period)`, `TimerExpired(name)`, `TimerExists(name)`
- **Party:** `GetParty()`, `GetPartyPresent()`, `GetPartyMissing()`

### Room API
- **Messaging:** `SendText(msg, excludes...)`, `SendTextToExits(msg, quiet, excludes...)`
- **Data:** `SetTempData/GetTempData`, `SetPermData/GetPermData` (persistent across restarts)
- **Items:** `GetItems()`, `DestroyItem(item)`, `SpawnItem(id, inStash)`, `RepeatSpawnItem(id, interval, container?)`
- **Mobs:** `GetMob(id, create?)`, `GetMobs(id?)`, `SpawnMob(id)`
- **Players:** `GetPlayers()`, `GetAllActors()`
- **Exits:** `AddTemporaryExit(simple, fancy, roomId, duration)`, `RemoveTemporaryExit(name)`, `SetLocked(exitName, locked)`, `IsLocked(exitName)`
- **Mutators:** `HasMutator(id)`, `AddMutator(id)`, `RemoveMutator(id)`
- **Quests:** `HasQuest(id, partyUser?)`, `MissingQuest(id, partyUser?)`

### Item Script API
`ItemId()`, `GetUsesLeft()`, `SetUsesLeft(n)`, `AddUsesLeft(n)`, `GetLastUsedRound()`, `MarkLastUsed()`, `DisplayName()`, `NameSimple()`, `NameComplex()`, `SetTempData/GetTempData`, `Rename(name, display?)`, `ShorthandId()`, `Redescribe(desc)`

### Conversation System (NPC-to-NPC ambient dialogue)
YAML files in `conversations/<zone>/<id>.yaml`. Define `Supported` map (initiator name → participant name, * = wildcard). Actions array of command arrays per round. Commands: say, sayto, emote, look, shout, attack. Triggers randomly when matching idle mobs share a room.

### Quest System
YAML files in `quests/<id>.yaml`. Steps as ordered stages. Rewards: experience, gold, item_id, skillinfo, buffid, questid, roomid, playermessage, roommessage. Secret quests hidden from log. Quest-gated exits block movement by quest state.

### Buffs (40+ built-in)
Key flags: `hidden`, `cancel-on-action/combat/water`, `lightsource`, `drunk`, `warmed`, `poison`, `no-combat/flee/go`, `superhearing`, `nightvision`, `see-hidden`, `see-nouns`, `revive-on-death`, `perma-gear`, `remove-curse`, `thirsty`, `hydrated`, `tripping`. Hooks: `onStart`, `onTrigger`, `onEnd`.

### Mutators (environmental modifiers)
Properties: `mutatorid`, `namemodifier` (append/replace + colorpattern), `descriptionmodifier`, `alertmodifier`, `respawnrate`, `decayrate`, `spawnnightonly/spawndayonly`, `playerbuffids`, `mobbuffids`, `exits` (add exits when active).

### Biomes (17 types)
Dark (need lightsource): cave, dungeon, spiderweb, swamp. Lit (visible at night): city, fort, house, land. Burnable: farmland, forest, house. Special: water requires swimming gear. Others: cliffs, desert, mountains, road, shore, snow.

### Races
Player: human, elf. NPC: troll, goblin, undead, insect, reptilian, eldritch horror, rodent, canine, fungus, tree, giant spider, faerie, golem, monkey, lagomorph, dummy, orb, reptile, ghostly spirit.

### Pets
cat (+speed, see-hidden), dog (+strength, 1d3 damage), mule (+vitality, +carrying), owl (+smarts, see-nouns).

---

## Advanced Patterns for StoryWorlds

### 1. Quest-gated exploration
Block exits until player completes story requirements. Check with `room.HasQuest()` or `user.HasQuest()` in room scripts.

### 2. Time-of-day mechanics
Use `UtilIsDay()` and `UtilGetTime()` for day/night variations — exits that open at night, NPCs that appear only during certain hours, descriptions that change.

### 3. Item-gated progress
Require specific items to proceed: keys for locks, rope for climbing, lantern for dark rooms. Use `user.HasItemId(id)` checks.

### 4. Puzzle rooms
Custom verb handlers: "say password", "push boulder", "adjust dial", "play instrument". Unlock secret exits or trigger events with `room.AddTemporaryExit()`.

### 5. Ephemeral/instanced rooms
`CreateInstancesFromRoomIds([roomIds])` or `CreateInstancesFromZone(name)` for private solo experiences.

### 6. Crafting
Container `recipes` map: output item → input items array. Players combine items in containers.

### 7. Progressive NPC dialogue
Track conversation state with `user.SetTempData(key, val)` (session) or `user.SetMiscCharacterData(key, val)` (persistent). Branch dialogue based on state.

### 8. Show vs Give items to NPCs
`onShow` and `onGive` mob hooks produce different outcomes — show an item for information, give it for quest advancement.

### 9. Dynamic environments
Mutators that spawn/decay over time, add/remove exits, modify room names/descriptions, apply buffs to players/mobs.

### 10. Charmed companions
NPCs that follow players and give contextual hints via `mob.CharmSet(userId, rounds)`.

### 11. Patrol routes with waypoint dialogue
`mob.Command("pathto room1 room2 home")` with `onPath` hook for location-aware behavior.

### 12. NPC-to-NPC conversations
Ambient dialogue via conversation YAML — guards chatting, characters arguing, world-building through overheard exchanges.

### 13. Collectible souvenirs
Items found in story worlds that players bring back to the Library. Track collections via `SetMiscCharacterData`.

### 14. Alignment-based branching
Player choices shift alignment (-100 to +100). Gate interactions and quest access based on alignment.

### 15. Custom map generation
`GetMap(roomId, zoom, height, width, title, showSecrets, markers...)` for in-world maps with custom markers.

### 16. Party-wide operations
`GetParty()` then party-wide: GiveQuest, MoveRoom, GiveBuff, LearnSpell, GrantXP for group experiences.

### 17. Room data persistence
`room.SetPermData(key, val)` for permanent world state changes that survive restarts. `room.SetTempData` for session-only.

### 18. Timed item spawns
`room.RepeatSpawnItem(id, roundInterval, container?)` for recurring treasure/resource spawning.

---

## StoryWorlds Zone Templates

See `ZONE_FRAMEWORK.md` for detailed step-by-step instructions on creating new story world zones, including:
- Zone config, entry room, portal item, portal script, library placement
- Templates for books, film reels, and paintings
- Return-to-library handler (MUST be in every room script)
- Dynamic content patterns and biome suggestions by genre

## Fictional Work → MUD Extraction

See `WORLD_EXTRACTION_GUIDE.md` for the complete decomposition process. When adding any new fictional work, extract these 8 categories:

1. **PLACES → Rooms** — every distinct location becomes a room with exits mapping physical connections. Sketch a top-down map first. Use cardinal directions for geography, custom named exits for non-geographic connections. 5+ idle messages per room (sight, sound, smell, NPC activity, environment). Biome matches feel. Secret exits for hidden areas. Locked exits for progression gates.

2. **CHARACTERS → Mobs** — every named character, creature, or significant presence. Non-combat NPCs: `hostile: false`, `hateraces: []`. Define per character: 3-5 idle commands, 3-5 ask topics, onShow/onGive reactions, physical placement, relationship mapping. Use conversation YAMLs for NPC-to-NPC ambient dialogue.

3. **OBJECTS → Items** — plot-critical objects, iconic props, weapons/armor, consumables, readables, keys, collectible souvenirs. Categories: portal objects (transport), progression objects (gate movement), atmosphere objects (lore/readables), interaction objects (custom verbs), equipment, consumables, souvenirs.

4. **SCENES → Scripted Events** — iconic moments become room scripts. onEnter for arrival scenes, onCommand for triggered scenes, onIdle for recurring atmospheric events. Puzzles via command sequence checks. Revelations via look/search handlers. Multi-stage sequences via quest steps.

5. **ATMOSPHERE → Environmental Systems** — weather via mutators + idle messages, darkness via biome, hazards via buff-applying mutators, sensory palette via ANSI color theming, time-sensitivity via UtilIsDay()/UtilGetTime().

6. **NARRATIVE ARC → Quest System** — primary quest = "experience the story" (visit locations, meet characters, witness scenes). Secret quests for deep-cut references. Don't require combat for primary quest. Rewards: souvenirs, XP, lore.

7. **RELATIONSHIPS → Conversation System** — character dynamics via conversation YAMLs, onAsk gossip, hates lists, paired spawning, onShow revelations, scripttag variants for evolving relationships.

8. **THEMES → Mechanical Expression** — identity/transformation via stat-changing items, power/corruption via alignment shifts, knowledge/discovery via secret exits and see-nouns buff, madness via contradictory connections, isolation via empty rooms.

### Master Checklist (every new zone):
**Pre-work:** entry point, rough map (5-20 locations), 5-10 characters, 3-5 iconic objects, 3-5 iconic scenes, sensory palette, emotional tone, biome(s).
**Build:** zone config, entry room with return handler, all rooms, all room scripts, character mobs + scripts, conversation YAMLs, items + scripts, quest(s), mutators, portal item in Library.
**Polish:** 5+ idle messages/room, 3+ idle commands/NPC, nouns in every room, sensory consistency, at least one secret, souvenir item, test walk-through.

## Genre-Specific Extraction Guide

When building a zone from a fictional work, the medium shapes what you extract and how you render it. Each genre has unique raw material that maps differently onto MUD rooms, mobs, items, and scripts.

### Albums / Music
**Raw material to extract:** Track listing (each track = one room), album title, year, historical context (what was happening in music and the world), band members and their roles, relationships with other bands or famous shows/events, art style and visual language of the era, cover art (describe it as a room noun), genre/subgenre. Lyrics provide room descriptions and NPC dialogue — but never quote them directly, instead translate their imagery into spatial/atmospheric descriptions. Instruments become nouns. Recording studios become hub rooms.

**MUD mapping:** Hub = recording studio or listening space. Each track room captures the FEELING of the song — abstract/synesthetic (colors, textures, emotions made physical) or era-representative (the world the music came from). Use idle messages for the sonic landscape — what instruments sound like described as physical sensations. NPCs are band members, producers, figures from the songs. The album's emotional arc = the quest progression. Souvenir = something iconic (a harmonica, a guitar pick, a mixtape).

### Films / TV Shows
**Raw material to extract:** Every distinct location (each = a room), every named character (each = a mob), iconic props (items), key scenes (scripted events), visual style and color palette (ANSI theming), the emotional/narrative arc (quest steps), director's visual language, era/setting, soundtrack moments, famous dialogue lines (NPC idle commands and onAsk responses). For TV shows: pick the most iconic locations across all seasons rather than one episode.

**MUD mapping:** Entry room = the establishing shot location. Hub = the most-visited location (bar, office, home). Rooms follow the film's geography. NPCs speak in character voice. Easter eggs are deep-cut references that reward fans. The zone's mutator should capture the overall TONE (dread, comedy, anxiety, warmth). Quest = "experience the story" — visit key locations, witness key moments.

### Books / Novels
**Raw material to extract:** Every described location, every named character, the prose style (this becomes the room description voice), key objects and symbols, the plot structure, themes and how they can become mechanical (alignment shifts, stat changes, quest gates), the author's descriptive palette (colors, smells, textures), historical period, the book's relationship to other works.

**MUD mapping:** Room descriptions should echo the author's prose style — Kerouac rooms feel breathless and long, Dostoevsky rooms feel feverish and cramped, Saint-Exupery rooms feel luminous and sad. The narrator's perspective shapes what idle messages notice. Symbolism becomes interactive — objects that represent themes should have special onCommand handlers. Reading-within-reading (books that contain books) = nested interactivity.

### Poetry
**Raw material to extract:** The poem's images (each major image = a room), the emotional movement, the specific sensory details (these become nouns and idle messages), the poet's voice, the poem's relationship to the poet's life, the historical moment, the form itself (a sonnet's turn can be a quest pivot, a villanelle's repetition can be a looping room).

**MUD mapping:** Small, intimate zones (5-10 rooms). Every word matters more. Idle messages carry the weight. NPCs are sparse — sometimes just one presence. The poem's emotional arc IS the quest. These zones should feel like being inside a single sustained feeling.

### Video Games
**Raw material to extract:** The game world's locations (each distinct area = a room), NPCs and their roles, items/weapons/tools, game mechanics that can be translated (farming → plant/harvest commands, combat → hostile mobs, puzzles → command sequences), the game's visual style, the game's tone (pastoral, apocalyptic, whimsical), progression systems, collectibles, boss encounters, the game's relationship to its genre.

**MUD mapping:** Translate the game's core loop into MUD interactions. Farming games: plant/harvest/fish commands. Shooters: hostile mobs + terrain navigation. RPGs: quest chains + NPC dialogue trees. Puzzles: command sequences that unlock exits. Respect the source game's pacing — Stardew Valley should feel slow and gentle, Far Cry should feel tense and beautiful.

### Paintings / Visual Art
**Raw material to extract:** Every element in the composition (foreground, midground, background = rooms), the artist's technique and style, the historical context, what the painting FEELS like to stand inside, the color palette, the light source, the movement or stillness, the scale.

**MUD mapping:** Small zones (5-12 rooms). You literally walk into the painting. Rooms map to compositional zones. The artist may appear as an NPC. Idle messages capture the painting's light and texture. These zones should feel like the world stopped moving — you are inside a frozen moment.

## Multiplayer Design Rules

See `MULTIPLAYER_DESIGN.md` for complete rules. Key points:
- **Per-user:** Quest state, TempData, MiscCharacterData, inventory. Safe for player-specific logic.
- **Shared:** Room items (first-come-first-served + respawn), mobs, temporary exits, room PermData, idle messages.
- **Guard mob spawning:** Always check `room.GetMobs(id).length == 0` before `room.SpawnMob(id)`.
- **Quest gates:** Use `user.HasQuest()` or user data, NEVER room PermData for player-specific progression.
- **Easter egg XP:** One-time per player using `user.GetMiscCharacterData("easter_key") != "found"`.
- **Important items:** Create via `user.GiveItem(CreateItem(id))` in scripts, not floor spawns, to avoid race conditions.
- **Easter egg hints:** Always provide in-game hints (NPC idle chatter, room idle messages, NPC-to-NPC conversations) so players can discover secrets without external knowledge.

## Interaction Command Vocabulary

Every zone uses commands beyond basic movement (north/south/east/west/up/down) to let players interact with the world. To keep the experience consistent and discoverable, we maintain a standard set of interaction verbs. Every zone should draw from this vocabulary rather than inventing new verbs without reason.

### Standard Interaction Verbs
| Verb | Usage | Example |
|------|-------|---------|
| `look <noun>` | Examine something in the room description | `look axe`, `look painting` |
| `read <noun>` | Read a book, sign, scrapbook, letter | `read bible`, `read scrapbook` |
| `say <words>` | Speak aloud, trigger dialogue | `say goodnight moon`, `say schwing` |
| `ask <mob> <topic>` | Ask an NPC about something | `ask grant about raptors` |
| `show <item> to <mob>` | Show an inventory item to an NPC | `show key to jack` |
| `give <item> to <mob>` | Give an item to an NPC | `give brooch to alan` |
| `use <item>` | Use an item (portal entry, souvenir) | `use harmonica`, `use reel` |
| `play <instrument/item>` | Play music, play a game | `play harmonica`, `play guitar` |
| `open <thing>` | Open a book, door, container | `open book`, `open elevator` |
| `enter <thing>` | Step into a portal, painting, etc. | `enter painting`, `enter portal` |
| `search` | Search for hidden things (secret exits) | `search` in any room |
| `sit` | Sit down (triggers scene in some rooms) | `sit` in therapy office, diner |
| `stand still` | Don't move (T. Rex, The Chokey) | `stand still` in T. Rex paddock |
| `wait` / `listen` | Pause and absorb atmosphere | `wait` in Des Moines, `listen` in warehouse |
| `hide` | Take cover (raptor kitchen, etc.) | `hide` in the kitchen |
| `jump` | Jump (Mario, platformer rooms) | `jump`, `hit block` |
| `kneel` / `bow` | Show reverence or submission | `kneel` at crossroads, `bow` backstage |
| `pray` | Pray (religious settings) | `pray` in chapel |
| `sing` / `headbang` | Musical participation | `sing` in Mirthmobile |
| `burn <thing>` | Set fire to something | `burn billboard` |
| `sabotage` / `wrench` | Eco-sabotage (Monkey Wrench) | `sabotage`, `cut wire` |
| `fish` / `cast` | Fishing | `fish` at pier |
| `plant` / `hoe` / `mine` / `dig` | Resource gathering (game worlds) | `plant` on farm |
| `drink` / `eat` / `taste` | Consume food/drink | `eat mush`, `drink` |
| `confess` | Confess (Crime & Punishment, Die Die) | `confess` in Porfiry's office |
| `hitchhike` / `thumb` | Hitch a ride | `hitchhike` on highway |

### Per-Zone Command Registry
Each zone should document its non-obvious commands in comments at the top of the entry room's .js file. Format:
```javascript
// ZONE COMMANDS: say goodnight moon (1500), play mittens (1507), eat mush (1508), count stars (1509)
```

## Collectible Souvenir Tracking

Each zone awards a souvenir item on quest completion. To let players track how many they've collected:
- Each souvenir's quest-completion script should also set `user.SetMiscCharacterData("souvenir_<zone>", "collected")`
- A future "collections" command in the Library can count all `souvenir_*` keys to show progress like "You have collected 12 of 25 world souvenirs."
- The Librarian NPC can be given an `onAsk` handler for "collection" or "souvenirs" that checks the player's collection count.

## CRITICAL: GoMUD Naming & Format Rules

See `GOMUD_RULES.md` for the complete list. Key rules that cause server PANIC if violated:

1. **File naming:** `{id}-{ConvertForFilename(name)}.yaml` — lowercase, non-alphanum → underscore. Periods become underscore (so "Mr." → "mr_", creating double underscores like `mr__wormwood`). **CRITICAL: Do NOT use apostrophes or exclamation marks in zone names, quest names, or item names** — the engine keeps them in the expected path, creating filesystem mismatches. Strip them from the `name:` field (e.g. "Waynes World" not "Wayne's World", "Die Die My Darling" not "Die! Die! My Darling!").
2. **Item IDs < 10000** go in `other-0/`. IDs 10000-19999 = weapons, 20000-29999 = armor, 30000+ = consumables
3. **Zone folders** must match zone config `name:` lowercased with spaces → underscores. The `name:` field must NOT contain apostrophes, exclamation marks, or other special punctuation.
4. **Mob YAML:** `name`, `description`, `raceid`, `level` go INSIDE `character:` block, not top-level. No `hateraces` field (use `hates`).
5. **Room nouns:** flat `key: string` pairs, NOT nested maps with `description:`
6. **No sign/signtext in room YAML.** Signs are runtime-only via `scribe` command.
7. **ECMAScript 5.1 only** — no let/const, no arrow functions, no template literals.
8. **Conversation names** must be lowercase in Supported map.
9. **Quest filenames** follow same ConvertForFilename convention.

**Always validate filenames before committing.** Run the server locally to catch panics early.

## Git
Commit at natural milestones. Don't wait too long between commits.
