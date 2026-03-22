#!/bin/bash
# Minimal MUD client for automated testing
# Usage: echo "command" | ./mudclient.sh
#   or:  ./mudclient.sh "look" "north" "look" "quit"
# Strips ANSI codes and telnet noise from output

HOST="${MUD_HOST:-localhost}"
PORT="${MUD_PORT:-33333}"
USER="${MUD_USER:-admin}"
PASS="${MUD_PASS:-password}"
DELAY="${MUD_DELAY:-0.8}"

# Build command sequence
{
    echo "$USER"
    sleep "$DELAY"
    echo "$PASS"
    sleep 2  # wait for login splash

    if [ $# -gt 0 ]; then
        for cmd in "$@"; do
            sleep "$DELAY"
            echo "$cmd"
        done
    else
        # Read commands from stdin
        while IFS= read -r cmd; do
            sleep "$DELAY"
            echo "$cmd"
        done
    fi

    sleep "$DELAY"
    echo "quit"
} | nc -w 10 "$HOST" "$PORT" 2>/dev/null | \
    sed 's/\x1b\[[0-9;]*m//g' | \
    sed 's/\x1b\[[^a-zA-Z]*[a-zA-Z]//g' | \
    sed 's/\r//g' | \
    sed 's/\[G\[2K//g' | \
    sed 's/!!MUSIC([^)]*)//g' | \
    tr -d '\377\375\374\373\376\372' | \
    sed '/^[[:space:]]*$/d'
