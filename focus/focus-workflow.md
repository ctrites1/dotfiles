# Focus workflow — handoff

An ADHD-oriented work-session system: a shell-driven "block" timer surfaced in
YASB, plus a resume note surfaced in the tmux status bar.

Suggested home: `~/dotfiles/focus/` (Stow package), with the scripts stowed into
`~/.local/bin` and `focus.ps1` copied to the Windows side.

## Architecture

One shared state directory. WSL writes it, Windows reads it. Nothing else
crosses the boundary — deliberately, because shelling out through `wsl.exe` on a
1-second YASB poll makes the bar stutter.

```
~/.local/state/focus/  ->  C:\Users\catri\.focus\
├── block.json    # {"name","starts","ends"}  -> YASB via focus.ps1
├── note.txt      # resume note               -> tmux status-right
└── last-file     # two lines: path, line no. -> nvim, read by `work`/`stop`
                  #   the path also picks the sub-project + session name
```

## Components

| Piece | Location | Role |
| --- | --- | --- |
| `block` / `unblock` | `~/.local/bin` | Start/clear a timed block (writes `block.json`) |
| `focus-common` | `~/.local/bin` | Sourced by `work`/`stop`: resolves root, last file, sub-project, session name |
| `work` | `~/.local/bin` | Attach the sub-project session, restore file, pin note to tmux bar |
| `stop` | `~/.local/bin` | Prompt for note, clear bar, switch off the session (leaves it running) |
| `focus.ps1` | `C:\Users\catri\.focus\` | Renders the countdown label as JSON for YASB |
| `focus_block` widget | YASB `config.yaml` | Polls `focus.ps1` at 1 Hz |
| autocmd | `init.lua` SECTION 2 | Records last file + line on `BufLeave`/`VimLeavePre`, **project files only** |
| `@rose_pine_status_right_prepend_section` | `tmux.conf` | Renders `#{@focus_note}` |

## Daily loop

```bash
work                              # resume the last sub-project; note pinned to the bar
block 50 wire up outage chart     # declare the block; YASB bar starts draining
unblock                           # clear (or just issue a new `block`)
stop                              # prompts for note, clears bar, switches away
```

## Design decisions worth preserving

- **Never `set -g status-right` directly.** Rose Pine owns it and reapplies on
  reload. Use `@rose_pine_status_right_prepend_section '#[fg=#908caa]#{@focus_note}'`,
  set *before* TPM runs, and have scripts poke the `@focus_note` user option.
  Requires tmux >= 3.3 for `#{@user_option}` interpolation; older falls back to
  `#(cat ~/.local/state/focus/note.txt)`.
- **One project root, three consumers.** `work`, `stop` and the nvim autocmd all
  resolve `${FOCUS_PROJECT:-~/warlock}`. Export `FOCUS_PROJECT` to point the
  whole system at a different tree; nvim picks it up because it inherits the
  shell's environment. Both sides resolve symlinks before comparing, so the
  recorded path and the guard agree.
- **The resume note is scoped to the project, and guarded twice.** The autocmd
  records a buffer only when its resolved path sits under the root; `work`
  re-checks the prefix and that the file still exists before opening it. The
  nvim guard is the real fix, the `work` guard covers notes written before it
  existed and files deleted since.
- **The sub-project is discovered, never configured.** `~/warlock` is a
  container of sibling repos (`cablepull`, `warlock-home`, ...). `focus_dir` is
  the first path component under the root taken from the recorded file, so
  `work` returns to whichever repo you were last in; a new repo dropped beside
  the others participates the first time you open a file in it. Falls back to
  the root when there is no usable note.
- **Session name derives from the sub-project basename** (dots to underscores),
  matching the existing `prefix + f` sessionizer. That is what makes `work` and
  `prefix + f` into the same directory converge on one session; hardcoding a
  name creates a duplicate session pointing at the same directory.
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
  that silently fails to appear needs the log checked.
- **`block` was silent on success**, making a working run and a broken run look
  identical. It now echoes the block name and end time.
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

## Open / unverified

1. Re-link the state directory and confirm both directions:
   ```bash
   ls -la ~/.local/state/
   readlink -f ~/.local/state/focus
   block 1 smoke test
   powershell.exe -NoProfile -Command 'Get-Content "$env:USERPROFILE\.focus\block.json"'
   ```
2. Run `focus.ps1` directly; expect one line of JSON with a visible bar. If an
   execution-policy error appears, add `-ExecutionPolicy Bypass` to `run_cmd`.
3. Confirm `focus_block` is listed in a bar's widget array in `config.yaml`, not
   only defined under `widgets:`. Then `yasbc reload`.
4. Confirm `~/.local/bin` is on PATH from `.profile` / `.bash_profile` — tmux
   panes are login shells (`set -g default-command "${SHELL} -l"`).
5. Verify the overtime branch by letting a 1-minute block expire.
6. Decide whether to enable `@resurrect-strategy-nvim 'session'` and
   `@continuum-restore 'on'` (both plugins installed, currently unconfigured).
