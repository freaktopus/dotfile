#!/usr/bin/env bash
# persistent "device" sessions shown on the second status line
#
#   device-sessions.sh bar <current session>     render the second line
#   device-sessions.sh click <range> <client>    status line click handler
#   device-sessions.sh add <name> [client]       add a device session
#   device-sessions.sh remove <name> [client]    remove a device session
#   device-sessions.sh restore                   recreate missing sessions
#
# the device list lives in ~/.config/tmux/devices, one name per line, and every
# name in it always has a session (recreated on start and when it is closed).
# this machine is always the first device and cannot be removed

list="$HOME/.config/tmux/devices"
cache="${XDG_RUNTIME_DIR:-/tmp}/tmux-device-tabs-$(id -u)"

fg="#ebdbb2"
muted="#a89984"
dim="#7c6f64"
faint="#504945"
surface="#3c3836"
orange="#fe8019"

sanitize() {
  printf '%s' "$1" | tr '.: ' '---' | tr -cd '[:alnum:]_-'
}

local_device=$(sanitize "$(uname -n | cut -d. -f1)")

devices() {
  printf '%s\n' "$local_device"
  [ -r "$list" ] && grep -vE '^\s*(#|$)' "$list" | grep -vxF "$local_device"
}

restore() {
  devices | while IFS= read -r name; do
    tmux has-session -t "=$name" 2>/dev/null || tmux new-session -d -s "$name" -c "$HOME"
  done
}

add() {
  name=$(sanitize "$1")
  [ -n "$name" ] || return
  mkdir -p "$(dirname "$list")"
  devices | grep -qxF "$name" || printf '%s\n' "$name" >> "$list"
  restore
  [ -n "$2" ] && tmux switch-client -c "$2" -t "=$name"
}

remove() {
  name="$1"
  client="$2"
  if [ "$name" = "$local_device" ]; then
    echo "$name is this machine and always stays on the bar" >&2
    return 1
  fi
  if [ -r "$list" ]; then
    grep -vxF "$name" "$list" > "$list.tmp"
    mv -f "$list.tmp" "$list"
  fi
  if [ -n "$client" ] && [ "$(tmux display -p -c "$client" '#{client_session}')" = "$name" ]; then
    next=$( { devices; tmux list-sessions -F '#{session_name}'; } | grep -vxF "$name" | head -1)
    [ -n "$next" ] || { tmux new-session -d -s main -c "$HOME"; next=main; }
    tmux switch-client -c "$client" -t "=$next"
  fi
  tmux kill-session -t "=$name" 2>/dev/null
}

bar() {
  current="$1"
  mapfile -t names < <(devices)
  mapfile -t others < <(tmux list-sessions -F '#{session_name}' | grep -vxF -f <(printf '%s\n' "${names[@]}" ""))
  declare -A windows
  while IFS=$'\t' read -r s w; do windows[$s]=$w; done < <(tmux list-sessions -F '#{session_name}	#{session_windows}')

  : > "$cache.$$"
  i=0
  tab() {
    # $1 = session name, $2 = colour of the name when not current
    printf '%s\t%s\n' "$i" "$1" >> "$cache.$$"
    count=${windows[$1]}
    if [ "$1" = "$current" ]; then
      printf '#[range=user|d:%s]#[bg=%s,fg=%s]▎#[fg=%s,bold]%s #[fg=%s,nobold]%s #[norange]#[bg=default] ' \
        "$i" "$surface" "$orange" "$fg" "$1" "$dim" "$count"
    else
      printf '#[range=user|d:%s]#[fg=%s] %s #[fg=%s]%s #[norange] ' "$i" "$2" "$1" "$faint" "${count:-0}"
    fi
    i=$(( i + 1 ))
  }

  for s in "${names[@]}"; do tab "$s" "$muted"; done
  if [ "${#others[@]}" -gt 0 ]; then
    [ "${#names[@]}" -gt 0 ] && printf '#[fg=%s]│ ' "$faint"
    for s in "${others[@]}"; do tab "$s" "$dim"; done
  fi
  mv -f "$cache.$$" "$cache"
}

click() {
  name=$(awk -F '\t' -v i="${1#d:}" '$1 == i { print $2 }' "$cache" 2>/dev/null)
  [ -n "$name" ] || return
  tmux has-session -t "=$name" 2>/dev/null || tmux new-session -d -s "$name" -c "$HOME"
  tmux switch-client -c "$2" -t "=$name"
}

cmd="$1"
shift
case "$cmd" in
  bar|restore) "$cmd" "$@" ;;
  click|add|remove)
    "$cmd" "$@"
    [ -n "$2" ] && tmux refresh-client -S -t "$2" 2>/dev/null
    ;;
  *) sed -n '2,12p' "$0" >&2; exit 1 ;;
esac
exit 0
