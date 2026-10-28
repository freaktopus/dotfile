# Session control kitten (tmux-like sessions). Run it as:
#   kitten session_ctl.py <command> [name]
# Commands: save, load, load-last, forget, rename-saved, reload, new, switch, kill, delete, rename, menu, autosave
#
# A session is a device (beacon404, k2, K-T4 ...), listed in ~/.config/kitty/devices.
# Saved tabs (ampixa, dengue ...) are tmux windows: a set of tabs that can be put in any session.
# Files (kitty saves nothing by itself):
#   sessions/<device>.kitty-session   the base of a device session (its first tabs)
#   autosave/<device>.kitty-session   all tabs of every session, every 15 minutes, overwritten
#   manual/<session>_<time>.kitty-session   Ctrl-a s: only the tabs of the active session, one file per save
# Reload and open use whichever of sessions/ and autosave/ is newer (the "pointer").
import os
import re
import shlex
import shutil
import subprocess
import time

from kittens.tui.handler import result_handler

from kitty.constants import config_dir as CONF
SESS = os.path.join(CONF, 'sessions')
AUTO = os.path.join(CONF, 'autosave')
MANUAL = os.path.join(CONF, 'manual')
DEVICES = os.path.join(CONF, 'devices')
EXT = '.kitty-session'
# every new session starts with the same tabs as k2
TEMPLATE = open(os.path.join(CONF, 'sessions', 'k2.kitty-session')).read() if os.path.exists(os.path.join(CONF, 'sessions', 'k2.kitty-session')) else 'new_tab zsh\ncd ~\nlaunch zsh\n'


def main(args):
    pass


def clean(name):
    return re.sub(r'[^A-Za-z0-9_-]', '', re.sub(r'[.: ]', '-', os.path.basename(name or '').removesuffix(EXT)))


def notify(msg):
    try:
        subprocess.Popen(['notify-send', '-a', 'kitty', '-t', '2500', 'kitty session', msg])
    except OSError:
        pass


def base_path(name):
    return os.path.join(SESS, name + EXT)


def saved_path(name):
    return os.path.join(MANUAL, name + EXT)


def auto_path(name):
    return os.path.join(AUTO, name + EXT)


def newest_path(name):
    found = [p for p in (base_path(name), auto_path(name)) if os.path.exists(p)]
    return max(found, key=os.path.getmtime) if found else ''


def devices():
    try:
        return [x.strip() for x in open(DEVICES) if x.strip() and not x.startswith('#')]
    except OSError:
        return []


def add_device(name):
    if name not in devices():
        with open(DEVICES, 'a') as f:
            f.write(name + '\n')


def remove_device(name):
    keep = [x for x in devices() if x != name]
    with open(DEVICES, 'w') as f:
        f.write('# sessions (one per device) shown on the tab bar, in this order\n')
        f.write(''.join(x + '\n' for x in keep))


def session_windows(boss, name):
    return [w for w in boss.all_windows if w.created_in_session_name == name]


SHELLS = {'zsh', 'bash', 'sh', 'fish', 'dash', 'nu'}


def keep_shell(line):
    """A window that ran a program (nvim ...) is saved as 'launch nvim ...'. When the program
    quits the window would close. Wrap it so a shell stays after the program ends."""
    if not line.startswith('launch '):
        return line
    try:
        words = shlex.split(line)
    except ValueError:
        return line
    i = 1
    while i < len(words) and (words[i].startswith('--') or words[i].startswith('kitty-unserialize-data=')):
        i += 1
    cmd = words[i:]
    if not cmd or os.path.basename(cmd[0]).lstrip('-') in SHELLS:
        return line
    wrapped = ['zsh', '-ic', f'{shlex.join(cmd)}; exec zsh']
    return shlex.join(words[:i] + wrapped)


def fix_file(path):
    with open(path) as f:
        lines = f.read().split('\n')
    tabs = sum(1 for x in lines if x.startswith('new_tab'))
    out = []
    for x in lines:
        x = keep_shell(x)
        if x.startswith('focus_tab ') and x[10:].strip().isdigit() and tabs and int(x[10:]) >= tabs:
            x = 'focus_tab 0'  # an old save pointed past the last tab
        out.append(x)
    if out != lines:
        with open(path, 'w') as f:
            f.write('\n'.join(out))


def fix_active_tabs(boss, name, path):
    """kitty numbers 'focus_tab' among all tabs of the OS window. A session file only holds the tabs
    of one session, so renumber it: the tab of this session that was used last is the active one."""
    from kitty.fast_data_types import current_focused_os_window_id, last_focused_os_window_id
    rank = {current_focused_os_window_id(): 2, last_focused_os_window_id(): 1}
    indexes = []
    for wid in sorted(boss.os_window_map, key=lambda w: rank.get(w, 0)):  # same order kitty writes them
        best, idx, count = None, 0, 0
        for tab in boss.os_window_map[wid]:
            ws = [w for w in tab if w.created_in_session_name == name]
            if ws:
                t = max(w.last_focused_at for w in ws)
                if best is None or t > best[0]:
                    best = (t, idx)
                idx += 1
        if best is not None:
            indexes.append(best[1])
    with open(path) as f:
        lines = f.read().split('\n')
    it = iter(indexes)
    out = [f'focus_tab {next(it, 0)}' if x.startswith('focus_tab ') else x for x in lines]
    with open(path, 'w') as f:
        f.write('\n'.join(out))


def write_session(boss, name, path):
    from kitty.session import parse_save_as_options_spec_args, save_as_session_part2
    opts, _ = parse_save_as_options_spec_args([
        '--save-only', '--use-foreground-process', f'--match=session:^{re.escape(name)}$'])
    if not session_windows(boss, name):
        return False
    save_as_session_part2(boss, opts, path)
    fix_file(path)
    fix_active_tabs(boss, name, path)
    return True


STARTED = time.time()


def autosave(boss):
    """Overwrite autosave/<name>.kitty-session for every loaded session (tabs, folders, programs,
    layouts, titles). The first write of a new kitty run keeps the old copy in autosave/previous/."""
    for name in list(boss.all_loaded_session_names):
        try:
            path = auto_path(name)
            if os.path.exists(path) and os.path.getmtime(path) < boss_started(boss):
                os.makedirs(os.path.join(AUTO, 'previous'), exist_ok=True)
                shutil.copy2(path, os.path.join(AUTO, 'previous', name + EXT))
            write_session(boss, name, path)
        except Exception:
            pass


def boss_started(boss):
    # the kitty process start time, not the time this file was loaded
    try:
        import psutil
        return psutil.Process().create_time()
    except Exception:
        return os.stat(f'/proc/{os.getpid()}').st_mtime


def ask_name(boss, title, callback, initial=''):
    def got(answer):
        name = clean(answer)
        if name:
            callback(name)
    boss.get_save_filepath(title, got, initial_value=initial)


def active_name(boss):
    return boss.active_session


def saved_names():
    try:
        files = [f for f in os.listdir(MANUAL) if f.endswith(EXT)]
        files.sort(key=lambda f: os.path.getmtime(os.path.join(MANUAL, f)), reverse=True)  # newest first
        return [f[:-len(EXT)] for f in files]
    except OSError:
        return []


def last_file():
    return os.path.join(MANUAL, '.last')


def last_saved(session):
    import json
    try:
        return json.load(open(last_file())).get(session, '')
    except (OSError, ValueError):
        return ''


def remember_saved(session, name):
    import json
    try:
        data = json.load(open(last_file()))
    except (OSError, ValueError):
        data = {}
    data[session] = name
    with open(last_file(), 'w') as f:
        json.dump(data, f)


def do_save(boss, name=''):
    """Save the tabs of the active session (only those) into manual/<session>_<timestamp>."""
    session = active_name(boss)
    if not session or not session_windows(boss, session):
        notify('no session to save')
        return
    os.makedirs(MANUAL, exist_ok=True)
    n = clean(name) if name else f'{session}_{time.strftime("%Y-%m-%d_%H-%M-%S")}'
    if write_session(boss, session, saved_path(n)):
        remember_saved(session, n)
        tabs = len({w.tabref().id for w in session_windows(boss, session) if w.tabref()})
        notify(f'saved {tabs} tabs of "{session}" as {n}')


def do_load(boss, name='', session='', confirmed=False):
    """Replace the tabs of a session (the active one by default) with a saved set (manual/<name>)."""
    session = session or active_name(boss)
    if not name:
        names = saved_names()
        if not names:
            notify('nothing saved yet, press Ctrl-a s first')
            return
        boss.choose_entry(f'Load saved tabs into "{session}" (replaces its tabs)', [(n, n) for n in names],
                          lambda n: do_load(boss, n, session) if n else None)
        return
    path = saved_path(name)
    if not os.path.exists(path):
        boss.ring_bell_if_allowed()
        return
    from kitty.fast_data_types import get_options
    from kitty.session import create_sessions, seen_session_paths
    if not confirmed:
        return confirm_then(boss, session, lambda: do_load(boss, name, session, True))
    fix_file(path)
    tm = boss.active_tab_manager
    old = session_windows(boss, session)
    added = False
    for sess in create_sessions(get_options(), default_session=path):
        if sess.num_of_windows_in_definition and tm is not None:
            tm.add_tabs_from_session(sess, session)
            added = True
    seen_session_paths.pop(name, None)
    if added:
        # the saved tabs replace the current ones; they were opened first so kitty never has zero tabs
        boss.close_windows_no_confirm(old)
        remember_saved(session, name)
        notify(f'loaded "{name}" into "{session}" (the previous tabs were closed)')


def do_forget(boss, name=''):
    """Delete one saved set of tabs from manual/ (asks to confirm)."""
    if not name:
        names = saved_names()
        if not names:
            notify('no saved tabs to remove')
            return
        boss.choose_entry('Remove saved tabs (deletes the file)', [(n, n) for n in names],
                          lambda n: do_forget(boss, n) if n else None)
        return

    def confirmed(ok):
        if ok and os.path.exists(saved_path(name)):
            os.remove(saved_path(name))
            notify(f'removed saved tabs "{name}"')
    boss.confirm(f'Delete the saved tabs "{name}"?', confirmed, window=boss.active_window, title='Remove saved tabs')


def do_rename_saved(boss, name=''):
    """Rename one saved set of tabs in manual/."""
    if not name:
        names = saved_names()
        if not names:
            notify('no saved tabs to rename')
            return
        boss.choose_entry('Rename saved tabs', [(n, n) for n in names],
                          lambda n: do_rename_saved(boss, n) if n else None)
        return

    def rename(new):
        if new == name or not os.path.exists(saved_path(name)):
            return
        if os.path.exists(saved_path(new)):
            notify(f'"{new}" already exists')
            return
        shutil.move(saved_path(name), saved_path(new))
        notify(f'renamed saved tabs "{name}" to "{new}"')
    ask_name(boss, f'Rename saved tabs "{name}" to', rename, initial=name)


def do_reload(boss, name='', confirmed=False):
    """Replace the tabs of a session with its autosave (or its base file if it has none yet)."""
    from kitty.session import create_session, seen_session_paths, switch_to_session
    name = name or active_name(boss)
    path = ''
    if name:
        path = auto_path(name) if os.path.exists(auto_path(name)) else (base_path(name) if os.path.exists(base_path(name)) else '')
    if not path:
        boss.ring_bell_if_allowed()
        notify('no autosave yet for this session')
        return
    if not confirmed:
        return confirm_then(boss, name, lambda: do_reload(boss, name, True))
    fix_file(path)
    old = session_windows(boss, name)
    seen_session_paths[name] = path
    # open the saved copy first, so the OS window never ends up with zero tabs
    create_session(boss, path)
    if old:
        boss.close_windows_no_confirm(old)
    switch_to_session(boss, name)
    notify(f'reloaded "{name}" from the {"autosave" if path == auto_path(name) else "base file"}')


def do_reload_all(boss, confirmed=False):
    """Restore every session from autosave/: all tabs of all devices, with their folders and programs."""
    from kitty.session import create_session, seen_session_paths, switch_to_session
    names = [n for n in devices() + [x for x in boss.all_loaded_session_names if x not in devices()]
             if os.path.exists(auto_path(n))]
    if not names:
        notify('no autosave yet')
        return
    if not confirmed:
        windows = [w for n in names for w in session_windows(boss, n)]
        msg, num = boss.close_windows_with_confirmation_msg(windows, boss.active_window)
        if num:
            boss.confirm(f'Restore everything from the autosave? {msg}',
                         lambda ok: do_reload_all(boss, True) if ok else None,
                         window=boss.active_window, title='Restore autosave')
            return
    current = active_name(boss)
    for n in names:
        path = auto_path(n)
        fix_file(path)
        old = session_windows(boss, n)
        seen_session_paths[n] = path
        create_session(boss, path)  # open the saved copy first, then close the old tabs
        if old:
            boss.close_windows_no_confirm(old)
    switch_to_session(boss, current if current in names else names[0])
    notify(f'restored {len(names)} sessions from the autosave: {", ".join(names)}')


def do_load_last(boss, name=''):
    """Reload the newest manual save of a session (the one saved or loaded last)."""
    session = name or active_name(boss)
    last = last_saved(session)
    if not last or not os.path.exists(saved_path(last)):
        mine = [n for n in saved_names() if n.startswith(session + '_')]
        last = mine[0] if mine else ''
    if not last:
        notify(f'no manual save of "{session}" yet, press Ctrl-a s first')
        return
    do_load(boss, last, session)


def do_switch(boss, name):
    """Go to a session; the tab bar then lists only the tabs of that session."""
    from kitty.session import goto_session, switch_to_session
    if not switch_to_session(boss, name, only_if_actual_windows_present=True):
        # a session that is not open starts with its default tabs (the base file), not an old autosave
        path = base_path(name) if os.path.exists(base_path(name)) else newest_path(name)
        if not path:
            boss.ring_bell_if_allowed()
            return
        fix_file(path)
        goto_session(boss, (path,))
    try:
        boss.refresh_active_tab_bar()
    except Exception:
        pass


def do_new(boss, name=''):
    def create(n):
        os.makedirs(SESS, exist_ok=True)
        if not os.path.exists(base_path(n)):
            with open(base_path(n), 'w') as f:
                f.write(TEMPLATE)
        add_device(n)
        do_switch(boss, n)
    if name:
        create(clean(name))
    else:
        ask_name(boss, 'Name of the new session', create)


def close_all(boss, name):
    from kitty.session import create_session
    windows = session_windows(boss, name)
    if not windows:
        return
    if len(windows) == len(list(boss.all_windows)):
        # closing would end kitty, so open another device first
        others = [d for d in devices() if d != name and os.path.exists(base_path(d))]
        if not others:
            notify('this is the only open session, kitty would quit')
            return
        create_session(boss, newest_path(others[0]) or base_path(others[0]))
    boss.close_windows_no_confirm(windows)


def confirm_then(boss, name, action):
    """Ask first when a program is still running in the session, then run action."""
    msg, num = boss.close_windows_with_confirmation_msg(session_windows(boss, name), boss.active_window)
    if num:
        boss.confirm(f'Close the session "{name}"? {msg}', lambda ok: action() if ok else None,
                     window=boss.active_window, title='Close session?')
    else:
        action()


def do_kill(boss, name=''):
    """Close all tabs of a session. It stays on the bar and its files are kept."""
    name = name or active_name(boss)
    if not name:
        return

    def go():
        write_session(boss, name, auto_path(name))
        close_all(boss, name)
        notify(f'closed "{name}" (still on the bar, saved copy kept)')
    confirm_then(boss, name, go)


def do_delete(boss, name):
    def go():
        close_all(boss, name)
        for p in (base_path(name), auto_path(name)):
            if os.path.exists(p):
                os.remove(p)
        remove_device(name)
        notify(f'deleted "{name}"')
    confirm_then(boss, name, go)


def do_rename(boss, name=''):
    name = name or active_name(boss)
    if not name:
        return

    def rename(new):
        from kitty.session import seen_session_paths
        if new == name:
            return
        for tm in boss.all_tab_managers:
            if tm.created_in_session_name == name:
                tm.created_in_session_name = new
            for tab in tm:
                if tab.created_in_session_name == name:
                    tab.created_in_session_name = new
        for w in boss.all_windows:
            if w.created_in_session_name == name:
                w.created_in_session_name = new
        for old_p, new_p in ((base_path(name), base_path(new)), (auto_path(name), auto_path(new))):
            if os.path.exists(old_p):
                shutil.move(old_p, new_p)
        seen_session_paths.pop(name, None)
        seen_session_paths[new] = base_path(new)
        devs = [new if d == name else d for d in devices()]
        with open(DEVICES, 'w') as f:
            f.write('# sessions (one per device) shown on the tab bar, in this order\n')
            f.write(''.join(d + '\n' for d in devs))
        notify(f'renamed "{name}" to "{new}"')
    ask_name(boss, f'Rename session "{name}" to', rename, initial=name)


def do_pick(boss, *_):
    names = devices() + [n for n in boss.all_loaded_session_names if n not in devices()]
    boss.choose_entry('Switch to session', [(n, n) for n in names], lambda n: do_switch(boss, n) if n else None)


def do_menu(boss, name=''):
    name = name or active_name(boss)
    if not name:
        return
    entries = [
        ('switch', 'Switch to it'),
        ('save', 'Save its tabs by hand'),
        ('load', 'Load saved tabs (replaces its tabs)'),
        ('reload', 'Reload the autosave'),
        ('rename', 'Rename'),
        ('kill', 'Close (close its tabs, stays on the bar)'),
        ('delete', 'Delete (close and remove the files)'),
    ]

    def chosen(action):
        if action == 'switch':
            do_switch(boss, name)
        elif action == 'save':
            do_switch(boss, name)
            do_save(boss, name)
        elif action == 'load':
            do_switch(boss, name)
            do_load(boss, '', name)
        elif action == 'reload':
            do_switch(boss, name)
            do_reload(boss, name)
        elif action == 'rename':
            do_rename(boss, name)
        elif action == 'kill':
            do_kill(boss, name)
        elif action == 'delete':
            do_delete(boss, name)
    boss.choose_entry(f'Session: {name}', entries, chosen)


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    cmd = args[1] if len(args) > 1 else ''
    arg = args[2] if len(args) > 2 else ''
    os.makedirs(AUTO, exist_ok=True)
    os.makedirs(MANUAL, exist_ok=True)
    fn = {
        'save': do_save, 'load': do_load, 'load-last': do_load_last, 'forget': do_forget, 'rename-saved': do_rename_saved, 'reload': do_reload, 'reload-all': lambda b, *_: do_reload_all(b), 'new': do_new, 'switch': do_switch,
        'kill': do_kill, 'delete': do_delete, 'rename': do_rename, 'menu': do_menu, 'pick': do_pick,
        'autosave': lambda b, *_: autosave(b),
    }.get(cmd)
    if fn is None:
        return
    fn(boss, arg) if arg or cmd in ('switch', 'delete', 'menu') else fn(boss)
