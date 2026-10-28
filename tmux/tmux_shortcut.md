# tmux shortcuts (your config)

**Prefix = `Ctrl-a`** — press it first, then the key. Written as `C-a` below.

Yes: **`C-a` `s`** opens the session tree (pick a session / its windows).  
**`C-a` `w`** opens the window tree for the current session.

---

## Sessions

| Keys | Action |
|------|--------|
| `C-a` `s` | Session picker (tree) |
| `C-a` `C-c` | New session (prompts for name) |
| `C-a` `C-f` | Find / switch session by name |
| `C-a` `(` / `)` | Previous / next session |
| `C-a` `BTab` | Last session |
| `C-a` `$` | Rename session |
| `C-a` `d` | Detach |

### Device sessions (second status line)

| Action | How |
|--------|-----|
| Switch to a device / session | **Click** its tab on the second status line |
| Add a device | `~/.config/tmux/scripts/device-sessions.sh add <name>` (or add a line to `~/.config/tmux/devices`) |
| Remove a device | `~/.config/tmux/scripts/device-sessions.sh remove <name>` |

Device sessions come back automatically when closed. Closing a session switches you to another one instead of detaching.

## Windows

| Keys | Action |
|------|--------|
| `C-a` `c` | New window |
| `C-a` `w` | Window picker (tree) |
| `C-a` `C-h` / `C-l` | Prev / next window |
| `C-a` `Tab` | Last window |
| `C-a` `1`…`9` | Jump to window N |
| `C-a` `,` | Rename window |
| `C-a` `&` | Kill window |
| `C-a` `f` | Find window |
| `C-a` `.` | Move window |
| `C-a` `C-S-H` / `C-S-L` | Swap window left / right |

## Panes / splits

| Keys | Action |
|------|--------|
| `C-a` `\|` or `_` | Split horizontal (side by side) |
| `C-a` `-` | Split vertical (top / bottom) |
| `C-a` `h` `j` `k` `l` | Move between panes |
| `C-a` `H` `J` `K` `L` | Resize pane |
| `C-a` `z` | Zoom / unzoom pane |
| `C-a` `+` | Maximize pane (toggle) |
| `C-a` `x` | Kill pane |
| `C-a` `!` | Break pane into window |
| `C-a` `;` | Last pane |
| `C-a` `q` | Show pane numbers |
| `C-a` `<` / `>` | Swap pane |
| `C-a` `Space` | Next layout |

## Mouse & copy

**Mouse is on** normally (scroll, click, resize).  
**Keyboard copy-mode is off.**

| Action | How |
|--------|-----|
| Select / copy text | Hold **Shift** + drag → `Ctrl-Shift-V` |
| Toggle mouse | `C-a` `m` |
| Stuck after drag | `Esc` |

## Config / misc

| Keys | Action |
|------|--------|
| `C-a` `r` | Reload config (not restore — restore is `C-a` `Ctrl-r`) |
| `C-a` `e` | Edit `tmux.conf.local` |
| `C-a` `m` | Toggle mouse |
| `C-a` `t` | Clock |
| `C-a` `?` | List keys |
| `C-a` `:` | Command prompt |
| `C-l` | Clear screen + history (no prefix) |

## Resurrect / continuum (survive accidental close)

Saves under `~/.local/share/tmux/resurrect/`. Continuum **auto-saves every 15 min** (default, counted from tmux server start). It does **not** auto-restore on start — use `C-a` `Ctrl-r`. Every save (auto or `C-a` `Ctrl-s`) moves the `last` link to the new snapshot, and `C-a` `Ctrl-r` always opens whatever `last` points to.

| Keys | Action |
|------|--------|
| `C-a` `Ctrl-s` | Save now (manual) |
| `C-a` `Ctrl-r` | **Replace** the current session's windows with the saved windows (last save) |

`C-a` `Ctrl-r` closes every window of the current session (and whatever runs in them) and opens only the saved windows in it, with their directories, layouts, programs (e.g. `nvim`) and the previously active window. Other sessions are not touched.

- If the save contains a session with the **same name** as the current one, only that session's windows are restored.
- Otherwise **all** saved windows are restored into the current session.
- The old windows are killed only after the saved ones were created, so a failed restore keeps what you had.

There is **no shortcut** to pick an older snapshot — only `last`. See below to restore an older one.

Closing Alacritty only **detaches** (sessions stay running). Continuum does **not** save on close/exit — only on the 15‑min timer or `C-a Ctrl-s`. Save manually before `kill-server` if you just changed something.

### Restore an older save (not `last`)

```bash
ls -lt ~/.local/share/tmux/resurrect/
cd ~/.local/share/tmux/resurrect
ln -fs tmux_resurrect_YYYYMMDDTHHMMSS.txt last   # pick the file you want
```

Then in tmux: `C-a` `Ctrl-r`.

Live session switching (not related to saves): `C-a` `s` or `C-a` `(` / `)`.

## Plugins (TPM / Oh my tmux)

| Keys | Action |
|------|--------|
| `C-a` `I` | Install plugins |
| `C-a` `u` | Update plugins |
| `C-a` `Alt-u` | Uninstall unused plugins |
