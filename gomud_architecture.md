---
name: GoMUD Architecture Reference
description: Comprehensive engine capabilities reference for GoMUD - rooms, items, mobs, scripts, quests, spells, buffs, mutators, conversations, biomes, pets, templates
type: reference
---

**Repo:** https://github.com/GoMudEngine/GoMud
**Runtime:** ECMAScript 5.1 via goja. Script load timeout: 1000ms, room script timeout: 50ms.
**Timing:** 50ms turns, 4s rounds, 900 rounds/day (1 real hour = 1 game day). Night = 8 of 24 game hours.

## Zone/Room System
- Zones = folders under `_datafiles/world/<world>/rooms/<zone>/`
- Each zone: `zone-config.yaml` + numbered room files + optional `.js` scripts
- Zone config: `name`, `roomid` (root), `autoscale` (min/max levels), `mutators`, `musicfile`, `defaultbiome`, `idlemessages`
- Room YAML: `roomid`, `zone`, `title`, `description`, `biome`, `mapsymbol`, `maplegend`, `musicfile`
- Special flags: `isbank`, `ischaracterroom`, `isstorage`, `pvp`
- Exits: compass, `up/down`, custom named (e.g., `vault`, `boat`, `canal`, `gateway`)
- Exit properties: `roomid`, `secret`, `mapdirection`, `exitmessage`, `lock` (difficulty, relockinterval, trapbuffids)
- Map directions: `north`, `south-x2`, `east-gap`, `west-gap2`, `northeast`, etc.
- Nouns: lookable objects, support aliasing via `:nounname` syntax
- Containers: named containers with optional `lock.difficulty` and `recipes` (crafting)
- SpawnInfo: `mobid`/`itemid`, `message`, `name` (override), `level`/`levelmod`, `forcehostile`, `respawnrate`, `maxwander`, `scripttag`, `questflags`, `idlecommands`, `container`, `gold`, `buffids`
- Skill training: `skilltraining: {skillname: {min: X, max: Y}}`
- Mutators: room-level environmental modifiers
- Signs: `sign.signtext` for readable signs
- `longtermdatastore`: persistent key-value per room

## Exits
- Standard: north/south/east/west/ne/nw/se/sw/up/down
- Custom named exits: any string works (boat, gateway, shadows, bushes, etc.)
- Locked exits: `lock.difficulty` (1-32+), `lock.relockinterval`, `lock.trapbuffids`
- Secret exits: `secret: true` - hidden from look, found via `search` skill
- Temporary exits: created via `room.AddTemporaryExit(simpleName, fancyName, roomId, duration)`

## Items
- Types: weapon, body/head/feet/gloves/belt/legs/neck/offhand/ring, key, potion, drink, food, botanical, object, readable
- Subtypes: wearable, drinkable, edible, usable, blobcontent, bludgeoning/slashing/stabbing/cleaving/shooting/whipping
- Key properties: `itemid`, `name`, `namesimple`, `displayname`, `description`, `type`, `subtype`
- Combat: `damage.diceroll` (e.g., `1d6`, `2d10+1`, `3@1d2` for multi-attack), `damagereduction`, `hands`
- Modifiers: `statmods`, `wornbuffids`, `buffids`, `critbuffids`, `cursed`, `breakchance`
- Usage: `uses` (0=unlimited), `keylockid` (for keys), `questtoken`
- Slots: head, neck, body, belt, gloves, ring, legs, feet, offhand (weapon separate)
- Stats: strength, speed, smarts, vitality, mysticism, perception, healthmax, manamax, healthrecovery, manarecovery, damage, attacks, casting, casting-restoration

## Item Script Hooks
- `onFound(user, item, room)` - gained item
- `onLost(user, item, room)` - lost item
- `onCommand(cmd, user, item, room)` - any command
- `onCommand_{verb}(user, item, room)` - specific verb (use, read, open, play, sweep, etc.)
- `onPurchase(user, item, room)` - shop purchase, return false to prevent

## Mob System
- Fields: `mobid`, `zone`, `name`, `description`, `hostile`, `maxwander`, `activitylevel`, `groups`, `hates`, `hateraces`
- Character block: `raceid`, `level`, `alignment`, `gold`, equipment, items, shop, spellbook
- Shop types: items (`itemid`+`quantitymax`+`restockrate`), buffs (`buffid`+`price`), pets (`pettype`+`price`), mobs (`mobid`+`quantitymax`), trade-for-item (`tradeitemid`)
- Combat: `combatcommands` (callforhelp, sneak, backstab, suicide vanish, portal home)
- Patrol: `mob.Command("pathto room1 room2 room3 home")` with `onPath` waypoints
- Scripting: via `scripts/{mobid}-{name}[-{scripttag}].js`
- Dynamic adjectives: `mob.SetAdjective("patrolling", true/false)`
- Charmed mobs: `mob.GetCharmedUserId()`, `mob.CharmSet(userId, rounds)`
- `scripttag`: loads alternate script file for same mob template

## Mob Script Hooks
- `onLoad(mob)`, `onIdle(mob, room)`, `onGive(mob, room, eventDetails)`, `onShow(mob, room, eventDetails)`
- `onAsk(mob, room, eventDetails)` - eventDetails.askText
- `onCommand(cmd, rest, mob, room, eventDetails)`, `onCommand_{cmd}(...)`
- `onHurt(mob, room, eventDetails)` - eventDetails.damage, .crit
- `onDie(mob, room, eventDetails)` - eventDetails.attackerCount
- `onPath(mob, room, eventDetails)` - eventDetails.status = start/waypoint/end
- `onPlayerDowned(mob, user, room)` - return true for once-per-type

## Room Script Hooks
- `onLoad(room)`, `onEnter(user, room)` (return false = suppress look), `onExit(user, room)`
- `onIdle(room)` (return true = suppress generic idle), `onCommand(cmd, rest, user, room)`
- `onCommand_{cmd}(rest, user, room)` - specific command handler

## Global Script API
- **Messaging:** SendBroadcast, SendUserMessage, SendRoomMessage, SendRoomExitsMessage
- **Retrieval:** GetUser(id), GetMob(instanceId), GetRoom(roomId), ActorNames(actors[])
- **Creation:** CreateItem(id), CreateEmptyRoomInstances(qty), CreateInstancesFromRoomIds(ids[]), CreateInstancesFromZone(name)
- **Maps:** GetMap(roomId, zoom, height, width, title, showSecrets, markers...)
- **Utilities:** UtilGetRoundNumber, UtilFindMatchIn(search, items[]), UtilGetSecondsToRounds/Turns, UtilGetMinutesToRounds/Turns, UtilStripPrepositions, UtilDiceRoll(qty, sides), UtilGetTime (Day/Hour/Hour24/Minute/AmPm/Night/DayStart/NightStart), UtilSetTimeDay, UtilSetTime, UtilIsDay, UtilLocateUser, UtilApplyColorPattern(text, pattern, wordsOnly?), UtilGetConfig, ExpandCommand

## Actor API (Users & Mobs, 90+ methods)
- **Identity:** UserId, InstanceId, MobTypeId, GetCharacterName, SetCharacterName, ShorthandId, GetRace, GetSize, GetLevel
- **Stats:** GetStat, GetStatMod, GetHealth/Max/Pct, SetHealth, AddHealth, GetMana/Max/Pct, AddMana
- **Resources:** AddGold(amt, bankAmt?), GrantXP(amt, reason), GetTrainingPoints, GiveTrainingPoints, GetStatPoints, GiveStatPoints, GiveExtraLife
- **Skills/Spells:** TrainSkill, GetSkillLevel, HasSpell, LearnSpell
- **Quests:** HasQuest, GiveQuest
- **Items:** HasItemId(id, excludeWorn?), GetBackpackItems, GiveItem, TakeItem, UpdateItem, Uncurse
- **Buffs:** HasBuff, GiveBuff(id, source), HasBuffFlag, CancelBuffWithFlag, RemoveBuff
- **Charm:** IsCharmed, GetCharmedUserId, CharmSet, CharmRemove, CharmExpire, GetCharmCount, GetMaxCharmCount
- **Movement:** GetRoomId, MoveRoom, SetResetRoomId, IsHome, Pathing, PathingAtWaypoint
- **Data:** SetTempData/GetTempData, SetMiscCharacterData/GetMiscCharacterData/GetMiscCharacterDataKeys
- **Commands:** Command(cmd, wait?), CommandFlagged(cmd, flags, wait?), Sleep(seconds)
- **Combat:** IsAggro, GetMobKills, GetRaceKills
- **Alignment:** GetAlignment, GetAlignmentName, ChangeAlignment
- **Taming:** IsTameable, GetTameMastery, SetTameMastery, GetChanceToTame
- **Timers:** TimerSet(name, period), TimerExpired, TimerExists
- **Party:** GetParty, GetPartyPresent, GetPartyMissing
- **Other:** GetPet, SendText, AddEventLog, GetLastInputRound, SetAdjective

## Party API (operates on all members)
GetMembers, SendText, SetResetRoomId, GiveQuest, AddGold, AddHealth, AddMana, Command, TrainSkill, MoveRoom, AddEventLog, GiveBuff, CancelBuffWithFlag, RemoveBuff, ChangeAlignment, LearnSpell, SetHealth, SetAdjective, GiveTrainingPoints, GiveStatPoints, GiveExtraLife, GrantXP, TimerSet

## Room API
- **Identity:** RoomId, IsEphemeral, RoomIdSource
- **Messaging:** SendText(msg, excludes...), SendTextToExits(msg, quiet, excludes...)
- **Data:** SetTempData/GetTempData, SetPermData/GetPermData
- **Items:** GetItems, DestroyItem, SpawnItem(id, inStash), RepeatSpawnItem(id, interval, container?)
- **Mobs:** GetMob(id, create?), GetMobs(id?), SpawnMob(id)
- **Players:** GetPlayers, GetAllActors
- **Structure:** GetContainers, GetExits (Name/Secret/Lock detail)
- **Quests:** HasQuest(id, partyUser?), MissingQuest(id, partyUser?)
- **Exits:** AddTemporaryExit, RemoveTemporaryExit, SetLocked, IsLocked
- **Mutators:** HasMutator, AddMutator, RemoveMutator

## Item API
ItemId, GetUsesLeft, SetUsesLeft, AddUsesLeft, GetLastUsedRound, MarkLastUsed, DisplayName, NameSimple, NameComplex, SetTempData/GetTempData, Rename(name, displayOrStyle?), ShorthandId, Redescribe

## Conversation System
- YAML files in `conversations/<zone>/<id>.yaml`
- `Supported` map: initiator name → participant name (* = wildcard)
- Actions: array of command arrays, one per round
- Commands: say, sayto, emote, look, shout, attack
- Triggers randomly when idle mobs of matching names are in the same room

## Quest System
- YAML files in `quests/<id>.yaml`
- Steps defined as ordered stages with completion triggers
- Rewards: experience, gold, item_id, skillinfo, buffid, questid, roomid, playermessage, roommessage
- Secret quests: hidden from quest log
- Quest gating: rooms can block exits based on quest state, mobs detect quest state

## Spells
- Types: helpsingle, helpmulti, harmsingle, harmmulti, harmarea, helparea, neutral
- Schools: restoration, conjuration, illusion
- Hooks: onCast (return false=abort), onWait (intermediate), onMagic (effect)
- Properties: manacost, waitrounds, levelrequired, castdifficulty

## Buffs (40+ types)
- Properties: buffid, name, description, triggercount, triggerspeed, flags, statmods, damage
- Flags: hidden, cancel-on-action/combat/water, lightsource, drunk, warmed, poison, no-combat/flee/go, superhearing, nightvision, see-hidden, see-nouns, revive-on-death, perma-gear, remove-curse, thirsty, hydrated, tripping
- Hooks: onStart, onTrigger, onEnd

## Mutators (environmental modifiers)
- Properties: mutatorid, namemodifier (append/replace + colorpattern), descriptionmodifier, alertmodifier
- Timing: respawnrate, decayrate (auto-remove), spawnnightonly/spawndayonly
- Effects: playerbuffids, mobbuffids, exits (add exits when active)
- Examples: death-recovery, dusty-floors (sweepable), wildfire (fire damage, decays), freezing-cold, pvp-enabled, pushed-boulder (reveals exit, decays)

## Biomes (17 types)
cave, city, cliffs, desert, dungeon, farmland, forest, fort, house, land, mountains, road, shore, snow, spiderweb, swamp, water
- Dark areas: cave, dungeon, spiderweb, swamp (need lightsource)
- Lit areas: city, fort, house, land (visible at night)
- Burnable: farmland, forest, house
- Special: water requires item 20030 (swimming gear)

## Races (21)
- Player: human, elf
- Key: each has unarmedname, size, defaultalignment, tnlscale, disabledslots, racial buffs, damage dice, base stats

## Pets (4)
cat (+speed, see-hidden), dog (+strength, 1d3 damage), mule (+vitality, +carrying), owl (+smarts, see-nouns)

## Advanced Patterns
1. **Quest-gated exits**: block movement unless player has quest step
2. **Time-of-day gates**: UtilIsDay() controls access
3. **Item-gated progress**: need specific item to use exit/interact
4. **Puzzle interactions**: custom verbs (push, pull, adjust, say) unlock secrets
5. **Ephemeral/instanced rooms**: CreateInstancesFromRoomIds for private areas
6. **Crafting**: container `recipes` map output item → input items
7. **Buff-on-enter**: rooms that apply buffs when entered
8. **Progressive dialogue**: TempData tracks conversation state per player
9. **Show vs Give distinction**: different outcomes for showing vs giving items
10. **Cumulative tracking**: SetMiscCharacterData for persistent per-player data
11. **Cross-mob scripting**: one mob's event triggers another mob's behavior
12. **Dynamic environment**: mutators that spawn/decay based on time, add/remove exits
13. **Party-wide operations**: GiveQuest, LearnSpell, MoveRoom for whole party
14. **Patrol routes**: pathto with waypoint events and location-aware dialogue
15. **Charmed companions**: mobs that follow and teleport to their owner
16. **Room data persistence**: SetPermData for permanent room state, SetTempData for session
17. **Timed item spawns**: RepeatSpawnItem with round intervals
18. **Custom map markers**: GetMap with room highlighting
19. **Mob-to-mob conversations**: ambient NPC dialogue via conversation YAML files
20. **Alignment system**: -100 to +100, affects interactions and quest access
