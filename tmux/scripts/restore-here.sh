#!/usr/bin/env bash
# usage: restore-here.sh <session>
# tmux-resurrect restore that replaces the windows of <session> with the saved
# windows instead of recreating the saved sessions. if the save has a session
# with the same name only its windows are used, otherwise every saved window.
# the old windows are killed only after the saved ones were created

target="$1"
[ -n "$target" ] || exit 1

resurrect="$HOME/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh"
orig_dir=$(tmux show -gqv @resurrect-dir)
dir="$orig_dir"
if [ -z "$dir" ]; then
  if [ -d "$HOME/.tmux/resurrect" ]; then
    dir="$HOME/.tmux/resurrect"
  else
    dir="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect"
  fi
fi
dir=$(printf '%s' "$dir" | sed "s,\$HOME,$HOME,g; s,~,$HOME,g")

if [ ! -f "$dir/last" ]; then
  tmux display "nothing saved yet (prefix + C-s saves)"
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

old_windows=$(tmux list-windows -t "=$target:" -F '#{window_id}')
offset=$(tmux list-windows -t "=$target:" -F '#{window_index}' | sort -n | tail -1)

# map "session<TAB>window" -> new window index, in saved order, plus a trailing
# "*" on the window that was active
awk -F '\t' -v offset="${offset:-0}" -v target="$target" '
  $1 == "window" {
    k = $2 "\t" $3
    order[++w] = k; sess[w] = $2
    active[k] = ($5 == 1)
    if ($2 == target) same = 1
  }
  END {
    next_index = offset
    for (i = 1; i <= w; i++) {
      if (same && sess[i] != target) continue
      k = order[i]
      print k "\t" ++next_index "\t" (active[k] ? "*" : "")
    }
  }' "$dir/last" > "$tmp/map"

if [ ! -s "$tmp/map" ]; then
  tmux display "no saved windows to restore into $target"
  exit 0
fi

awk -F '\t' -v OFS='\t' -v target="$target" '
  FNR == NR { map[$1 "\t" $2] = $3; next }
  ($1 == "pane" || $1 == "window") && (($2 "\t" $3) in map) { $3 = map[$2 "\t" $3]; $2 = target; print }
' "$tmp/map" "$dir/last" > "$tmp/last"

if [ -f "$dir/pane_contents.tar.gz" ]; then
  mkdir -p "$tmp/src"
  gzip -d < "$dir/pane_contents.tar.gz" | tar xf - -C "$tmp/src" 2>/dev/null
  mkdir -p "$tmp/out/pane_contents"
  while IFS=$'\t' read -r session window new _; do
    for f in "$tmp/src/pane_contents/pane-$session:$window."*; do
      [ -f "$f" ] && cp "$f" "$tmp/out/pane_contents/pane-$target:$new.${f##*.}"
    done
  done < "$tmp/map"
  tar cf - -C "$tmp/out" ./pane_contents/ | gzip > "$tmp/pane_contents.tar.gz"
fi

tmux set -g @resurrect-dir "$tmp"
"$resurrect" 2>/dev/null
if [ -n "$orig_dir" ]; then
  tmux set -g @resurrect-dir "$orig_dir"
else
  tmux set -gu @resurrect-dir
fi

restored=$(tmux list-windows -t "=$target:" -F '#{window_index}' | awk -v o="${offset:-0}" '$1 > o' | wc -l)
if [ "$restored" -eq 0 ]; then
  tmux display "restore failed, kept the current windows of $target"
  exit 1
fi

active_index=$(awk -F '\t' '$4 == "*" { print $3; exit }' "$tmp/map")
active_id=$(tmux display -p -t "=$target:${active_index:-$((offset + 1))}" '#{window_id}' 2>/dev/null)

for w in $old_windows; do
  tmux kill-window -t "$w" 2>/dev/null
done
tmux move-window -r -t "=$target:" 2>/dev/null
[ -n "$active_id" ] && tmux select-window -t "$active_id"

tmux display "replaced $target with $restored saved window(s)"
