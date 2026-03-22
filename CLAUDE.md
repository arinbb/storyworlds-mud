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
| 500-599   | Starry Night        | Portal item exists |
| 600+      | Future worlds       | Available   |
| 900+      | Tutorial (system)   | Inherited   |

## Mob ID Allocation
| Range     | Zone           |
|-----------|----------------|
| 1-9       | System (rat, guard, guide - inherited) |
| 10-19     | Wonderland     |
| 20-29     | (next world)   |
| 100+      | Library (Librarian=100) |

## Item ID Allocation
| Range       | Type                |
|-------------|---------------------|
| 1-99        | System/keys/misc    |
| 10001-19999 | Weapons             |
| 20001-29999 | Armor               |
| 30001-39999 | Consumables         |
| 50001-50099 | Portal Books        |
| 50100-50199 | Portal Film Reels   |
| 50200-50299 | Portal Paintings    |
| 60001+      | Story world souvenirs/collectibles |

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

## Git
Commit at natural milestones. Don't wait too long between commits.
