#!/bin/bash
# StoryWorlds Zone Statistics Generator
# Generates a comprehensive report of all zones, their contents, and interaction commands.
# Usage: ./zone_stats.sh

cd "$(dirname "$0")/engine/_datafiles/world/storyworlds" || exit 1

SKIP="tutorial the_grand_library endless_trashheap shadow_realm startland"

echo "=== StoryWorlds Content Statistics ==="
echo ""
printf "%-30s %5s %5s %5s %5s %5s %5s %5s\n" "Zone" "Rooms" "Mobs" "Nouns" "Eggs" "Convs" "Mutat" "Cmds"
echo "----------------------------------------------------------------------------------------------"

total_rooms=0; total_mobs=0; total_nouns=0; total_eggs=0; total_convs=0; total_muts=0; total_cmds=0

for zone_dir in rooms/*/; do
    zone=$(basename "$zone_dir")
    skip=false
    for s in $SKIP; do [ "$zone" = "$s" ] && skip=true; done
    $skip && continue

    rooms=$(ls "$zone_dir"*.yaml 2>/dev/null | grep -v zone-config | wc -l | tr -d ' ')
    mobs=0; [ -d "mobs/$zone" ] && mobs=$(ls mobs/$zone/*.yaml 2>/dev/null | wc -l | tr -d ' ')
    nouns=$(grep -c "^  [a-z].*: >-" "$zone_dir"*.yaml 2>/dev/null | awk -F: '{s+=$NF}END{print s+0}')
    eggs=$(grep -c "GrantXP" "$zone_dir"*.js 2>/dev/null | awk -F: '{s+=$NF}END{print s+0}')
    convs=0; [ -d "conversations/$zone" ] && convs=$(ls conversations/$zone/*.yaml 2>/dev/null | wc -l | tr -d ' ')
    muts=$(grep -c "mutatorid:" "$zone_dir/zone-config.yaml" 2>/dev/null || true); muts=${muts:-0}; muts=$(echo "$muts" | tr -d '[:space:]')
    cmds=$(grep -oh 'cmd == "[a-z_]*"' "$zone_dir"*.js 2>/dev/null | sed 's/cmd == "//;s/"//' | sort -u | wc -l | tr -d ' ')

    printf "%-30s %5s %5s %5s %5s %5s %5s %5s\n" "$zone" "$rooms" "$mobs" "$nouns" "$eggs" "$convs" "$muts" "$cmds"
    total_rooms=$((total_rooms + rooms))
    total_mobs=$((total_mobs + mobs))
    total_nouns=$((total_nouns + nouns))
    total_eggs=$((total_eggs + eggs))
    total_convs=$((total_convs + convs))
    total_muts=$((total_muts + muts))
    total_cmds=$((total_cmds + cmds))
done

echo "----------------------------------------------------------------------------------------------"
printf "%-30s %5s %5s %5s %5s %5s %5s %5s\n" "TOTALS" "$total_rooms" "$total_mobs" "$total_nouns" "$total_eggs" "$total_convs" "$total_muts" "$total_cmds"

echo ""
echo "=== Global Counts ==="
echo "Total items: $(find items -name '*.yaml' | wc -l | tr -d ' ')"
echo "Total quests: $(find quests -name '*.yaml' | wc -l | tr -d ' ')"
echo "Total mutator files: $(find mutators -name '*.yaml' | wc -l | tr -d ' ')"
echo "Total conversation files: $(find conversations -name '*.yaml' 2>/dev/null | wc -l | tr -d ' ')"
echo "Total JS scripts: $(find rooms mobs items -name '*.js' 2>/dev/null | wc -l | tr -d ' ')"

echo ""
echo "=== Library Hub ==="
echo "Rooms: $(ls rooms/the_grand_library/*.yaml 2>/dev/null | grep -v zone-config | wc -l | tr -d ' ') (Atrium, Book Stacks, Screening Room, Gallery, Mezzanine, Deep Stacks, Listening Room, Arcade, Trophy Room)"
echo "Portal items in Book Stacks: $(grep -c 'itemid:' rooms/the_grand_library/2.yaml 2>/dev/null)"
echo "Portal items in Screening Room: $(grep -c 'itemid:' rooms/the_grand_library/3.yaml 2>/dev/null)"
echo "Portal items in Gallery: $(grep -c 'itemid:' rooms/the_grand_library/4.yaml 2>/dev/null)"
echo "Portal items in Listening Room: $(grep -c 'itemid:' rooms/the_grand_library/7.yaml 2>/dev/null)"
echo "Portal items in Arcade: $(grep -c 'itemid:' rooms/the_grand_library/8.yaml 2>/dev/null)"
