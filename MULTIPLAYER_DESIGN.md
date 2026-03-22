# StoryWorlds Multiplayer Design Rules

GoMUD is inherently multiplayer. Every design decision must account for multiple players in the same zone simultaneously.

## What's Per-User vs Shared

| System | Scope | Implication |
|--------|-------|-------------|
| Quest progress | **Per-user** | Each player has their own quest state. Safe. |
| TempData | **Per-user** | Session data like `bj_count`, `visited_afterlife`. Safe. |
| MiscCharacterData | **Per-user** (persistent) | Permanent per-player data. Safe. |
| Inventory/items | **Per-user** | Each player has their own backpack. Safe. |
| Room items (floor/containers) | **Shared** | First-come-first-served. Respawns on timer. |
| Room PermData | **Shared** | ALL players see the same room state. Use carefully. |
| Room TempData | **Shared** | Session-level room state. All players share it. |
| Temporary exits | **Shared** | All players in the room see and can use them. |
| Mobs | **Shared instances** | All players see the same mob. SpawnMob creates new instances. |
| NPC-to-NPC conversations | **Shared** | All players in the room see ambient NPC dialogue. |
| Idle messages | **Shared** | All players in the room see idle messages. |

## Design Rules

### Rule 1: Portal Items Must Respawn
Portal books/reels/paintings are shared items in containers. When one player takes the Beetlejuice reel, others can't until it respawns. Our `respawnrate: 1 real minutes` handles this, but be aware of brief windows where an item is unavailable.

**Pattern:** Use short respawn rates (1-2 real minutes) for portal items so players don't wait long.

### Rule 2: Don't Use Room PermData for Player-Specific State
Room PermData is global. If you set `room.SetPermData("puzzle_solved", "true")`, it's solved for EVERYONE permanently.

**When to use PermData:** World-state changes that SHOULD affect all players (a bridge is built, a wall is destroyed, a door is permanently opened).

**When NOT to use PermData:** Player-specific progress. Use `user.SetMiscCharacterData()` (persistent) or `user.SetTempData()` (session) instead.

### Rule 3: Guard Against Duplicate Mob Spawning
`room.SpawnMob(id)` creates a new instance every call. If two players both trigger a summoning script, you get two Beetlejuices.

**Pattern:** Check if the mob already exists before spawning:
```javascript
var mobs = room.GetMobs(22);
if (mobs.length == 0) {
    room.SpawnMob(22);
}
```

### Rule 4: Temporary Exits Are Shared Events
When one player draws the chalk door, ALL players in the attic see the exit and can use it. This is actually good — it creates shared experiences and encourages cooperation.

**Pattern:** Treat temporary exits as world events. Use descriptive `SendRoomMessage` so everyone understands what happened.

### Rule 5: Script Commands Are User-Specific
`onCommand(cmd, rest, user, room)` fires for the specific user who typed the command. The `user` parameter is that player only. `SendUserMessage(user.UserId(), ...)` goes only to them.

**Pattern:** Use `SendUserMessage` for personal experiences (what you see/feel) and `SendRoomMessage` for what others witness.

### Rule 6: Quest Steps Must Use Per-User Tracking
Quest state is per-user. Use quest flags, user TempData, or MiscCharacterData for progression gating — never room PermData.

**Pattern for quest-gated exits:**
```javascript
// CORRECT — per-user check
if (user.HasQuest(10)) {
    // allow passage
}

// WRONG — shared state that one player sets for everyone
if (room.GetPermData("quest_done") == "true") {
    // this gate is open for ALL players once ONE completes it
}
```

### Rule 7: Item Pickups Are Race-Condition Vulnerable
Two players grabbing the same item simultaneously can cause issues. This is a known GoMUD limitation.

**Pattern:** For important items, use spawninfo with `respawnrate` rather than one-time spawns. For quest items, use `user.GiveItem(CreateItem(id))` in scripts to create a fresh copy for each player rather than placing one item on the ground.

### Rule 8: NPC Interactions Are Visible to All
When one player asks Adam about Beetlejuice, Adam's response (via `mob.Command("say ...")`) is visible to all players in the room. This is a feature, not a bug — it creates a living world.

**Pattern:** Write NPC dialogue as if other people might be listening. Avoid breaking the fourth wall in `say` commands.

### Rule 9: Instanced Rooms for Solo Experiences
Use `CreateInstancesFromRoomIds()` or `CreateInstancesFromZone()` when a player needs a private experience (dream sequence, solo trial, personal revelation).

**Pattern:**
```javascript
var instanceMap = CreateInstancesFromRoomIds([900, 901, 902]);
user.MoveRoom(instanceMap[900]); // player goes to their private copy
```

### Rule 10: Easter Eggs Should Be Repeatable
Easter eggs triggered by commands (say "nice model", pull face) should work for each player independently. Use per-user TempData to track who's already triggered them and avoid double-rewarding XP.

**Pattern:**
```javascript
if (user.GetMiscCharacterData("easter_nice_model") != "found") {
    user.GrantXP(500, "nice model");
    user.SetMiscCharacterData("easter_nice_model", "found");
}
```

## Audit Checklist for New Content

When creating new rooms, mobs, items, or scripts, verify:

- [ ] Portal items have respawn rates (1-2 real minutes)
- [ ] Mob spawning checks for existing instances before creating new ones
- [ ] Quest-gated content uses per-user state, not room PermData
- [ ] Easter egg XP rewards are one-time per player (MiscCharacterData guard)
- [ ] Important quest items are created via script (CreateItem) not floor spawns
- [ ] NPC dialogue makes sense if overheard by multiple players
- [ ] Temporary exits have appropriate durations and room-wide announcements
- [ ] Scripts use SendUserMessage for personal experiences, SendRoomMessage for shared events
