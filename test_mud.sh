#!/bin/bash
# StoryWorlds MUD automated test script
# Usage: ./test_mud.sh [command1] [command2] ...
# Default: runs a basic walk-through test
# Requires: server running on localhost:33333

STRIP_ANSI='s/\x1b\[[0-9;]*m//g; s/\x1b\[[^a-zA-Z]*[a-zA-Z]//g; s/\r//g; s/\[G\[2K//g; s/!!MUSIC[^)]*\)//g'

send_commands() {
    local cmds=""
    # Login
    cmds="admin\n"
    sleep_cmd="sleep 1\n"
    cmds+="password\n"

    # Add each command with a delay
    for cmd in "$@"; do
        cmds+="$cmd\n"
    done

    cmds+="quit\n"

    # Send commands via netcat, strip ANSI, filter empty lines
    printf "$cmds" | while IFS= read -r line; do
        echo "$line"
        sleep 0.5
    done | nc -w 8 localhost 33333 2>/dev/null | sed "$STRIP_ANSI" | grep -v '^$' | grep -v '^\s*$' | grep -v '═\|─\|│\|╒\|╕\|└\|┘\|║\|╔\|╗\|╚\|╝'
}

if [ $# -eq 0 ]; then
    # Default test: basic walkthrough
    echo "=== StoryWorlds MUD Test ==="
    echo "--- Testing: Login and Library ---"
    send_commands "look" "north" "look" "south" "east" "look" "west" "look desk"
else
    send_commands "$@"
fi
