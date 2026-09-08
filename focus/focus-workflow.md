# Focus workflow — handoff

An ADHD-oriented work-session system: a shell-driven "block" timer surfaced in
YASB, plus a resume note surfaced in the tmux status bar.

**Status: working end to end.** All six items that were open in the previous
revision have been verified except the resurrect/continuum decision. What is
*not* done is packaging — see "Not yet stowed" below.

## Architecture

One shared state directory. WSL writes it, Windows reads it. Nothing else
crosses the boundary — deliberately, because shelling out through `wsl.exe` on a
1-second YASB poll makes the bar stutter.

```
~/.local/state/focus/  ->  C:\Users\catri\.focus\   (symlink, verified)
├── block.json    # {"name","starts","ends"}  -> YASB via focus.ps1
├── note.txt      # resume note               -> tmux status-right
├── last-file     # two lines: path, line no. -> nvim, read by `work`/`stop`
│                 #   the path also picks the sub-project + session name
└── focus.ps1     # lives on the Windows side only; not in the repo
```

## Components

| Piece | Location | Tracked in repo? | Role |
| --- | --- | --- | --- |
| `block` / `unblock` | `~/.local/bin` | no | Start/clear a timed block (writes `block.json`) |
| `focus-common` | `~/.local/bin` | no | Sourced by `work`/`stop` (mode 644, not executable): resolves root, last file, sub-project, session name |
| `work` | `~/.local/bin` | no | Attach the sub-project session, restore file, pin note to tmux bar |
| `stop` | `~/.local/bin` | no | Prompt for note, clear bar, switch off the session (leaves it running) |
| `focus.ps1` | `C:\Users\catri\.focus\` | no | Renders the countdown label as JSON for YASB |
| `focus_block` widget | YASB `config.yaml` | separate repo | Polls `focus.ps1` at 1 Hz; wired into `bars.*.center` |
| autocmd | `init.lua` SECTION 2, ~L237 | yes | Records last file + line on `BufLeave`/`VimLeavePre`, **project files only** |
| `@rose_pine_status_right_prepend_section` | `tmux.conf:46` | yes | Renders `#{@focus_note}` |

### Not yet stowed

`focus/` contains only this document. The five shell scripts are real files in
`~/.local/bin`, and `focus.ps1` exists only under the Windows profile — none of
them are under version control. Converting to a Stow package means creating
`focus/.local/bin/{block,unblock,focus-common,work,stop}` and `stow focus`.

One thing to watch when doing it: `work` and `stop` locate `focus-common` with
`dirname "$(readlink -f "$0")"`. Under Stow, `$0` is a symlink into
`~/dotfiles/focus/.local/bin/`, `readlink -f` follows it, and `focus-common`
resolves in that same directory — so the three files must stay siblings. That
happens to be exactly what Stow produces, but it is load-bearing.

`focus.ps1` has no natural home in a Stow tree (Windows side of the boundary).
Either keep a copy in `focus/windows/focus.ps1` and copy it by hand, or leave it
untracked and accept it as the one unversioned piece.

## Daily loop

```bash
work                              # resume the last sub-project; note pinned to the bar
block 50 wire up outage chart     # declare the block; YASB bar starts draining
unblock                           # clear (or just issue a new `block`)
stop                              # prompts for note, clears bar, switches away
```

## Design decisions worth preserving

- **Never `set -g status-right` directly.** Rose Pine owns it and reapplies on
  reload. Use `@rose_pine_status_right_prepend_section '#[fg=#9ccfd8]#{@focus_note}'`,
  set *before* TPM runs, and have scripts poke the `@focus_note` user option.
  Requires tmux >= 3.3 for `#{@user_option}` interpolation; **tmux here is 3.4**,
  so the `#(cat ~/.local/state/focus/note.txt)` fallback is not needed.
- **One project root, three consumers.** `work`, `stop` and the nvim autocmd all
  resolve `${FOCUS_PROJECT:-~/warlock}`. Export `FOCUS_PROJECT` to point the
  whole system at a different tree; nvim picks it up because it inherits the
  shell's environment. Both sides resolve symlinks before comparing, so the
  recorded path and the guard agree.
- **The resume note is scoped to the project, and guarded twice.** The autocmd
  records a buffer only when its resolved path sits under the root (and skips
  any buffer with a non-empty `buftype` — terminals, help, quickfix, scratch);
  `work` re-checks the prefix and that the file still exists before opening it.
  The nvim guard is the real fix, the `work` guard covers notes written before it
  existed and files deleted since.
- **On `VimLeavePre` the cursor may not belong to the buffer being recorded.**
  The autocmd trusts `nvim_win_get_cursor` only when `args.buf` is the current
  buffer, and otherwise falls back to the `"` mark.
- **The sub-project is discovered, never configured.** `~/warlock` is a
  container of sibling repos (`cablepull`, `warlock-home`, ...). `focus_dir` is
  the first path component under the root taken from the recorded file, so
  `work` returns to whichever repo you were last in; a new repo dropped beside
  the others participates the first time you open a file in it. Falls back to
  the root when there is no usable note.
- **Session name derives from the sub-project basename** (dots to underscores),
  matching the existing `prefix + f` sessionizer (`tmux_sessionizer`). That is
  what makes `work` and `prefix + f` into the same directory converge on one
  session; hardcoding a name creates a duplicate session pointing at the same
  directory.
- **Always force an exact session match, but mind which spelling.** Bare `-t`
  prefix-matches, so `has-session -t cablepull` succeeds against an existing
  `cablepull_backup` and `work` attaches to the wrong repo. `has-session`,
  `switch-client` and `attach` take a *target-session* and want `"=name"`;
  `set-option` and `send-keys` take a *target-pane* and want `"=name:"`. Both
  spellings still exact-match (verified against a `warlock-home-extra` decoy).
- **`stop` switches, it does not detach.** It moves the client to the most
  recently attached other session and leaves the work session running -- windows,
  dev servers and unsaved buffers survive, and `work` returns instantly. If it
  is the only session, `stop` creates a `home` session at `$HOME` rather than
  dropping you out of tmux.
- **Set `@focus_note` outside the `has-session` branch** — tmux-continuum may
  have already restored the session.
- **`tmux refresh-client -S` after setting the note.** tmux-sensible sets
  `status-interval 5`; without this the note lags up to 5s on attach.
- **`block.json` is written to a `.tmp` and `mv`d into place.** The widget polls
  at 1 Hz and would otherwise catch a half-written file.
- **Overtime reports, never nags.** Past `ends` the widget flips to `+Nm` and
  changes colour. Interrupting hyperfocus is the expensive failure mode.
- **No `jq` dependency.** The nvim autocmd writes two plain lines, read in bash
  with `{ IFS= read -r file; IFS= read -r line; } < "$state/last-file"`.
- **Autocmd lives in SECTION 2 inside a named augroup** (`user-focus-note`), per
  the config's existing convention — without `clear = true`, re-sourcing
  registers duplicate callbacks.
- **`work` branches on `$TMUX`:** `switch-client` when already inside tmux,
  `attach` otherwise. Plain `attach` errors with "sessions should be nested with
  care".
- **Both scripts strip a metacharacter before it reaches its consumer.** `block`
  drops `"` and `\` from the block name so the hand-rolled JSON stays valid;
  `work` drops `#` from the note because `#` opens a tmux format sequence.

## Gotchas already hit (do not re-derive)

- **PowerShell 5.1 parse errors showing `â–ˆ`.** PS 5.1 reads `.ps1` in the ANSI
  codepage unless the file has a BOM. Fix: keep the source pure ASCII and build
  the bar characters from code points (`[char]0x2588`, `[char]0x2591`), and set
  `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8` — the parse problem
  and the output-encoding problem are separate. Note `[string]$FULL * $n`
  repeats; `[char] * $n` does not.
- **Symlink nested inside a real directory.** If `~/.local/state/focus` already
  existed as a directory (the nvim autocmd `mkdir -p`s it), `ln -s` silently
  created `~/.local/state/focus/.focus`. Use `ln -sfn` and verify with
  `readlink -f ~/.local/state/focus/block.json`.
- **Windows vs WSL username.** `$USER` is the WSL name; the Windows profile is
  `catri`. Hardcode the Windows path rather than interpolating `$USER`.
- **YASB splits `run_cmd` on spaces** before handing it to `subprocess`
  (upstream issue #815), so the script path must contain no spaces.
- **YASB logs custom-widget exceptions rather than surfacing them.** A widget
  that silently fails to appear needs `~/.config/yasb/yasb.log` checked. It is
  currently clean of focus-related entries.
- **`work` resumed into files outside the project.** Two independent causes,
  both fixed. (1) The autocmd fired on `BufLeave` for *every* buffer, so the
  last file touched anywhere on the machine won — in practice the obsidian vault
  under `/mnt/a/catri/Documents/`. (2) `project` was `$HOME/work/warlock`, a
  path that does not exist; the real tree is `$HOME/warlock`, so `new-session
  -c` was landing somewhere else entirely. Prefix-matching needs the trailing
  slash (`"$project"/*`), otherwise a sibling `warlock-other/` matches.
- **`session_last_attached` is empty for a never-attached session** (anything
  continuum restored). With a space-separated format that shifts awk's fields
  and `stop` picked an empty session name. Use
  `#{?session_last_attached,#{session_last_attached},0}` and read the name as
  the rest of the line.
- **`set-option -t "=name"` fails with `no such session: =name`.** Its `-t` is
  a target-pane, where `=` is not the exact-match prefix; `send-keys` behaves
  the same way. Use `"=name:"` for both. This was the first thing `work` hit
  after the session name went dynamic.
- **`refresh-client -S` errors `no current client` when nothing is attached** --
  i.e. every `work` run from a fresh terminal -- and `set -e` then killed the
  script one line before `exec tmux attach`. It is a latency nicety, so
  `2>/dev/null || true` it.
- **A `while` loop that never matches exits 1**, and under `set -euo pipefail`
  that killed `stop` inside the command substitution -- before the `home`
  fallback could run, i.e. exactly in the only-one-session case the fallback
  exists for. Hence the `|| true`. (The `[ -n "$f" ] && cmd` one-liners in
  `work` are fine: bash exempts a failed test in an AND-list from `set -e`.)

## Verified (previously open)

Checked against the live system; the commands are here so they can be re-run
after the Stow migration.

1. **State directory links both ways.** `readlink -f ~/.local/state/focus` ->
   `/mnt/c/Users/catri/.focus`; a `block` written from WSL is readable from the
   Windows side.
2. **`focus.ps1` runs clean.** `powershell.exe -NoProfile -File
   'C:\Users\catri\.focus\focus.ps1'` emits one line of JSON. No
   execution-policy error, so `run_cmd` stays
   `powershell -NoProfile -File C:\Users\catri\.focus\focus.ps1` — no
   `-ExecutionPolicy Bypass` needed.
3. **The widget is on a bar**, not merely defined: `bars.*.center:
   [home, focus_block]`, with `run_interval: 1000`, `return_format: json`,
   `hide_empty: true`, `encoding: utf-8`.
4. **`~/.local/bin` is on PATH** from `.profile:25`, which matters because tmux
   panes are login shells (`tmux.conf:11`, `default-command "${SHELL} -l"`).
5. **The overtime branch fires.** An expired block renders
   `{"text":"focus commands  +2m"}`.

## Open

1. **Package it.** See "Not yet stowed" — this is the only substantial work
   left, and until it is done a machine rebuild loses the scripts.
2. **Decide on `@resurrect-strategy-nvim 'session'` and `@continuum-restore
   'on'`.** Both plugins are declared (`tmux.conf:27-28`) and both remain
   unconfigured. `work` and `stop` are already written to survive a restored,
   never-attached session, so this is a preference call rather than a blocker.
3. **`block` is silent on success again.** An earlier revision echoed the block
   name and end time; the current script ends at the `mv` with no output, so a
   working run and a broken run look identical from the shell. Worth restoring —
   it is one `printf` — since the YASB bar is the only other feedback and it
   sits on the Windows side.
4. **`.focus-block-widget` has no CSS.** The widget sets `class_name:
   focus-block-widget` but `styles.css` defines no matching rule, so the
   countdown inherits default bar styling and the overtime state is not
   visually distinct. The "changes colour" behaviour described above is
   currently aspirational.
5. **`unblock` has no `set -euo pipefail`** unlike its four siblings. Harmless
   for a one-line `rm -f`, but inconsistent.
