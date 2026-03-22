# StoryWorlds Zone Framework

A reusable system for creating new fictional world zones in the StoryWorlds MUD.

## Architecture Overview

```
Library Hub (rooms 1-99)
  ├── Book Stacks → Books (items 50001-50099)
  ├── Screening Room → Film Reels (items 50100-50199)
  └── Gallery → Paintings (items 50200-50299)

Each media item transports player to a zone:
  Wonderland (rooms 100-199)
  Odyssey (rooms 200-299)
  Blade Runner (rooms 300-399)
  Princess Bride (rooms 400-499)
  Starry Night (rooms 500-599)
  ... (each new world gets a 100-room block)
```

## Room ID Allocation

| Range     | Zone                |
|-----------|---------------------|
| 1-99      | Library Hub         |
| 100-199   | Wonderland          |
| 200-299   | The Odyssey         |
| 300-399   | Blade Runner        |
| 400-499   | The Princess Bride  |
| 500-599   | Starry Night        |
| 600-699   | (next world)        |
| 700-799   | (next world)        |
| 900+      | Tutorial (system)   |

## Creating a New Story World Zone

### Step 1: Create the zone folder
```
mkdir -p engine/_datafiles/world/storyworlds/rooms/<zone_name>
mkdir -p engine/_datafiles/world/storyworlds/mobs/<zone_name>/scripts
```

### Step 2: Zone config (zone-config.yaml)
```yaml
name: <Display Name>
roomid: <first room ID, e.g. 300>
autoscale:
  minimum: 1
  maximum: 5
defaultbiome: <biome>  # city, forest, dungeon, cave, water, house, etc.
idlemessages:
- <atmospheric message 1>
- <atmospheric message 2>
- <atmospheric message 3>
- <atmospheric message 4>
```

### Step 3: Entry room (must handle "return" command)
Every story world's entry room MUST include a script with the return handler:

```javascript
// entry_room.js - TEMPLATE
var LIBRARY_ROOM = 1;

function onCommand(cmd, rest, user, room) {
    if (cmd == "return") {
        SendUserMessage(user.UserId(), "<ansi fg=\"cyan\">[Departure description]</ansi>");
        SendRoomMessage(room.RoomId(), user.GetCharacterName(true) + " [departure message for others]", user.UserId());
        user.MoveRoom(LIBRARY_ROOM);
        return true;
    }
    // ... other custom interactions
    return false;
}

function onEnter(user, room) {
    SendUserMessage(user.UserId(), "");
    SendUserMessage(user.UserId(), "<ansi fg=\"cyan\">[Arrival description]</ansi>");
    SendUserMessage(user.UserId(), "");
    SendUserMessage(user.UserId(), "<ansi fg=\"3\">(Type 'return' at any time to go back to the Grand Library.)</ansi>");
    return false;
}
```

**IMPORTANT:** Every room in a story world should handle "return" in its script. Copy the return handler into each room's .js file so players can leave from anywhere.

### Step 4: Create the portal item

**For books** (items/other-0/5XXXX-name.yaml):
```yaml
itemid: 5XXXX
name: <Book Title>
namesimple: book
displayname: a copy of <ansi fg="itemname"><Book Title></ansi>
description: <physical description of the book>
type: object
subtype: usable
uses: 0
value: 0
```

**For film reels** (items/other-0/5XXXX-name.yaml):
```yaml
itemid: 5XXXX
name: <Film Title> film reel
namesimple: reel
displayname: a film reel labeled <ansi fg="itemname"><Film Title></ansi>
description: <physical description of the reel>
type: object
subtype: usable
uses: 0
value: 0
```

**For paintings** (items/other-0/5XXXX-name.yaml):
```yaml
itemid: 5XXXX
name: <Painting Title> painting
namesimple: painting
displayname: a framed print of <ansi fg="itemname"><Painting Title></ansi>
description: <physical description of the artwork>
type: object
subtype: usable
uses: 0
value: 0
```

### Step 5: Create the portal item script

```javascript
// Portal item script - TEMPLATE
var DEST_ROOM = <entry room ID>;
var WORLD_NAME = "<World Name>";
var ENTER_MSG_SELF = "<what the player experiences>";
var ENTER_MSG_ROOM = "<what others see>";

// Books respond to: open, read, use
// Films respond to: load, use, play
// Art responds to: gaze, use, enter

function onCommand_<verb>(user, item, room) {
    return enterWorld(user, item, room);
}

function onCommand_use(user, item, room) {
    return enterWorld(user, item, room);
}

function enterWorld(user, item, room) {
    SendUserMessage(user.UserId(), "");
    SendUserMessage(user.UserId(), "<ansi fg=\"<color>\">" + ENTER_MSG_SELF + "</ansi>");
    SendRoomMessage(room.RoomId(), user.GetCharacterName(true) + "<ansi fg=\"<color>\">" + ENTER_MSG_ROOM + "</ansi>", user.UserId());
    user.MoveRoom(DEST_ROOM);
    return true;
}
```

### Step 6: Place the item in the Library
Add a spawninfo entry to the appropriate library room:
- Books → rooms/library/2.yaml (Book Stacks)
- Films → rooms/library/3.yaml (Screening Room)
- Art → rooms/library/4.yaml (Gallery)

```yaml
spawninfo:
- itemid: 5XXXX
  container: shelves  # or "wall" for gallery
  respawnrate: 1 real minutes
```

## Dynamic Content Patterns

### Pattern 1: Interactive Objects (nouns)
Use `nouns` in room YAML for things players can `look` at:
```yaml
nouns:
  fountain:
    description: >-
      The fountain bubbles with mercury-colored liquid...
```

### Pattern 2: Custom Verb Interactions (room scripts)
Handle custom commands in room `.js` files:
```javascript
function onCommand(cmd, rest, user, room) {
    if (cmd == "drink" && rest.indexOf("fountain") >= 0) {
        SendUserMessage(user.UserId(), "You drink from the fountain...");
        return true;
    }
    return false;
}
```

### Pattern 3: Atmospheric NPCs (non-combat mobs)
Create mobs that talk and emote but don't fight:
```yaml
# mob YAML
hateraces: []
angrycommands: []

# In room spawninfo:
spawninfo:
- mobid: XX
  idlecommands:
  - say <dialogue line>
  - ""            # empty string = do nothing (creates pauses)
  - emote <action>
  - wander        # mob wanders to adjacent rooms
```

### Pattern 4: NPC Conversations (ask system)
Use mob scripts with `onAsk` for topic-based dialogue:
```javascript
function onAsk(mob, room, eventDetails) {
    var question = eventDetails.askText.toLowerCase();
    if (question.indexOf("treasure") >= 0) {
        mob.Command("say Ah, the treasure? It lies beyond the...");
        return true;
    }
    return true;
}
```

### Pattern 5: Scene Transitions (temporary exits)
Create dramatic exits that appear based on actions:
```javascript
function onCommand(cmd, rest, user, room) {
    if (cmd == "pull" && rest.indexOf("lever") >= 0) {
        room.AddTemporaryExit("hidden passage", ":cyan", 305, "10 real minutes");
        SendRoomMessage(room.RoomId(), "A hidden passage grinds open in the wall!");
        return true;
    }
    return false;
}
```

### Pattern 6: Idle Atmosphere
Use `idlemessages` liberally for immersion. Aim for 5+ per room:
```yaml
idlemessages:
- <sight>
- <sound>
- <smell or sensation>
- <NPC activity>
- <environmental change>
```

### Pattern 7: Collectible Souvenirs
Create items players can find in story worlds and bring back:
```yaml
itemid: 6XXXX
name: <souvenir name>
description: <description with narrative significance>
type: object
subtype: usable
uses: 0
value: 1
```

### Pattern 8: Danger/Combat Encounters
For worlds that warrant it, add hostile mobs sparingly:
```yaml
spawninfo:
- mobid: XX
  forcehostile: true
  respawnrate: 5 real minutes
  message: <dramatic entrance>
```

## Biome Suggestions by Genre

| Genre          | Biome    | Notes                           |
|----------------|----------|---------------------------------|
| Fantasy        | forest   | Magic, medieval settings        |
| Sci-Fi         | city     | Urban, futuristic               |
| Horror         | dungeon  | Dark, confined                  |
| Ocean/Naval    | water    | Seas, ships                     |
| Interior       | house    | Rooms, buildings                |
| Wilderness     | forest   | Natural settings                |
| Underground    | cave     | Mines, tunnels                  |
| Desert/Arid    | desert   | Barren landscapes               |
| Mountain       | mountains| Peaks, passes                   |
