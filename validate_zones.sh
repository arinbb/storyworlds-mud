#!/bin/bash
# StoryWorlds Zone Validator
# Run before starting the server to catch common PANIC-causing issues.
# Usage: ./validate_zones.sh

cd "$(dirname "$0")/engine/_datafiles/world/storyworlds" || exit 1

ERRORS=0
WARNINGS=0

error() { echo "  ERROR: $1"; ERRORS=$((ERRORS + 1)); }
warn()  { echo "  WARN:  $1"; WARNINGS=$((WARNINGS + 1)); }

echo "=== StoryWorlds Zone Validator ==="
echo ""

# 1. Check for unquoted colons in idle messages
echo "[1] Checking for unquoted colons in YAML idle messages..."
while IFS= read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    error "$file:$linenum — unquoted colon in idle message (wrap in single quotes)"
done < <(grep -rn "^- [^'\"][^:]*: " rooms/*/[0-9]*.yaml 2>/dev/null | \
    grep -v "roomid:\|zone:\|title:\|description:\|mapsymbol:\|maplegend:\|biome:\|exits:\|nouns:\|spawninfo:\|container:\|lock:\|respawnrate:\|mapdirection:\|message:\|mobid:\|itemid:\|mutatorid:\|difficulty:\|secret:\|exitmessage:\|maxwander:\|levelmod:\|idlecommands:\|questflags:\|forcehostile:\|gold:\|buffids:\|scripttag:" | \
    grep -v "^rooms/[^/]*/zone-config.yaml")

# 2. Check mutator format in zone configs
echo "[2] Checking mutator format in zone-config.yaml files..."
for f in rooms/*/zone-config.yaml; do
    if grep -q "^mutators:" "$f"; then
        # Check if any mutator line is a bare string (not '- mutatorid:')
        if grep -A1 "^mutators:" "$f" | tail -1 | grep -q "^- [a-z]" && ! grep -A1 "^mutators:" "$f" | tail -1 | grep -q "^- mutatorid:"; then
            error "$f — mutator entry missing 'mutatorid:' prefix (use '- mutatorid: name' not '- name')"
        fi
    fi
done

# 3. Check mob filenames match character names (period → double underscore)
echo "[3] Checking mob filename conventions..."
for f in mobs/*/*.yaml; do
    name=$(grep "^  name:" "$f" | head -1 | sed 's/  name: //')
    if [ -z "$name" ]; then continue; fi
    # Compute expected filename
    expected=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed "s/'//g" | sed 's/!//g' | sed 's/[^a-z0-9]/_/g')
    mobid=$(basename "$f" | cut -d- -f1)
    expected_file="${mobid}-${expected}.yaml"
    actual_file=$(basename "$f")
    if [ "$actual_file" != "$expected_file" ]; then
        error "$f — filename '$actual_file' should be '$expected_file' (name='$name')"
    fi
done

# 4. Check for apostrophes/exclamation marks in zone names
echo "[4] Checking zone names for problematic characters..."
for f in rooms/*/zone-config.yaml; do
    name=$(grep "^name:" "$f" | sed 's/name: //')
    if echo "$name" | grep -q "[!'!]"; then
        error "$f — zone name '$name' contains apostrophe or exclamation mark (remove them)"
    fi
done

# 5. Check quest names for exclamation marks (apostrophes OK in quest names)
echo "[5] Checking quest names..."
for f in quests/*.yaml; do
    name=$(grep "^name:" "$f" | sed 's/name: //')
    if echo "$name" | grep -q '!'; then
        error "$f — quest name '$name' contains exclamation mark (remove it)"
    fi
done

# 6. Check item names for exclamation marks (apostrophes OK in item names)
echo "[6] Checking item names..."
for f in items/other-0/*.yaml; do
    name=$(grep "^name:" "$f" | sed 's/name: //')
    if echo "$name" | grep -q '!'; then
        error "$f — item name '$name' contains exclamation mark (remove it)"
    fi
done

# 7. Check mutator filenames use underscores not hyphens
echo "[7] Checking mutator filenames..."
for f in mutators/*.yaml; do
    base=$(basename "$f")
    if echo "$base" | grep -q "[^_a-z0-9.]"; then
        warn "$f — mutator filename should use only lowercase letters, numbers, and underscores"
    fi
done

# 8. Check nouns aren't nested maps
echo "[8] Checking for nested noun maps..."
for f in rooms/*/[0-9]*.yaml; do
    if grep -A1 "^nouns:" "$f" | grep -q "description:"; then
        error "$f — noun uses nested 'description:' map (should be flat key: string)"
    fi
done

# 9. Check mob character block structure
echo "[9] Checking mob YAML structure..."
for f in mobs/*/*.yaml; do
    if grep -q "^name:" "$f"; then
        error "$f — 'name:' is at top level (should be inside 'character:' block)"
    fi
    if grep -q "^description:" "$f"; then
        error "$f — 'description:' is at top level (should be inside 'character:' block)"
    fi
    if grep -q "^raceid:" "$f"; then
        error "$f — 'raceid:' is at top level (should be inside 'character:' block)"
    fi
    if grep -q "^hateraces:" "$f"; then
        error "$f — 'hateraces:' is not a valid field (use 'hates:' instead)"
    fi
done

# 10. Check for ES5.1 violations in JS files
echo "[10] Checking JavaScript for ES5.1 violations..."
for f in rooms/*/*.js mobs/*/scripts/*.js items/other-0/*.js; do
    [ -f "$f" ] || continue
    if grep -qn "^\s*let " "$f"; then
        error "$f — uses 'let' (ES5.1 requires 'var')"
    fi
    if grep -qn "^\s*const " "$f"; then
        error "$f — uses 'const' (ES5.1 requires 'var')"
    fi
    if grep -qn "=>" "$f"; then
        error "$f — uses arrow function (not ES5.1 compatible)"
    fi
    if grep -qn '`' "$f"; then
        error "$f — uses template literal backticks (not ES5.1 compatible)"
    fi
done

echo ""
echo "=== Results ==="
echo "Errors:   $ERRORS"
echo "Warnings: $WARNINGS"
if [ $ERRORS -gt 0 ]; then
    echo "FIX ERRORS BEFORE STARTING THE SERVER — they will cause PANICs."
    exit 1
else
    echo "All clear — safe to start the server."
    exit 0
fi
