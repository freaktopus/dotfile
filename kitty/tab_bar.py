# Tab bar styled like the old tmux status line (gruvbox):
#   left : tabs  "▎1 name" (current = orange bar on #3c3836), dim index for the others
#   right: sessions (current = orange block with ●, ○ = loaded, dim = not opened; number = its tabs), date, yellow clock
# tabs are the equivalent of tmux windows. Kitty has one tab bar row only, so the
# sessions share it. Switch with Ctrl-a S, manage with Ctrl-a m.
import datetime
import os

from kitty.fast_data_types import Screen, add_timer, get_boss
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb


def rgb(hex_color: str) -> int:
    return as_rgb(int(hex_color.lstrip('#'), 16))


FG = rgb('#ebdbb2')
MUTED = rgb('#c2b59b')
DIM = rgb('#a0907e')
SURFACE = rgb('#3c3836')
ORANGE = rgb('#d97757')  # Claude orange
YELLOW = rgb('#fabd2f')
GOLD = rgb('#d79921')
BG0 = rgb('#1d2021')
PILL = rgb('#32302f')


def _refresh_clock(timer_id=None) -> None:
    # kitty only redraws the tab bar on events, so poke it to keep the clock current
    try:
        for tm in get_boss().os_window_map.values():
            tm.mark_tab_bar_dirty()
    except Exception:
        pass


try:
    add_timer(_refresh_clock, 30.0, True)
except Exception:
    pass


AUTOSAVE_SECONDS = 15 * 60


def _autosave(timer_id=None) -> None:
    # overwrite autosave/<session>.kitty-session for every loaded session
    try:
        import importlib.util
        from kitty.constants import config_dir
        path = os.path.join(config_dir, 'session_ctl.py')
        spec = importlib.util.spec_from_file_location('session_ctl', path)
        mod = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)
        os.makedirs(mod.AUTO, exist_ok=True)
        mod.autosave(get_boss())
    except Exception:
        pass


try:
    add_timer(_autosave, AUTOSAVE_SECONDS, True)
except Exception:
    pass


def _session_names(loaded) -> list:
    # the devices (file order), then any other loaded session
    conf = os.path.expanduser('~/.config/kitty')
    names = []
    try:
        for line in open(os.path.join(conf, 'devices')):
            line = line.strip()
            if line and not line.startswith('#') and line not in names:
                names.append(line)
    except OSError:
        pass
    names += sorted(n for n in set(loaded) if n not in names)
    return names


def _session_chips(active: str, default_bg: int) -> list:
    """[(name, parts)] one entry per session plus a '+' entry for a new one."""
    counts = {}
    try:
        for t in get_boss().all_tabs:
            if t.created_in_session_name:
                counts[t.created_in_session_name] = counts.get(t.created_in_session_name, 0) + 1
    except Exception:
        pass
    chips = []
    for n in _session_names(counts):
        c = counts.get(n, 0)
        if n == active:
            # the session you are in now: solid orange block with a filled dot
            parts = [(f' ● {n} {c} ', BG0, ORANGE, False)]
        elif c:
            # loaded, has tabs, but not the one on screen
            parts = [(f' ○ {n} {c} ', MUTED, SURFACE, False)]
        else:
            parts = [(f'  {n}  ', DIM, PILL, False)]
        chips.append((n, parts + [('  ', FG, default_bg, False)]))  # two blank cells between devices
    chips.append(('+', [(' + ', ORANGE, SURFACE, False), (' ', FG, default_bg, False)]))
    return chips


def _width(parts) -> int:
    return sum(len(p[0]) for p in parts)


# clickable areas of the session chips: os_window_id -> [(first_cell, last_cell, name)]
def _shared_ranges() -> dict:
    # kept on TabManager so a reloaded tab_bar.py and the mouse hook share one dict
    from kitty.tabs import TabManager
    if '_chip_ranges' not in TabManager.__dict__:
        TabManager._chip_ranges = {}
    return TabManager._chip_ranges


CHIP_RANGES = _shared_ranges()


def _draw_right(screen: Screen, tab: TabBarData, default_bg: int) -> None:
    now = datetime.datetime.now()
    active = tab.active_session_name or ''
    chips = _session_chips(active, default_bg)
    chip_parts = [p for _, parts in chips for p in parts]
    sep = [('│', DIM, default_bg, False)]
    clock = [(now.strftime(' %H:%M '), BG0, GOLD, False)]
    date = [(now.strftime(' %a %d %b '), MUTED, SURFACE, False)]
    room = screen.columns - screen.cursor.x - 2
    # drop the least important things first when the window is narrow
    for parts in (chip_parts + sep + date + clock, chip_parts + sep + clock, chip_parts, []):
        if _width(parts) <= room:
            break
    start = screen.columns - _width(parts)
    ranges = []
    if parts:
        screen.cursor.bg = default_bg
        screen.draw(' ' * (start - screen.cursor.x))
        if parts[:len(chip_parts)] == chip_parts:
            x = start
            for name, cparts in chips:
                w = _width(cparts)
                ranges.append((x, x + w - 1 - (1 if name == '+' else 2), name))
                x += w
        for text, fg, bg, bold in parts:
            screen.cursor.fg = fg
            screen.cursor.bg = bg
            screen.cursor.bold = bold
            screen.draw(text)
        screen.cursor.bold = False
    CHIP_RANGES[tab.os_window_id] = ranges


def _session_ctl():
    import importlib.util
    from kitty.constants import config_dir
    spec = importlib.util.spec_from_file_location('session_ctl', os.path.join(config_dir, 'session_ctl.py'))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def _patch_mouse() -> None:
    """Clicks on the session chips: left = switch (or new on +), right = menu."""
    from kitty.tabs import TabManager
    if getattr(TabManager, '_sessions_patched', False):
        return
    original = TabManager.handle_tab_bar_mouse

    def handle(self, x, y, button, modifiers, action):
        if button >= 0:
            cell = (int(x) - self.tab_bar.window_geometry.left) // self.tab_bar.cell_width
            for a, b, name in TabManager._chip_ranges.get(self.os_window_id, ()):
                if a <= cell <= b:
                    if action == 0 and button in (0, 1):  # release
                        try:
                            mod, boss = _session_ctl(), get_boss()
                            if name == '+':
                                mod.do_new(boss)
                            elif button == 1:
                                mod.do_menu(boss, name)
                            else:
                                mod.do_switch(boss, name)
                        except Exception:
                            pass
                    return
        return original(self, x, y, button, modifiers, action)

    TabManager.handle_tab_bar_mouse = handle
    TabManager._sessions_patched = True


try:
    _patch_mouse()
except Exception:
    pass


def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData,
) -> int:
    default_bg = as_rgb(int(draw_data.default_bg))
    title = tab.title
    max_title = max(max_title_length - 6, 4)
    if len(title) > max_title:
        title = title[:max_title - 1] + '…'
    zoom = ' 󰁌' if tab.layout_name == 'stack' and tab.num_window_groups > 1 else ''
    attention = tab.needs_attention or tab.has_activity_since_last_focus

    if tab.is_active:
        screen.cursor.bg = SURFACE
        screen.cursor.fg = ORANGE
        screen.draw('▎')
        screen.cursor.fg = FG
        screen.cursor.bold = False
        screen.draw(f'{index} {title}{zoom} ')
        screen.cursor.bold = False
    else:
        screen.cursor.bg = default_bg
        screen.cursor.fg = DIM
        screen.draw(f' {index} ')
        screen.cursor.fg = YELLOW if attention else MUTED
        screen.draw(f'{title}{zoom} ')
    screen.cursor.bg = default_bg

    end = screen.cursor.x
    if is_last:
        _draw_right(screen, tab, default_bg)
    return end
