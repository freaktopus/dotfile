# kitty shortcuts

**Prefix = `Ctrl-a`.** Press it, let go, then press the next key. Written below as `C-a`.

## Words

| Word | What it is |
|---|---|
| **session** | One per device: `beacon404` (this machine, the default), `k2`, `K-T4`. Each has its own tabs. |
| **tab** | One entry on the tab bar |
| **split** | A window inside a tab |
| **saved tabs** | A set of tabs saved by hand (`ampixa`, `dengue`, `ieee`, `portfolio`, `repo`, and every `C-a s`). Any session can load one. |

## The bar (bottom)

- **Left:** the tabs of the current session only.
- **Right:** the sessions, then date and clock.
  - `● name 3` on an orange block: the session you are in (3 = its tabs).
  - `○ name 2` on a grey block: open, but not on screen.
  - A dim name: not opened yet.
  - `+` makes a new session.
- **Left click** a session to go to it. **Right click** for its menu: switch, save, load saved tabs, reload, rename, kill, delete.

## Sessions and saving

| Keys | Action |
|------|--------|
| `C-a` `S` | Pick a session |
| `C-a` `n` | New session |
| `C-a` `R` | Rename the current session |
| `C-a` `m` | Menu of the current session |
| `C-a` `s` | **Save** only the tabs of the current session, as `manual/<session>_<date>_<time>`. A new file every time. |
| `C-a` `o` | **Load saved tabs**: pick one from `manual/` (newest first). The session's current tabs are closed first. |
| `C-a` `X` | **Remove** a saved set of tabs (pick, confirm, deleted) |
| `C-a` `N` | **Rename** a saved set of tabs (pick, type the new name) |
| `C-a` `O` | **Reload the last manual save** of the current session (no list) |
| `C-a` `r` | **Restore the autosave**: all device sessions, each with its tabs, folders, running programs and layout. Open tabs of those sessions are replaced. |
| `C-a` `Ctrl-k` | **Close the session**: closes all its tabs, but it stays on the bar and its files are kept |

Delete (in the menu) closes the session and removes its files and its place on the bar.

When a program is still running, closing a session, closing kitty, loading or reloading asks first.

**Default tabs:** every session opens with the same tabs as `k2` (Nvim, Terminal, Terminal 2), including new ones from `+`. Change `sessions/k2.kitty-session` to change what new sessions start with.

**Autosave:** every 15 minutes every open session is written to `autosave/<session>`, overwriting the last one: its tabs, their titles, folders, split layout, the program in each window (like `nvim`) and which tab was active. `C-a r` restores all of it. The copy from before the last kitty start is kept once in `autosave/previous/`. It never touches `manual/`. The right-click menu "Reload the autosave" restores just one session.

Programs that were running (like `nvim`) are saved too. When the program quits you land in a shell.

## Tabs

| Keys | Action |
|------|--------|
| `C-a` `c` | New tab (same folder) |
| `C-a` `w` | Tab picker |
| `C-a` `Ctrl-h` / `Ctrl-l` | Previous / next tab |
| `C-a` `Tab` | Last tab |
| `C-a` `1`…`9` | Jump to tab N |
| `C-a` `,` | Rename tab |
| `C-a` `&` | Close tab |
| `C-a` `Ctrl-Shift-h` / `Ctrl-Shift-l` | Move tab left / right |

## Splits

| Keys | Action |
|------|--------|
| `C-a` `\|` or `_` | Split side by side |
| `C-a` `-` | Split top / bottom |
| `C-a` `h` `j` `k` `l` | Move between splits |
| `C-a` `H` `J` `K` `L` | Resize split |
| `C-a` `z` | Zoom / unzoom the split |
| `C-a` `x` | Close split |
| `C-a` `!` | Turn the split into its own tab |
| `C-a` `q` | Pick a split by number |
| `C-a` `Space` | Next layout |
| `C-a` `<` / `>` | Move split |

## Copy, scroll, text

- Select text with the mouse: it is copied automatically. Paste: `Ctrl-Shift-v`. Copy: `Ctrl-Shift-c`.
- `Ctrl-Shift-z`: scrollback in Neovim. `Ctrl-Shift-i`: screen text in Neovim.
- `Ctrl-l`: clear screen and history.

## Without the prefix

| Keys | Action |
|------|--------|
| `Ctrl-Shift-Enter` | New split |
| `Ctrl-Shift-t` | New tab |
| `Ctrl-Shift-Left` / `Right` | Previous / next tab |
| `Ctrl-Shift-h` / `l` | Previous / next split |
| `Ctrl-Shift-w` | Close split |
| `Ctrl-Shift-q` | Close the whole window |
| `Ctrl-Shift-,` | Reload config |
| `Ctrl-Shift-+` / `-` | Bigger / smaller text |

## Config

| Keys | Action |
|------|--------|
| `C-a` `Ctrl-r` | Reload config |
| `C-a` `e` | Edit `kitty.conf` |
| `C-a` `:` | kitty command shell |
| `C-a` `?` | Open this guide |
| `C-a` `C-a` | Send a real `Ctrl-a` to the program |

If a change needs a restart (fonts, tab bar style), close and reopen kitty.

## Files (`~/.config/kitty/`)

| What | Where |
|---|---|
| Saved tabs | `manual/` |
| Autosave | `autosave/` |
| Session base files: the default tabs a session opens with (same as k2 for all) | `sessions/` |
| Session list on the bar, in order | `devices` |
| Settings | `kitty.conf` |
| Bar drawing, clicks, autosave timer | `tab_bar.py` |
| Save / load / reload / menu code | `session_ctl.py` |

## Important shortcuts

| Keys | Action |
|------|--------|
| `C-a` `Ctrl-k` | Close the current device session (tabs closed, stays on the bar) |
| `C-a` `,` | Rename the current tab |
| `C-a` `R` | Rename the current device (session) |
| `C-a` `O` | Reload the last manual save of this session |
| `C-a` `o` | Reload a manual save: pick one from the list |
| `C-a` `r` | Restore the autosave (all sessions, every detail) |
| `C-a` `s` | Save the tabs of this session by hand |
| `C-a` `N` / `X` | Rename / remove a manual save |
