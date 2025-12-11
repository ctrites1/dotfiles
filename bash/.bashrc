# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Start tmux when wsl starts
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
eval "$(starship init bash)"
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
declare -x BUN_INSTALL="/home/catrites/.bun"
declare -x DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
declare -x DISPLAY=":0"
declare -x HOME="/home/catrites"
declare -x HOSTTYPE="x86_64"
declare -x LANG="C.UTF-8"
declare -x LESSCLOSE="/usr/bin/lesspipe %s %s"
declare -x LESSOPEN="| /usr/bin/lesspipe %s"
declare -x LOGNAME="catrites"
declare -x LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:"
declare -x NAME="BlueMarshmallow"
declare -x NVM_BIN="/home/catrites/.nvm/versions/node/v23.11.0/bin"
declare -x NVM_CD_FLAGS=""
declare -x NVM_DIR="/home/catrites/.nvm"
declare -x NVM_INC="/home/catrites/.nvm/versions/node/v23.11.0/include/node"
declare -x OLDPWD="/home/catrites/dotfiles"
declare -x PATH="/home/catrites/.pyenv/shims:/home/catrites/.pyenv/bin:/home/catrites/.local/bin:/home/catrites/.pyenv/bin:/home/catrites/.local/bin:/home/catrites/.nvm/versions/node/v23.11.0/bin:/home/catrites/.bun/bin:/usr/local/bin:/home/catrites/.config/composer/vendor/bin:/home/catrites/.config/composer/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Users/Christine/AppData/Local/fnm_multishells/26488_1762367342723:/mnt/c/Program Files/Python312/Scripts/:/mnt/c/Program Files/Python312/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/Microsoft VS Code/bin:/mnt/c/Program Files/nodejs/:/mnt/c/Program Files/dotnet/:/mnt/c/Program Files/Git/cmd:/mnt/c/cygwin64/bin:/mnt/c/Program Files/Calibre2/:/mnt/c/Program Files/Vagrant/bin:/mnt/c/Program Files/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/:/mnt/c/Program Files/whkd/bin/:/mnt/c/Program Files/Neovim/bin:/mnt/c/MinGW/bin:/mnt/c/Users/Christine/AppData/Local/Microsoft/WinGet/Packages/ezwinports.make_Microsoft.Winget.Source_8wekyb3d8bbwe/bin/:/mnt/c/Program Files/PowerShell/7-preview/preview:/mnt/c/Program Files/komorebi/bin/:/mnt/c/Program Files/komo-launch/:/mnt/c/Program Files/YASB/:/mnt/c/Program Files/CMake/bin:/mnt/c/Program Files (x86)/Windows Kits/10/Windows Performance Toolkit/:/mnt/c/Program Files/Docker/Docker/resources/bin:/mnt/c/Program Files/PowerShell/7/:/mnt/c/Users/Christine/.local/bin:/mnt/c/Users/Christine/AppData/Local/Programs/Python/Python310/Scripts/:/mnt/c/Users/Christine/AppData/Local/Programs/Python/Python310/:/mnt/c/Users/Christine/.pyenv/pyenv-win/bin:/mnt/c/Users/Christine/.pyenv/pyenv-win/shims:/mnt/c/Users/Christine/.cargo/bin:/mnt/c/Users/Christine/scoop/shims:/mnt/c/Users/Christine/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/MySQL/MySQL Server 8.0/bin:/mnt/c/Users/Christine/AppData/Roaming/npm:/mnt/c/Users/Christine/.bun/bin:/mnt/c/Users/Christine/.dotnet/tools:/mnt/c/Users/Christine/.fly/bin:/mnt/c/Users/Christine/AppData/Local/Microsoft/WinGet/Packages/ezwinports.make_Microsoft.Winget.Source_8wekyb3d8bbwe/bin:/mnt/c/Users/Christine/.dotnet/tools:/mnt/c/Users/Christine/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/Christine/AppData/Local/Programs/oh-my-posh/bin:/mnt/c/Users/Christine/AppData/Local/Gource/cmd:/mnt/c/php:/mnt/c/Users/Christine/AppData/Roaming/Python/Python312/Scripts:/mnt/c/Program Files/JetBrains/PhpStorm 2024.3.5/bin:/mnt/c/Users/Christine/AppData/Local/Microsoft/WinGet/Packages/Schniz.fnm_Microsoft.Winget.Source_8wekyb3d8bbwe:/snap/bin:/bin:/usr/bin:/opt/nvim-linux-x86_64/bin"
declare -x PULSE_SERVER="unix:/mnt/wslg/PulseServer"
declare -x PWD="/home/catrites"
declare -x PYENV_ROOT="/home/catrites/.pyenv"
declare -x PYENV_SHELL="bash"
declare -x SHELL="/bin/bash"
declare -x SHLVL="1"
declare -x STARSHIP_SESSION_KEY="2999923826242417"
declare -x STARSHIP_SHELL="bash"
declare -x TERM="xterm-256color"
declare -x USER="catrites"
declare -x WAYLAND_DISPLAY="wayland-0"
declare -x WSL2_GUI_APPS_ENABLED="1"
declare -x WSLENV="WT_SESSION:WT_PROFILE_ID:"
declare -x WSL_DISTRO_NAME="Ubuntu-24.04"
declare -x WSL_INTEROP="/run/WSL/843_interop"
declare -x WT_PROFILE_ID="{61c54bbd-c2c6-5271-96e7-009a87ff44bf}"
declare -x WT_SESSION="bb5d70a9-4e4d-458f-9970-1f92aac9e4c4"
declare -x XDG_DATA_DIRS="/usr/local/share:/usr/share:/var/lib/snapd/desktop"
declare -x XDG_RUNTIME_DIR="/run/user/1000/"
__expand_tilde_by_ref () 
{ 
    if [[ ${!1-} == \~* ]]; then
        eval $1="$(printf ~%q "${!1#\~}")";
    fi
}
__get_cword_at_cursor_by_ref () 
{ 
    local cword words=();
    __reassemble_comp_words_by_ref "$1" words cword;
    local i cur="" index=$COMP_POINT lead=${COMP_LINE:0:COMP_POINT};
    if [[ $index -gt 0 && ( -n $lead && -n ${lead//[[:space:]]/} ) ]]; then
        cur=$COMP_LINE;
        for ((i = 0; i <= cword; ++i))
        do
            while [[ ${#cur} -ge ${#words[i]} && ${cur:0:${#words[i]}} != "${words[i]-}" ]]; do
                cur="${cur:1}";
                ((index > 0)) && ((index--));
            done;
            if ((i < cword)); then
                local old_size=${#cur};
                cur="${cur#"${words[i]}"}";
                local new_size=${#cur};
                ((index -= old_size - new_size));
            fi;
        done;
        [[ -n $cur && ! -n ${cur//[[:space:]]/} ]] && cur=;
        ((index < 0)) && index=0;
    fi;
    local "$2" "$3" "$4" && _upvars -a${#words[@]} $2 ${words+"${words[@]}"} -v $3 "$cword" -v $4 "${cur:0:index}"
}
__git_eread () 
{ 
    test -r "$1" && IFS='
' read -r "$2" < "$1"
}
__git_ps1 () 
{ 
    local exit=$?;
    local pcmode=no;
    local detached=no;
    local ps1pc_start='\u@\h:\w ';
    local ps1pc_end='\$ ';
    local printf_format=' (%s)';
    case "$#" in 
        2 | 3)
            pcmode=yes;
            ps1pc_start="$1";
            ps1pc_end="$2";
            printf_format="${3:-$printf_format}";
            PS1="$ps1pc_start$ps1pc_end"
        ;;
        0 | 1)
            printf_format="${1:-$printf_format}"
        ;;
        *)
            return $exit
        ;;
    esac;
    local ps1_expanded=yes;
    [ -z "${ZSH_VERSION-}" ] || [[ -o PROMPT_SUBST ]] || ps1_expanded=no;
    [ -z "${BASH_VERSION-}" ] || shopt -q promptvars || ps1_expanded=no;
    local repo_info rev_parse_exit_code;
    repo_info="$(git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree --short HEAD 2> /dev/null)";
    rev_parse_exit_code="$?";
    if [ -z "$repo_info" ]; then
        return $exit;
    fi;
    local short_sha="";
    if [ "$rev_parse_exit_code" = "0" ]; then
        short_sha="${repo_info##*'
'}";
        repo_info="${repo_info%'
'*}";
    fi;
    local inside_worktree="${repo_info##*'
'}";
    repo_info="${repo_info%'
'*}";
    local bare_repo="${repo_info##*'
'}";
    repo_info="${repo_info%'
'*}";
    local inside_gitdir="${repo_info##*'
'}";
    local g="${repo_info%'
'*}";
    if [ "true" = "$inside_worktree" ] && [ -n "${GIT_PS1_HIDE_IF_PWD_IGNORED-}" ] && [ "$(git config --bool bash.hideIfPwdIgnored)" != "false" ] && git check-ignore -q .; then
        return $exit;
    fi;
    local sparse="";
    if [ -z "${GIT_PS1_COMPRESSSPARSESTATE-}" ] && [ -z "${GIT_PS1_OMITSPARSESTATE-}" ] && [ "$(git config --bool core.sparseCheckout)" = "true" ]; then
        sparse="|SPARSE";
    fi;
    local r="";
    local b="";
    local step="";
    local total="";
    if [ -d "$g/rebase-merge" ]; then
        __git_eread "$g/rebase-merge/head-name" b;
        __git_eread "$g/rebase-merge/msgnum" step;
        __git_eread "$g/rebase-merge/end" total;
        r="|REBASE";
    else
        if [ -d "$g/rebase-apply" ]; then
            __git_eread "$g/rebase-apply/next" step;
            __git_eread "$g/rebase-apply/last" total;
            if [ -f "$g/rebase-apply/rebasing" ]; then
                __git_eread "$g/rebase-apply/head-name" b;
                r="|REBASE";
            else
                if [ -f "$g/rebase-apply/applying" ]; then
                    r="|AM";
                else
                    r="|AM/REBASE";
                fi;
            fi;
        else
            if [ -f "$g/MERGE_HEAD" ]; then
                r="|MERGING";
            else
                if __git_sequencer_status; then
                    :;
                else
                    if [ -f "$g/BISECT_LOG" ]; then
                        r="|BISECTING";
                    fi;
                fi;
            fi;
        fi;
        if [ -n "$b" ]; then
            :;
        else
            if [ -h "$g/HEAD" ]; then
                b="$(git symbolic-ref HEAD 2> /dev/null)";
            else
                local head="";
                if ! __git_eread "$g/HEAD" head; then
                    return $exit;
                fi;
                b="${head#ref: }";
                if [ "$head" = "$b" ]; then
                    detached=yes;
                    b="$(case "${GIT_PS1_DESCRIBE_STYLE-}" in 
    contains)
        git describe --contains HEAD
    ;;
    branch)
        git describe --contains --all HEAD
    ;;
    tag)
        git describe --tags HEAD
    ;;
    describe)
        git describe HEAD
    ;;
    * | default)
        git describe --tags --exact-match HEAD
    ;;
esac 2> /dev/null)" || b="$short_sha...";
                    b="($b)";
                fi;
            fi;
        fi;
    fi;
    if [ -n "$step" ] && [ -n "$total" ]; then
        r="$r $step/$total";
    fi;
    local conflict="";
    if [[ "${GIT_PS1_SHOWCONFLICTSTATE}" == "yes" ]] && [[ -n $(git ls-files --unmerged 2> /dev/null) ]]; then
        conflict="|CONFLICT";
    fi;
    local w="";
    local i="";
    local s="";
    local u="";
    local h="";
    local c="";
    local p="";
    local upstream="";
    if [ "true" = "$inside_gitdir" ]; then
        if [ "true" = "$bare_repo" ]; then
            c="BARE:";
        else
            b="GIT_DIR!";
        fi;
    else
        if [ "true" = "$inside_worktree" ]; then
            if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ] && [ "$(git config --bool bash.showDirtyState)" != "false" ]; then
                git diff --no-ext-diff --quiet || w="*";
                git diff --no-ext-diff --cached --quiet || i="+";
                if [ -z "$short_sha" ] && [ -z "$i" ]; then
                    i="#";
                fi;
            fi;
            if [ -n "${GIT_PS1_SHOWSTASHSTATE-}" ] && git rev-parse --verify --quiet refs/stash > /dev/null; then
                s="$";
            fi;
            if [ -n "${GIT_PS1_SHOWUNTRACKEDFILES-}" ] && [ "$(git config --bool bash.showUntrackedFiles)" != "false" ] && git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' > /dev/null 2> /dev/null; then
                u="%${ZSH_VERSION+%}";
            fi;
            if [ -n "${GIT_PS1_COMPRESSSPARSESTATE-}" ] && [ "$(git config --bool core.sparseCheckout)" = "true" ]; then
                h="?";
            fi;
            if [ -n "${GIT_PS1_SHOWUPSTREAM-}" ]; then
                __git_ps1_show_upstream;
            fi;
        fi;
    fi;
    local z="${GIT_PS1_STATESEPARATOR-" "}";
    b=${b##refs/heads/};
    if [ $pcmode = yes ] && [ $ps1_expanded = yes ]; then
        __git_ps1_branch_name=$b;
        b="\${__git_ps1_branch_name}";
    fi;
    if [ -n "${GIT_PS1_SHOWCOLORHINTS-}" ]; then
        __git_ps1_colorize_gitstring;
    fi;
    local f="$h$w$i$s$u$p";
    local gitstring="$c$b${f:+$z$f}${sparse}$r${upstream}${conflict}";
    if [ $pcmode = yes ]; then
        if [ "${__git_printf_supports_v-}" != yes ]; then
            gitstring=$(printf -- "$printf_format" "$gitstring");
        else
            printf -v gitstring -- "$printf_format" "$gitstring";
        fi;
        PS1="$ps1pc_start$gitstring$ps1pc_end";
    else
        printf -- "$printf_format" "$gitstring";
    fi;
    return $exit
}
__git_ps1_colorize_gitstring () 
{ 
    if [[ -n ${ZSH_VERSION-} ]]; then
        local c_red='%F{red}';
        local c_green='%F{green}';
        local c_lblue='%F{blue}';
        local c_clear='%f';
    else
        local c_red='[31m';
        local c_green='[32m';
        local c_lblue='[1;34m';
        local c_clear='[0m';
    fi;
    local bad_color=$c_red;
    local ok_color=$c_green;
    local flags_color="$c_lblue";
    local branch_color="";
    if [ $detached = no ]; then
        branch_color="$ok_color";
    else
        branch_color="$bad_color";
    fi;
    if [ -n "$c" ]; then
        c="$branch_color$c$c_clear";
    fi;
    b="$branch_color$b$c_clear";
    if [ -n "$w" ]; then
        w="$bad_color$w$c_clear";
    fi;
    if [ -n "$i" ]; then
        i="$ok_color$i$c_clear";
    fi;
    if [ -n "$s" ]; then
        s="$flags_color$s$c_clear";
    fi;
    if [ -n "$u" ]; then
        u="$bad_color$u$c_clear";
    fi
}
__git_ps1_show_upstream () 
{ 
    local key value;
    local svn_remote svn_url_pattern count n;
    local upstream_type=git legacy="" verbose="" name="";
    svn_remote=();
    local output="$(git config -z --get-regexp '^(svn-remote\..*\.url|bash\.showupstream)$' 2> /dev/null | tr '\0\n' '\n ')";
    while read -r key value; do
        case "$key" in 
            bash.showupstream)
                GIT_PS1_SHOWUPSTREAM="$value";
                if [[ -z "${GIT_PS1_SHOWUPSTREAM}" ]]; then
                    p="";
                    return;
                fi
            ;;
            svn-remote.*.url)
                svn_remote[$((${#svn_remote[@]} + 1))]="$value";
                svn_url_pattern="$svn_url_pattern\\|$value";
                upstream_type=svn+git
            ;;
        esac;
    done <<< "$output";
    local option;
    for option in ${GIT_PS1_SHOWUPSTREAM};
    do
        case "$option" in 
            git | svn)
                upstream_type="$option"
            ;;
            verbose)
                verbose=1
            ;;
            legacy)
                legacy=1
            ;;
            name)
                name=1
            ;;
        esac;
    done;
    case "$upstream_type" in 
        git)
            upstream_type="@{upstream}"
        ;;
        svn*)
            local -a svn_upstream;
            svn_upstream=($(git log --first-parent -1 --grep="^git-svn-id: \(${svn_url_pattern#??}\)" 2> /dev/null));
            if [[ 0 -ne ${#svn_upstream[@]} ]]; then
                svn_upstream=${svn_upstream[${#svn_upstream[@]} - 2]};
                svn_upstream=${svn_upstream%@*};
                local n_stop="${#svn_remote[@]}";
                for ((n=1; n <= n_stop; n++))
                do
                    svn_upstream=${svn_upstream#${svn_remote[$n]}};
                done;
                if [[ -z "$svn_upstream" ]]; then
                    upstream_type=${GIT_SVN_ID:-git-svn};
                else
                    upstream_type=${svn_upstream#/};
                fi;
            else
                if [[ "svn+git" = "$upstream_type" ]]; then
                    upstream_type="@{upstream}";
                fi;
            fi
        ;;
    esac;
    if [[ -z "$legacy" ]]; then
        count="$(git rev-list --count --left-right "$upstream_type"...HEAD 2> /dev/null)";
    else
        local commits;
        if commits="$(git rev-list --left-right "$upstream_type"...HEAD 2> /dev/null)"; then
            local commit behind=0 ahead=0;
            for commit in $commits;
            do
                case "$commit" in 
                    "<"*)
                        ((behind++))
                    ;;
                    *)
                        ((ahead++))
                    ;;
                esac;
            done;
            count="$behind	$ahead";
        else
            count="";
        fi;
    fi;
    if [[ -z "$verbose" ]]; then
        case "$count" in 
            "")
                p=""
            ;;
            "0	0")
                p="="
            ;;
            "0	"*)
                p=">"
            ;;
            *"	0")
                p="<"
            ;;
            *)
                p="<>"
            ;;
        esac;
    else
        case "$count" in 
            "")
                upstream=""
            ;;
            "0	0")
                upstream="|u="
            ;;
            "0	"*)
                upstream="|u+${count#0	}"
            ;;
            *"	0")
                upstream="|u-${count%	0}"
            ;;
            *)
                upstream="|u+${count#*	}-${count%	*}"
            ;;
        esac;
        if [[ -n "$count" && -n "$name" ]]; then
            __git_ps1_upstream_name=$(git rev-parse --abbrev-ref "$upstream_type" 2> /dev/null);
            if [ $pcmode = yes ] && [ $ps1_expanded = yes ]; then
                upstream="$upstream \${__git_ps1_upstream_name}";
            else
                upstream="$upstream ${__git_ps1_upstream_name}";
                unset __git_ps1_upstream_name;
            fi;
        fi;
    fi
}
__git_sequencer_status () 
{ 
    local todo;
    if test -f "$g/CHERRY_PICK_HEAD"; then
        r="|CHERRY-PICKING";
        return 0;
    else
        if test -f "$g/REVERT_HEAD"; then
            r="|REVERTING";
            return 0;
        else
            if __git_eread "$g/sequencer/todo" todo; then
                case "$todo" in 
                    p[\ \	] | pick[\ \	]*)
                        r="|CHERRY-PICKING";
                        return 0
                    ;;
                    revert[\ \	]*)
                        r="|REVERTING";
                        return 0
                    ;;
                esac;
            fi;
        fi;
    fi;
    return 1
}
__load_completion () 
{ 
    local -a dirs=(${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions);
    local ifs=$IFS IFS=: dir cmd="${1##*/}" compfile;
    [[ -n $cmd ]] || return 1;
    for dir in ${XDG_DATA_DIRS:-/usr/local/share:/usr/share};
    do
        dirs+=($dir/bash-completion/completions);
    done;
    IFS=$ifs;
    if [[ $BASH_SOURCE == */* ]]; then
        dirs+=("${BASH_SOURCE%/*}/completions");
    else
        dirs+=(./completions);
    fi;
    local backslash=;
    if [[ $cmd == \\* ]]; then
        cmd="${cmd:1}";
        $(complete -p "$cmd" 2> /dev/null || echo false) "\\$cmd" && return 0;
        backslash=\\;
    fi;
    for dir in "${dirs[@]}";
    do
        [[ -d $dir ]] || continue;
        for compfile in "$cmd" "$cmd.bash" "_$cmd";
        do
            compfile="$dir/$compfile";
            if [[ -f $compfile ]] && . "$compfile" &> /dev/null; then
                [[ -n $backslash ]] && $(complete -p "$cmd") "\\$cmd";
                return 0;
            fi;
        done;
    done;
    [[ -v _xspecs[$cmd] ]] && complete -F _filedir_xspec "$cmd" "$backslash$cmd" && return 0;
    return 1
}
__ltrim_colon_completions () 
{ 
    if [[ $1 == *:* && $COMP_WORDBREAKS == *:* ]]; then
        local colon_word=${1%"${1##*:}"};
        local i=${#COMPREPLY[*]};
        while ((i-- > 0)); do
            COMPREPLY[i]=${COMPREPLY[i]#"$colon_word"};
        done;
    fi
}
__nvm () 
{ 
    declare previous_word;
    previous_word="${COMP_WORDS[COMP_CWORD - 1]}";
    case "${previous_word}" in 
        use | run | exec | ls | list | uninstall)
            __nvm_installed_nodes
        ;;
        alias | unalias)
            __nvm_alias
        ;;
        *)
            __nvm_commands
        ;;
    esac;
    return 0
}
__nvm_alias () 
{ 
    __nvm_generate_completion "$(__nvm_aliases)"
}
__nvm_aliases () 
{ 
    declare aliases;
    aliases="";
    if [ -d "${NVM_DIR}/alias" ]; then
        aliases="$(command cd "${NVM_DIR}/alias" && command find "${PWD}" -type f | command sed "s:${PWD}/::")";
    fi;
    echo "${aliases} node stable unstable iojs"
}
__nvm_commands () 
{ 
    declare current_word;
    declare command;
    current_word="${COMP_WORDS[COMP_CWORD]}";
    COMMANDS='
    help install uninstall use run exec
    alias unalias reinstall-packages
    current list ls list-remote ls-remote
    install-latest-npm
    cache deactivate unload
    version version-remote which';
    if [ ${#COMP_WORDS[@]} == 4 ]; then
        command="${COMP_WORDS[COMP_CWORD - 2]}";
        case "${command}" in 
            alias)
                __nvm_installed_nodes
            ;;
        esac;
    else
        case "${current_word}" in 
            -*)
                __nvm_options
            ;;
            *)
                __nvm_generate_completion "${COMMANDS}"
            ;;
        esac;
    fi
}
__nvm_generate_completion () 
{ 
    declare current_word;
    current_word="${COMP_WORDS[COMP_CWORD]}";
    COMPREPLY=($(compgen -W "$1" -- "${current_word}"));
    return 0
}
__nvm_installed_nodes () 
{ 
    __nvm_generate_completion "$(nvm_ls) $(__nvm_aliases)"
}
__nvm_options () 
{ 
    OPTIONS='';
    __nvm_generate_completion "${OPTIONS}"
}
__parse_options () 
{ 
    local option option2 i IFS=' 	
,/|';
    option=;
    local -a array=($1);
    for i in "${array[@]}";
    do
        case "$i" in 
            ---*)
                break
            ;;
            --?*)
                option=$i;
                break
            ;;
            -?*)
                [[ -n $option ]] || option=$i
            ;;
            *)
                break
            ;;
        esac;
    done;
    [[ -n $option ]] || return 0;
    IFS=' 	
';
    if [[ $option =~ (\[((no|dont)-?)\]). ]]; then
        option2=${option/"${BASH_REMATCH[1]}"/};
        option2=${option2%%[<{().[]*};
        printf '%s\n' "${option2/=*/=}";
        option=${option/"${BASH_REMATCH[1]}"/"${BASH_REMATCH[2]}"};
    fi;
    option=${option%%[<{().[]*};
    printf '%s\n' "${option/=*/=}"
}
__python_argcomplete_expand_tilde_by_ref () 
{ 
    if [ -n "${ZSH_VERSION-}" ]; then
        if [ "${(P)1[1]}" = "~" ]; then
            eval $1="${(P)1/#\~/$HOME}";
        fi;
    else
        if [ "${!1:0:1}" = "~" ]; then
            if [ "${!1}" != "${!1//\/}" ]; then
                eval $1="${!1/%\/*}"/'${!1#*/}';
            else
                eval $1="${!1}";
            fi;
        fi;
    fi
}
__python_argcomplete_run () 
{ 
    if [[ -z "${ARGCOMPLETE_USE_TEMPFILES-}" ]]; then
        __python_argcomplete_run_inner "$@";
        return;
    fi;
    local tmpfile="$(mktemp)";
    _ARGCOMPLETE_STDOUT_FILENAME="$tmpfile" __python_argcomplete_run_inner "$@";
    local code=$?;
    cat "$tmpfile";
    rm "$tmpfile";
    return $code
}
__python_argcomplete_run_inner () 
{ 
    if [[ -z "${_ARC_DEBUG-}" ]]; then
        "$@" 8>&1 9>&2 > /dev/null 2>&1;
    else
        "$@" 8>&1 9>&2 1>&9 2>&1;
    fi
}
__python_argcomplete_scan_head () 
{ 
    local file="$1";
    local target="$2";
    if [[ -n "${ZSH_VERSION-}" ]]; then
        read -r -k 1024 -u 0 < "$file";
    else
        read -r -N 1024 < "$file";
    fi;
    if [[ "$target" = "interpreter" ]]; then
        read -r <<< "$REPLY";
    fi;
    local regex;
    case "$target" in 
        magic_string)
            regex='PYTHON_ARGCOMPLETE_OK'
        ;;
        easy_install)
            regex="(PBR Generated)|(EASY-INSTALL-(SCRIPT|ENTRY-SCRIPT|DEV-SCRIPT))"
        ;;
        asdf)
            regex="asdf exec "
        ;;
        interpreter)
            regex='^#!(.*)$'
        ;;
    esac;
    local ret="";
    if [[ "$REPLY" =~ $regex ]]; then
        ret=1;
    fi;
    __python_argcomplete_upshift_bash_rematch;
    [[ -n $ret ]]
}
__python_argcomplete_scan_head_noerr () 
{ 
    __python_argcomplete_scan_head "$@" 2> /dev/null
}
__python_argcomplete_upshift_bash_rematch () 
{ 
    if [[ -z "${ZSH_VERSION-}" ]]; then
        _BASH_REMATCH=("" "${BASH_REMATCH[@]}");
    else
        _BASH_REMATCH=("${BASH_REMATCH[@]}");
    fi
}
__python_argcomplete_which () 
{ 
    if [[ -n "${ZSH_VERSION-}" ]]; then
        whence -p "$@";
    else
        type -P "$@";
    fi
}
__reassemble_comp_words_by_ref () 
{ 
    local exclude i j line ref;
    if [[ -n $1 ]]; then
        exclude="[${1//[^$COMP_WORDBREAKS]/}]";
    fi;
    printf -v "$3" %s "$COMP_CWORD";
    if [[ -v exclude ]]; then
        line=$COMP_LINE;
        for ((i = 0, j = 0; i < ${#COMP_WORDS[@]}; i++, j++))
        do
            while [[ $i -gt 0 && ${COMP_WORDS[i]} == +($exclude) ]]; do
                [[ $line != [[:blank:]]* ]] && ((j >= 2)) && ((j--));
                ref="$2[$j]";
                printf -v "$ref" %s "${!ref-}${COMP_WORDS[i]}";
                ((i == COMP_CWORD)) && printf -v "$3" %s "$j";
                line=${line#*"${COMP_WORDS[i]}"};
                [[ $line == [[:blank:]]* ]] && ((j++));
                ((i < ${#COMP_WORDS[@]} - 1)) && ((i++)) || break 2;
            done;
            ref="$2[$j]";
            printf -v "$ref" %s "${!ref-}${COMP_WORDS[i]}";
            line=${line#*"${COMP_WORDS[i]}"};
            ((i == COMP_CWORD)) && printf -v "$3" %s "$j";
        done;
        ((i == COMP_CWORD)) && printf -v "$3" %s "$j";
    else
        for i in "${!COMP_WORDS[@]}";
        do
            printf -v "$2[i]" %s "${COMP_WORDS[i]}";
        done;
    fi
}
_allowed_groups () 
{ 
    if _complete_as_root; then
        local IFS='
';
        COMPREPLY=($(compgen -g -- "$1"));
    else
        local IFS='
 ';
        COMPREPLY=($(compgen -W "$(id -Gn 2> /dev/null || groups 2> /dev/null)" -- "$1"));
    fi
}
_allowed_users () 
{ 
    if _complete_as_root; then
        local IFS='
';
        COMPREPLY=($(compgen -u -- "${1:-$cur}"));
    else
        local IFS='
 ';
        COMPREPLY=($(compgen -W "$(id -un 2> /dev/null || whoami 2> /dev/null)" -- "${1:-$cur}"));
    fi
}
_available_interfaces () 
{ 
    local PATH=$PATH:/sbin;
    COMPREPLY=($({ if [[ ${1:-} == -w ]]; then
    iwconfig;
else
    if [[ ${1:-} == -a ]]; then
        ifconfig || ip link show up;
    else
        ifconfig -a || ip link show;
    fi;
fi; } 2> /dev/null | awk '/^[^ \t]/ { if ($1 ~ /^[0-9]+:/) { print $2 } else { print $1 } }'));
    COMPREPLY=($(compgen -W '${COMPREPLY[@]/%[[:punct:]]/}' -- "$cur"))
}
_bashcomp_try_faketty () 
{ 
    if type unbuffer &> /dev/null; then
        unbuffer -p "$@";
    else
        if script --version 2>&1 | command grep -qF util-linux; then
            script -qaefc "$*" /dev/null;
        else
            "$@";
        fi;
    fi
}
_cd () 
{ 
    local cur prev words cword;
    _init_completion || return;
    local IFS='
' i j k;
    compopt -o filenames;
    if [[ -z ${CDPATH:-} || $cur == ?(.)?(.)/* ]]; then
        _filedir -d;
        return;
    fi;
    local -r mark_dirs=$(_rl_enabled mark-directories && echo y);
    local -r mark_symdirs=$(_rl_enabled mark-symlinked-directories && echo y);
    for i in ${CDPATH//:/'
'};
    do
        k="${#COMPREPLY[@]}";
        for j in $(compgen -d -- $i/$cur);
        do
            if [[ ( -n $mark_symdirs && -L $j || -n $mark_dirs && ! -L $j ) && ! -d ${j#$i/} ]]; then
                j+="/";
            fi;
            COMPREPLY[k++]=${j#$i/};
        done;
    done;
    _filedir -d;
    if ((${#COMPREPLY[@]} == 1)); then
        i=${COMPREPLY[0]};
        if [[ $i == "$cur" && $i != "*/" ]]; then
            COMPREPLY[0]="${i}/";
        fi;
    fi;
    return
}
_cd_devices () 
{ 
    COMPREPLY+=($(compgen -f -d -X "!*/?([amrs])cd*" -- "${cur:-/dev/}"))
}
_command () 
{ 
    local offset i;
    offset=1;
    for ((i = 1; i <= COMP_CWORD; i++))
    do
        if [[ ${COMP_WORDS[i]} != -* ]]; then
            offset=$i;
            break;
        fi;
    done;
    _command_offset $offset
}
_command_offset () 
{ 
    local word_offset=$1 i j;
    for ((i = 0; i < word_offset; i++))
    do
        for ((j = 0; j <= ${#COMP_LINE}; j++))
        do
            [[ $COMP_LINE == "${COMP_WORDS[i]}"* ]] && break;
            COMP_LINE=${COMP_LINE:1};
            ((COMP_POINT--));
        done;
        COMP_LINE=${COMP_LINE#"${COMP_WORDS[i]}"};
        ((COMP_POINT -= ${#COMP_WORDS[i]}));
    done;
    for ((i = 0; i <= COMP_CWORD - word_offset; i++))
    do
        COMP_WORDS[i]=${COMP_WORDS[i + word_offset]};
    done;
    for ((i; i <= COMP_CWORD; i++))
    do
        unset 'COMP_WORDS[i]';
    done;
    ((COMP_CWORD -= word_offset));
    COMPREPLY=();
    local cur;
    _get_comp_words_by_ref cur;
    if ((COMP_CWORD == 0)); then
        local IFS='
';
        compopt -o filenames;
        COMPREPLY=($(compgen -d -c -- "$cur"));
    else
        local cmd=${COMP_WORDS[0]} compcmd=${COMP_WORDS[0]};
        local cspec=$(complete -p $cmd 2> /dev/null);
        if [[ ! -n $cspec && $cmd == */* ]]; then
            cspec=$(complete -p ${cmd##*/} 2> /dev/null);
            [[ -n $cspec ]] && compcmd=${cmd##*/};
        fi;
        if [[ ! -n $cspec ]]; then
            compcmd=${cmd##*/};
            _completion_loader $compcmd;
            cspec=$(complete -p $compcmd 2> /dev/null);
        fi;
        if [[ -n $cspec ]]; then
            if [[ ${cspec#* -F } != "$cspec" ]]; then
                local func=${cspec#*-F };
                func=${func%% *};
                if ((${#COMP_WORDS[@]} >= 2)); then
                    $func $cmd "${COMP_WORDS[-1]}" "${COMP_WORDS[-2]}";
                else
                    $func $cmd "${COMP_WORDS[-1]}";
                fi;
                local opt;
                while [[ $cspec == *" -o "* ]]; do
                    cspec=${cspec#*-o };
                    opt=${cspec%% *};
                    compopt -o $opt;
                    cspec=${cspec#$opt};
                done;
            else
                cspec=${cspec#complete};
                cspec=${cspec%%$compcmd};
                COMPREPLY=($(eval compgen "$cspec" -- '$cur'));
            fi;
        else
            if ((${#COMPREPLY[@]} == 0)); then
                _minimal;
            fi;
        fi;
    fi
}
_complete_as_root () 
{ 
    [[ $EUID -eq 0 || -n ${root_command:-} ]]
}
_completion_loader () 
{ 
    local cmd="${1:-_EmptycmD_}";
    __load_completion "$cmd" && return 124;
    complete -F _minimal -- "$cmd" && return 124
}
_configured_interfaces () 
{ 
    if [[ -f /etc/debian_version ]]; then
        COMPREPLY=($(compgen -W "$(command sed -ne 's|^iface \([^ ]\{1,\}\).*$|\1|p' /etc/network/interfaces /etc/network/interfaces.d/* 2> /dev/null)" -- "$cur"));
    else
        if [[ -f /etc/SuSE-release ]]; then
            COMPREPLY=($(compgen -W "$(printf '%s\n' /etc/sysconfig/network/ifcfg-* | command sed -ne 's|.*ifcfg-\([^*].*\)$|\1|p')" -- "$cur"));
        else
            if [[ -f /etc/pld-release ]]; then
                COMPREPLY=($(compgen -W "$(command ls -B /etc/sysconfig/interfaces | command sed -ne 's|.*ifcfg-\([^*].*\)$|\1|p')" -- "$cur"));
            else
                COMPREPLY=($(compgen -W "$(printf '%s\n' /etc/sysconfig/network-scripts/ifcfg-* | command sed -ne 's|.*ifcfg-\([^*].*\)$|\1|p')" -- "$cur"));
            fi;
        fi;
    fi
}
_count_args () 
{ 
    local i cword words;
    __reassemble_comp_words_by_ref "${1-}" words cword;
    args=1;
    for ((i = 1; i < cword; i++))
    do
        if [[ ${words[i]} != -* && ${words[i - 1]} != ${2-} || ${words[i]} == ${3-} ]]; then
            ((args++));
        fi;
    done
}
_dvd_devices () 
{ 
    COMPREPLY+=($(compgen -f -d -X "!*/?(r)dvd*" -- "${cur:-/dev/}"))
}
_expand () 
{ 
    case ${cur-} in 
        ~*/*)
            __expand_tilde_by_ref cur
        ;;
        ~*)
            _tilde "$cur" || eval COMPREPLY[0]="$(printf ~%q "${COMPREPLY[0]#\~}")";
            return ${#COMPREPLY[@]}
        ;;
    esac
}
_filedir () 
{ 
    local IFS='
';
    _tilde "${cur-}" || return;
    local -a toks;
    local reset arg=${1-};
    if [[ $arg == -d ]]; then
        reset=$(shopt -po noglob);
        set -o noglob;
        toks=($(compgen -d -- "${cur-}"));
        IFS=' ';
        $reset;
        IFS='
';
    else
        local quoted;
        _quote_readline_by_ref "${cur-}" quoted;
        local xspec=${arg:+"!*.@($arg|${arg^^})"} plusdirs=();
        local opts=(-f -X "$xspec");
        [[ -n $xspec ]] && plusdirs=(-o plusdirs);
        [[ -n ${COMP_FILEDIR_FALLBACK-} || -z ${plusdirs-} ]] || opts+=("${plusdirs[@]}");
        reset=$(shopt -po noglob);
        set -o noglob;
        toks+=($(compgen "${opts[@]}" -- $quoted));
        IFS=' ';
        $reset;
        IFS='
';
        [[ -n ${COMP_FILEDIR_FALLBACK-} && -n $arg && ${#toks[@]} -lt 1 ]] && { 
            reset=$(shopt -po noglob);
            set -o noglob;
            toks+=($(compgen -f ${plusdirs+"${plusdirs[@]}"} -- $quoted));
            IFS=' ';
            $reset;
            IFS='
'
        };
    fi;
    if ((${#toks[@]} != 0)); then
        compopt -o filenames 2> /dev/null;
        COMPREPLY+=("${toks[@]}");
    fi
}
_filedir_xspec () 
{ 
    local cur prev words cword;
    _init_completion || return;
    _tilde "$cur" || return;
    local IFS='
' xspec=${_xspecs[${1##*/}]} tmp;
    local -a toks;
    toks=($(compgen -d -- "$(quote_readline "$cur")" | { while read -r tmp; do
    printf '%s\n' $tmp;
done; }));
    eval xspec="${xspec}";
    local matchop=!;
    if [[ $xspec == !* ]]; then
        xspec=${xspec#!};
        matchop=@;
    fi;
    xspec="$matchop($xspec|${xspec^^})";
    toks+=($(eval compgen -f -X "'!$xspec'" -- '$(quote_readline "$cur")' | { while read -r tmp; do
    [[ -n $tmp ]] && printf '%s\n' $tmp;
done; }));
    [[ -n ${COMP_FILEDIR_FALLBACK:-} && ${#toks[@]} -lt 1 ]] && { 
        local reset=$(shopt -po noglob);
        set -o noglob;
        toks+=($(compgen -f -- "$(quote_readline "$cur")"));
        IFS=' ';
        $reset;
        IFS='
'
    };
    if ((${#toks[@]} != 0)); then
        compopt -o filenames;
        COMPREPLY=("${toks[@]}");
    fi
}
_fstypes () 
{ 
    local fss;
    if [[ -e /proc/filesystems ]]; then
        fss="$(cut -d'	' -f2 /proc/filesystems)
             $(awk '! /\*/ { print $NF }' /etc/filesystems 2> /dev/null)";
    else
        fss="$(awk '/^[ \t]*[^#]/ { print $3 }' /etc/fstab 2> /dev/null)
             $(awk '/^[ \t]*[^#]/ { print $3 }' /etc/mnttab 2> /dev/null)
             $(awk '/^[ \t]*[^#]/ { print $4 }' /etc/vfstab 2> /dev/null)
             $(awk '{ print $1 }' /etc/dfs/fstypes 2> /dev/null)
             $([[ -d /etc/fs ]] && command ls /etc/fs)";
    fi;
    [[ -n $fss ]] && COMPREPLY+=($(compgen -W "$fss" -- "$cur"))
}
_get_comp_words_by_ref () 
{ 
    local exclude flag i OPTIND=1;
    local cur cword words=();
    local upargs=() upvars=() vcur vcword vprev vwords;
    while getopts "c:i:n:p:w:" flag "$@"; do
        case $flag in 
            c)
                vcur=$OPTARG
            ;;
            i)
                vcword=$OPTARG
            ;;
            n)
                exclude=$OPTARG
            ;;
            p)
                vprev=$OPTARG
            ;;
            w)
                vwords=$OPTARG
            ;;
            *)
                echo "bash_completion: $FUNCNAME: usage error" 1>&2;
                return 1
            ;;
        esac;
    done;
    while [[ $# -ge $OPTIND ]]; do
        case ${!OPTIND} in 
            cur)
                vcur=cur
            ;;
            prev)
                vprev=prev
            ;;
            cword)
                vcword=cword
            ;;
            words)
                vwords=words
            ;;
            *)
                echo "bash_completion: $FUNCNAME: \`${!OPTIND}':" "unknown argument" 1>&2;
                return 1
            ;;
        esac;
        ((OPTIND += 1));
    done;
    __get_cword_at_cursor_by_ref "${exclude-}" words cword cur;
    [[ -v vcur ]] && { 
        upvars+=("$vcur");
        upargs+=(-v $vcur "$cur")
    };
    [[ -v vcword ]] && { 
        upvars+=("$vcword");
        upargs+=(-v $vcword "$cword")
    };
    [[ -v vprev && $cword -ge 1 ]] && { 
        upvars+=("$vprev");
        upargs+=(-v $vprev "${words[cword - 1]}")
    };
    [[ -v vwords ]] && { 
        upvars+=("$vwords");
        upargs+=(-a${#words[@]} $vwords ${words+"${words[@]}"})
    };
    ((${#upvars[@]})) && local "${upvars[@]}" && _upvars "${upargs[@]}"
}
_get_cword () 
{ 
    local LC_CTYPE=C;
    local cword words;
    __reassemble_comp_words_by_ref "${1-}" words cword;
    if [[ -n ${2-} && -n ${2//[^0-9]/} ]]; then
        printf "%s" "${words[cword - $2]}";
    else
        if ((${#words[cword]} == 0 && COMP_POINT == ${#COMP_LINE})); then
            :;
        else
            local i;
            local cur="$COMP_LINE";
            local index="$COMP_POINT";
            for ((i = 0; i <= cword; ++i))
            do
                while [[ ${#cur} -ge ${#words[i]} && ${cur:0:${#words[i]}} != "${words[i]}" ]]; do
                    cur="${cur:1}";
                    ((index > 0)) && ((index--));
                done;
                if ((i < cword)); then
                    local old_size="${#cur}";
                    cur="${cur#${words[i]}}";
                    local new_size="${#cur}";
                    ((index -= old_size - new_size));
                fi;
            done;
            if [[ ${words[cword]:0:${#cur}} != "$cur" ]]; then
                printf "%s" "${words[cword]}";
            else
                printf "%s" "${cur:0:index}";
            fi;
        fi;
    fi
}
_get_first_arg () 
{ 
    local i;
    arg=;
    for ((i = 1; i < COMP_CWORD; i++))
    do
        if [[ ${COMP_WORDS[i]} != -* ]]; then
            arg=${COMP_WORDS[i]};
            break;
        fi;
    done
}
_get_pword () 
{ 
    if ((COMP_CWORD >= 1)); then
        _get_cword "${@:-}" 1;
    fi
}
_gids () 
{ 
    if type getent &> /dev/null; then
        COMPREPLY=($(compgen -W '$(getent group | cut -d: -f3)' -- "$cur"));
    else
        if type perl &> /dev/null; then
            COMPREPLY=($(compgen -W '$(perl -e '"'"'while (($gid) = (getgrent)[2]) { print $gid . "\n" }'"'"')' -- "$cur"));
        else
            COMPREPLY=($(compgen -W '$(cut -d: -f3 /etc/group)' -- "$cur"));
        fi;
    fi
}
_have () 
{ 
    PATH=$PATH:/usr/sbin:/sbin:/usr/local/sbin type $1 &> /dev/null
}
_included_ssh_config_files () 
{ 
    (($# < 1)) && echo "bash_completion: $FUNCNAME: missing mandatory argument CONFIG" 1>&2;
    local configfile i f;
    configfile=$1;
    local reset=$(shopt -po noglob);
    set -o noglob;
    local included=($(command sed -ne 's/^[[:blank:]]*[Ii][Nn][Cc][Ll][Uu][Dd][Ee][[:blank:]]\(.*\)$/\1/p' "${configfile}"));
    $reset;
    [[ -n ${included-} ]] || return;
    for i in "${included[@]}";
    do
        if ! [[ $i =~ ^\~.*|^\/.* ]]; then
            if [[ $configfile =~ ^\/etc\/ssh.* ]]; then
                i="/etc/ssh/$i";
            else
                i="$HOME/.ssh/$i";
            fi;
        fi;
        __expand_tilde_by_ref i;
        set +o noglob;
        for f in $i;
        do
            if [[ -r $f ]]; then
                config+=("$f");
                _included_ssh_config_files $f;
            fi;
        done;
        $reset;
    done
}
_init_completion () 
{ 
    local exclude="" flag outx errx inx OPTIND=1;
    while getopts "n:e:o:i:s" flag "$@"; do
        case $flag in 
            n)
                exclude+=$OPTARG
            ;;
            e)
                errx=$OPTARG
            ;;
            o)
                outx=$OPTARG
            ;;
            i)
                inx=$OPTARG
            ;;
            s)
                split=false;
                exclude+==
            ;;
            *)
                echo "bash_completion: $FUNCNAME: usage error" 1>&2;
                return 1
            ;;
        esac;
    done;
    COMPREPLY=();
    local redir="@(?([0-9])<|?([0-9&])>?(>)|>&)";
    _get_comp_words_by_ref -n "$exclude<>&" cur prev words cword;
    _variables && return 1;
    if [[ $cur == $redir* || ${prev-} == $redir ]]; then
        local xspec;
        case $cur in 
            2'>'*)
                xspec=${errx-}
            ;;
            *'>'*)
                xspec=${outx-}
            ;;
            *'<'*)
                xspec=${inx-}
            ;;
            *)
                case $prev in 
                    2'>'*)
                        xspec=${errx-}
                    ;;
                    *'>'*)
                        xspec=${outx-}
                    ;;
                    *'<'*)
                        xspec=${inx-}
                    ;;
                esac
            ;;
        esac;
        cur="${cur##$redir}";
        _filedir $xspec;
        return 1;
    fi;
    local i skip;
    for ((i = 1; i < ${#words[@]}; 1))
    do
        if [[ ${words[i]} == $redir* ]]; then
            [[ ${words[i]} == $redir ]] && skip=2 || skip=1;
            words=("${words[@]:0:i}" "${words[@]:i+skip}");
            ((i <= cword)) && ((cword -= skip));
        else
            ((i++));
        fi;
    done;
    ((cword <= 0)) && return 1;
    prev=${words[cword - 1]};
    [[ -n ${split-} ]] && _split_longopt && split=true;
    return 0
}
_installed_modules () 
{ 
    COMPREPLY=($(compgen -W "$(PATH="$PATH:/sbin" lsmod | awk '{if (NR != 1) print $1}')" -- "$1"))
}
_ip_addresses () 
{ 
    local n;
    case ${1-} in 
        -a)
            n='6\?'
        ;;
        -6)
            n='6'
        ;;
        *)
            n=
        ;;
    esac;
    local PATH=$PATH:/sbin;
    local addrs=$({ LC_ALL=C ifconfig -a || ip addr show; } 2> /dev/null | command sed -e 's/[[:space:]]addr:/ /' -ne "s|.*inet${n}[[:space:]]\{1,\}\([^[:space:]/]*\).*|\1|p");
    COMPREPLY+=($(compgen -W "$addrs" -- "${cur-}"))
}
_kernel_versions () 
{ 
    COMPREPLY=($(compgen -W '$(command ls /lib/modules)' -- "$cur"))
}
_known_hosts () 
{ 
    local cur prev words cword;
    _init_completion -n : || return;
    local options;
    [[ ${1-} == -a || ${2-} == -a ]] && options=-a;
    [[ ${1-} == -c || ${2-} == -c ]] && options+=" -c";
    _known_hosts_real ${options-} -- "$cur"
}
_known_hosts_real () 
{ 
    local configfile flag prefix="" ifs=$IFS;
    local cur suffix="" aliases i host ipv4 ipv6;
    local -a kh tmpkh=() khd=() config=();
    local OPTIND=1;
    while getopts "ac46F:p:" flag "$@"; do
        case $flag in 
            a)
                aliases='yes'
            ;;
            c)
                suffix=':'
            ;;
            F)
                configfile=$OPTARG
            ;;
            p)
                prefix=$OPTARG
            ;;
            4)
                ipv4=1
            ;;
            6)
                ipv6=1
            ;;
            *)
                echo "bash_completion: $FUNCNAME: usage error" 1>&2;
                return 1
            ;;
        esac;
    done;
    if (($# < OPTIND)); then
        echo "bash_completion: $FUNCNAME: missing mandatory argument CWORD" 1>&2;
        return 1;
    fi;
    cur=${!OPTIND};
    ((OPTIND += 1));
    if (($# >= OPTIND)); then
        echo "bash_completion: $FUNCNAME($*): unprocessed arguments:" "$(while (($# >= OPTIND)); do
    printf '%s ' ${!OPTIND}
shift;
done)" 1>&2;
        return 1;
    fi;
    [[ $cur == *@* ]] && prefix=$prefix${cur%@*}@ && cur=${cur#*@};
    kh=();
    if [[ -v configfile ]]; then
        [[ -r $configfile ]] && config+=("$configfile");
    else
        for i in /etc/ssh/ssh_config ~/.ssh/config ~/.ssh2/config;
        do
            [[ -r $i ]] && config+=("$i");
        done;
    fi;
    local reset=$(shopt -po noglob);
    set -o noglob;
    if ((${#config[@]} > 0)); then
        for i in "${config[@]}";
        do
            _included_ssh_config_files "$i";
        done;
    fi;
    if ((${#config[@]} > 0)); then
        local IFS='
';
        tmpkh=($(awk 'sub("^[ \t]*([Gg][Ll][Oo][Bb][Aa][Ll]|[Uu][Ss][Ee][Rr])[Kk][Nn][Oo][Ww][Nn][Hh][Oo][Ss][Tt][Ss][Ff][Ii][Ll][Ee][ \t]+", "") { print $0 }' "${config[@]}" | sort -u));
        IFS=$ifs;
    fi;
    if ((${#tmpkh[@]} != 0)); then
        local j;
        for i in "${tmpkh[@]}";
        do
            while [[ $i =~ ^([^\"]*)\"([^\"]*)\"(.*)$ ]]; do
                i=${BASH_REMATCH[1]}${BASH_REMATCH[3]};
                j=${BASH_REMATCH[2]};
                __expand_tilde_by_ref j;
                [[ -r $j ]] && kh+=("$j");
            done;
            for j in $i;
            do
                __expand_tilde_by_ref j;
                [[ -r $j ]] && kh+=("$j");
            done;
        done;
    fi;
    if [[ ! -v configfile ]]; then
        for i in /etc/ssh/ssh_known_hosts /etc/ssh/ssh_known_hosts2 /etc/known_hosts /etc/known_hosts2 ~/.ssh/known_hosts ~/.ssh/known_hosts2;
        do
            [[ -r $i ]] && kh+=("$i");
        done;
        for i in /etc/ssh2/knownhosts ~/.ssh2/hostkeys;
        do
            [[ -d $i ]] && khd+=("$i"/*pub);
        done;
    fi;
    if ((${#kh[@]} + ${#khd[@]} > 0)); then
        if ((${#kh[@]} > 0)); then
            for i in "${kh[@]}";
            do
                while read -ra tmpkh; do
                    ((${#tmpkh[@]} == 0)) && continue;
                    set -- "${tmpkh[@]}";
                    [[ $1 == [\|\#]* ]] && continue;
                    [[ $1 == @* ]] && shift;
                    local IFS=,;
                    for host in $1;
                    do
                        [[ $host == *[*?]* ]] && continue;
                        host="${host#[}";
                        host="${host%]?(:+([0-9]))}";
                        COMPREPLY+=($host);
                    done;
                    IFS=$ifs;
                done < "$i";
            done;
            COMPREPLY=($(compgen -W '${COMPREPLY[@]}' -- "$cur"));
        fi;
        if ((${#khd[@]} > 0)); then
            for i in "${khd[@]}";
            do
                if [[ $i == *key_22_$cur*.pub && -r $i ]]; then
                    host=${i/#*key_22_/};
                    host=${host/%.pub/};
                    COMPREPLY+=($host);
                fi;
            done;
        fi;
        for i in ${!COMPREPLY[*]};
        do
            COMPREPLY[i]=$prefix${COMPREPLY[i]}$suffix;
        done;
    fi;
    if [[ ${#config[@]} -gt 0 && -v aliases ]]; then
        local -a hosts=($(command sed -ne 's/^[[:blank:]]*[Hh][Oo][Ss][Tt][[:blank:]]\(.*\)$/\1/p' "${config[@]}"));
        if ((${#hosts[@]} != 0)); then
            COMPREPLY+=($(compgen -P "$prefix" -S "$suffix" -W '${hosts[@]%%[*?%]*}' -X '\!*' -- "$cur"));
        fi;
    fi;
    if [[ -n ${COMP_KNOWN_HOSTS_WITH_AVAHI-} ]] && type avahi-browse &> /dev/null; then
        COMPREPLY+=($(compgen -P "$prefix" -S "$suffix" -W "$(avahi-browse -cpr _workstation._tcp 2> /dev/null | awk -F';' '/^=/ { print $7 }' | sort -u)" -- "$cur"));
    fi;
    if type ruptime &> /dev/null; then
        COMPREPLY+=($(compgen -W "$(ruptime 2> /dev/null | awk '!/^ruptime:/ { print $1 }')" -- "$cur"));
    fi;
    if [[ -n ${COMP_KNOWN_HOSTS_WITH_HOSTFILE-1} ]]; then
        COMPREPLY+=($(compgen -A hostname -P "$prefix" -S "$suffix" -- "$cur"));
    fi;
    $reset;
    if [[ -v ipv4 ]]; then
        COMPREPLY=("${COMPREPLY[@]/*:*$suffix/}");
    fi;
    if [[ -v ipv6 ]]; then
        COMPREPLY=("${COMPREPLY[@]/+([0-9]).+([0-9]).+([0-9]).+([0-9])$suffix/}");
    fi;
    if [[ -v ipv4 || -v ipv6 ]]; then
        for i in "${!COMPREPLY[@]}";
        do
            [[ -n ${COMPREPLY[i]} ]] || unset -v "COMPREPLY[i]";
        done;
    fi;
    __ltrim_colon_completions "$prefix$cur"
}
_longopt () 
{ 
    local cur prev words cword split;
    _init_completion -s || return;
    case "${prev,,}" in 
        --help | --usage | --version)
            return
        ;;
        --!(no-*)dir*)
            _filedir -d;
            return
        ;;
        --!(no-*)@(file|path)*)
            _filedir;
            return
        ;;
        --+([-a-z0-9_]))
            local argtype=$(LC_ALL=C $1 --help 2>&1 | command sed -ne "s|.*$prev\[\{0,1\}=[<[]\{0,1\}\([-A-Za-z0-9_]\{1,\}\).*|\1|p");
            case ${argtype,,} in 
                *dir*)
                    _filedir -d;
                    return
                ;;
                *file* | *path*)
                    _filedir;
                    return
                ;;
            esac
        ;;
    esac;
    $split && return;
    if [[ $cur == -* ]]; then
        COMPREPLY=($(compgen -W "$(LC_ALL=C $1 --help 2>&1 | while read -r line; do
    [[ $line =~ --[A-Za-z0-9]+([-_][A-Za-z0-9]+)*=? ]] && printf '%s\n' ${BASH_REMATCH[0]};
done)" -- "$cur"));
        [[ ${COMPREPLY-} == *= ]] && compopt -o nospace;
    else
        if [[ $1 == *@(rmdir|chroot) ]]; then
            _filedir -d;
        else
            [[ $1 == *mkdir ]] && compopt -o nospace;
            _filedir;
        fi;
    fi
}
_mac_addresses () 
{ 
    local re='\([A-Fa-f0-9]\{2\}:\)\{5\}[A-Fa-f0-9]\{2\}';
    local PATH="$PATH:/sbin:/usr/sbin";
    COMPREPLY+=($({ LC_ALL=C ifconfig -a || ip link show; } 2> /dev/null | command sed -ne "s/.*[[:space:]]HWaddr[[:space:]]\{1,\}\($re\)[[:space:]].*/\1/p" -ne "s/.*[[:space:]]HWaddr[[:space:]]\{1,\}\($re\)[[:space:]]*$/\1/p" -ne "s|.*[[:space:]]\(link/\)\{0,1\}ether[[:space:]]\{1,\}\($re\)[[:space:]].*|\2|p" -ne "s|.*[[:space:]]\(link/\)\{0,1\}ether[[:space:]]\{1,\}\($re\)[[:space:]]*$|\2|p"));
    COMPREPLY+=($({ arp -an || ip neigh show; } 2> /dev/null | command sed -ne "s/.*[[:space:]]\($re\)[[:space:]].*/\1/p" -ne "s/.*[[:space:]]\($re\)[[:space:]]*$/\1/p"));
    COMPREPLY+=($(command sed -ne "s/^[[:space:]]*\($re\)[[:space:]].*/\1/p" /etc/ethers 2> /dev/null));
    COMPREPLY=($(compgen -W '${COMPREPLY[@]}' -- "$cur"));
    __ltrim_colon_completions "$cur"
}
_minimal () 
{ 
    local cur prev words cword split;
    _init_completion -s || return;
    $split && return;
    _filedir
}
_modules () 
{ 
    local modpath;
    modpath=/lib/modules/$1;
    COMPREPLY=($(compgen -W "$(command ls -RL $modpath 2> /dev/null | command sed -ne 's/^\(.*\)\.k\{0,1\}o\(\.[gx]z\)\{0,1\}$/\1/p')" -- "$cur"))
}
_ncpus () 
{ 
    local var=NPROCESSORS_ONLN;
    [[ $OSTYPE == *linux* ]] && var=_$var;
    local n=$(getconf $var 2> /dev/null);
    printf %s ${n:-1}
}
_parse_help () 
{ 
    eval local cmd="$(quote "$1")";
    local line;
    { 
        case $cmd in 
            -)
                cat
            ;;
            *)
                LC_ALL=C "$(dequote "$cmd")" ${2:---help} 2>&1
            ;;
        esac
    } | while read -r line; do
        [[ $line == *([[:blank:]])-* ]] || continue;
        while [[ $line =~ ((^|[^-])-[A-Za-z0-9?][[:space:]]+)\[?[A-Z0-9]+([,_-]+[A-Z0-9]+)?(\.\.+)?\]? ]]; do
            line=${line/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"};
        done;
        __parse_options "${line// or /, }";
    done
}
_parse_usage () 
{ 
    eval local cmd="$(quote "$1")";
    local line match option i char;
    { 
        case $cmd in 
            -)
                cat
            ;;
            *)
                LC_ALL=C "$(dequote "$cmd")" ${2:---usage} 2>&1
            ;;
        esac
    } | while read -r line; do
        while [[ $line =~ \[[[:space:]]*(-[^]]+)[[:space:]]*\] ]]; do
            match=${BASH_REMATCH[0]};
            option=${BASH_REMATCH[1]};
            case $option in 
                -?(\[)+([a-zA-Z0-9?]))
                    for ((i = 1; i < ${#option}; i++))
                    do
                        char=${option:i:1};
                        [[ $char != '[' ]] && printf '%s\n' -$char;
                    done
                ;;
                *)
                    __parse_options "$option"
                ;;
            esac;
            line=${line#*"$match"};
        done;
    done
}
_pci_ids () 
{ 
    COMPREPLY+=($(compgen -W "$(PATH="$PATH:/sbin" lspci -n | awk '{print $3}')" -- "$cur"))
}
_pgids () 
{ 
    COMPREPLY=($(compgen -W '$(command ps axo pgid=)' -- "$cur"))
}
_pids () 
{ 
    COMPREPLY=($(compgen -W '$(command ps axo pid=)' -- "$cur"))
}
_pnames () 
{ 
    local -a procs;
    if [[ ${1-} == -s ]]; then
        procs=($(command ps axo comm | command sed -e 1d));
    else
        local line i=-1 ifs=$IFS;
        IFS='
';
        local -a psout=($(command ps axo command=));
        IFS=$ifs;
        for line in "${psout[@]}";
        do
            if ((i == -1)); then
                if [[ $line =~ ^(.*[[:space:]])COMMAND([[:space:]]|$) ]]; then
                    i=${#BASH_REMATCH[1]};
                else
                    break;
                fi;
            else
                line=${line:i};
                line=${line%% *};
                procs+=($line);
            fi;
        done;
        if ((i == -1)); then
            for line in "${psout[@]}";
            do
                if [[ $line =~ ^[[(](.+)[])]$ ]]; then
                    procs+=(${BASH_REMATCH[1]});
                else
                    line=${line%% *};
                    line=${line##@(*/|-)};
                    procs+=($line);
                fi;
            done;
        fi;
    fi;
    COMPREPLY=($(compgen -X "<defunct>" -W '${procs[@]}' -- "$cur"))
}
_pyenv () 
{ 
    COMPREPLY=();
    local word="${COMP_WORDS[COMP_CWORD]}";
    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=($(compgen -W "$(pyenv commands)" -- "$word"));
    else
        local words=("${COMP_WORDS[@]}");
        unset words[0];
        unset words[$COMP_CWORD];
        local completions=$(pyenv completions "${words[@]}");
        COMPREPLY=($(compgen -W "$completions" -- "$word"));
    fi
}
_python_argcomplete_global () 
{ 
    if [[ -n "${ZSH_VERSION-}" ]]; then
        setopt local_options BASH_REMATCH;
    fi;
    local _BASH_REMATCH="";
    local executable="";
    local req_argv=();
    if [[ -z "${ZSH_VERSION-}" ]]; then
        executable=$1;
        req_argv=("" "${COMP_WORDS[@]:1}");
        __python_argcomplete_expand_tilde_by_ref executable;
    else
        if [[ "$service" != "-default-" ]]; then
            _default;
            return;
        fi;
        executable="${words[1]}";
        req_argv=("${words[@]:1}");
    fi;
    local ARGCOMPLETE=0;
    if [[ "$executable" == python* ]] || [[ "$executable" == pypy* ]]; then
        if [[ "${req_argv[1]}" == -m ]]; then
            if __python_argcomplete_run "$executable" -m argcomplete._check_module "${req_argv[2]}"; then
                ARGCOMPLETE=3;
            else
                return;
            fi;
        fi;
        if [[ $ARGCOMPLETE == 0 ]]; then
            local potential_path="${req_argv[1]}";
            __python_argcomplete_expand_tilde_by_ref potential_path;
            if [[ -f "$potential_path" ]] && __python_argcomplete_scan_head_noerr "$potential_path" magic_string; then
                req_argv[1]="$potential_path";
                ARGCOMPLETE=2;
            else
                return;
            fi;
        fi;
    else
        if __python_argcomplete_which "$executable" > /dev/null 2>&1; then
            local SCRIPT_NAME=$(__python_argcomplete_which "$executable");
            __python_argcomplete_scan_head_noerr "$SCRIPT_NAME" interpreter;
            if ( __python_argcomplete_which pyenv && [[ "$SCRIPT_NAME" = $(pyenv root)/shims/* ]] ) > /dev/null 2>&1; then
                local SCRIPT_NAME=$(pyenv which "$executable");
            fi;
            if ( __python_argcomplete_which asdf && __python_argcomplete_scan_head_noerr "$SCRIPT_NAME" asdf ) > /dev/null 2>&1; then
                local SCRIPT_NAME=$(asdf which "$executable");
            fi;
            if __python_argcomplete_scan_head_noerr "$SCRIPT_NAME" magic_string; then
                ARGCOMPLETE=1;
            else
                if __python_argcomplete_scan_head_noerr "$SCRIPT_NAME" interpreter; then
                    __python_argcomplete_upshift_bash_rematch;
                    local interpreter="${_BASH_REMATCH[2]}";
                    if [[ -n "${ZSH_VERSION-}" ]]; then
                        interpreter=($=interpreter);
                    else
                        interpreter=($interpreter);
                    fi;
                    if ( __python_argcomplete_scan_head_noerr "$SCRIPT_NAME" easy_install && "${interpreter[@]}" "$(__python_argcomplete_which python-argcomplete-check-easy-install-script)" "$SCRIPT_NAME" ) > /dev/null 2>&1; then
                        ARGCOMPLETE=1;
                    else
                        if __python_argcomplete_run "${interpreter[@]}" -m argcomplete._check_console_script "$SCRIPT_NAME"; then
                            ARGCOMPLETE=1;
                        fi;
                    fi;
                fi;
            fi;
        fi;
    fi;
    if [[ $ARGCOMPLETE != 0 ]]; then
        local IFS='';
        if [[ -n "${ZSH_VERSION-}" ]]; then
            local completions;
            completions=($(IFS="$IFS" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" _ARGCOMPLETE=$ARGCOMPLETE _ARGCOMPLETE_SHELL="zsh" _ARGCOMPLETE_SUPPRESS_SPACE=1 __python_argcomplete_run "$executable" "${(@)req_argv[1, ${ARGCOMPLETE}-1]}"));
            _describe "$executable" completions;
        else
            COMPREPLY=($(IFS="$IFS" COMP_LINE="$COMP_LINE" COMP_POINT="$COMP_POINT" COMP_TYPE="$COMP_TYPE" _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" _ARGCOMPLETE=$ARGCOMPLETE _ARGCOMPLETE_SHELL="bash" _ARGCOMPLETE_SUPPRESS_SPACE=1 __python_argcomplete_run "$executable" "${req_argv[@]:1:${ARGCOMPLETE}-1}"));
            if [[ $? != 0 ]]; then
                unset COMPREPLY;
            else
                if [[ "${COMPREPLY-}" =~ [=/:]$ ]]; then
                    compopt -o nospace;
                fi;
            fi;
        fi;
    else
        if [[ -n "${ZSH_VERSION-}" ]]; then
            _default;
        else
            type -t _completion_loader | grep --color=auto -q 'function' && _completion_loader "$@";
        fi;
    fi
}
_quote_readline_by_ref () 
{ 
    if [[ $1 == \'* ]]; then
        printf -v $2 %s "${1:1}";
    else
        printf -v $2 %q "$1";
    fi;
    [[ ${!2} == \$* ]] && eval $2=${!2}
}
_realcommand () 
{ 
    type -P "$1" > /dev/null && { 
        if type -p realpath > /dev/null; then
            realpath "$(type -P "$1")";
        else
            if type -p greadlink > /dev/null; then
                greadlink -f "$(type -P "$1")";
            else
                if type -p readlink > /dev/null; then
                    readlink -f "$(type -P "$1")";
                else
                    type -P "$1";
                fi;
            fi;
        fi
    }
}
_rl_enabled () 
{ 
    [[ "$(bind -v)" == *$1+([[:space:]])on* ]]
}
_root_command () 
{ 
    local PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin;
    local root_command=$1;
    _command
}
_service () 
{ 
    local cur prev words cword;
    _init_completion || return;
    ((cword > 2)) && return;
    if [[ $cword -eq 1 && $prev == ?(*/)service ]]; then
        _services;
        [[ -e /etc/mandrake-release ]] && _xinetd_services;
    else
        local sysvdirs;
        _sysvdirs;
        COMPREPLY=($(compgen -W '`command sed -e "y/|/ /" \
            -ne "s/^.*\(U\|msg_u\)sage.*{\(.*\)}.*$/\2/p" \
            ${sysvdirs[0]}/${prev##*/} 2>/dev/null` start stop' -- "$cur"));
    fi
}
_services () 
{ 
    local sysvdirs;
    _sysvdirs;
    local IFS=' 	
' reset=$(shopt -p nullglob);
    shopt -s nullglob;
    COMPREPLY=($(printf '%s\n' ${sysvdirs[0]}/!($_backup_glob|functions|README)));
    $reset;
    COMPREPLY+=($({ systemctl list-units --full --all || systemctl list-unit-files; } 2> /dev/null | awk '$1 ~ /\.service$/ { sub("\\.service$", "", $1); print $1 }'));
    if [[ -x /sbin/upstart-udev-bridge ]]; then
        COMPREPLY+=($(initctl list 2> /dev/null | cut -d' ' -f1));
    fi;
    COMPREPLY=($(compgen -W '${COMPREPLY[@]#${sysvdirs[0]}/}' -- "$cur"))
}
_shells () 
{ 
    local shell rest;
    while read -r shell rest; do
        [[ $shell == /* && $shell == "$cur"* ]] && COMPREPLY+=($shell);
    done 2> /dev/null < /etc/shells
}
_signals () 
{ 
    local -a sigs=($(compgen -P "${1-}" -A signal "SIG${cur#${1-}}"));
    COMPREPLY+=("${sigs[@]/#${1-}SIG/${1-}}")
}
_split_longopt () 
{ 
    if [[ $cur == --?*=* ]]; then
        prev="${cur%%?(\\)=*}";
        cur="${cur#*=}";
        return 0;
    fi;
    return 1
}
_starship_set_return () 
{ 
    return "${1:-0}"
}
_sysvdirs () 
{ 
    sysvdirs=();
    [[ -d /etc/rc.d/init.d ]] && sysvdirs+=(/etc/rc.d/init.d);
    [[ -d /etc/init.d ]] && sysvdirs+=(/etc/init.d);
    [[ -f /etc/slackware-version ]] && sysvdirs=(/etc/rc.d);
    return 0
}
_terms () 
{ 
    COMPREPLY+=($(compgen -W "$({ command sed -ne 's/^\([^[:space:]#|]\{2,\}\)|.*/\1/p' /etc/termcap
{ toe -a || toe; } | awk '{ print $1 }'
find /{etc,lib,usr/lib,usr/share}/terminfo/? -type f -maxdepth 1 | awk -F/ '{ print $NF }'; } 2> /dev/null)" -- "$cur"))
}
_tilde () 
{ 
    local result=0;
    if [[ ${1-} == \~* && $1 != */* ]]; then
        COMPREPLY=($(compgen -P '~' -u -- "${1#\~}"));
        result=${#COMPREPLY[@]};
        ((result > 0)) && compopt -o filenames 2> /dev/null;
    fi;
    return $result
}
_uids () 
{ 
    if type getent &> /dev/null; then
        COMPREPLY=($(compgen -W '$(getent passwd | cut -d: -f3)' -- "$cur"));
    else
        if type perl &> /dev/null; then
            COMPREPLY=($(compgen -W '$(perl -e '"'"'while (($uid) = (getpwent)[2]) { print $uid . "\n" }'"'"')' -- "$cur"));
        else
            COMPREPLY=($(compgen -W '$(cut -d: -f3 /etc/passwd)' -- "$cur"));
        fi;
    fi
}
_upvar () 
{ 
    echo "bash_completion: $FUNCNAME: deprecated function," "use _upvars instead" 1>&2;
    if unset -v "$1"; then
        if (($# == 2)); then
            eval $1=\"\$2\";
        else
            eval $1=\(\"\$"{@:2}"\"\);
        fi;
    fi
}
_upvars () 
{ 
    if ! (($#)); then
        echo "bash_completion: $FUNCNAME: usage: $FUNCNAME" "[-v varname value] | [-aN varname [value ...]] ..." 1>&2;
        return 2;
    fi;
    while (($#)); do
        case $1 in 
            -a*)
                [[ -n ${1#-a} ]] || { 
                    echo "bash_completion: $FUNCNAME:" "\`$1': missing number specifier" 1>&2;
                    return 1
                };
                printf %d "${1#-a}" &> /dev/null || { 
                    echo bash_completion: "$FUNCNAME: \`$1': invalid number specifier" 1>&2;
                    return 1
                };
                [[ -n "$2" ]] && unset -v "$2" && eval $2=\(\"\$"{@:3:${1#-a}}"\"\) && shift $((${1#-a} + 2)) || { 
                    echo bash_completion: "$FUNCNAME: \`$1${2+ }$2': missing argument(s)" 1>&2;
                    return 1
                }
            ;;
            -v)
                [[ -n "$2" ]] && unset -v "$2" && eval $2=\"\$3\" && shift 3 || { 
                    echo "bash_completion: $FUNCNAME: $1:" "missing argument(s)" 1>&2;
                    return 1
                }
            ;;
            *)
                echo "bash_completion: $FUNCNAME: $1: invalid option" 1>&2;
                return 1
            ;;
        esac;
    done
}
_usb_ids () 
{ 
    COMPREPLY+=($(compgen -W "$(PATH="$PATH:/sbin" lsusb | awk '{print $6}')" -- "$cur"))
}
_user_at_host () 
{ 
    local cur prev words cword;
    _init_completion -n : || return;
    if [[ $cur == *@* ]]; then
        _known_hosts_real "$cur";
    else
        COMPREPLY=($(compgen -u -S @ -- "$cur"));
        compopt -o nospace;
    fi
}
_usergroup () 
{ 
    if [[ $cur == *\\\\* || $cur == *:*:* ]]; then
        return;
    else
        if [[ $cur == *\\:* ]]; then
            local prefix;
            prefix=${cur%%*([^:])};
            prefix=${prefix//\\/};
            local mycur="${cur#*[:]}";
            if [[ ${1-} == -u ]]; then
                _allowed_groups "$mycur";
            else
                local IFS='
';
                COMPREPLY=($(compgen -g -- "$mycur"));
            fi;
            COMPREPLY=($(compgen -P "$prefix" -W "${COMPREPLY[@]}"));
        else
            if [[ $cur == *:* ]]; then
                local mycur="${cur#*:}";
                if [[ ${1-} == -u ]]; then
                    _allowed_groups "$mycur";
                else
                    local IFS='
';
                    COMPREPLY=($(compgen -g -- "$mycur"));
                fi;
            else
                if [[ ${1-} == -u ]]; then
                    _allowed_users "$cur";
                else
                    local IFS='
';
                    COMPREPLY=($(compgen -u -- "$cur"));
                fi;
            fi;
        fi;
    fi
}
_userland () 
{ 
    local userland=$(uname -s);
    [[ $userland == @(Linux|GNU/*) ]] && userland=GNU;
    [[ $userland == "$1" ]]
}
_variable_assignments () 
{ 
    local cur=${1-};
    if [[ $cur =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
        prev=${BASH_REMATCH[1]};
        cur=${BASH_REMATCH[2]};
    else
        return 1;
    fi;
    case $prev in 
        TZ)
            cur=/usr/share/zoneinfo/$cur;
            _filedir;
            for i in "${!COMPREPLY[@]}";
            do
                if [[ ${COMPREPLY[i]} == *.tab ]]; then
                    unset 'COMPREPLY[i]';
                    continue;
                else
                    if [[ -d ${COMPREPLY[i]} ]]; then
                        COMPREPLY[i]+=/;
                        compopt -o nospace;
                    fi;
                fi;
                COMPREPLY[i]=${COMPREPLY[i]#/usr/share/zoneinfo/};
            done
        ;;
        TERM)
            _terms
        ;;
        LANG | LC_*)
            COMPREPLY=($(compgen -W '$(locale -a 2>/dev/null)' -- "$cur"))
        ;;
        *)
            _variables && return 0;
            _filedir
        ;;
    esac;
    return 0
}
_variables () 
{ 
    if [[ $cur =~ ^(\$(\{[!#]?)?)([A-Za-z0-9_]*)$ ]]; then
        if [[ $cur == '${'* ]]; then
            local arrs vars;
            vars=($(compgen -A variable -P ${BASH_REMATCH[1]} -S '}' -- ${BASH_REMATCH[3]}));
            arrs=($(compgen -A arrayvar -P ${BASH_REMATCH[1]} -S '[' -- ${BASH_REMATCH[3]}));
            if ((${#vars[@]} == 1 && ${#arrs[@]} != 0)); then
                compopt -o nospace;
                COMPREPLY+=(${arrs[*]});
            else
                COMPREPLY+=(${vars[*]});
            fi;
        else
            COMPREPLY+=($(compgen -A variable -P '$' -- "${BASH_REMATCH[3]}"));
        fi;
        return 0;
    else
        if [[ $cur =~ ^(\$\{[#!]?)([A-Za-z0-9_]*)\[([^]]*)$ ]]; then
            local IFS='
';
            COMPREPLY+=($(compgen -W '$(printf %s\\n "${!'${BASH_REMATCH[2]}'[@]}")' -P "${BASH_REMATCH[1]}${BASH_REMATCH[2]}[" -S ']}' -- "${BASH_REMATCH[3]}"));
            if [[ ${BASH_REMATCH[3]} == [@*] ]]; then
                COMPREPLY+=("${BASH_REMATCH[1]}${BASH_REMATCH[2]}[${BASH_REMATCH[3]}]}");
            fi;
            __ltrim_colon_completions "$cur";
            return 0;
        else
            if [[ $cur =~ ^\$\{[#!]?[A-Za-z0-9_]*\[.*\]$ ]]; then
                COMPREPLY+=("$cur}");
                __ltrim_colon_completions "$cur";
                return 0;
            fi;
        fi;
    fi;
    return 1
}
_xfunc () 
{ 
    set -- "$@";
    local srcfile=$1;
    shift;
    declare -F $1 &> /dev/null || __load_completion "$srcfile";
    "$@"
}
_xinetd_services () 
{ 
    local xinetddir=${BASHCOMP_XINETDDIR:-/etc/xinetd.d};
    if [[ -d $xinetddir ]]; then
        local IFS=' 	
' reset=$(shopt -p nullglob);
        shopt -s nullglob;
        local -a svcs=($(printf '%s\n' $xinetddir/!($_backup_glob)));
        $reset;
        ((!${#svcs[@]})) || COMPREPLY+=($(compgen -W '${svcs[@]#$xinetddir/}' -- "${cur-}"));
    fi
}
command_not_found_handle () 
{ 
    if [ -x /usr/lib/command-not-found ]; then
        /usr/lib/command-not-found -- "$1";
        return $?;
    else
        if [ -x /usr/share/command-not-found/command-not-found ]; then
            /usr/share/command-not-found/command-not-found -- "$1";
            return $?;
        else
            printf "%s: command not found\n" "$1" 1>&2;
            return 127;
        fi;
    fi
}
dequote () 
{ 
    eval printf %s "$1" 2> /dev/null
}
gawklibpath_append () 
{ 
    [ -z "$AWKLIBPATH" ] && AWKLIBPATH=`gawk 'BEGIN {print ENVIRON["AWKLIBPATH"]}'`;
    export AWKLIBPATH="$AWKLIBPATH:$*"
}
gawklibpath_default () 
{ 
    unset AWKLIBPATH;
    export AWKLIBPATH=`gawk 'BEGIN {print ENVIRON["AWKLIBPATH"]}'`
}
gawklibpath_prepend () 
{ 
    [ -z "$AWKLIBPATH" ] && AWKLIBPATH=`gawk 'BEGIN {print ENVIRON["AWKLIBPATH"]}'`;
    export AWKLIBPATH="$*:$AWKLIBPATH"
}
gawkpath_append () 
{ 
    [ -z "$AWKPATH" ] && AWKPATH=`gawk 'BEGIN {print ENVIRON["AWKPATH"]}'`;
    export AWKPATH="$AWKPATH:$*"
}
gawkpath_default () 
{ 
    unset AWKPATH;
    export AWKPATH=`gawk 'BEGIN {print ENVIRON["AWKPATH"]}'`
}
gawkpath_prepend () 
{ 
    [ -z "$AWKPATH" ] && AWKPATH=`gawk 'BEGIN {print ENVIRON["AWKPATH"]}'`;
    export AWKPATH="$*:$AWKPATH"
}
nvm () 
{ 
    if [ "$#" -lt 1 ]; then
        nvm --help;
        return;
    fi;
    local DEFAULT_IFS;
    DEFAULT_IFS=" $(nvm_echo t | command tr t \\t)
";
    if [ "${-#*e}" != "$-" ]; then
        set +e;
        local EXIT_CODE;
        IFS="${DEFAULT_IFS}" nvm "$@";
        EXIT_CODE="$?";
        set -e;
        return "$EXIT_CODE";
    else
        if [ "${-#*a}" != "$-" ]; then
            set +a;
            local EXIT_CODE;
            IFS="${DEFAULT_IFS}" nvm "$@";
            EXIT_CODE="$?";
            set -a;
            return "$EXIT_CODE";
        else
            if [ -n "${BASH-}" ] && [ "${-#*E}" != "$-" ]; then
                set +E;
                local EXIT_CODE;
                IFS="${DEFAULT_IFS}" nvm "$@";
                EXIT_CODE="$?";
                set -E;
                return "$EXIT_CODE";
            else
                if [ "${IFS}" != "${DEFAULT_IFS}" ]; then
                    IFS="${DEFAULT_IFS}" nvm "$@";
                    return "$?";
                fi;
            fi;
        fi;
    fi;
    local i;
    for i in "$@";
    do
        case $i in 
            --)
                break
            ;;
            '-h' | 'help' | '--help')
                NVM_NO_COLORS="";
                for j in "$@";
                do
                    if [ "${j}" = '--no-colors' ]; then
                        NVM_NO_COLORS="${j}";
                        break;
                    fi;
                done;
                local NVM_IOJS_PREFIX;
                NVM_IOJS_PREFIX="$(nvm_iojs_prefix)";
                local NVM_NODE_PREFIX;
                NVM_NODE_PREFIX="$(nvm_node_prefix)";
                NVM_VERSION="$(nvm --version)";
                nvm_echo;
                nvm_echo "Node Version Manager (v${NVM_VERSION})";
                nvm_echo;
                nvm_echo 'Note: <version> refers to any version-like string nvm understands. This includes:';
                nvm_echo '  - full or partial version numbers, starting with an optional "v" (0.10, v0.1.2, v1)';
                nvm_echo "  - default (built-in) aliases: ${NVM_NODE_PREFIX}, stable, unstable, ${NVM_IOJS_PREFIX}, system";
                nvm_echo '  - custom aliases you define with `nvm alias foo`';
                nvm_echo;
                nvm_echo ' Any options that produce colorized output should respect the `--no-colors` option.';
                nvm_echo;
                nvm_echo 'Usage:';
                nvm_echo '  nvm --help                                  Show this message';
                nvm_echo '    --no-colors                               Suppress colored output';
                nvm_echo '  nvm --version                               Print out the installed version of nvm';
                nvm_echo '  nvm install [<version>]                     Download and install a <version>. Uses .nvmrc if available and version is omitted.';
                nvm_echo '   The following optional arguments, if provided, must appear directly after `nvm install`:';
                nvm_echo '    -s                                        Skip binary download, install from source only.';
                nvm_echo '    -b                                        Skip source download, install from binary only.';
                nvm_echo '    --reinstall-packages-from=<version>       When installing, reinstall packages installed in <node|iojs|node version number>';
                nvm_echo '    --lts                                     When installing, only select from LTS (long-term support) versions';
                nvm_echo '    --lts=<LTS name>                          When installing, only select from versions for a specific LTS line';
                nvm_echo '    --skip-default-packages                   When installing, skip the default-packages file if it exists';
                nvm_echo '    --latest-npm                              After installing, attempt to upgrade to the latest working npm on the given node version';
                nvm_echo '    --no-progress                             Disable the progress bar on any downloads';
                nvm_echo '    --alias=<name>                            After installing, set the alias specified to the version specified. (same as: nvm alias <name> <version>)';
                nvm_echo '    --default                                 After installing, set default alias to the version specified. (same as: nvm alias default <version>)';
                nvm_echo '    --save                                    After installing, write the specified version to .nvmrc';
                nvm_echo '  nvm uninstall <version>                     Uninstall a version';
                nvm_echo '  nvm uninstall --lts                         Uninstall using automatic LTS (long-term support) alias `lts/*`, if available.';
                nvm_echo '  nvm uninstall --lts=<LTS name>              Uninstall using automatic alias for provided LTS line, if available.';
                nvm_echo '  nvm use [<version>]                         Modify PATH to use <version>. Uses .nvmrc if available and version is omitted.';
                nvm_echo '   The following optional arguments, if provided, must appear directly after `nvm use`:';
                nvm_echo '    --silent                                  Silences stdout/stderr output';
                nvm_echo '    --lts                                     Uses automatic LTS (long-term support) alias `lts/*`, if available.';
                nvm_echo '    --lts=<LTS name>                          Uses automatic alias for provided LTS line, if available.';
                nvm_echo '    --save                                    Writes the specified version to .nvmrc.';
                nvm_echo '  nvm exec [<version>] [<command>]            Run <command> on <version>. Uses .nvmrc if available and version is omitted.';
                nvm_echo '   The following optional arguments, if provided, must appear directly after `nvm exec`:';
                nvm_echo '    --silent                                  Silences stdout/stderr output';
                nvm_echo '    --lts                                     Uses automatic LTS (long-term support) alias `lts/*`, if available.';
                nvm_echo '    --lts=<LTS name>                          Uses automatic alias for provided LTS line, if available.';
                nvm_echo '  nvm run [<version>] [<args>]                Run `node` on <version> with <args> as arguments. Uses .nvmrc if available and version is omitted.';
                nvm_echo '   The following optional arguments, if provided, must appear directly after `nvm run`:';
                nvm_echo '    --silent                                  Silences stdout/stderr output';
                nvm_echo '    --lts                                     Uses automatic LTS (long-term support) alias `lts/*`, if available.';
                nvm_echo '    --lts=<LTS name>                          Uses automatic alias for provided LTS line, if available.';
                nvm_echo '  nvm current                                 Display currently activated version of Node';
                nvm_echo '  nvm ls [<version>]                          List installed versions, matching a given <version> if provided';
                nvm_echo '    --no-colors                               Suppress colored output';
                nvm_echo '    --no-alias                                Suppress `nvm alias` output';
                nvm_echo '  nvm ls-remote [<version>]                   List remote versions available for install, matching a given <version> if provided';
                nvm_echo '    --lts                                     When listing, only show LTS (long-term support) versions';
                nvm_echo '    --lts=<LTS name>                          When listing, only show versions for a specific LTS line';
                nvm_echo '    --no-colors                               Suppress colored output';
                nvm_echo '  nvm version <version>                       Resolve the given description to a single local version';
                nvm_echo '  nvm version-remote <version>                Resolve the given description to a single remote version';
                nvm_echo '    --lts                                     When listing, only select from LTS (long-term support) versions';
                nvm_echo '    --lts=<LTS name>                          When listing, only select from versions for a specific LTS line';
                nvm_echo '  nvm deactivate                              Undo effects of `nvm` on current shell';
                nvm_echo '    --silent                                  Silences stdout/stderr output';
                nvm_echo '  nvm alias [<pattern>]                       Show all aliases beginning with <pattern>';
                nvm_echo '    --no-colors                               Suppress colored output';
                nvm_echo '  nvm alias <name> <version>                  Set an alias named <name> pointing to <version>';
                nvm_echo '  nvm unalias <name>                          Deletes the alias named <name>';
                nvm_echo '  nvm install-latest-npm                      Attempt to upgrade to the latest working `npm` on the current node version';
                nvm_echo '  nvm reinstall-packages <version>            Reinstall global `npm` packages contained in <version> to current version';
                nvm_echo '  nvm unload                                  Unload `nvm` from shell';
                nvm_echo '  nvm which [current | <version>]             Display path to installed node version. Uses .nvmrc if available and version is omitted.';
                nvm_echo '    --silent                                  Silences stdout/stderr output when a version is omitted';
                nvm_echo '  nvm cache dir                               Display path to the cache directory for nvm';
                nvm_echo '  nvm cache clear                             Empty cache directory for nvm';
                nvm_echo '  nvm set-colors [<color codes>]              Set five text colors using format "yMeBg". Available when supported.';
                nvm_echo '                                               Initial colors are:';
                nvm_echo_with_colors "                                                  $(nvm_wrap_with_color_code 'b' 'b')$(nvm_wrap_with_color_code 'y' 'y')$(nvm_wrap_with_color_code 'g' 'g')$(nvm_wrap_with_color_code 'r' 'r')$(nvm_wrap_with_color_code 'e' 'e')";
                nvm_echo '                                               Color codes:';
                nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'r' 'r')/$(nvm_wrap_with_color_code 'R' 'R') = $(nvm_wrap_with_color_code 'r' 'red') / $(nvm_wrap_with_color_code 'R' 'bold red')";
                nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'g' 'g')/$(nvm_wrap_with_color_code 'G' 'G') = $(nvm_wrap_with_color_code 'g' 'green') / $(nvm_wrap_with_color_code 'G' 'bold green')";
                nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'b' 'b')/$(nvm_wrap_with_color_code 'B' 'B') = $(nvm_wrap_with_color_code 'b' 'blue') / $(nvm_wrap_with_color_code 'B' 'bold blue')";
                nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'c' 'c')/$(nvm_wrap_with_color_code 'C' 'C') = $(nvm_wrap_with_color_code 'c' 'cyan') / $(nvm_wrap_with_color_code 'C' 'bold cyan')";
                nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'm' 'm')/$(nvm_wrap_with_color_code 'M' 'M') = $(nvm_wrap_with_color_code 'm' 'magenta') / $(nvm_wrap_with_color_code 'M' 'bold magenta')";
                nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'y' 'y')/$(nvm_wrap_with_color_code 'Y' 'Y') = $(nvm_wrap_with_color_code 'y' 'yellow') / $(nvm_wrap_with_color_code 'Y' 'bold yellow')";
                nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'k' 'k')/$(nvm_wrap_with_color_code 'K' 'K') = $(nvm_wrap_with_color_code 'k' 'black') / $(nvm_wrap_with_color_code 'K' 'bold black')";
                nvm_echo_with_colors "                                                $(nvm_wrap_with_color_code 'e' 'e')/$(nvm_wrap_with_color_code 'W' 'W') = $(nvm_wrap_with_color_code 'e' 'light grey') / $(nvm_wrap_with_color_code 'W' 'white')";
                nvm_echo 'Example:';
                nvm_echo '  nvm install 8.0.0                     Install a specific version number';
                nvm_echo '  nvm use 8.0                           Use the latest available 8.0.x release';
                nvm_echo '  nvm run 6.10.3 app.js                 Run app.js using node 6.10.3';
                nvm_echo '  nvm exec 4.8.3 node app.js            Run `node app.js` with the PATH pointing to node 4.8.3';
                nvm_echo '  nvm alias default 8.1.0               Set default node version on a shell';
                nvm_echo '  nvm alias default node                Always default to the latest available node version on a shell';
                nvm_echo;
                nvm_echo '  nvm install node                      Install the latest available version';
                nvm_echo '  nvm use node                          Use the latest version';
                nvm_echo '  nvm install --lts                     Install the latest LTS version';
                nvm_echo '  nvm use --lts                         Use the latest LTS version';
                nvm_echo;
                nvm_echo '  nvm set-colors cgYmW                  Set text colors to cyan, green, bold yellow, magenta, and white';
                nvm_echo;
                nvm_echo 'Note:';
                nvm_echo '  to remove, delete, or uninstall nvm - just remove the `$NVM_DIR` folder (usually `~/.nvm`)';
                nvm_echo;
                return 0
            ;;
        esac;
    done;
    local COMMAND;
    COMMAND="${1-}";
    shift;
    local VERSION;
    local ADDITIONAL_PARAMETERS;
    case $COMMAND in 
        "cache")
            case "${1-}" in 
                dir)
                    nvm_cache_dir
                ;;
                clear)
                    local DIR;
                    DIR="$(nvm_cache_dir)";
                    if command rm -rf "${DIR}" && command mkdir -p "${DIR}"; then
                        nvm_echo 'nvm cache cleared.';
                    else
                        nvm_err "Unable to clear nvm cache: ${DIR}";
                        return 1;
                    fi
                ;;
                *)
                    nvm --help 1>&2;
                    return 127
                ;;
            esac
        ;;
        "debug")
            local OS_VERSION;
            nvm_is_zsh && setopt local_options shwordsplit;
            nvm_err "nvm --version: v$(nvm --version)";
            if [ -n "${TERM_PROGRAM-}" ]; then
                nvm_err "\$TERM_PROGRAM: ${TERM_PROGRAM}";
            fi;
            nvm_err "\$SHELL: ${SHELL}";
            nvm_err "\$SHLVL: ${SHLVL-}";
            nvm_err "whoami: '$(whoami)'";
            nvm_err "\${HOME}: ${HOME}";
            nvm_err "\${NVM_DIR}: '$(nvm_sanitize_path "${NVM_DIR}")'";
            nvm_err "\${PATH}: $(nvm_sanitize_path "${PATH}")";
            nvm_err "\$PREFIX: '$(nvm_sanitize_path "${PREFIX}")'";
            nvm_err "\${NPM_CONFIG_PREFIX}: '$(nvm_sanitize_path "${NPM_CONFIG_PREFIX}")'";
            nvm_err "\$NVM_NODEJS_ORG_MIRROR: '${NVM_NODEJS_ORG_MIRROR}'";
            nvm_err "\$NVM_IOJS_ORG_MIRROR: '${NVM_IOJS_ORG_MIRROR}'";
            nvm_err "shell version: '$(${SHELL} --version | command head -n 1)'";
            nvm_err "uname -a: '$(command uname -a | command awk '{$2=""; print}' | command xargs)'";
            nvm_err "checksum binary: '$(nvm_get_checksum_binary 2> /dev/null)'";
            if [ "$(nvm_get_os)" = "darwin" ] && nvm_has sw_vers; then
                OS_VERSION="$(sw_vers | command awk '{print $2}' | command xargs)";
            else
                if [ -r "/etc/issue" ]; then
                    OS_VERSION="$(command head -n 1 /etc/issue | command sed 's/\\.//g')";
                    if [ -z "${OS_VERSION}" ] && [ -r "/etc/os-release" ]; then
                        OS_VERSION="$(. /etc/os-release && echo "${NAME}" "${VERSION}")";
                    fi;
                fi;
            fi;
            if [ -n "${OS_VERSION}" ]; then
                nvm_err "OS version: ${OS_VERSION}";
            fi;
            if nvm_has "awk"; then
                nvm_err "awk: $(nvm_command_info awk), $({ command awk --version 2> /dev/null || command awk -W version; } | command head -n 1)";
            else
                nvm_err "awk: not found";
            fi;
            if nvm_has "curl"; then
                nvm_err "curl: $(nvm_command_info curl), $(command curl -V | command head -n 1)";
            else
                nvm_err "curl: not found";
            fi;
            if nvm_has "wget"; then
                nvm_err "wget: $(nvm_command_info wget), $(command wget -V | command head -n 1)";
            else
                nvm_err "wget: not found";
            fi;
            local TEST_TOOLS ADD_TEST_TOOLS;
            TEST_TOOLS="git grep";
            ADD_TEST_TOOLS="sed cut basename rm mkdir xargs";
            if [ "darwin" != "$(nvm_get_os)" ] && [ "freebsd" != "$(nvm_get_os)" ]; then
                TEST_TOOLS="${TEST_TOOLS} ${ADD_TEST_TOOLS}";
            else
                for tool in ${ADD_TEST_TOOLS};
                do
                    if nvm_has "${tool}"; then
                        nvm_err "${tool}: $(nvm_command_info "${tool}")";
                    else
                        nvm_err "${tool}: not found";
                    fi;
                done;
            fi;
            for tool in ${TEST_TOOLS};
            do
                local NVM_TOOL_VERSION;
                if nvm_has "${tool}"; then
                    if command ls -l "$(nvm_command_info "${tool}" | command awk '{print $1}')" | command grep -q busybox; then
                        NVM_TOOL_VERSION="$(command "${tool}" --help 2>&1 | command head -n 1)";
                    else
                        NVM_TOOL_VERSION="$(command "${tool}" --version 2>&1 | command head -n 1)";
                    fi;
                    nvm_err "${tool}: $(nvm_command_info "${tool}"), ${NVM_TOOL_VERSION}";
                else
                    nvm_err "${tool}: not found";
                fi;
                unset NVM_TOOL_VERSION;
            done;
            unset TEST_TOOLS ADD_TEST_TOOLS;
            local NVM_DEBUG_OUTPUT;
            for NVM_DEBUG_COMMAND in 'nvm current' 'which node' 'which iojs' 'which npm' 'npm config get prefix' 'npm root -g';
            do
                NVM_DEBUG_OUTPUT="$(${NVM_DEBUG_COMMAND} 2>&1)";
                nvm_err "${NVM_DEBUG_COMMAND}: $(nvm_sanitize_path "${NVM_DEBUG_OUTPUT}")";
            done;
            return 42
        ;;
        "install" | "i")
            local version_not_provided;
            version_not_provided=0;
            local NVM_OS;
            NVM_OS="$(nvm_get_os)";
            if ! nvm_has "curl" && ! nvm_has "wget"; then
                nvm_err 'nvm needs curl or wget to proceed.';
                return 1;
            fi;
            if [ $# -lt 1 ]; then
                version_not_provided=1;
            fi;
            local nobinary;
            local nosource;
            local noprogress;
            nobinary=0;
            noprogress=0;
            nosource=0;
            local LTS;
            local ALIAS;
            local NVM_UPGRADE_NPM;
            NVM_UPGRADE_NPM=0;
            local NVM_WRITE_TO_NVMRC;
            NVM_WRITE_TO_NVMRC=0;
            local PROVIDED_REINSTALL_PACKAGES_FROM;
            local REINSTALL_PACKAGES_FROM;
            local SKIP_DEFAULT_PACKAGES;
            while [ $# -ne 0 ]; do
                case "$1" in 
                    ---*)
                        nvm_err 'arguments with `---` are not supported - this is likely a typo';
                        return 55
                    ;;
                    -s)
                        shift;
                        nobinary=1;
                        if [ $nosource -eq 1 ]; then
                            nvm err '-s and -b cannot be set together since they would skip install from both binary and source';
                            return 6;
                        fi
                    ;;
                    -b)
                        shift;
                        nosource=1;
                        if [ $nobinary -eq 1 ]; then
                            nvm err '-s and -b cannot be set together since they would skip install from both binary and source';
                            return 6;
                        fi
                    ;;
                    -j)
                        shift;
                        nvm_get_make_jobs "$1";
                        shift
                    ;;
                    --no-progress)
                        noprogress=1;
                        shift
                    ;;
                    --lts)
                        LTS='*';
                        shift
                    ;;
                    --lts=*)
                        LTS="${1##--lts=}";
                        shift
                    ;;
                    --latest-npm)
                        NVM_UPGRADE_NPM=1;
                        shift
                    ;;
                    --default)
                        if [ -n "${ALIAS-}" ]; then
                            nvm_err '--default and --alias are mutually exclusive, and may not be provided more than once';
                            return 6;
                        fi;
                        ALIAS='default';
                        shift
                    ;;
                    --alias=*)
                        if [ -n "${ALIAS-}" ]; then
                            nvm_err '--default and --alias are mutually exclusive, and may not be provided more than once';
                            return 6;
                        fi;
                        ALIAS="${1##--alias=}";
                        shift
                    ;;
                    --reinstall-packages-from=*)
                        if [ -n "${PROVIDED_REINSTALL_PACKAGES_FROM-}" ]; then
                            nvm_err '--reinstall-packages-from may not be provided more than once';
                            return 6;
                        fi;
                        PROVIDED_REINSTALL_PACKAGES_FROM="$(nvm_echo "$1" | command cut -c 27-)";
                        if [ -z "${PROVIDED_REINSTALL_PACKAGES_FROM}" ]; then
                            nvm_err 'If --reinstall-packages-from is provided, it must point to an installed version of node.';
                            return 6;
                        fi;
                        REINSTALL_PACKAGES_FROM="$(nvm_version "${PROVIDED_REINSTALL_PACKAGES_FROM}")" || :;
                        shift
                    ;;
                    --copy-packages-from=*)
                        if [ -n "${PROVIDED_REINSTALL_PACKAGES_FROM-}" ]; then
                            nvm_err '--reinstall-packages-from may not be provided more than once, or combined with `--copy-packages-from`';
                            return 6;
                        fi;
                        PROVIDED_REINSTALL_PACKAGES_FROM="$(nvm_echo "$1" | command cut -c 22-)";
                        if [ -z "${PROVIDED_REINSTALL_PACKAGES_FROM}" ]; then
                            nvm_err 'If --copy-packages-from is provided, it must point to an installed version of node.';
                            return 6;
                        fi;
                        REINSTALL_PACKAGES_FROM="$(nvm_version "${PROVIDED_REINSTALL_PACKAGES_FROM}")" || :;
                        shift
                    ;;
                    --reinstall-packages-from | --copy-packages-from)
                        nvm_err "If ${1} is provided, it must point to an installed version of node using \`=\`.";
                        return 6
                    ;;
                    --skip-default-packages)
                        SKIP_DEFAULT_PACKAGES=true;
                        shift
                    ;;
                    --save | -w)
                        if [ $NVM_WRITE_TO_NVMRC -eq 1 ]; then
                            nvm_err '--save and -w may only be provided once';
                            return 6;
                        fi;
                        NVM_WRITE_TO_NVMRC=1;
                        shift
                    ;;
                    *)
                        break
                    ;;
                esac;
            done;
            local provided_version;
            provided_version="${1-}";
            if [ -z "${provided_version}" ]; then
                if [ "_${LTS-}" = '_*' ]; then
                    nvm_echo 'Installing latest LTS version.';
                    if [ $# -gt 0 ]; then
                        shift;
                    fi;
                else
                    if [ "_${LTS-}" != '_' ]; then
                        nvm_echo "Installing with latest version of LTS line: ${LTS}";
                        if [ $# -gt 0 ]; then
                            shift;
                        fi;
                    else
                        nvm_rc_version;
                        if [ $version_not_provided -eq 1 ] && [ -z "${NVM_RC_VERSION}" ]; then
                            unset NVM_RC_VERSION;
                            nvm --help 1>&2;
                            return 127;
                        fi;
                        provided_version="${NVM_RC_VERSION}";
                        unset NVM_RC_VERSION;
                    fi;
                fi;
            else
                if [ $# -gt 0 ]; then
                    shift;
                fi;
            fi;
            case "${provided_version}" in 
                'lts/*')
                    LTS='*';
                    provided_version=''
                ;;
                lts/*)
                    LTS="${provided_version##lts/}";
                    provided_version=''
                ;;
            esac;
            local EXIT_CODE;
            VERSION="$(NVM_VERSION_ONLY=true NVM_LTS="${LTS-}" nvm_remote_version "${provided_version}")";
            EXIT_CODE="$?";
            if [ "${VERSION}" = 'N/A' ] || [ $EXIT_CODE -ne 0 ]; then
                local LTS_MSG;
                local REMOTE_CMD;
                if [ "${LTS-}" = '*' ]; then
                    LTS_MSG='(with LTS filter) ';
                    REMOTE_CMD='nvm ls-remote --lts';
                else
                    if [ -n "${LTS-}" ]; then
                        LTS_MSG="(with LTS filter '${LTS}') ";
                        REMOTE_CMD="nvm ls-remote --lts=${LTS}";
                        if [ -z "${provided_version}" ]; then
                            nvm_err "Version with LTS filter '${LTS}' not found - try \`${REMOTE_CMD}\` to browse available versions.";
                            return 3;
                        fi;
                    else
                        REMOTE_CMD='nvm ls-remote';
                    fi;
                fi;
                nvm_err "Version '${provided_version}' ${LTS_MSG-}not found - try \`${REMOTE_CMD}\` to browse available versions.";
                return 3;
            fi;
            ADDITIONAL_PARAMETERS='';
            while [ $# -ne 0 ]; do
                case "$1" in 
                    --reinstall-packages-from=*)
                        if [ -n "${PROVIDED_REINSTALL_PACKAGES_FROM-}" ]; then
                            nvm_err '--reinstall-packages-from may not be provided more than once';
                            return 6;
                        fi;
                        PROVIDED_REINSTALL_PACKAGES_FROM="$(nvm_echo "$1" | command cut -c 27-)";
                        if [ -z "${PROVIDED_REINSTALL_PACKAGES_FROM}" ]; then
                            nvm_err 'If --reinstall-packages-from is provided, it must point to an installed version of node.';
                            return 6;
                        fi;
                        REINSTALL_PACKAGES_FROM="$(nvm_version "${PROVIDED_REINSTALL_PACKAGES_FROM}")" || :
                    ;;
                    --copy-packages-from=*)
                        if [ -n "${PROVIDED_REINSTALL_PACKAGES_FROM-}" ]; then
                            nvm_err '--reinstall-packages-from may not be provided more than once, or combined with `--copy-packages-from`';
                            return 6;
                        fi;
                        PROVIDED_REINSTALL_PACKAGES_FROM="$(nvm_echo "$1" | command cut -c 22-)";
                        if [ -z "${PROVIDED_REINSTALL_PACKAGES_FROM}" ]; then
                            nvm_err 'If --copy-packages-from is provided, it must point to an installed version of node.';
                            return 6;
                        fi;
                        REINSTALL_PACKAGES_FROM="$(nvm_version "${PROVIDED_REINSTALL_PACKAGES_FROM}")" || :
                    ;;
                    --reinstall-packages-from | --copy-packages-from)
                        nvm_err "If ${1} is provided, it must point to an installed version of node using \`=\`.";
                        return 6
                    ;;
                    --skip-default-packages)
                        SKIP_DEFAULT_PACKAGES=true
                    ;;
                    *)
                        ADDITIONAL_PARAMETERS="${ADDITIONAL_PARAMETERS} $1"
                    ;;
                esac;
                shift;
            done;
            if [ -n "${PROVIDED_REINSTALL_PACKAGES_FROM-}" ] && [ "$(nvm_ensure_version_prefix "${PROVIDED_REINSTALL_PACKAGES_FROM}")" = "${VERSION}" ]; then
                nvm_err "You can't reinstall global packages from the same version of node you're installing.";
                return 4;
            else
                if [ "${REINSTALL_PACKAGES_FROM-}" = 'N/A' ]; then
                    nvm_err "If --reinstall-packages-from is provided, it must point to an installed version of node.";
                    return 5;
                fi;
            fi;
            local FLAVOR;
            if nvm_is_iojs_version "${VERSION}"; then
                FLAVOR="$(nvm_iojs_prefix)";
            else
                FLAVOR="$(nvm_node_prefix)";
            fi;
            EXIT_CODE=0;
            if nvm_is_version_installed "${VERSION}"; then
                nvm_err "${VERSION} is already installed.";
                nvm use "${VERSION}";
                EXIT_CODE=$?;
                if [ $EXIT_CODE -eq 0 ]; then
                    if [ "${NVM_UPGRADE_NPM}" = 1 ]; then
                        nvm install-latest-npm;
                        EXIT_CODE=$?;
                    fi;
                    if [ $EXIT_CODE -ne 0 ] && [ -z "${SKIP_DEFAULT_PACKAGES-}" ]; then
                        nvm_install_default_packages;
                    fi;
                    if [ $EXIT_CODE -ne 0 ] && [ -n "${REINSTALL_PACKAGES_FROM-}" ] && [ "_${REINSTALL_PACKAGES_FROM}" != "_N/A" ]; then
                        nvm reinstall-packages "${REINSTALL_PACKAGES_FROM}";
                        EXIT_CODE=$?;
                    fi;
                fi;
                if [ -n "${LTS-}" ]; then
                    LTS="$(echo "${LTS}" | tr '[:upper:]' '[:lower:]')";
                    nvm_ensure_default_set "lts/${LTS}";
                else
                    nvm_ensure_default_set "${provided_version}";
                fi;
                if [ $NVM_WRITE_TO_NVMRC -eq 1 ]; then
                    nvm_write_nvmrc "${VERSION}";
                    EXIT_CODE=$?;
                fi;
                if [ $EXIT_CODE -ne 0 ] && [ -n "${ALIAS-}" ]; then
                    nvm alias "${ALIAS}" "${provided_version}";
                    EXIT_CODE=$?;
                fi;
                return $EXIT_CODE;
            fi;
            if [ -n "${NVM_INSTALL_THIRD_PARTY_HOOK-}" ]; then
                nvm_err '** $NVM_INSTALL_THIRD_PARTY_HOOK env var set; dispatching to third-party installation method **';
                local NVM_METHOD_PREFERENCE;
                NVM_METHOD_PREFERENCE='binary';
                if [ $nobinary -eq 1 ]; then
                    NVM_METHOD_PREFERENCE='source';
                fi;
                local VERSION_PATH;
                VERSION_PATH="$(nvm_version_path "${VERSION}")";
                "${NVM_INSTALL_THIRD_PARTY_HOOK}" "${VERSION}" "${FLAVOR}" std "${NVM_METHOD_PREFERENCE}" "${VERSION_PATH}" || { 
                    EXIT_CODE=$?;
                    nvm_err '*** Third-party $NVM_INSTALL_THIRD_PARTY_HOOK env var failed to install! ***';
                    return $EXIT_CODE
                };
                if ! nvm_is_version_installed "${VERSION}"; then
                    nvm_err '*** Third-party $NVM_INSTALL_THIRD_PARTY_HOOK env var claimed to succeed, but failed to install! ***';
                    return 33;
                fi;
                EXIT_CODE=0;
            else
                if [ "_${NVM_OS}" = "_freebsd" ]; then
                    nobinary=1;
                    nvm_err "Currently, there is no binary for FreeBSD";
                else
                    if [ "_$NVM_OS" = "_openbsd" ]; then
                        nobinary=1;
                        nvm_err "Currently, there is no binary for OpenBSD";
                    else
                        if [ "_${NVM_OS}" = "_sunos" ]; then
                            if ! nvm_has_solaris_binary "${VERSION}"; then
                                nobinary=1;
                                nvm_err "Currently, there is no binary of version ${VERSION} for SunOS";
                            fi;
                        fi;
                    fi;
                fi;
                if [ $nobinary -ne 1 ] && nvm_binary_available "${VERSION}"; then
                    NVM_NO_PROGRESS="${NVM_NO_PROGRESS:-${noprogress}}" nvm_install_binary "${FLAVOR}" std "${VERSION}" "${nosource}";
                    EXIT_CODE=$?;
                else
                    EXIT_CODE=-1;
                    if [ $nosource -eq 1 ]; then
                        nvm_err "Binary download is not available for ${VERSION}";
                        EXIT_CODE=3;
                    fi;
                fi;
                if [ $EXIT_CODE -ne 0 ] && [ $nosource -ne 1 ]; then
                    if [ -z "${NVM_MAKE_JOBS-}" ]; then
                        nvm_get_make_jobs;
                    fi;
                    if [ "_${NVM_OS}" = "_win" ]; then
                        nvm_err 'Installing from source on non-WSL Windows is not supported';
                        EXIT_CODE=87;
                    else
                        NVM_NO_PROGRESS="${NVM_NO_PROGRESS:-${noprogress}}" nvm_install_source "${FLAVOR}" std "${VERSION}" "${NVM_MAKE_JOBS}" "${ADDITIONAL_PARAMETERS}";
                        EXIT_CODE=$?;
                    fi;
                fi;
            fi;
            if [ $EXIT_CODE -eq 0 ]; then
                if nvm_use_if_needed "${VERSION}" && nvm_install_npm_if_needed "${VERSION}"; then
                    if [ -n "${LTS-}" ]; then
                        nvm_ensure_default_set "lts/${LTS}";
                    else
                        nvm_ensure_default_set "${provided_version}";
                    fi;
                    if [ "${NVM_UPGRADE_NPM}" = 1 ]; then
                        nvm install-latest-npm;
                        EXIT_CODE=$?;
                    fi;
                    if [ $EXIT_CODE -eq 0 ] && [ -z "${SKIP_DEFAULT_PACKAGES-}" ]; then
                        nvm_install_default_packages;
                    fi;
                    if [ $EXIT_CODE -eq 0 ] && [ -n "${REINSTALL_PACKAGES_FROM-}" ] && [ "_${REINSTALL_PACKAGES_FROM}" != "_N/A" ]; then
                        nvm reinstall-packages "${REINSTALL_PACKAGES_FROM}";
                        EXIT_CODE=$?;
                    fi;
                else
                    EXIT_CODE=$?;
                fi;
            fi;
            return $EXIT_CODE
        ;;
        "uninstall")
            if [ $# -ne 1 ]; then
                nvm --help 1>&2;
                return 127;
            fi;
            local PATTERN;
            PATTERN="${1-}";
            case "${PATTERN-}" in 
                --)

                ;;
                --lts | 'lts/*')
                    VERSION="$(nvm_match_version "lts/*")"
                ;;
                lts/*)
                    VERSION="$(nvm_match_version "lts/${PATTERN##lts/}")"
                ;;
                --lts=*)
                    VERSION="$(nvm_match_version "lts/${PATTERN##--lts=}")"
                ;;
                *)
                    VERSION="$(nvm_version "${PATTERN}")"
                ;;
            esac;
            if [ "_${VERSION}" = "_$(nvm_ls_current)" ]; then
                if nvm_is_iojs_version "${VERSION}"; then
                    nvm_err "nvm: Cannot uninstall currently-active io.js version, ${VERSION} (inferred from ${PATTERN}).";
                else
                    nvm_err "nvm: Cannot uninstall currently-active node version, ${VERSION} (inferred from ${PATTERN}).";
                fi;
                return 1;
            fi;
            if ! nvm_is_version_installed "${VERSION}"; then
                nvm_err "${VERSION} version is not installed...";
                return;
            fi;
            local SLUG_BINARY;
            local SLUG_SOURCE;
            if nvm_is_iojs_version "${VERSION}"; then
                SLUG_BINARY="$(nvm_get_download_slug iojs binary std "${VERSION}")";
                SLUG_SOURCE="$(nvm_get_download_slug iojs source std "${VERSION}")";
            else
                SLUG_BINARY="$(nvm_get_download_slug node binary std "${VERSION}")";
                SLUG_SOURCE="$(nvm_get_download_slug node source std "${VERSION}")";
            fi;
            local NVM_SUCCESS_MSG;
            if nvm_is_iojs_version "${VERSION}"; then
                NVM_SUCCESS_MSG="Uninstalled io.js $(nvm_strip_iojs_prefix "${VERSION}")";
            else
                NVM_SUCCESS_MSG="Uninstalled node ${VERSION}";
            fi;
            local VERSION_PATH;
            VERSION_PATH="$(nvm_version_path "${VERSION}")";
            if ! nvm_check_file_permissions "${VERSION_PATH}"; then
                nvm_err 'Cannot uninstall, incorrect permissions on installation folder.';
                nvm_err 'This is usually caused by running `npm install -g` as root. Run the following commands as root to fix the permissions and then try again.';
                nvm_err;
                nvm_err "  chown -R $(whoami) \"$(nvm_sanitize_path "${VERSION_PATH}")\"";
                nvm_err "  chmod -R u+w \"$(nvm_sanitize_path "${VERSION_PATH}")\"";
                return 1;
            fi;
            local CACHE_DIR;
            CACHE_DIR="$(nvm_cache_dir)";
            command rm -rf "${CACHE_DIR}/bin/${SLUG_BINARY}/files" "${CACHE_DIR}/src/${SLUG_SOURCE}/files" "${VERSION_PATH}" 2> /dev/null;
            nvm_echo "${NVM_SUCCESS_MSG}";
            for ALIAS in $(nvm_grep -l "${VERSION}" "$(nvm_alias_path)/*" 2> /dev/null);
            do
                nvm unalias "$(command basename "${ALIAS}")";
            done
        ;;
        "deactivate")
            local NVM_SILENT;
            while [ $# -ne 0 ]; do
                case "${1}" in 
                    --silent)
                        NVM_SILENT=1
                    ;;
                    --)

                    ;;
                esac;
                shift;
            done;
            local NEWPATH;
            NEWPATH="$(nvm_strip_path "${PATH}" "/bin")";
            if [ "_${PATH}" = "_${NEWPATH}" ]; then
                if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                    nvm_err "Could not find ${NVM_DIR}/*/bin in \${PATH}";
                fi;
            else
                export PATH="${NEWPATH}";
                \hash -r;
                if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                    nvm_echo "${NVM_DIR}/*/bin removed from \${PATH}";
                fi;
            fi;
            if [ -n "${MANPATH-}" ]; then
                NEWPATH="$(nvm_strip_path "${MANPATH}" "/share/man")";
                if [ "_${MANPATH}" = "_${NEWPATH}" ]; then
                    if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                        nvm_err "Could not find ${NVM_DIR}/*/share/man in \${MANPATH}";
                    fi;
                else
                    export MANPATH="${NEWPATH}";
                    if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                        nvm_echo "${NVM_DIR}/*/share/man removed from \${MANPATH}";
                    fi;
                fi;
            fi;
            if [ -n "${NODE_PATH-}" ]; then
                NEWPATH="$(nvm_strip_path "${NODE_PATH}" "/lib/node_modules")";
                if [ "_${NODE_PATH}" != "_${NEWPATH}" ]; then
                    export NODE_PATH="${NEWPATH}";
                    if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                        nvm_echo "${NVM_DIR}/*/lib/node_modules removed from \${NODE_PATH}";
                    fi;
                fi;
            fi;
            unset NVM_BIN;
            unset NVM_INC
        ;;
        "use")
            local PROVIDED_VERSION;
            local NVM_SILENT;
            local NVM_SILENT_ARG;
            local NVM_DELETE_PREFIX;
            NVM_DELETE_PREFIX=0;
            local NVM_LTS;
            local IS_VERSION_FROM_NVMRC;
            IS_VERSION_FROM_NVMRC=0;
            local NVM_WRITE_TO_NVMRC;
            NVM_WRITE_TO_NVMRC=0;
            while [ $# -ne 0 ]; do
                case "$1" in 
                    --silent)
                        NVM_SILENT=1;
                        NVM_SILENT_ARG='--silent'
                    ;;
                    --delete-prefix)
                        NVM_DELETE_PREFIX=1
                    ;;
                    --)

                    ;;
                    --lts)
                        NVM_LTS='*'
                    ;;
                    --lts=*)
                        NVM_LTS="${1##--lts=}"
                    ;;
                    --save | -w)
                        if [ $NVM_WRITE_TO_NVMRC -eq 1 ]; then
                            nvm_err '--save and -w may only be provided once';
                            return 6;
                        fi;
                        NVM_WRITE_TO_NVMRC=1
                    ;;
                    --*)

                    ;;
                    *)
                        if [ -n "${1-}" ]; then
                            PROVIDED_VERSION="$1";
                        fi
                    ;;
                esac;
                shift;
            done;
            if [ -n "${NVM_LTS-}" ]; then
                VERSION="$(nvm_match_version "lts/${NVM_LTS:-*}")";
            else
                if [ -z "${PROVIDED_VERSION-}" ]; then
                    NVM_SILENT="${NVM_SILENT:-0}" nvm_rc_version;
                    if [ -n "${NVM_RC_VERSION-}" ]; then
                        PROVIDED_VERSION="${NVM_RC_VERSION}";
                        IS_VERSION_FROM_NVMRC=1;
                        VERSION="$(nvm_version "${PROVIDED_VERSION}")";
                    fi;
                    unset NVM_RC_VERSION;
                    if [ -z "${VERSION}" ]; then
                        nvm_err 'Please see `nvm --help` or https://github.com/nvm-sh/nvm#nvmrc for more information.';
                        return 127;
                    fi;
                else
                    VERSION="$(nvm_match_version "${PROVIDED_VERSION}")";
                fi;
            fi;
            if [ -z "${VERSION}" ]; then
                nvm --help 1>&2;
                return 127;
            fi;
            if [ $NVM_WRITE_TO_NVMRC -eq 1 ]; then
                nvm_write_nvmrc "${VERSION}";
            fi;
            if [ "_${VERSION}" = '_system' ]; then
                if nvm_has_system_node && nvm deactivate "${NVM_SILENT_ARG-}" > /dev/null 2>&1; then
                    if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                        nvm_echo "Now using system version of node: $(node -v 2> /dev/null)$(nvm_print_npm_version)";
                    fi;
                    return;
                else
                    if nvm_has_system_iojs && nvm deactivate "${NVM_SILENT_ARG-}" > /dev/null 2>&1; then
                        if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                            nvm_echo "Now using system version of io.js: $(iojs --version 2> /dev/null)$(nvm_print_npm_version)";
                        fi;
                        return;
                    else
                        if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                            nvm_err 'System version of node not found.';
                        fi;
                    fi;
                fi;
                return 127;
            else
                if [ "_${VERSION}" = '_∞' ]; then
                    if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                        nvm_err "The alias \"${PROVIDED_VERSION}\" leads to an infinite loop. Aborting.";
                    fi;
                    return 8;
                fi;
            fi;
            if [ "${VERSION}" = 'N/A' ]; then
                if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                    nvm_ensure_version_installed "${PROVIDED_VERSION}" "${IS_VERSION_FROM_NVMRC}";
                fi;
                return 3;
            else
                if ! nvm_ensure_version_installed "${VERSION}" "${IS_VERSION_FROM_NVMRC}"; then
                    return $?;
                fi;
            fi;
            local NVM_VERSION_DIR;
            NVM_VERSION_DIR="$(nvm_version_path "${VERSION}")";
            PATH="$(nvm_change_path "${PATH}" "/bin" "${NVM_VERSION_DIR}")";
            if nvm_has manpath; then
                if [ -z "${MANPATH-}" ]; then
                    local MANPATH;
                    MANPATH=$(manpath);
                fi;
                MANPATH="$(nvm_change_path "${MANPATH}" "/share/man" "${NVM_VERSION_DIR}")";
                export MANPATH;
            fi;
            export PATH;
            \hash -r;
            export NVM_BIN="${NVM_VERSION_DIR}/bin";
            export NVM_INC="${NVM_VERSION_DIR}/include/node";
            if [ "${NVM_SYMLINK_CURRENT-}" = true ]; then
                command rm -f "${NVM_DIR}/current" && ln -s "${NVM_VERSION_DIR}" "${NVM_DIR}/current";
            fi;
            local NVM_USE_OUTPUT;
            NVM_USE_OUTPUT='';
            if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                if nvm_is_iojs_version "${VERSION}"; then
                    NVM_USE_OUTPUT="Now using io.js $(nvm_strip_iojs_prefix "${VERSION}")$(nvm_print_npm_version)";
                else
                    NVM_USE_OUTPUT="Now using node ${VERSION}$(nvm_print_npm_version)";
                fi;
            fi;
            if [ "_${VERSION}" != "_system" ]; then
                local NVM_USE_CMD;
                NVM_USE_CMD="nvm use --delete-prefix";
                if [ -n "${PROVIDED_VERSION}" ]; then
                    NVM_USE_CMD="${NVM_USE_CMD} ${VERSION}";
                fi;
                if [ "${NVM_SILENT:-0}" -eq 1 ]; then
                    NVM_USE_CMD="${NVM_USE_CMD} --silent";
                fi;
                if ! nvm_die_on_prefix "${NVM_DELETE_PREFIX}" "${NVM_USE_CMD}" "${NVM_VERSION_DIR}"; then
                    return 11;
                fi;
            fi;
            if [ -n "${NVM_USE_OUTPUT-}" ] && [ "${NVM_SILENT:-0}" -ne 1 ]; then
                nvm_echo "${NVM_USE_OUTPUT}";
            fi
        ;;
        "run")
            local provided_version;
            local has_checked_nvmrc;
            has_checked_nvmrc=0;
            local IS_VERSION_FROM_NVMRC;
            IS_VERSION_FROM_NVMRC=0;
            local NVM_SILENT;
            local NVM_SILENT_ARG;
            local NVM_LTS;
            while [ $# -gt 0 ]; do
                case "$1" in 
                    --silent)
                        NVM_SILENT=1;
                        NVM_SILENT_ARG='--silent';
                        shift
                    ;;
                    --lts)
                        NVM_LTS='*';
                        shift
                    ;;
                    --lts=*)
                        NVM_LTS="${1##--lts=}";
                        shift
                    ;;
                    *)
                        if [ -n "$1" ]; then
                            break;
                        else
                            shift;
                        fi
                    ;;
                esac;
            done;
            if [ $# -lt 1 ] && [ -z "${NVM_LTS-}" ]; then
                NVM_SILENT="${NVM_SILENT:-0}" nvm_rc_version && has_checked_nvmrc=1;
                if [ -n "${NVM_RC_VERSION-}" ]; then
                    VERSION="$(nvm_version "${NVM_RC_VERSION-}")" || :;
                fi;
                unset NVM_RC_VERSION;
                if [ "${VERSION:-N/A}" = 'N/A' ]; then
                    nvm --help 1>&2;
                    return 127;
                fi;
            fi;
            if [ -z "${NVM_LTS-}" ]; then
                provided_version="$1";
                if [ -n "${provided_version}" ]; then
                    VERSION="$(nvm_version "${provided_version}")" || :;
                    if [ "_${VERSION:-N/A}" = '_N/A' ] && ! nvm_is_valid_version "${provided_version}"; then
                        provided_version='';
                        if [ $has_checked_nvmrc -ne 1 ]; then
                            NVM_SILENT="${NVM_SILENT:-0}" nvm_rc_version && has_checked_nvmrc=1;
                        fi;
                        provided_version="${NVM_RC_VERSION}";
                        IS_VERSION_FROM_NVMRC=1;
                        VERSION="$(nvm_version "${NVM_RC_VERSION}")" || :;
                        unset NVM_RC_VERSION;
                    else
                        shift;
                    fi;
                fi;
            fi;
            local NVM_IOJS;
            if nvm_is_iojs_version "${VERSION}"; then
                NVM_IOJS=true;
            fi;
            local EXIT_CODE;
            nvm_is_zsh && setopt local_options shwordsplit;
            local LTS_ARG;
            if [ -n "${NVM_LTS-}" ]; then
                LTS_ARG="--lts=${NVM_LTS-}";
                VERSION='';
            fi;
            if [ "_${VERSION}" = "_N/A" ]; then
                nvm_ensure_version_installed "${provided_version}" "${IS_VERSION_FROM_NVMRC}";
            else
                if [ "${NVM_IOJS}" = true ]; then
                    nvm exec "${NVM_SILENT_ARG-}" "${LTS_ARG-}" "${VERSION}" iojs "$@";
                else
                    nvm exec "${NVM_SILENT_ARG-}" "${LTS_ARG-}" "${VERSION}" node "$@";
                fi;
            fi;
            EXIT_CODE="$?";
            return $EXIT_CODE
        ;;
        "exec")
            local NVM_SILENT;
            local NVM_LTS;
            while [ $# -gt 0 ]; do
                case "$1" in 
                    --silent)
                        NVM_SILENT=1;
                        shift
                    ;;
                    --lts)
                        NVM_LTS='*';
                        shift
                    ;;
                    --lts=*)
                        NVM_LTS="${1##--lts=}";
                        shift
                    ;;
                    --)
                        break
                    ;;
                    --*)
                        nvm_err "Unsupported option \"$1\".";
                        return 55
                    ;;
                    *)
                        if [ -n "$1" ]; then
                            break;
                        else
                            shift;
                        fi
                    ;;
                esac;
            done;
            local provided_version;
            provided_version="$1";
            if [ "${NVM_LTS-}" != '' ]; then
                provided_version="lts/${NVM_LTS:-*}";
                VERSION="${provided_version}";
            else
                if [ -n "${provided_version}" ]; then
                    VERSION="$(nvm_version "${provided_version}")" || :;
                    if [ "_${VERSION}" = '_N/A' ] && ! nvm_is_valid_version "${provided_version}"; then
                        NVM_SILENT="${NVM_SILENT:-0}" nvm_rc_version && has_checked_nvmrc=1;
                        provided_version="${NVM_RC_VERSION}";
                        unset NVM_RC_VERSION;
                        VERSION="$(nvm_version "${provided_version}")" || :;
                    else
                        shift;
                    fi;
                fi;
            fi;
            nvm_ensure_version_installed "${provided_version}";
            EXIT_CODE=$?;
            if [ "${EXIT_CODE}" != "0" ]; then
                return $EXIT_CODE;
            fi;
            if [ "${NVM_SILENT:-0}" -ne 1 ]; then
                if [ "${NVM_LTS-}" = '*' ]; then
                    nvm_echo "Running node latest LTS -> $(nvm_version "${VERSION}")$(nvm use --silent "${VERSION}" && nvm_print_npm_version)";
                else
                    if [ -n "${NVM_LTS-}" ]; then
                        nvm_echo "Running node LTS \"${NVM_LTS-}\" -> $(nvm_version "${VERSION}")$(nvm use --silent "${VERSION}" && nvm_print_npm_version)";
                    else
                        if nvm_is_iojs_version "${VERSION}"; then
                            nvm_echo "Running io.js $(nvm_strip_iojs_prefix "${VERSION}")$(nvm use --silent "${VERSION}" && nvm_print_npm_version)";
                        else
                            nvm_echo "Running node ${VERSION}$(nvm use --silent "${VERSION}" && nvm_print_npm_version)";
                        fi;
                    fi;
                fi;
            fi;
            NODE_VERSION="${VERSION}" "${NVM_DIR}/nvm-exec" "$@"
        ;;
        "ls" | "list")
            local PATTERN;
            local NVM_NO_COLORS;
            local NVM_NO_ALIAS;
            while [ $# -gt 0 ]; do
                case "${1}" in 
                    --)

                    ;;
                    --no-colors)
                        NVM_NO_COLORS="${1}"
                    ;;
                    --no-alias)
                        NVM_NO_ALIAS="${1}"
                    ;;
                    --*)
                        nvm_err "Unsupported option \"${1}\".";
                        return 55
                    ;;
                    *)
                        PATTERN="${PATTERN:-$1}"
                    ;;
                esac;
                shift;
            done;
            if [ -n "${PATTERN-}" ] && [ -n "${NVM_NO_ALIAS-}" ]; then
                nvm_err '`--no-alias` is not supported when a pattern is provided.';
                return 55;
            fi;
            local NVM_LS_OUTPUT;
            local NVM_LS_EXIT_CODE;
            NVM_LS_OUTPUT=$(nvm_ls "${PATTERN-}");
            NVM_LS_EXIT_CODE=$?;
            NVM_NO_COLORS="${NVM_NO_COLORS-}" nvm_print_versions "${NVM_LS_OUTPUT}";
            if [ -z "${NVM_NO_ALIAS-}" ] && [ -z "${PATTERN-}" ]; then
                if [ -n "${NVM_NO_COLORS-}" ]; then
                    nvm alias --no-colors;
                else
                    nvm alias;
                fi;
            fi;
            return $NVM_LS_EXIT_CODE
        ;;
        "ls-remote" | "list-remote")
            local NVM_LTS;
            local PATTERN;
            local NVM_NO_COLORS;
            while [ $# -gt 0 ]; do
                case "${1-}" in 
                    --)

                    ;;
                    --lts)
                        NVM_LTS='*'
                    ;;
                    --lts=*)
                        NVM_LTS="${1##--lts=}"
                    ;;
                    --no-colors)
                        NVM_NO_COLORS="${1}"
                    ;;
                    --*)
                        nvm_err "Unsupported option \"${1}\".";
                        return 55
                    ;;
                    *)
                        if [ -z "${PATTERN-}" ]; then
                            PATTERN="${1-}";
                            if [ -z "${NVM_LTS-}" ]; then
                                case "${PATTERN}" in 
                                    'lts/*')
                                        NVM_LTS='*';
                                        PATTERN=''
                                    ;;
                                    lts/*)
                                        NVM_LTS="${PATTERN##lts/}";
                                        PATTERN=''
                                    ;;
                                esac;
                            fi;
                        fi
                    ;;
                esac;
                shift;
            done;
            local NVM_OUTPUT;
            local EXIT_CODE;
            NVM_OUTPUT="$(NVM_LTS="${NVM_LTS-}" nvm_remote_versions "${PATTERN}" && :)";
            EXIT_CODE=$?;
            if [ -n "${NVM_OUTPUT}" ]; then
                NVM_NO_COLORS="${NVM_NO_COLORS-}" nvm_print_versions "${NVM_OUTPUT}";
                return $EXIT_CODE;
            fi;
            NVM_NO_COLORS="${NVM_NO_COLORS-}" nvm_print_versions "N/A";
            return 3
        ;;
        "current")
            nvm_version current
        ;;
        "which")
            local NVM_SILENT;
            local provided_version;
            while [ $# -ne 0 ]; do
                case "${1}" in 
                    --silent)
                        NVM_SILENT=1
                    ;;
                    --)

                    ;;
                    *)
                        provided_version="${1-}"
                    ;;
                esac;
                shift;
            done;
            if [ -z "${provided_version-}" ]; then
                NVM_SILENT="${NVM_SILENT:-0}" nvm_rc_version;
                if [ -n "${NVM_RC_VERSION}" ]; then
                    provided_version="${NVM_RC_VERSION}";
                    VERSION=$(nvm_version "${NVM_RC_VERSION}") || :;
                fi;
                unset NVM_RC_VERSION;
            else
                if [ "${provided_version}" != 'system' ]; then
                    VERSION="$(nvm_version "${provided_version}")" || :;
                else
                    VERSION="${provided_version-}";
                fi;
            fi;
            if [ -z "${VERSION}" ]; then
                nvm --help 1>&2;
                return 127;
            fi;
            if [ "_${VERSION}" = '_system' ]; then
                if nvm_has_system_iojs > /dev/null 2>&1 || nvm_has_system_node > /dev/null 2>&1; then
                    local NVM_BIN;
                    NVM_BIN="$(nvm use system > /dev/null 2>&1 && command which node)";
                    if [ -n "${NVM_BIN}" ]; then
                        nvm_echo "${NVM_BIN}";
                        return;
                    fi;
                    return 1;
                fi;
                nvm_err 'System version of node not found.';
                return 127;
            else
                if [ "${VERSION}" = '∞' ]; then
                    nvm_err "The alias \"${2}\" leads to an infinite loop. Aborting.";
                    return 8;
                fi;
            fi;
            nvm_ensure_version_installed "${provided_version}";
            EXIT_CODE=$?;
            if [ "${EXIT_CODE}" != "0" ]; then
                return $EXIT_CODE;
            fi;
            local NVM_VERSION_DIR;
            NVM_VERSION_DIR="$(nvm_version_path "${VERSION}")";
            nvm_echo "${NVM_VERSION_DIR}/bin/node"
        ;;
        "alias")
            local NVM_ALIAS_DIR;
            NVM_ALIAS_DIR="$(nvm_alias_path)";
            local NVM_CURRENT;
            NVM_CURRENT="$(nvm_ls_current)";
            command mkdir -p "${NVM_ALIAS_DIR}/lts";
            local ALIAS;
            local TARGET;
            local NVM_NO_COLORS;
            ALIAS='--';
            TARGET='--';
            while [ $# -gt 0 ]; do
                case "${1-}" in 
                    --)

                    ;;
                    --no-colors)
                        NVM_NO_COLORS="${1}"
                    ;;
                    --*)
                        nvm_err "Unsupported option \"${1}\".";
                        return 55
                    ;;
                    *)
                        if [ "${ALIAS}" = '--' ]; then
                            ALIAS="${1-}";
                        else
                            if [ "${TARGET}" = '--' ]; then
                                TARGET="${1-}";
                            fi;
                        fi
                    ;;
                esac;
                shift;
            done;
            if [ -z "${TARGET}" ]; then
                nvm unalias "${ALIAS}";
                return $?;
            else
                if echo "${ALIAS}" | grep --color=auto -q "#"; then
                    nvm_err 'Aliases with a comment delimiter (#) are not supported.';
                    return 1;
                else
                    if [ "${TARGET}" != '--' ]; then
                        if [ "${ALIAS#*\/}" != "${ALIAS}" ]; then
                            nvm_err 'Aliases in subdirectories are not supported.';
                            return 1;
                        fi;
                        VERSION="$(nvm_version "${TARGET}")" || :;
                        if [ "${VERSION}" = 'N/A' ]; then
                            nvm_err "! WARNING: Version '${TARGET}' does not exist.";
                        fi;
                        nvm_make_alias "${ALIAS}" "${TARGET}";
                        NVM_NO_COLORS="${NVM_NO_COLORS-}" NVM_CURRENT="${NVM_CURRENT-}" DEFAULT=false nvm_print_formatted_alias "${ALIAS}" "${TARGET}" "${VERSION}";
                    else
                        if [ "${ALIAS-}" = '--' ]; then
                            unset ALIAS;
                        fi;
                        nvm_list_aliases "${ALIAS-}";
                    fi;
                fi;
            fi
        ;;
        "unalias")
            local NVM_ALIAS_DIR;
            NVM_ALIAS_DIR="$(nvm_alias_path)";
            command mkdir -p "${NVM_ALIAS_DIR}";
            if [ $# -ne 1 ]; then
                nvm --help 1>&2;
                return 127;
            fi;
            if [ "${1#*\/}" != "${1-}" ]; then
                nvm_err 'Aliases in subdirectories are not supported.';
                return 1;
            fi;
            local NVM_IOJS_PREFIX;
            local NVM_NODE_PREFIX;
            NVM_IOJS_PREFIX="$(nvm_iojs_prefix)";
            NVM_NODE_PREFIX="$(nvm_node_prefix)";
            local NVM_ALIAS_EXISTS;
            NVM_ALIAS_EXISTS=0;
            if [ -f "${NVM_ALIAS_DIR}/${1-}" ]; then
                NVM_ALIAS_EXISTS=1;
            fi;
            if [ $NVM_ALIAS_EXISTS -eq 0 ]; then
                case "$1" in 
                    "stable" | "unstable" | "${NVM_IOJS_PREFIX}" | "${NVM_NODE_PREFIX}" | "system")
                        nvm_err "${1-} is a default (built-in) alias and cannot be deleted.";
                        return 1
                    ;;
                esac;
                nvm_err "Alias ${1-} doesn't exist!";
                return;
            fi;
            local NVM_ALIAS_ORIGINAL;
            NVM_ALIAS_ORIGINAL="$(nvm_alias "${1}")";
            command rm -f "${NVM_ALIAS_DIR}/${1}";
            nvm_echo "Deleted alias ${1} - restore it with \`nvm alias \"${1}\" \"${NVM_ALIAS_ORIGINAL}\"\`"
        ;;
        "install-latest-npm")
            if [ $# -ne 0 ]; then
                nvm --help 1>&2;
                return 127;
            fi;
            nvm_install_latest_npm
        ;;
        "reinstall-packages" | "copy-packages")
            if [ $# -ne 1 ]; then
                nvm --help 1>&2;
                return 127;
            fi;
            local PROVIDED_VERSION;
            PROVIDED_VERSION="${1-}";
            if [ "${PROVIDED_VERSION}" = "$(nvm_ls_current)" ] || [ "$(nvm_version "${PROVIDED_VERSION}" || :)" = "$(nvm_ls_current)" ]; then
                nvm_err 'Can not reinstall packages from the current version of node.';
                return 2;
            fi;
            local VERSION;
            if [ "_${PROVIDED_VERSION}" = "_system" ]; then
                if ! nvm_has_system_node && ! nvm_has_system_iojs; then
                    nvm_err 'No system version of node or io.js detected.';
                    return 3;
                fi;
                VERSION="system";
            else
                VERSION="$(nvm_version "${PROVIDED_VERSION}")" || :;
            fi;
            local NPMLIST;
            NPMLIST="$(nvm_npm_global_modules "${VERSION}")";
            local INSTALLS;
            local LINKS;
            INSTALLS="${NPMLIST%% //// *}";
            LINKS="${NPMLIST##* //// }";
            nvm_echo "Reinstalling global packages from ${VERSION}...";
            if [ -n "${INSTALLS}" ]; then
                nvm_echo "${INSTALLS}" | command xargs npm install -g --quiet;
            else
                nvm_echo "No installed global packages found...";
            fi;
            nvm_echo "Linking global packages from ${VERSION}...";
            if [ -n "${LINKS}" ]; then
                ( set -f;
                IFS='
';
                for LINK in ${LINKS};
                do
                    set +f;
                    unset IFS;
                    if [ -n "${LINK}" ]; then
                        case "${LINK}" in 
                            '/'*)
                                ( nvm_cd "${LINK}" && npm link )
                            ;;
                            *)
                                ( nvm_cd "$(npm root -g)/../${LINK}" && npm link )
                            ;;
                        esac;
                    fi;
                done );
            else
                nvm_echo "No linked global packages found...";
            fi
        ;;
        "clear-cache")
            command rm -f "${NVM_DIR}/v*" "$(nvm_version_dir)" 2> /dev/null;
            nvm_echo 'nvm cache cleared.'
        ;;
        "version")
            nvm_version "${1}"
        ;;
        "version-remote")
            local NVM_LTS;
            local PATTERN;
            while [ $# -gt 0 ]; do
                case "${1-}" in 
                    --)

                    ;;
                    --lts)
                        NVM_LTS='*'
                    ;;
                    --lts=*)
                        NVM_LTS="${1##--lts=}"
                    ;;
                    --*)
                        nvm_err "Unsupported option \"${1}\".";
                        return 55
                    ;;
                    *)
                        PATTERN="${PATTERN:-${1}}"
                    ;;
                esac;
                shift;
            done;
            case "${PATTERN-}" in 
                'lts/*')
                    NVM_LTS='*';
                    unset PATTERN
                ;;
                lts/*)
                    NVM_LTS="${PATTERN##lts/}";
                    unset PATTERN
                ;;
            esac;
            NVM_VERSION_ONLY=true NVM_LTS="${NVM_LTS-}" nvm_remote_version "${PATTERN:-node}"
        ;;
        "--version" | "-v")
            nvm_echo '0.40.2'
        ;;
        "unload")
            nvm deactivate > /dev/null 2>&1;
            unset -f nvm nvm_iojs_prefix nvm_node_prefix nvm_add_iojs_prefix nvm_strip_iojs_prefix nvm_is_iojs_version nvm_is_alias nvm_has_non_aliased nvm_ls_remote nvm_ls_remote_iojs nvm_ls_remote_index_tab nvm_ls nvm_remote_version nvm_remote_versions nvm_install_binary nvm_install_source nvm_clang_version nvm_get_mirror nvm_get_download_slug nvm_download_artifact nvm_install_npm_if_needed nvm_use_if_needed nvm_check_file_permissions nvm_print_versions nvm_compute_checksum nvm_get_checksum_binary nvm_get_checksum_alg nvm_get_checksum nvm_compare_checksum nvm_version nvm_rc_version nvm_match_version nvm_ensure_default_set nvm_get_arch nvm_get_os nvm_print_implicit_alias nvm_validate_implicit_alias nvm_resolve_alias nvm_ls_current nvm_alias nvm_binary_available nvm_change_path nvm_strip_path nvm_num_version_groups nvm_format_version nvm_ensure_version_prefix nvm_normalize_version nvm_is_valid_version nvm_normalize_lts nvm_ensure_version_installed nvm_cache_dir nvm_version_path nvm_alias_path nvm_version_dir nvm_find_nvmrc nvm_find_up nvm_find_project_dir nvm_tree_contains_path nvm_version_greater nvm_version_greater_than_or_equal_to nvm_print_npm_version nvm_install_latest_npm nvm_npm_global_modules nvm_has_system_node nvm_has_system_iojs nvm_download nvm_get_latest nvm_has nvm_install_default_packages nvm_get_default_packages nvm_curl_use_compression nvm_curl_version nvm_auto nvm_supports_xz nvm_echo nvm_err nvm_grep nvm_cd nvm_die_on_prefix nvm_get_make_jobs nvm_get_minor_version nvm_has_solaris_binary nvm_is_merged_node_version nvm_is_natural_num nvm_is_version_installed nvm_list_aliases nvm_make_alias nvm_print_alias_path nvm_print_default_alias nvm_print_formatted_alias nvm_resolve_local_alias nvm_sanitize_path nvm_has_colors nvm_process_parameters nvm_node_version_has_solaris_binary nvm_iojs_version_has_solaris_binary nvm_curl_libz_support nvm_command_info nvm_is_zsh nvm_stdout_is_terminal nvm_npmrc_bad_news_bears nvm_sanitize_auth_header nvm_get_colors nvm_set_colors nvm_print_color_code nvm_wrap_with_color_code nvm_format_help_message_colors nvm_echo_with_colors nvm_err_with_colors nvm_get_artifact_compression nvm_install_binary_extract nvm_extract_tarball nvm_process_nvmrc nvm_nvmrc_invalid_msg nvm_write_nvmrc > /dev/null 2>&1;
            unset NVM_RC_VERSION NVM_NODEJS_ORG_MIRROR NVM_IOJS_ORG_MIRROR NVM_DIR NVM_CD_FLAGS NVM_BIN NVM_INC NVM_MAKE_JOBS NVM_COLORS INSTALLED_COLOR SYSTEM_COLOR CURRENT_COLOR NOT_INSTALLED_COLOR DEFAULT_COLOR LTS_COLOR > /dev/null 2>&1
        ;;
        "set-colors")
            local EXIT_CODE;
            nvm_set_colors "${1-}";
            EXIT_CODE=$?;
            if [ "$EXIT_CODE" -eq 17 ]; then
                nvm --help 1>&2;
                nvm_echo;
                nvm_err_with_colors "\033[1;37mPlease pass in five \033[1;31mvalid color codes\033[1;37m. Choose from: rRgGbBcCyYmMkKeW\033[0m";
            fi
        ;;
        *)
            nvm --help 1>&2;
            return 127
        ;;
    esac
}
nvm_add_iojs_prefix () 
{ 
    nvm_echo "$(nvm_iojs_prefix)-$(nvm_ensure_version_prefix "$(nvm_strip_iojs_prefix "${1-}")")"
}
nvm_alias () 
{ 
    local ALIAS;
    ALIAS="${1-}";
    if [ -z "${ALIAS}" ]; then
        nvm_err 'An alias is required.';
        return 1;
    fi;
    if ! ALIAS="$(nvm_normalize_lts "${ALIAS}")"; then
        return $?;
    fi;
    if [ -z "${ALIAS}" ]; then
        return 2;
    fi;
    local NVM_ALIAS_PATH;
    NVM_ALIAS_PATH="$(nvm_alias_path)/${ALIAS}";
    if [ ! -f "${NVM_ALIAS_PATH}" ]; then
        nvm_err 'Alias does not exist.';
        return 2;
    fi;
    command awk 'NF' "${NVM_ALIAS_PATH}"
}
nvm_alias_path () 
{ 
    nvm_echo "$(nvm_version_dir old)/alias"
}
nvm_auto () 
{ 
    local NVM_MODE;
    NVM_MODE="${1-}";
    case "${NVM_MODE}" in 
        none)
            return 0
        ;;
        use)
            local VERSION;
            local NVM_CURRENT;
            NVM_CURRENT="$(nvm_ls_current)";
            if [ "_${NVM_CURRENT}" = '_none' ] || [ "_${NVM_CURRENT}" = '_system' ]; then
                VERSION="$(nvm_resolve_local_alias default 2> /dev/null || nvm_echo)";
                if [ -n "${VERSION}" ]; then
                    if [ "_${VERSION}" != '_N/A' ] && nvm_is_valid_version "${VERSION}"; then
                        nvm use --silent "${VERSION}" > /dev/null;
                    else
                        return 0;
                    fi;
                else
                    if nvm_rc_version > /dev/null 2>&1; then
                        nvm use --silent > /dev/null;
                    fi;
                fi;
            else
                nvm use --silent "${NVM_CURRENT}" > /dev/null;
            fi
        ;;
        install)
            local VERSION;
            VERSION="$(nvm_alias default 2> /dev/null || nvm_echo)";
            if [ -n "${VERSION}" ] && [ "_${VERSION}" != '_N/A' ] && nvm_is_valid_version "${VERSION}"; then
                nvm install "${VERSION}" > /dev/null;
            else
                if nvm_rc_version > /dev/null 2>&1; then
                    nvm install > /dev/null;
                else
                    return 0;
                fi;
            fi
        ;;
        *)
            nvm_err 'Invalid auto mode supplied.';
            return 1
        ;;
    esac
}
nvm_binary_available () 
{ 
    nvm_version_greater_than_or_equal_to "$(nvm_strip_iojs_prefix "${1-}")" v0.8.6
}
nvm_cache_dir () 
{ 
    nvm_echo "${NVM_DIR}/.cache"
}
nvm_cd () 
{ 
    \cd "$@"
}
nvm_change_path () 
{ 
    if [ -z "${1-}" ]; then
        nvm_echo "${3-}${2-}";
    else
        if ! nvm_echo "${1-}" | nvm_grep -q "${NVM_DIR}/[^/]*${2-}" && ! nvm_echo "${1-}" | nvm_grep -q "${NVM_DIR}/versions/[^/]*/[^/]*${2-}"; then
            nvm_echo "${3-}${2-}:${1-}";
        else
            if nvm_echo "${1-}" | nvm_grep -Eq "(^|:)(/usr(/local)?)?${2-}:.*${NVM_DIR}/[^/]*${2-}" || nvm_echo "${1-}" | nvm_grep -Eq "(^|:)(/usr(/local)?)?${2-}:.*${NVM_DIR}/versions/[^/]*/[^/]*${2-}"; then
                nvm_echo "${3-}${2-}:${1-}";
            else
                nvm_echo "${1-}" | command sed -e "s#${NVM_DIR}/[^/]*${2-}[^:]*#${3-}${2-}#" -e "s#${NVM_DIR}/versions/[^/]*/[^/]*${2-}[^:]*#${3-}${2-}#";
            fi;
        fi;
    fi
}
nvm_check_file_permissions () 
{ 
    nvm_is_zsh && setopt local_options nonomatch;
    for FILE in "$1"/* "$1"/.[!.]* "$1"/..?*;
    do
        if [ -d "$FILE" ]; then
            if [ -n "${NVM_DEBUG-}" ]; then
                nvm_err "${FILE}";
            fi;
            if [ ! -L "${FILE}" ] && ! nvm_check_file_permissions "${FILE}"; then
                return 2;
            fi;
        else
            if [ -e "$FILE" ] && [ ! -w "$FILE" ] && [ ! -O "$FILE" ]; then
                nvm_err "file is not writable or self-owned: $(nvm_sanitize_path "$FILE")";
                return 1;
            fi;
        fi;
    done;
    return 0
}
nvm_clang_version () 
{ 
    clang --version | command awk '{ if ($2 == "version") print $3; else if ($3 == "version") print $4 }' | command sed 's/-.*$//g'
}
nvm_command_info () 
{ 
    local COMMAND;
    local INFO;
    COMMAND="${1}";
    if type "${COMMAND}" | nvm_grep -q hashed; then
        INFO="$(type "${COMMAND}" | command sed -E 's/\(|\)//g' | command awk '{print $4}')";
    else
        if type "${COMMAND}" | nvm_grep -q aliased; then
            INFO="$(which "${COMMAND}") ($(type "${COMMAND}" | command awk '{ $1=$2=$3=$4="" ;print }' | command sed -e 's/^\ *//g' -Ee "s/\`|'//g"))";
        else
            if type "${COMMAND}" | nvm_grep -q "^${COMMAND} is an alias for"; then
                INFO="$(which "${COMMAND}") ($(type "${COMMAND}" | command awk '{ $1=$2=$3=$4=$5="" ;print }' | command sed 's/^\ *//g'))";
            else
                if type "${COMMAND}" | nvm_grep -q "^${COMMAND} is /"; then
                    INFO="$(type "${COMMAND}" | command awk '{print $3}')";
                else
                    INFO="$(type "${COMMAND}")";
                fi;
            fi;
        fi;
    fi;
    nvm_echo "${INFO}"
}
nvm_compare_checksum () 
{ 
    local FILE;
    FILE="${1-}";
    if [ -z "${FILE}" ]; then
        nvm_err 'Provided file to checksum is empty.';
        return 4;
    else
        if ! [ -f "${FILE}" ]; then
            nvm_err 'Provided file to checksum does not exist.';
            return 3;
        fi;
    fi;
    local COMPUTED_SUM;
    COMPUTED_SUM="$(nvm_compute_checksum "${FILE}")";
    local CHECKSUM;
    CHECKSUM="${2-}";
    if [ -z "${CHECKSUM}" ]; then
        nvm_err 'Provided checksum to compare to is empty.';
        return 2;
    fi;
    if [ -z "${COMPUTED_SUM}" ]; then
        nvm_err "Computed checksum of '${FILE}' is empty.";
        nvm_err 'WARNING: Continuing *without checksum verification*';
        return;
    else
        if [ "${COMPUTED_SUM}" != "${CHECKSUM}" ] && [ "${COMPUTED_SUM}" != "\\${CHECKSUM}" ]; then
            nvm_err "Checksums do not match: '${COMPUTED_SUM}' found, '${CHECKSUM}' expected.";
            return 1;
        fi;
    fi;
    nvm_err 'Checksums matched!'
}
nvm_compute_checksum () 
{ 
    local FILE;
    FILE="${1-}";
    if [ -z "${FILE}" ]; then
        nvm_err 'Provided file to checksum is empty.';
        return 2;
    else
        if ! [ -f "${FILE}" ]; then
            nvm_err 'Provided file to checksum does not exist.';
            return 1;
        fi;
    fi;
    if nvm_has_non_aliased "sha256sum"; then
        nvm_err 'Computing checksum with sha256sum';
        command sha256sum "${FILE}" | command awk '{print $1}';
    else
        if nvm_has_non_aliased "shasum"; then
            nvm_err 'Computing checksum with shasum -a 256';
            command shasum -a 256 "${FILE}" | command awk '{print $1}';
        else
            if nvm_has_non_aliased "sha256"; then
                nvm_err 'Computing checksum with sha256 -q';
                command sha256 -q "${FILE}" | command awk '{print $1}';
            else
                if nvm_has_non_aliased "gsha256sum"; then
                    nvm_err 'Computing checksum with gsha256sum';
                    command gsha256sum "${FILE}" | command awk '{print $1}';
                else
                    if nvm_has_non_aliased "openssl"; then
                        nvm_err 'Computing checksum with openssl dgst -sha256';
                        command openssl dgst -sha256 "${FILE}" | command awk '{print $NF}';
                    else
                        if nvm_has_non_aliased "bssl"; then
                            nvm_err 'Computing checksum with bssl sha256sum';
                            command bssl sha256sum "${FILE}" | command awk '{print $1}';
                        else
                            if nvm_has_non_aliased "sha1sum"; then
                                nvm_err 'Computing checksum with sha1sum';
                                command sha1sum "${FILE}" | command awk '{print $1}';
                            else
                                if nvm_has_non_aliased "sha1"; then
                                    nvm_err 'Computing checksum with sha1 -q';
                                    command sha1 -q "${FILE}";
                                fi;
                            fi;
                        fi;
                    fi;
                fi;
            fi;
        fi;
    fi
}
nvm_curl_libz_support () 
{ 
    curl -V 2> /dev/null | nvm_grep "^Features:" | nvm_grep -q "libz"
}
nvm_curl_use_compression () 
{ 
    nvm_curl_libz_support && nvm_version_greater_than_or_equal_to "$(nvm_curl_version)" 7.21.0
}
nvm_curl_version () 
{ 
    curl -V | command awk '{ if ($1 == "curl") print $2 }' | command sed 's/-.*$//g'
}
nvm_die_on_prefix () 
{ 
    local NVM_DELETE_PREFIX;
    NVM_DELETE_PREFIX="${1-}";
    case "${NVM_DELETE_PREFIX}" in 
        0 | 1)

        ;;
        *)
            nvm_err 'First argument "delete the prefix" must be zero or one';
            return 1
        ;;
    esac;
    local NVM_COMMAND;
    NVM_COMMAND="${2-}";
    local NVM_VERSION_DIR;
    NVM_VERSION_DIR="${3-}";
    if [ -z "${NVM_COMMAND}" ] || [ -z "${NVM_VERSION_DIR}" ]; then
        nvm_err 'Second argument "nvm command", and third argument "nvm version dir", must both be nonempty';
        return 2;
    fi;
    if [ -n "${PREFIX-}" ] && [ "$(nvm_version_path "$(node -v)")" != "${PREFIX}" ]; then
        nvm deactivate > /dev/null 2>&1;
        nvm_err "nvm is not compatible with the \"PREFIX\" environment variable: currently set to \"${PREFIX}\"";
        nvm_err 'Run `unset PREFIX` to unset it.';
        return 3;
    fi;
    local NVM_OS;
    NVM_OS="$(nvm_get_os)";
    local NVM_NPM_CONFIG_x_PREFIX_ENV;
    NVM_NPM_CONFIG_x_PREFIX_ENV="$(command awk 'BEGIN { for (name in ENVIRON) if (toupper(name) == "NPM_CONFIG_PREFIX") { print name; break } }')";
    if [ -n "${NVM_NPM_CONFIG_x_PREFIX_ENV-}" ]; then
        local NVM_CONFIG_VALUE;
        eval "NVM_CONFIG_VALUE=\"\$${NVM_NPM_CONFIG_x_PREFIX_ENV}\"";
        if [ -n "${NVM_CONFIG_VALUE-}" ] && [ "_${NVM_OS}" = "_win" ]; then
            NVM_CONFIG_VALUE="$(cd "$NVM_CONFIG_VALUE" 2> /dev/null && pwd)";
        fi;
        if [ -n "${NVM_CONFIG_VALUE-}" ] && ! nvm_tree_contains_path "${NVM_DIR}" "${NVM_CONFIG_VALUE}"; then
            nvm deactivate > /dev/null 2>&1;
            nvm_err "nvm is not compatible with the \"${NVM_NPM_CONFIG_x_PREFIX_ENV}\" environment variable: currently set to \"${NVM_CONFIG_VALUE}\"";
            nvm_err "Run \`unset ${NVM_NPM_CONFIG_x_PREFIX_ENV}\` to unset it.";
            return 4;
        fi;
    fi;
    local NVM_NPM_BUILTIN_NPMRC;
    NVM_NPM_BUILTIN_NPMRC="${NVM_VERSION_DIR}/lib/node_modules/npm/npmrc";
    if nvm_npmrc_bad_news_bears "${NVM_NPM_BUILTIN_NPMRC}"; then
        if [ "_${NVM_DELETE_PREFIX}" = "_1" ]; then
            npm config --loglevel=warn delete prefix --userconfig="${NVM_NPM_BUILTIN_NPMRC}";
            npm config --loglevel=warn delete globalconfig --userconfig="${NVM_NPM_BUILTIN_NPMRC}";
        else
            nvm_err "Your builtin npmrc file ($(nvm_sanitize_path "${NVM_NPM_BUILTIN_NPMRC}"))";
            nvm_err 'has a `globalconfig` and/or a `prefix` setting, which are incompatible with nvm.';
            nvm_err "Run \`${NVM_COMMAND}\` to unset it.";
            return 10;
        fi;
    fi;
    local NVM_NPM_GLOBAL_NPMRC;
    NVM_NPM_GLOBAL_NPMRC="${NVM_VERSION_DIR}/etc/npmrc";
    if nvm_npmrc_bad_news_bears "${NVM_NPM_GLOBAL_NPMRC}"; then
        if [ "_${NVM_DELETE_PREFIX}" = "_1" ]; then
            npm config --global --loglevel=warn delete prefix;
            npm config --global --loglevel=warn delete globalconfig;
        else
            nvm_err "Your global npmrc file ($(nvm_sanitize_path "${NVM_NPM_GLOBAL_NPMRC}"))";
            nvm_err 'has a `globalconfig` and/or a `prefix` setting, which are incompatible with nvm.';
            nvm_err "Run \`${NVM_COMMAND}\` to unset it.";
            return 10;
        fi;
    fi;
    local NVM_NPM_USER_NPMRC;
    NVM_NPM_USER_NPMRC="${HOME}/.npmrc";
    if nvm_npmrc_bad_news_bears "${NVM_NPM_USER_NPMRC}"; then
        if [ "_${NVM_DELETE_PREFIX}" = "_1" ]; then
            npm config --loglevel=warn delete prefix --userconfig="${NVM_NPM_USER_NPMRC}";
            npm config --loglevel=warn delete globalconfig --userconfig="${NVM_NPM_USER_NPMRC}";
        else
            nvm_err "Your user’s .npmrc file ($(nvm_sanitize_path "${NVM_NPM_USER_NPMRC}"))";
            nvm_err 'has a `globalconfig` and/or a `prefix` setting, which are incompatible with nvm.';
            nvm_err "Run \`${NVM_COMMAND}\` to unset it.";
            return 10;
        fi;
    fi;
    local NVM_NPM_PROJECT_NPMRC;
    NVM_NPM_PROJECT_NPMRC="$(nvm_find_project_dir)/.npmrc";
    if nvm_npmrc_bad_news_bears "${NVM_NPM_PROJECT_NPMRC}"; then
        if [ "_${NVM_DELETE_PREFIX}" = "_1" ]; then
            npm config --loglevel=warn delete prefix;
            npm config --loglevel=warn delete globalconfig;
        else
            nvm_err "Your project npmrc file ($(nvm_sanitize_path "${NVM_NPM_PROJECT_NPMRC}"))";
            nvm_err 'has a `globalconfig` and/or a `prefix` setting, which are incompatible with nvm.';
            nvm_err "Run \`${NVM_COMMAND}\` to unset it.";
            return 10;
        fi;
    fi
}
nvm_download () 
{ 
    if nvm_has "curl"; then
        local CURL_COMPRESSED_FLAG="";
        local CURL_HEADER_FLAG="";
        if [ -n "${NVM_AUTH_HEADER:-}" ]; then
            sanitized_header=$(nvm_sanitize_auth_header "${NVM_AUTH_HEADER}");
            CURL_HEADER_FLAG="--header \"Authorization: ${sanitized_header}\"";
        fi;
        if nvm_curl_use_compression; then
            CURL_COMPRESSED_FLAG="--compressed";
        fi;
        local NVM_DOWNLOAD_ARGS;
        NVM_DOWNLOAD_ARGS='';
        for arg in "$@";
        do
            NVM_DOWNLOAD_ARGS="${NVM_DOWNLOAD_ARGS} \"$arg\"";
        done;
        eval "curl -q --fail ${CURL_COMPRESSED_FLAG:-} ${CURL_HEADER_FLAG:-} ${NVM_DOWNLOAD_ARGS}";
    else
        if nvm_has "wget"; then
            ARGS=$(nvm_echo "$@" | command sed "
      s/--progress-bar /--progress=bar /
      s/--compressed //
      s/--fail //
      s/-L //
      s/-I /--server-response /
      s/-s /-q /
      s/-sS /-nv /
      s/-o /-O /
      s/-C - /-c /
    ");
            if [ -n "${NVM_AUTH_HEADER:-}" ]; then
                ARGS="${ARGS} --header \"${NVM_AUTH_HEADER}\"";
            fi;
            eval wget $ARGS;
        fi;
    fi
}
nvm_download_artifact () 
{ 
    local FLAVOR;
    case "${1-}" in 
        node | iojs)
            FLAVOR="${1}"
        ;;
        *)
            nvm_err 'supported flavors: node, iojs';
            return 1
        ;;
    esac;
    local KIND;
    case "${2-}" in 
        binary | source)
            KIND="${2}"
        ;;
        *)
            nvm_err 'supported kinds: binary, source';
            return 1
        ;;
    esac;
    local TYPE;
    TYPE="${3-}";
    local MIRROR;
    MIRROR="$(nvm_get_mirror "${FLAVOR}" "${TYPE}")";
    if [ -z "${MIRROR}" ]; then
        return 2;
    fi;
    local VERSION;
    VERSION="${4}";
    if [ -z "${VERSION}" ]; then
        nvm_err 'A version number is required.';
        return 3;
    fi;
    if [ "${KIND}" = 'binary' ] && ! nvm_binary_available "${VERSION}"; then
        nvm_err "No precompiled binary available for ${VERSION}.";
        return;
    fi;
    local SLUG;
    SLUG="$(nvm_get_download_slug "${FLAVOR}" "${KIND}" "${VERSION}")";
    local COMPRESSION;
    COMPRESSION="$(nvm_get_artifact_compression "${VERSION}")";
    local CHECKSUM;
    CHECKSUM="$(nvm_get_checksum "${FLAVOR}" "${TYPE}" "${VERSION}" "${SLUG}" "${COMPRESSION}")";
    local tmpdir;
    if [ "${KIND}" = 'binary' ]; then
        tmpdir="$(nvm_cache_dir)/bin/${SLUG}";
    else
        tmpdir="$(nvm_cache_dir)/src/${SLUG}";
    fi;
    command mkdir -p "${tmpdir}/files" || ( nvm_err "creating directory ${tmpdir}/files failed";
    return 3 );
    local TARBALL;
    TARBALL="${tmpdir}/${SLUG}.${COMPRESSION}";
    local TARBALL_URL;
    if nvm_version_greater_than_or_equal_to "${VERSION}" 0.1.14; then
        TARBALL_URL="${MIRROR}/${VERSION}/${SLUG}.${COMPRESSION}";
    else
        TARBALL_URL="${MIRROR}/${SLUG}.${COMPRESSION}";
    fi;
    if [ -r "${TARBALL}" ]; then
        nvm_err "Local cache found: $(nvm_sanitize_path "${TARBALL}")";
        if nvm_compare_checksum "${TARBALL}" "${CHECKSUM}" > /dev/null 2>&1; then
            nvm_err "Checksums match! Using existing downloaded archive $(nvm_sanitize_path "${TARBALL}")";
            nvm_echo "${TARBALL}";
            return 0;
        fi;
        nvm_compare_checksum "${TARBALL}" "${CHECKSUM}";
        nvm_err "Checksum check failed!";
        nvm_err "Removing the broken local cache...";
        command rm -rf "${TARBALL}";
    fi;
    nvm_err "Downloading ${TARBALL_URL}...";
    nvm_download -L -C - "${PROGRESS_BAR}" "${TARBALL_URL}" -o "${TARBALL}" || ( command rm -rf "${TARBALL}" "${tmpdir}";
    nvm_err "download from ${TARBALL_URL} failed";
    return 4 );
    if nvm_grep '404 Not Found' "${TARBALL}" > /dev/null; then
        command rm -rf "${TARBALL}" "${tmpdir}";
        nvm_err "HTTP 404 at URL ${TARBALL_URL}";
        return 5;
    fi;
    nvm_compare_checksum "${TARBALL}" "${CHECKSUM}" || ( command rm -rf "${tmpdir}/files";
    return 6 );
    nvm_echo "${TARBALL}"
}
nvm_echo () 
{ 
    command printf %s\\n "$*" 2> /dev/null
}
nvm_echo_with_colors () 
{ 
    command printf %b\\n "$*" 2> /dev/null
}
nvm_ensure_default_set () 
{ 
    local VERSION;
    VERSION="$1";
    if [ -z "${VERSION}" ]; then
        nvm_err 'nvm_ensure_default_set: a version is required';
        return 1;
    else
        if nvm_alias default > /dev/null 2>&1; then
            return 0;
        fi;
    fi;
    local OUTPUT;
    OUTPUT="$(nvm alias default "${VERSION}")";
    local EXIT_CODE;
    EXIT_CODE="$?";
    nvm_echo "Creating default alias: ${OUTPUT}";
    return $EXIT_CODE
}
nvm_ensure_version_installed () 
{ 
    local PROVIDED_VERSION;
    PROVIDED_VERSION="${1-}";
    local IS_VERSION_FROM_NVMRC;
    IS_VERSION_FROM_NVMRC="${2-}";
    if [ "${PROVIDED_VERSION}" = 'system' ]; then
        if nvm_has_system_iojs || nvm_has_system_node; then
            return 0;
        fi;
        nvm_err "N/A: no system version of node/io.js is installed.";
        return 1;
    fi;
    local LOCAL_VERSION;
    local EXIT_CODE;
    LOCAL_VERSION="$(nvm_version "${PROVIDED_VERSION}")";
    EXIT_CODE="$?";
    local NVM_VERSION_DIR;
    if [ "${EXIT_CODE}" != "0" ] || ! nvm_is_version_installed "${LOCAL_VERSION}"; then
        if VERSION="$(nvm_resolve_alias "${PROVIDED_VERSION}")"; then
            nvm_err "N/A: version \"${PROVIDED_VERSION} -> ${VERSION}\" is not yet installed.";
        else
            local PREFIXED_VERSION;
            PREFIXED_VERSION="$(nvm_ensure_version_prefix "${PROVIDED_VERSION}")";
            nvm_err "N/A: version \"${PREFIXED_VERSION:-$PROVIDED_VERSION}\" is not yet installed.";
        fi;
        nvm_err "";
        if [ "${PROVIDED_VERSION}" = 'lts' ]; then
            nvm_err '`lts` is not an alias - you may need to run `nvm install --lts` to install and `nvm use --lts` to use it.';
        else
            if [ "${IS_VERSION_FROM_NVMRC}" != '1' ]; then
                nvm_err "You need to run \`nvm install ${PROVIDED_VERSION}\` to install and use it.";
            else
                nvm_err 'You need to run `nvm install` to install and use the node version specified in `.nvmrc`.';
            fi;
        fi;
        return 1;
    fi
}
nvm_ensure_version_prefix () 
{ 
    local NVM_VERSION;
    NVM_VERSION="$(nvm_strip_iojs_prefix "${1-}" | command sed -e 's/^\([0-9]\)/v\1/g')";
    if nvm_is_iojs_version "${1-}"; then
        nvm_add_iojs_prefix "${NVM_VERSION}";
    else
        nvm_echo "${NVM_VERSION}";
    fi
}
nvm_err () 
{ 
    nvm_echo "$@" 1>&2
}
nvm_err_with_colors () 
{ 
    nvm_echo_with_colors "$@" 1>&2
}
nvm_extract_tarball () 
{ 
    if [ "$#" -ne 4 ]; then
        nvm_err 'nvm_extract_tarball requires exactly 4 arguments';
        return 5;
    fi;
    local NVM_OS;
    NVM_OS="${1-}";
    local VERSION;
    VERSION="${2-}";
    local TARBALL;
    TARBALL="${3-}";
    local TMPDIR;
    TMPDIR="${4-}";
    local tar_compression_flag;
    tar_compression_flag='z';
    if nvm_supports_xz "${VERSION}"; then
        tar_compression_flag='J';
    fi;
    local tar;
    tar='tar';
    if [ "${NVM_OS}" = 'aix' ]; then
        tar='gtar';
    fi;
    if [ "${NVM_OS}" = 'openbsd' ]; then
        if [ "${tar_compression_flag}" = 'J' ]; then
            command xzcat "${TARBALL}" | "${tar}" -xf - -C "${TMPDIR}" -s '/[^\/]*\///' || return 1;
        else
            command "${tar}" -x${tar_compression_flag}f "${TARBALL}" -C "${TMPDIR}" -s '/[^\/]*\///' || return 1;
        fi;
    else
        command "${tar}" -x${tar_compression_flag}f "${TARBALL}" -C "${TMPDIR}" --strip-components 1 || return 1;
    fi
}
nvm_find_nvmrc () 
{ 
    local dir;
    dir="$(nvm_find_up '.nvmrc')";
    if [ -e "${dir}/.nvmrc" ]; then
        nvm_echo "${dir}/.nvmrc";
    fi
}
nvm_find_project_dir () 
{ 
    local path_;
    path_="${PWD}";
    while [ "${path_}" != "" ] && [ "${path_}" != '.' ] && [ ! -f "${path_}/package.json" ] && [ ! -d "${path_}/node_modules" ]; do
        path_=${path_%/*};
    done;
    nvm_echo "${path_}"
}
nvm_find_up () 
{ 
    local path_;
    path_="${PWD}";
    while [ "${path_}" != "" ] && [ "${path_}" != '.' ] && [ ! -f "${path_}/${1-}" ]; do
        path_=${path_%/*};
    done;
    nvm_echo "${path_}"
}
nvm_format_version () 
{ 
    local VERSION;
    VERSION="$(nvm_ensure_version_prefix "${1-}")";
    local NUM_GROUPS;
    NUM_GROUPS="$(nvm_num_version_groups "${VERSION}")";
    if [ "${NUM_GROUPS}" -lt 3 ]; then
        nvm_format_version "${VERSION%.}.0";
    else
        nvm_echo "${VERSION}" | command cut -f1-3 -d.;
    fi
}
nvm_get_arch () 
{ 
    local HOST_ARCH;
    local NVM_OS;
    local EXIT_CODE;
    local LONG_BIT;
    NVM_OS="$(nvm_get_os)";
    if [ "_${NVM_OS}" = "_sunos" ]; then
        if HOST_ARCH=$(pkg_info -Q MACHINE_ARCH pkg_install); then
            HOST_ARCH=$(nvm_echo "${HOST_ARCH}" | command tail -1);
        else
            HOST_ARCH=$(isainfo -n);
        fi;
    else
        if [ "_${NVM_OS}" = "_aix" ]; then
            HOST_ARCH=ppc64;
        else
            HOST_ARCH="$(command uname -m)";
            LONG_BIT="$(getconf LONG_BIT 2> /dev/null)";
        fi;
    fi;
    local NVM_ARCH;
    case "${HOST_ARCH}" in 
        x86_64 | amd64)
            NVM_ARCH="x64"
        ;;
        i*86)
            NVM_ARCH="x86"
        ;;
        aarch64 | armv8l)
            NVM_ARCH="arm64"
        ;;
        *)
            NVM_ARCH="${HOST_ARCH}"
        ;;
    esac;
    if [ "_${LONG_BIT}" = "_32" ] && [ "${NVM_ARCH}" = "x64" ]; then
        NVM_ARCH="x86";
    fi;
    if [ "$(uname)" = "Linux" ] && [ "${NVM_ARCH}" = arm64 ] && [ "$(command od -An -t x1 -j 4 -N 1 "/sbin/init" 2> /dev/null)" = ' 01' ]; then
        NVM_ARCH=armv7l;
        HOST_ARCH=armv7l;
    fi;
    if [ -f "/etc/alpine-release" ]; then
        NVM_ARCH=x64-musl;
    fi;
    nvm_echo "${NVM_ARCH}"
}
nvm_get_artifact_compression () 
{ 
    local VERSION;
    VERSION="${1-}";
    local NVM_OS;
    NVM_OS="$(nvm_get_os)";
    local COMPRESSION;
    COMPRESSION='tar.gz';
    if [ "_${NVM_OS}" = '_win' ]; then
        COMPRESSION='zip';
    else
        if nvm_supports_xz "${VERSION}"; then
            COMPRESSION='tar.xz';
        fi;
    fi;
    nvm_echo "${COMPRESSION}"
}
nvm_get_checksum () 
{ 
    local FLAVOR;
    case "${1-}" in 
        node | iojs)
            FLAVOR="${1}"
        ;;
        *)
            nvm_err 'supported flavors: node, iojs';
            return 2
        ;;
    esac;
    local MIRROR;
    MIRROR="$(nvm_get_mirror "${FLAVOR}" "${2-}")";
    if [ -z "${MIRROR}" ]; then
        return 1;
    fi;
    local SHASUMS_URL;
    if [ "$(nvm_get_checksum_alg)" = 'sha-256' ]; then
        SHASUMS_URL="${MIRROR}/${3}/SHASUMS256.txt";
    else
        SHASUMS_URL="${MIRROR}/${3}/SHASUMS.txt";
    fi;
    nvm_download -L -s "${SHASUMS_URL}" -o - | command awk "{ if (\"${4}.${5}\" == \$2) print \$1}"
}
nvm_get_checksum_alg () 
{ 
    local NVM_CHECKSUM_BIN;
    NVM_CHECKSUM_BIN="$(nvm_get_checksum_binary 2> /dev/null)";
    case "${NVM_CHECKSUM_BIN-}" in 
        sha256sum | shasum | sha256 | gsha256sum | openssl | bssl)
            nvm_echo 'sha-256'
        ;;
        sha1sum | sha1)
            nvm_echo 'sha-1'
        ;;
        *)
            nvm_get_checksum_binary;
            return $?
        ;;
    esac
}
nvm_get_checksum_binary () 
{ 
    if nvm_has_non_aliased 'sha256sum'; then
        nvm_echo 'sha256sum';
    else
        if nvm_has_non_aliased 'shasum'; then
            nvm_echo 'shasum';
        else
            if nvm_has_non_aliased 'sha256'; then
                nvm_echo 'sha256';
            else
                if nvm_has_non_aliased 'gsha256sum'; then
                    nvm_echo 'gsha256sum';
                else
                    if nvm_has_non_aliased 'openssl'; then
                        nvm_echo 'openssl';
                    else
                        if nvm_has_non_aliased 'bssl'; then
                            nvm_echo 'bssl';
                        else
                            if nvm_has_non_aliased 'sha1sum'; then
                                nvm_echo 'sha1sum';
                            else
                                if nvm_has_non_aliased 'sha1'; then
                                    nvm_echo 'sha1';
                                else
                                    nvm_err 'Unaliased sha256sum, shasum, sha256, gsha256sum, openssl, or bssl not found.';
                                    nvm_err 'Unaliased sha1sum or sha1 not found.';
                                    return 1;
                                fi;
                            fi;
                        fi;
                    fi;
                fi;
            fi;
        fi;
    fi
}
nvm_get_colors () 
{ 
    local COLOR;
    local SYS_COLOR;
    local COLORS;
    COLORS="${NVM_COLORS:-bygre}";
    case $1 in 
        1)
            COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 1, 1); }')")
        ;;
        2)
            COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 2, 1); }')")
        ;;
        3)
            COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 3, 1); }')")
        ;;
        4)
            COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 4, 1); }')")
        ;;
        5)
            COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 5, 1); }')")
        ;;
        6)
            SYS_COLOR=$(nvm_print_color_code "$(echo "$COLORS" | awk '{ print substr($0, 2, 1); }')");
            COLOR=$(nvm_echo "$SYS_COLOR" | command tr '0;' '1;')
        ;;
        *)
            nvm_err "Invalid color index, ${1-}";
            return 1
        ;;
    esac;
    nvm_echo "$COLOR"
}
nvm_get_default_packages () 
{ 
    local NVM_DEFAULT_PACKAGE_FILE;
    NVM_DEFAULT_PACKAGE_FILE="${NVM_DIR}/default-packages";
    if [ -f "${NVM_DEFAULT_PACKAGE_FILE}" ]; then
        command awk -v filename="${NVM_DEFAULT_PACKAGE_FILE}" '
      /^[[:space:]]*#/ { next }                     # Skip lines that begin with #
      /^[[:space:]]*$/ { next }                     # Skip empty lines
      /[[:space:]]/ && !/^[[:space:]]*#/ {
        print "Only one package per line is allowed in `" filename "`. Please remove any lines with multiple space-separated values." > "/dev/stderr"
        err = 1
        exit 1
      }
      {
        if (NR > 1 && !prev_space) printf " "
        printf "%s", $0
        prev_space = 0
      }
    ' "${NVM_DEFAULT_PACKAGE_FILE}";
    fi
}
nvm_get_download_slug () 
{ 
    local FLAVOR;
    case "${1-}" in 
        node | iojs)
            FLAVOR="${1}"
        ;;
        *)
            nvm_err 'supported flavors: node, iojs';
            return 1
        ;;
    esac;
    local KIND;
    case "${2-}" in 
        binary | source)
            KIND="${2}"
        ;;
        *)
            nvm_err 'supported kinds: binary, source';
            return 2
        ;;
    esac;
    local VERSION;
    VERSION="${3-}";
    local NVM_OS;
    NVM_OS="$(nvm_get_os)";
    local NVM_ARCH;
    NVM_ARCH="$(nvm_get_arch)";
    if ! nvm_is_merged_node_version "${VERSION}"; then
        if [ "${NVM_ARCH}" = 'armv6l' ] || [ "${NVM_ARCH}" = 'armv7l' ]; then
            NVM_ARCH="arm-pi";
        fi;
    fi;
    if nvm_version_greater '14.17.0' "${VERSION}" || ( nvm_version_greater_than_or_equal_to "${VERSION}" '15.0.0' && nvm_version_greater '16.0.0' "${VERSION}" ); then
        if [ "_${NVM_OS}" = '_darwin' ] && [ "${NVM_ARCH}" = 'arm64' ]; then
            NVM_ARCH=x64;
        fi;
    fi;
    if [ "${KIND}" = 'binary' ]; then
        nvm_echo "${FLAVOR}-${VERSION}-${NVM_OS}-${NVM_ARCH}";
    else
        if [ "${KIND}" = 'source' ]; then
            nvm_echo "${FLAVOR}-${VERSION}";
        fi;
    fi
}
nvm_get_latest () 
{ 
    local NVM_LATEST_URL;
    local CURL_COMPRESSED_FLAG;
    if nvm_has "curl"; then
        if nvm_curl_use_compression; then
            CURL_COMPRESSED_FLAG="--compressed";
        fi;
        NVM_LATEST_URL="$(curl ${CURL_COMPRESSED_FLAG:-} -q -w "%{url_effective}\\n" -L -s -S https://latest.nvm.sh -o /dev/null)";
    else
        if nvm_has "wget"; then
            NVM_LATEST_URL="$(wget -q https://latest.nvm.sh --server-response -O /dev/null 2>&1 | command awk '/^  Location: /{DEST=$2} END{ print DEST }')";
        else
            nvm_err 'nvm needs curl or wget to proceed.';
            return 1;
        fi;
    fi;
    if [ -z "${NVM_LATEST_URL}" ]; then
        nvm_err "https://latest.nvm.sh did not redirect to the latest release on GitHub";
        return 2;
    fi;
    nvm_echo "${NVM_LATEST_URL##*/}"
}
nvm_get_make_jobs () 
{ 
    if nvm_is_natural_num "${1-}"; then
        NVM_MAKE_JOBS="$1";
        nvm_echo "number of \`make\` jobs: ${NVM_MAKE_JOBS}";
        return;
    else
        if [ -n "${1-}" ]; then
            unset NVM_MAKE_JOBS;
            nvm_err "$1 is invalid for number of \`make\` jobs, must be a natural number";
        fi;
    fi;
    local NVM_OS;
    NVM_OS="$(nvm_get_os)";
    local NVM_CPU_CORES;
    case "_${NVM_OS}" in 
        "_linux")
            NVM_CPU_CORES="$(nvm_grep -c -E '^processor.+: [0-9]+' /proc/cpuinfo)"
        ;;
        "_freebsd" | "_darwin" | "_openbsd")
            NVM_CPU_CORES="$(sysctl -n hw.ncpu)"
        ;;
        "_sunos")
            NVM_CPU_CORES="$(psrinfo | wc -l)"
        ;;
        "_aix")
            NVM_CPU_CORES="$(pmcycles -m | wc -l)"
        ;;
    esac;
    if ! nvm_is_natural_num "${NVM_CPU_CORES}"; then
        nvm_err 'Can not determine how many core(s) are available, running in single-threaded mode.';
        nvm_err 'Please report an issue on GitHub to help us make nvm run faster on your computer!';
        NVM_MAKE_JOBS=1;
    else
        nvm_echo "Detected that you have ${NVM_CPU_CORES} CPU core(s)";
        if [ "${NVM_CPU_CORES}" -gt 2 ]; then
            NVM_MAKE_JOBS=$((NVM_CPU_CORES - 1));
            nvm_echo "Running with ${NVM_MAKE_JOBS} threads to speed up the build";
        else
            NVM_MAKE_JOBS=1;
            nvm_echo 'Number of CPU core(s) less than or equal to 2, running in single-threaded mode';
        fi;
    fi
}
nvm_get_minor_version () 
{ 
    local VERSION;
    VERSION="$1";
    if [ -z "${VERSION}" ]; then
        nvm_err 'a version is required';
        return 1;
    fi;
    case "${VERSION}" in 
        v | .* | *..* | v*[!.0123456789]* | [!v]*[!.0123456789]* | [!v0123456789]* | v[!0123456789]*)
            nvm_err 'invalid version number';
            return 2
        ;;
    esac;
    local PREFIXED_VERSION;
    PREFIXED_VERSION="$(nvm_format_version "${VERSION}")";
    local MINOR;
    MINOR="$(nvm_echo "${PREFIXED_VERSION}" | nvm_grep -e '^v' | command cut -c2- | command cut -d . -f 1,2)";
    if [ -z "${MINOR}" ]; then
        nvm_err 'invalid version number! (please report this)';
        return 3;
    fi;
    nvm_echo "${MINOR}"
}
nvm_get_mirror () 
{ 
    local NVM_MIRROR;
    NVM_MIRROR='';
    case "${1}-${2}" in 
        node-std)
            NVM_MIRROR="${NVM_NODEJS_ORG_MIRROR:-https://nodejs.org/dist}"
        ;;
        iojs-std)
            NVM_MIRROR="${NVM_IOJS_ORG_MIRROR:-https://iojs.org/dist}"
        ;;
        *)
            nvm_err 'unknown type of node.js or io.js release';
            return 1
        ;;
    esac;
    case "${NVM_MIRROR}" in 
        *\`* | *\\* | *\'* | *\(* | *' '*)
            nvm_err '$NVM_NODEJS_ORG_MIRROR and $NVM_IOJS_ORG_MIRROR may only contain a URL';
            return 2
        ;;
    esac;
    if ! nvm_echo "${NVM_MIRROR}" | command awk '{ $0 ~ "^https?://[a-zA-Z0-9./_-]+$" }'; then
        nvm_err '$NVM_NODEJS_ORG_MIRROR and $NVM_IOJS_ORG_MIRROR may only contain a URL';
        return 2;
    fi;
    nvm_echo "${NVM_MIRROR}"
}
nvm_get_os () 
{ 
    local NVM_UNAME;
    NVM_UNAME="$(command uname -a)";
    local NVM_OS;
    case "${NVM_UNAME}" in 
        Linux\ *)
            NVM_OS=linux
        ;;
        Darwin\ *)
            NVM_OS=darwin
        ;;
        SunOS\ *)
            NVM_OS=sunos
        ;;
        FreeBSD\ *)
            NVM_OS=freebsd
        ;;
        OpenBSD\ *)
            NVM_OS=openbsd
        ;;
        AIX\ *)
            NVM_OS=aix
        ;;
        CYGWIN* | MSYS* | MINGW*)
            NVM_OS=win
        ;;
    esac;
    nvm_echo "${NVM_OS-}"
}
nvm_grep () 
{ 
    GREP_OPTIONS='' command grep "$@"
}
nvm_has () 
{ 
    type "${1-}" > /dev/null 2>&1
}
nvm_has_colors () 
{ 
    local NVM_NUM_COLORS;
    if nvm_has tput; then
        NVM_NUM_COLORS="$(command tput -T "${TERM:-vt100}" colors)";
    fi;
    [ "${NVM_NUM_COLORS:--1}" -ge 8 ] && [ "${NVM_NO_COLORS-}" != '--no-colors' ]
}
nvm_has_non_aliased () 
{ 
    nvm_has "${1-}" && ! nvm_is_alias "${1-}"
}
nvm_has_solaris_binary () 
{ 
    local VERSION="${1-}";
    if nvm_is_merged_node_version "${VERSION}"; then
        return 0;
    else
        if nvm_is_iojs_version "${VERSION}"; then
            nvm_iojs_version_has_solaris_binary "${VERSION}";
        else
            nvm_node_version_has_solaris_binary "${VERSION}";
        fi;
    fi
}
nvm_has_system_iojs () 
{ 
    [ "$(nvm deactivate > /dev/null 2>&1 && command -v iojs)" != '' ]
}
nvm_has_system_node () 
{ 
    [ "$(nvm deactivate > /dev/null 2>&1 && command -v node)" != '' ]
}
nvm_install_binary () 
{ 
    local FLAVOR;
    case "${1-}" in 
        node | iojs)
            FLAVOR="${1}"
        ;;
        *)
            nvm_err 'supported flavors: node, iojs';
            return 4
        ;;
    esac;
    local TYPE;
    TYPE="${2-}";
    local PREFIXED_VERSION;
    PREFIXED_VERSION="${3-}";
    if [ -z "${PREFIXED_VERSION}" ]; then
        nvm_err 'A version number is required.';
        return 3;
    fi;
    local nosource;
    nosource="${4-}";
    local VERSION;
    VERSION="$(nvm_strip_iojs_prefix "${PREFIXED_VERSION}")";
    local NVM_OS;
    NVM_OS="$(nvm_get_os)";
    if [ -z "${NVM_OS}" ]; then
        return 2;
    fi;
    local TARBALL;
    local TMPDIR;
    local PROGRESS_BAR;
    local NODE_OR_IOJS;
    if [ "${FLAVOR}" = 'node' ]; then
        NODE_OR_IOJS="${FLAVOR}";
    else
        if [ "${FLAVOR}" = 'iojs' ]; then
            NODE_OR_IOJS="io.js";
        fi;
    fi;
    if [ "${NVM_NO_PROGRESS-}" = "1" ]; then
        PROGRESS_BAR="-sS";
    else
        PROGRESS_BAR="--progress-bar";
    fi;
    nvm_echo "Downloading and installing ${NODE_OR_IOJS-} ${VERSION}...";
    TARBALL="$(PROGRESS_BAR="${PROGRESS_BAR}" nvm_download_artifact "${FLAVOR}" binary "${TYPE-}" "${VERSION}" | command tail -1)";
    if [ -f "${TARBALL}" ]; then
        TMPDIR="$(dirname "${TARBALL}")/files";
    fi;
    if nvm_install_binary_extract "${NVM_OS}" "${PREFIXED_VERSION}" "${VERSION}" "${TARBALL}" "${TMPDIR}"; then
        if [ -n "${ALIAS-}" ]; then
            nvm alias "${ALIAS}" "${provided_version}";
        fi;
        return 0;
    fi;
    if [ "${nosource-}" = '1' ]; then
        nvm_err 'Binary download failed. Download from source aborted.';
        return 0;
    fi;
    nvm_err 'Binary download failed, trying source.';
    if [ -n "${TMPDIR-}" ]; then
        command rm -rf "${TMPDIR}";
    fi;
    return 1
}
nvm_install_binary_extract () 
{ 
    if [ "$#" -ne 5 ]; then
        nvm_err 'nvm_install_binary_extract needs 5 parameters';
        return 1;
    fi;
    local NVM_OS;
    local PREFIXED_VERSION;
    local VERSION;
    local TARBALL;
    local TMPDIR;
    NVM_OS="${1}";
    PREFIXED_VERSION="${2}";
    VERSION="${3}";
    TARBALL="${4}";
    TMPDIR="${5}";
    local VERSION_PATH;
    [ -n "${TMPDIR-}" ] && command mkdir -p "${TMPDIR}" && VERSION_PATH="$(nvm_version_path "${PREFIXED_VERSION}")" || return 1;
    if [ "${NVM_OS}" = 'win' ]; then
        VERSION_PATH="${VERSION_PATH}/bin";
        command unzip -q "${TARBALL}" -d "${TMPDIR}" || return 1;
    else
        nvm_extract_tarball "${NVM_OS}" "${VERSION}" "${TARBALL}" "${TMPDIR}";
    fi;
    command mkdir -p "${VERSION_PATH}" || return 1;
    if [ "${NVM_OS}" = 'win' ]; then
        command mv "${TMPDIR}/"*/* "${VERSION_PATH}/" || return 1;
        command chmod +x "${VERSION_PATH}"/node.exe || return 1;
        command chmod +x "${VERSION_PATH}"/npm || return 1;
        command chmod +x "${VERSION_PATH}"/npx 2> /dev/null;
    else
        command mv "${TMPDIR}/"* "${VERSION_PATH}" || return 1;
    fi;
    command rm -rf "${TMPDIR}";
    return 0
}
nvm_install_default_packages () 
{ 
    local DEFAULT_PACKAGES;
    DEFAULT_PACKAGES="$(nvm_get_default_packages)";
    EXIT_CODE=$?;
    if [ $EXIT_CODE -ne 0 ] || [ -z "${DEFAULT_PACKAGES}" ]; then
        return $EXIT_CODE;
    fi;
    nvm_echo "Installing default global packages from ${NVM_DIR}/default-packages...";
    nvm_echo "npm install -g --quiet ${DEFAULT_PACKAGES}";
    if ! nvm_echo "${DEFAULT_PACKAGES}" | command xargs npm install -g --quiet; then
        nvm_err "Failed installing default packages. Please check if your default-packages file or a package in it has problems!";
        return 1;
    fi
}
nvm_install_latest_npm () 
{ 
    nvm_echo 'Attempting to upgrade to the latest working version of npm...';
    local NODE_VERSION;
    NODE_VERSION="$(nvm_strip_iojs_prefix "$(nvm_ls_current)")";
    local NPM_VERSION;
    NPM_VERSION="$(npm --version 2> /dev/null)";
    if [ "${NODE_VERSION}" = 'system' ]; then
        NODE_VERSION="$(node --version)";
    else
        if [ "${NODE_VERSION}" = 'none' ]; then
            nvm_echo "Detected node version ${NODE_VERSION}, npm version v${NPM_VERSION}";
            NODE_VERSION='';
        fi;
    fi;
    if [ -z "${NODE_VERSION}" ]; then
        nvm_err 'Unable to obtain node version.';
        return 1;
    fi;
    if [ -z "${NPM_VERSION}" ]; then
        nvm_err 'Unable to obtain npm version.';
        return 2;
    fi;
    local NVM_NPM_CMD;
    NVM_NPM_CMD='npm';
    if [ "${NVM_DEBUG-}" = 1 ]; then
        nvm_echo "Detected node version ${NODE_VERSION}, npm version v${NPM_VERSION}";
        NVM_NPM_CMD='nvm_echo npm';
    fi;
    local NVM_IS_0_6;
    NVM_IS_0_6=0;
    if nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 0.6.0 && nvm_version_greater 0.7.0 "${NODE_VERSION}"; then
        NVM_IS_0_6=1;
    fi;
    local NVM_IS_0_9;
    NVM_IS_0_9=0;
    if nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 0.9.0 && nvm_version_greater 0.10.0 "${NODE_VERSION}"; then
        NVM_IS_0_9=1;
    fi;
    if [ $NVM_IS_0_6 -eq 1 ]; then
        nvm_echo '* `node` v0.6.x can only upgrade to `npm` v1.3.x';
        $NVM_NPM_CMD install -g npm@1.3;
    else
        if [ $NVM_IS_0_9 -eq 0 ]; then
            if nvm_version_greater_than_or_equal_to "${NPM_VERSION}" 1.0.0 && nvm_version_greater 2.0.0 "${NPM_VERSION}"; then
                nvm_echo '* `npm` v1.x needs to first jump to `npm` v1.4.28 to be able to upgrade further';
                $NVM_NPM_CMD install -g npm@1.4.28;
            else
                if nvm_version_greater_than_or_equal_to "${NPM_VERSION}" 2.0.0 && nvm_version_greater 3.0.0 "${NPM_VERSION}"; then
                    nvm_echo '* `npm` v2.x needs to first jump to the latest v2 to be able to upgrade further';
                    $NVM_NPM_CMD install -g npm@2;
                fi;
            fi;
        fi;
    fi;
    if [ $NVM_IS_0_9 -eq 1 ] || [ $NVM_IS_0_6 -eq 1 ]; then
        nvm_echo '* node v0.6 and v0.9 are unable to upgrade further';
    else
        if nvm_version_greater 1.1.0 "${NODE_VERSION}"; then
            nvm_echo '* `npm` v4.5.x is the last version that works on `node` versions < v1.1.0';
            $NVM_NPM_CMD install -g npm@4.5;
        else
            if nvm_version_greater 4.0.0 "${NODE_VERSION}"; then
                nvm_echo '* `npm` v5 and higher do not work on `node` versions below v4.0.0';
                $NVM_NPM_CMD install -g npm@4;
            else
                if [ $NVM_IS_0_9 -eq 0 ] && [ $NVM_IS_0_6 -eq 0 ]; then
                    local NVM_IS_4_4_OR_BELOW;
                    NVM_IS_4_4_OR_BELOW=0;
                    if nvm_version_greater 4.5.0 "${NODE_VERSION}"; then
                        NVM_IS_4_4_OR_BELOW=1;
                    fi;
                    local NVM_IS_5_OR_ABOVE;
                    NVM_IS_5_OR_ABOVE=0;
                    if [ $NVM_IS_4_4_OR_BELOW -eq 0 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 5.0.0; then
                        NVM_IS_5_OR_ABOVE=1;
                    fi;
                    local NVM_IS_6_OR_ABOVE;
                    NVM_IS_6_OR_ABOVE=0;
                    local NVM_IS_6_2_OR_ABOVE;
                    NVM_IS_6_2_OR_ABOVE=0;
                    if [ $NVM_IS_5_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 6.0.0; then
                        NVM_IS_6_OR_ABOVE=1;
                        if nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 6.2.0; then
                            NVM_IS_6_2_OR_ABOVE=1;
                        fi;
                    fi;
                    local NVM_IS_9_OR_ABOVE;
                    NVM_IS_9_OR_ABOVE=0;
                    local NVM_IS_9_3_OR_ABOVE;
                    NVM_IS_9_3_OR_ABOVE=0;
                    if [ $NVM_IS_6_2_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 9.0.0; then
                        NVM_IS_9_OR_ABOVE=1;
                        if nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 9.3.0; then
                            NVM_IS_9_3_OR_ABOVE=1;
                        fi;
                    fi;
                    local NVM_IS_10_OR_ABOVE;
                    NVM_IS_10_OR_ABOVE=0;
                    if [ $NVM_IS_9_3_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 10.0.0; then
                        NVM_IS_10_OR_ABOVE=1;
                    fi;
                    local NVM_IS_12_LTS_OR_ABOVE;
                    NVM_IS_12_LTS_OR_ABOVE=0;
                    if [ $NVM_IS_10_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 12.13.0; then
                        NVM_IS_12_LTS_OR_ABOVE=1;
                    fi;
                    local NVM_IS_13_OR_ABOVE;
                    NVM_IS_13_OR_ABOVE=0;
                    if [ $NVM_IS_12_LTS_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 13.0.0; then
                        NVM_IS_13_OR_ABOVE=1;
                    fi;
                    local NVM_IS_14_LTS_OR_ABOVE;
                    NVM_IS_14_LTS_OR_ABOVE=0;
                    if [ $NVM_IS_13_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 14.15.0; then
                        NVM_IS_14_LTS_OR_ABOVE=1;
                    fi;
                    local NVM_IS_14_17_OR_ABOVE;
                    NVM_IS_14_17_OR_ABOVE=0;
                    if [ $NVM_IS_14_LTS_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 14.17.0; then
                        NVM_IS_14_17_OR_ABOVE=1;
                    fi;
                    local NVM_IS_15_OR_ABOVE;
                    NVM_IS_15_OR_ABOVE=0;
                    if [ $NVM_IS_14_LTS_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 15.0.0; then
                        NVM_IS_15_OR_ABOVE=1;
                    fi;
                    local NVM_IS_16_OR_ABOVE;
                    NVM_IS_16_OR_ABOVE=0;
                    if [ $NVM_IS_15_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 16.0.0; then
                        NVM_IS_16_OR_ABOVE=1;
                    fi;
                    local NVM_IS_16_LTS_OR_ABOVE;
                    NVM_IS_16_LTS_OR_ABOVE=0;
                    if [ $NVM_IS_16_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 16.13.0; then
                        NVM_IS_16_LTS_OR_ABOVE=1;
                    fi;
                    local NVM_IS_17_OR_ABOVE;
                    NVM_IS_17_OR_ABOVE=0;
                    if [ $NVM_IS_16_LTS_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 17.0.0; then
                        NVM_IS_17_OR_ABOVE=1;
                    fi;
                    local NVM_IS_18_OR_ABOVE;
                    NVM_IS_18_OR_ABOVE=0;
                    if [ $NVM_IS_17_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 18.0.0; then
                        NVM_IS_18_OR_ABOVE=1;
                    fi;
                    local NVM_IS_18_17_OR_ABOVE;
                    NVM_IS_18_17_OR_ABOVE=0;
                    if [ $NVM_IS_18_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 18.17.0; then
                        NVM_IS_18_17_OR_ABOVE=1;
                    fi;
                    local NVM_IS_19_OR_ABOVE;
                    NVM_IS_19_OR_ABOVE=0;
                    if [ $NVM_IS_18_17_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 19.0.0; then
                        NVM_IS_19_OR_ABOVE=1;
                    fi;
                    local NVM_IS_20_5_OR_ABOVE;
                    NVM_IS_20_5_OR_ABOVE=0;
                    if [ $NVM_IS_19_OR_ABOVE -eq 1 ] && nvm_version_greater_than_or_equal_to "${NODE_VERSION}" 20.5.0; then
                        NVM_IS_20_5_OR_ABOVE=1;
                    fi;
                    local NVM_IS_20_17_or_ABOVE;
                    NVM_IS_20_17_or_ABOVE=0;
                    if [ $NVM_IS_20_5_OR_ABOVE -eq 1 ] && nvm_version_greater 20.17.0 "${NODE_VERSION}"; then
                        NVM_IS_20_17_or_ABOVE=1;
                    fi;
                    local NVM_IS_21_OR_ABOVE;
                    NVM_IS_21_OR_ABOVE=0;
                    if [ $NVM_IS_20_17_or_ABOVE -eq 1 ] && nvm_version_greater 21.0.0 "${NODE_VERSION}"; then
                        NVM_IS_21_OR_ABOVE=1;
                    fi;
                    local NVM_IS_22_9_OR_ABOVE;
                    NVM_IS_22_9_OR_ABOVE=0;
                    if [ $NVM_IS_21_OR_ABOVE -eq 1 ] && nvm_version_greater 22.9.0 "${NODE_VERSION}"; then
                        NVM_IS_22_9_OR_ABOVE=1;
                    fi;
                    if [ $NVM_IS_4_4_OR_BELOW -eq 1 ] || { 
                        [ $NVM_IS_5_OR_ABOVE -eq 1 ] && nvm_version_greater 5.10.0 "${NODE_VERSION}"
                    }; then
                        nvm_echo '* `npm` `v5.3.x` is the last version that works on `node` 4.x versions below v4.4, or 5.x versions below v5.10, due to `Buffer.alloc`';
                        $NVM_NPM_CMD install -g npm@5.3;
                    else
                        if [ $NVM_IS_4_4_OR_BELOW -eq 0 ] && nvm_version_greater 4.7.0 "${NODE_VERSION}"; then
                            nvm_echo '* `npm` `v5.4.1` is the last version that works on `node` `v4.5` and `v4.6`';
                            $NVM_NPM_CMD install -g npm@5.4.1;
                        else
                            if [ $NVM_IS_6_OR_ABOVE -eq 0 ]; then
                                nvm_echo '* `npm` `v5.x` is the last version that works on `node` below `v6.0.0`';
                                $NVM_NPM_CMD install -g npm@5;
                            else
                                if { 
                                    [ $NVM_IS_6_OR_ABOVE -eq 1 ] && [ $NVM_IS_6_2_OR_ABOVE -eq 0 ]
                                } || { 
                                    [ $NVM_IS_9_OR_ABOVE -eq 1 ] && [ $NVM_IS_9_3_OR_ABOVE -eq 0 ]
                                }; then
                                    nvm_echo '* `npm` `v6.9` is the last version that works on `node` `v6.0.x`, `v6.1.x`, `v9.0.x`, `v9.1.x`, or `v9.2.x`';
                                    $NVM_NPM_CMD install -g npm@6.9;
                                else
                                    if [ $NVM_IS_10_OR_ABOVE -eq 0 ]; then
                                        if nvm_version_greater 4.4.4 "${NPM_VERSION}"; then
                                            nvm_echo '* `npm` `v4.4.4` or later is required to install npm v6.14.18';
                                            $NVM_NPM_CMD install -g npm@4;
                                        fi;
                                        nvm_echo '* `npm` `v6.x` is the last version that works on `node` below `v10.0.0`';
                                        $NVM_NPM_CMD install -g npm@6;
                                    else
                                        if [ $NVM_IS_12_LTS_OR_ABOVE -eq 0 ] || { 
                                            [ $NVM_IS_13_OR_ABOVE -eq 1 ] && [ $NVM_IS_14_LTS_OR_ABOVE -eq 0 ]
                                        } || { 
                                            [ $NVM_IS_15_OR_ABOVE -eq 1 ] && [ $NVM_IS_16_OR_ABOVE -eq 0 ]
                                        }; then
                                            nvm_echo '* `npm` `v7.x` is the last version that works on `node` `v13`, `v15`, below `v12.13`, or `v14.0` - `v14.15`';
                                            $NVM_NPM_CMD install -g npm@7;
                                        else
                                            if { 
                                                [ $NVM_IS_12_LTS_OR_ABOVE -eq 1 ] && [ $NVM_IS_13_OR_ABOVE -eq 0 ]
                                            } || { 
                                                [ $NVM_IS_14_LTS_OR_ABOVE -eq 1 ] && [ $NVM_IS_14_17_OR_ABOVE -eq 0 ]
                                            } || { 
                                                [ $NVM_IS_16_OR_ABOVE -eq 1 ] && [ $NVM_IS_16_LTS_OR_ABOVE -eq 0 ]
                                            } || { 
                                                [ $NVM_IS_17_OR_ABOVE -eq 1 ] && [ $NVM_IS_18_OR_ABOVE -eq 0 ]
                                            }; then
                                                nvm_echo '* `npm` `v8.6` is the last version that works on `node` `v12`, `v14.13` - `v14.16`, or `v16.0` - `v16.12`';
                                                $NVM_NPM_CMD install -g npm@8.6;
                                            else
                                                if [ $NVM_IS_18_17_OR_ABOVE -eq 0 ] || { 
                                                    [ $NVM_IS_19_OR_ABOVE -eq 1 ] && [ $NVM_IS_20_5_OR_ABOVE -eq 0 ]
                                                }; then
                                                    nvm_echo '* `npm` `v9.x` is the last version that works on `node` `< v18.17`, `v19`, or `v20.0` - `v20.4`';
                                                    $NVM_NPM_CMD install -g npm@9;
                                                else
                                                    if [ $NVM_IS_20_17_or_ABOVE -eq 0 ] || { 
                                                        [ $NVM_IS_21_OR_ABOVE -eq 1 ] && [ $NVM_IS_22_9_OR_ABOVE -eq 0 ]
                                                    }; then
                                                        nvm_echo '* `npm` `v10.x` is the last version that works on `node` `< v20.17`, `v21`, or `v22.0` - `v22.8`';
                                                        $NVM_NPM_CMD install -g npm@10;
                                                    else
                                                        nvm_echo '* Installing latest `npm`; if this does not work on your node version, please report a bug!';
                                                        $NVM_NPM_CMD install -g npm;
                                                    fi;
                                                fi;
                                            fi;
                                        fi;
                                    fi;
                                fi;
                            fi;
                        fi;
                    fi;
                fi;
            fi;
        fi;
    fi;
    nvm_echo "* npm upgraded to: v$(npm --version 2> /dev/null)"
}
nvm_install_npm_if_needed () 
{ 
    local VERSION;
    VERSION="$(nvm_ls_current)";
    if ! nvm_has "npm"; then
        nvm_echo 'Installing npm...';
        if nvm_version_greater 0.2.0 "${VERSION}"; then
            nvm_err 'npm requires node v0.2.3 or higher';
        else
            if nvm_version_greater_than_or_equal_to "${VERSION}" 0.2.0; then
                if nvm_version_greater 0.2.3 "${VERSION}"; then
                    nvm_err 'npm requires node v0.2.3 or higher';
                else
                    nvm_download -L https://npmjs.org/install.sh -o - | clean=yes npm_install=0.2.19 sh;
                fi;
            else
                nvm_download -L https://npmjs.org/install.sh -o - | clean=yes sh;
            fi;
        fi;
    fi;
    return $?
}
nvm_install_source () 
{ 
    local FLAVOR;
    case "${1-}" in 
        node | iojs)
            FLAVOR="${1}"
        ;;
        *)
            nvm_err 'supported flavors: node, iojs';
            return 4
        ;;
    esac;
    local TYPE;
    TYPE="${2-}";
    local PREFIXED_VERSION;
    PREFIXED_VERSION="${3-}";
    if [ -z "${PREFIXED_VERSION}" ]; then
        nvm_err 'A version number is required.';
        return 3;
    fi;
    local VERSION;
    VERSION="$(nvm_strip_iojs_prefix "${PREFIXED_VERSION}")";
    local NVM_MAKE_JOBS;
    NVM_MAKE_JOBS="${4-}";
    local ADDITIONAL_PARAMETERS;
    ADDITIONAL_PARAMETERS="${5-}";
    local NVM_ARCH;
    NVM_ARCH="$(nvm_get_arch)";
    if [ "${NVM_ARCH}" = 'armv6l' ] || [ "${NVM_ARCH}" = 'armv7l' ]; then
        if [ -n "${ADDITIONAL_PARAMETERS}" ]; then
            ADDITIONAL_PARAMETERS="--without-snapshot ${ADDITIONAL_PARAMETERS}";
        else
            ADDITIONAL_PARAMETERS='--without-snapshot';
        fi;
    fi;
    if [ -n "${ADDITIONAL_PARAMETERS}" ]; then
        nvm_echo "Additional options while compiling: ${ADDITIONAL_PARAMETERS}";
    fi;
    local NVM_OS;
    NVM_OS="$(nvm_get_os)";
    local make;
    make='make';
    local MAKE_CXX;
    case "${NVM_OS}" in 
        'freebsd' | 'openbsd')
            make='gmake';
            MAKE_CXX="CC=${CC:-cc} CXX=${CXX:-c++}"
        ;;
        'darwin')
            MAKE_CXX="CC=${CC:-cc} CXX=${CXX:-c++}"
        ;;
        'aix')
            make='gmake'
        ;;
    esac;
    if nvm_has "clang++" && nvm_has "clang" && nvm_version_greater_than_or_equal_to "$(nvm_clang_version)" 3.5; then
        if [ -z "${CC-}" ] || [ -z "${CXX-}" ]; then
            nvm_echo "Clang v3.5+ detected! CC or CXX not specified, will use Clang as C/C++ compiler!";
            MAKE_CXX="CC=${CC:-cc} CXX=${CXX:-c++}";
        fi;
    fi;
    local TARBALL;
    local TMPDIR;
    local VERSION_PATH;
    if [ "${NVM_NO_PROGRESS-}" = "1" ]; then
        PROGRESS_BAR="-sS";
    else
        PROGRESS_BAR="--progress-bar";
    fi;
    nvm_is_zsh && setopt local_options shwordsplit;
    TARBALL="$(PROGRESS_BAR="${PROGRESS_BAR}" nvm_download_artifact "${FLAVOR}" source "${TYPE}" "${VERSION}" | command tail -1)" && [ -f "${TARBALL}" ] && TMPDIR="$(dirname "${TARBALL}")/files" && if ! ( command mkdir -p "${TMPDIR}" && nvm_extract_tarball "${NVM_OS}" "${VERSION}" "${TARBALL}" "${TMPDIR}" && VERSION_PATH="$(nvm_version_path "${PREFIXED_VERSION}")" && nvm_cd "${TMPDIR}" && nvm_echo '$>'./configure --prefix="${VERSION_PATH}" $ADDITIONAL_PARAMETERS'<' && ./configure --prefix="${VERSION_PATH}" $ADDITIONAL_PARAMETERS && $make -j "${NVM_MAKE_JOBS}" ${MAKE_CXX-} && command rm -f "${VERSION_PATH}" 2> /dev/null && $make -j "${NVM_MAKE_JOBS}" ${MAKE_CXX-} install ); then
        nvm_err "nvm: install ${VERSION} failed!";
        command rm -rf "${TMPDIR-}";
        return 1;
    fi
}
nvm_iojs_prefix () 
{ 
    nvm_echo 'iojs'
}
nvm_iojs_version_has_solaris_binary () 
{ 
    local IOJS_VERSION;
    IOJS_VERSION="$1";
    local STRIPPED_IOJS_VERSION;
    STRIPPED_IOJS_VERSION="$(nvm_strip_iojs_prefix "${IOJS_VERSION}")";
    if [ "_${STRIPPED_IOJS_VERSION}" = "${IOJS_VERSION}" ]; then
        return 1;
    fi;
    nvm_version_greater_than_or_equal_to "${STRIPPED_IOJS_VERSION}" v3.3.1
}
nvm_is_alias () 
{ 
    \alias "${1-}" > /dev/null 2>&1
}
nvm_is_iojs_version () 
{ 
    case "${1-}" in 
        iojs-*)
            return 0
        ;;
    esac;
    return 1
}
nvm_is_merged_node_version () 
{ 
    nvm_version_greater_than_or_equal_to "$1" v4.0.0
}
nvm_is_natural_num () 
{ 
    if [ -z "$1" ]; then
        return 4;
    fi;
    case "$1" in 
        0)
            return 1
        ;;
        -*)
            return 3
        ;;
        *)
            [ "$1" -eq "$1" ] 2> /dev/null
        ;;
    esac
}
nvm_is_valid_version () 
{ 
    if nvm_validate_implicit_alias "${1-}" 2> /dev/null; then
        return 0;
    fi;
    case "${1-}" in 
        "$(nvm_iojs_prefix)" | "$(nvm_node_prefix)")
            return 0
        ;;
        *)
            local VERSION;
            VERSION="$(nvm_strip_iojs_prefix "${1-}")";
            nvm_version_greater_than_or_equal_to "${VERSION}" 0
        ;;
    esac
}
nvm_is_version_installed () 
{ 
    if [ -z "${1-}" ]; then
        return 1;
    fi;
    local NVM_NODE_BINARY;
    NVM_NODE_BINARY='node';
    if [ "_$(nvm_get_os)" = '_win' ]; then
        NVM_NODE_BINARY='node.exe';
    fi;
    if [ -x "$(nvm_version_path "$1" 2> /dev/null)/bin/${NVM_NODE_BINARY}" ]; then
        return 0;
    fi;
    return 1
}
nvm_is_zsh () 
{ 
    [ -n "${ZSH_VERSION-}" ]
}
nvm_list_aliases () 
{ 
    local ALIAS;
    ALIAS="${1-}";
    local NVM_CURRENT;
    NVM_CURRENT="$(nvm_ls_current)";
    local NVM_ALIAS_DIR;
    NVM_ALIAS_DIR="$(nvm_alias_path)";
    command mkdir -p "${NVM_ALIAS_DIR}/lts";
    if [ "${ALIAS}" != "${ALIAS#lts/}" ]; then
        nvm_alias "${ALIAS}";
        return $?;
    fi;
    nvm_is_zsh && unsetopt local_options nomatch;
    ( local ALIAS_PATH;
    for ALIAS_PATH in "${NVM_ALIAS_DIR}/${ALIAS}"*;
    do
        NVM_NO_COLORS="${NVM_NO_COLORS-}" NVM_CURRENT="${NVM_CURRENT}" nvm_print_alias_path "${NVM_ALIAS_DIR}" "${ALIAS_PATH}" &
    done;
    wait ) | command sort;
    ( local ALIAS_NAME;
    for ALIAS_NAME in "$(nvm_node_prefix)" "stable" "unstable" "$(nvm_iojs_prefix)";
    do
        { 
            if [ ! -f "${NVM_ALIAS_DIR}/${ALIAS_NAME}" ] && { 
                [ -z "${ALIAS}" ] || [ "${ALIAS_NAME}" = "${ALIAS}" ]
            }; then
                NVM_NO_COLORS="${NVM_NO_COLORS-}" NVM_CURRENT="${NVM_CURRENT}" nvm_print_default_alias "${ALIAS_NAME}";
            fi
        } &
    done;
    wait ) | command sort;
    ( local LTS_ALIAS;
    for ALIAS_PATH in "${NVM_ALIAS_DIR}/lts/${ALIAS}"*;
    do
        { 
            LTS_ALIAS="$(NVM_NO_COLORS="${NVM_NO_COLORS-}" NVM_LTS=true nvm_print_alias_path "${NVM_ALIAS_DIR}" "${ALIAS_PATH}")";
            if [ -n "${LTS_ALIAS}" ]; then
                nvm_echo "${LTS_ALIAS}";
            fi
        } &
    done;
    wait ) | command sort;
    return
}
nvm_ls () 
{ 
    local PATTERN;
    PATTERN="${1-}";
    local VERSIONS;
    VERSIONS='';
    if [ "${PATTERN}" = 'current' ]; then
        nvm_ls_current;
        return;
    fi;
    local NVM_IOJS_PREFIX;
    NVM_IOJS_PREFIX="$(nvm_iojs_prefix)";
    local NVM_NODE_PREFIX;
    NVM_NODE_PREFIX="$(nvm_node_prefix)";
    local NVM_VERSION_DIR_IOJS;
    NVM_VERSION_DIR_IOJS="$(nvm_version_dir "${NVM_IOJS_PREFIX}")";
    local NVM_VERSION_DIR_NEW;
    NVM_VERSION_DIR_NEW="$(nvm_version_dir new)";
    local NVM_VERSION_DIR_OLD;
    NVM_VERSION_DIR_OLD="$(nvm_version_dir old)";
    case "${PATTERN}" in 
        "${NVM_IOJS_PREFIX}" | "${NVM_NODE_PREFIX}")
            PATTERN="${PATTERN}-"
        ;;
        *)
            if nvm_resolve_local_alias "${PATTERN}"; then
                return;
            fi;
            PATTERN="$(nvm_ensure_version_prefix "${PATTERN}")"
        ;;
    esac;
    if [ "${PATTERN}" = 'N/A' ]; then
        return;
    fi;
    local NVM_PATTERN_STARTS_WITH_V;
    case $PATTERN in 
        v*)
            NVM_PATTERN_STARTS_WITH_V=true
        ;;
        *)
            NVM_PATTERN_STARTS_WITH_V=false
        ;;
    esac;
    if [ $NVM_PATTERN_STARTS_WITH_V = true ] && [ "_$(nvm_num_version_groups "${PATTERN}")" = "_3" ]; then
        if nvm_is_version_installed "${PATTERN}"; then
            VERSIONS="${PATTERN}";
        else
            if nvm_is_version_installed "$(nvm_add_iojs_prefix "${PATTERN}")"; then
                VERSIONS="$(nvm_add_iojs_prefix "${PATTERN}")";
            fi;
        fi;
    else
        case "${PATTERN}" in 
            "${NVM_IOJS_PREFIX}-" | "${NVM_NODE_PREFIX}-" | "system")

            ;;
            *)
                local NUM_VERSION_GROUPS;
                NUM_VERSION_GROUPS="$(nvm_num_version_groups "${PATTERN}")";
                if [ "${NUM_VERSION_GROUPS}" = "2" ] || [ "${NUM_VERSION_GROUPS}" = "1" ]; then
                    PATTERN="${PATTERN%.}.";
                fi
            ;;
        esac;
        nvm_is_zsh && setopt local_options shwordsplit;
        nvm_is_zsh && unsetopt local_options markdirs;
        local NVM_DIRS_TO_SEARCH1;
        NVM_DIRS_TO_SEARCH1='';
        local NVM_DIRS_TO_SEARCH2;
        NVM_DIRS_TO_SEARCH2='';
        local NVM_DIRS_TO_SEARCH3;
        NVM_DIRS_TO_SEARCH3='';
        local NVM_ADD_SYSTEM;
        NVM_ADD_SYSTEM=false;
        if nvm_is_iojs_version "${PATTERN}"; then
            NVM_DIRS_TO_SEARCH1="${NVM_VERSION_DIR_IOJS}";
            PATTERN="$(nvm_strip_iojs_prefix "${PATTERN}")";
            if nvm_has_system_iojs; then
                NVM_ADD_SYSTEM=true;
            fi;
        else
            if [ "${PATTERN}" = "${NVM_NODE_PREFIX}-" ]; then
                NVM_DIRS_TO_SEARCH1="${NVM_VERSION_DIR_OLD}";
                NVM_DIRS_TO_SEARCH2="${NVM_VERSION_DIR_NEW}";
                PATTERN='';
                if nvm_has_system_node; then
                    NVM_ADD_SYSTEM=true;
                fi;
            else
                NVM_DIRS_TO_SEARCH1="${NVM_VERSION_DIR_OLD}";
                NVM_DIRS_TO_SEARCH2="${NVM_VERSION_DIR_NEW}";
                NVM_DIRS_TO_SEARCH3="${NVM_VERSION_DIR_IOJS}";
                if nvm_has_system_iojs || nvm_has_system_node; then
                    NVM_ADD_SYSTEM=true;
                fi;
            fi;
        fi;
        if ! [ -d "${NVM_DIRS_TO_SEARCH1}" ] || ! ( command ls -1qA "${NVM_DIRS_TO_SEARCH1}" | nvm_grep -q . ); then
            NVM_DIRS_TO_SEARCH1='';
        fi;
        if ! [ -d "${NVM_DIRS_TO_SEARCH2}" ] || ! ( command ls -1qA "${NVM_DIRS_TO_SEARCH2}" | nvm_grep -q . ); then
            NVM_DIRS_TO_SEARCH2="${NVM_DIRS_TO_SEARCH1}";
        fi;
        if ! [ -d "${NVM_DIRS_TO_SEARCH3}" ] || ! ( command ls -1qA "${NVM_DIRS_TO_SEARCH3}" | nvm_grep -q . ); then
            NVM_DIRS_TO_SEARCH3="${NVM_DIRS_TO_SEARCH2}";
        fi;
        local SEARCH_PATTERN;
        if [ -z "${PATTERN}" ]; then
            PATTERN='v';
            SEARCH_PATTERN='.*';
        else
            SEARCH_PATTERN="$(nvm_echo "${PATTERN}" | command sed 's#\.#\\\.#g;')";
        fi;
        if [ -n "${NVM_DIRS_TO_SEARCH1}${NVM_DIRS_TO_SEARCH2}${NVM_DIRS_TO_SEARCH3}" ]; then
            VERSIONS="$(command find "${NVM_DIRS_TO_SEARCH1}"/* "${NVM_DIRS_TO_SEARCH2}"/* "${NVM_DIRS_TO_SEARCH3}"/* -name . -o -type d -prune -o -path "${PATTERN}*" | command sed -e "
            s#${NVM_VERSION_DIR_IOJS}/#versions/${NVM_IOJS_PREFIX}/#;
            s#^${NVM_DIR}/##;
            \\#^[^v]# d;
            \\#^versions\$# d;
            s#^versions/##;
            s#^v#${NVM_NODE_PREFIX}/v#;
            \\#${SEARCH_PATTERN}# !d;
          " -e 's#^\([^/]\{1,\}\)/\(.*\)$#\2.\1#;' | command sort -t. -u -k 1.2,1n -k 2,2n -k 3,3n | command sed -e 's#\(.*\)\.\([^\.]\{1,\}\)$#\2-\1#;' -e "s#^${NVM_NODE_PREFIX}-##;")";
        fi;
    fi;
    if [ "${NVM_ADD_SYSTEM-}" = true ]; then
        case "${PATTERN}" in 
            '' | v)
                VERSIONS="${VERSIONS}
system"
            ;;
            system)
                VERSIONS="system"
            ;;
        esac;
    fi;
    if [ -z "${VERSIONS}" ]; then
        nvm_echo 'N/A';
        return 3;
    fi;
    nvm_echo "${VERSIONS}"
}
nvm_ls_current () 
{ 
    local NVM_LS_CURRENT_NODE_PATH;
    if ! NVM_LS_CURRENT_NODE_PATH="$(command which node 2> /dev/null)"; then
        nvm_echo 'none';
    else
        if nvm_tree_contains_path "$(nvm_version_dir iojs)" "${NVM_LS_CURRENT_NODE_PATH}"; then
            nvm_add_iojs_prefix "$(iojs --version 2> /dev/null)";
        else
            if nvm_tree_contains_path "${NVM_DIR}" "${NVM_LS_CURRENT_NODE_PATH}"; then
                local VERSION;
                VERSION="$(node --version 2> /dev/null)";
                if [ "${VERSION}" = "v0.6.21-pre" ]; then
                    nvm_echo 'v0.6.21';
                else
                    nvm_echo "${VERSION:-none}";
                fi;
            else
                nvm_echo 'system';
            fi;
        fi;
    fi
}
nvm_ls_remote () 
{ 
    local PATTERN;
    PATTERN="${1-}";
    if nvm_validate_implicit_alias "${PATTERN}" 2> /dev/null; then
        local IMPLICIT;
        IMPLICIT="$(nvm_print_implicit_alias remote "${PATTERN}")";
        if [ -z "${IMPLICIT-}" ] || [ "${IMPLICIT}" = 'N/A' ]; then
            nvm_echo "N/A";
            return 3;
        fi;
        PATTERN="$(NVM_LTS="${NVM_LTS-}" nvm_ls_remote "${IMPLICIT}" | command tail -1 | command awk '{ print $1 }')";
    else
        if [ -n "${PATTERN}" ]; then
            PATTERN="$(nvm_ensure_version_prefix "${PATTERN}")";
        else
            PATTERN=".*";
        fi;
    fi;
    NVM_LTS="${NVM_LTS-}" nvm_ls_remote_index_tab node std "${PATTERN}"
}
nvm_ls_remote_index_tab () 
{ 
    local LTS;
    LTS="${NVM_LTS-}";
    if [ "$#" -lt 3 ]; then
        nvm_err 'not enough arguments';
        return 5;
    fi;
    local FLAVOR;
    FLAVOR="${1-}";
    local TYPE;
    TYPE="${2-}";
    local MIRROR;
    MIRROR="$(nvm_get_mirror "${FLAVOR}" "${TYPE}")";
    if [ -z "${MIRROR}" ]; then
        return 3;
    fi;
    local PREFIX;
    PREFIX='';
    case "${FLAVOR}-${TYPE}" in 
        iojs-std)
            PREFIX="$(nvm_iojs_prefix)-"
        ;;
        node-std)
            PREFIX=''
        ;;
        iojs-*)
            nvm_err 'unknown type of io.js release';
            return 4
        ;;
        *)
            nvm_err 'unknown type of node.js release';
            return 4
        ;;
    esac;
    local SORT_COMMAND;
    SORT_COMMAND='command sort';
    case "${FLAVOR}" in 
        node)
            SORT_COMMAND='command sort -t. -u -k 1.2,1n -k 2,2n -k 3,3n'
        ;;
    esac;
    local PATTERN;
    PATTERN="${3-}";
    if [ "${PATTERN#"${PATTERN%?}"}" = '.' ]; then
        PATTERN="${PATTERN%.}";
    fi;
    local VERSIONS;
    if [ -n "${PATTERN}" ] && [ "${PATTERN}" != '*' ]; then
        if [ "${FLAVOR}" = 'iojs' ]; then
            PATTERN="$(nvm_ensure_version_prefix "$(nvm_strip_iojs_prefix "${PATTERN}")")";
        else
            PATTERN="$(nvm_ensure_version_prefix "${PATTERN}")";
        fi;
    else
        unset PATTERN;
    fi;
    nvm_is_zsh && setopt local_options shwordsplit;
    local VERSION_LIST;
    VERSION_LIST="$(nvm_download -L -s "${MIRROR}/index.tab" -o - | command sed "
        1d;
        s/^/${PREFIX}/;
      ")";
    local LTS_ALIAS;
    local LTS_VERSION;
    command mkdir -p "$(nvm_alias_path)/lts";
    { 
        command awk '{
        if ($10 ~ /^\-?$/) { next }
        if ($10 && !a[tolower($10)]++) {
          if (alias) { print alias, version }
          alias_name = "lts/" tolower($10)
          if (!alias) { print "lts/*", alias_name }
          alias = alias_name
          version = $1
        }
      }
      END {
        if (alias) {
          print alias, version
        }
      }' | while read -r LTS_ALIAS_LINE; do
            LTS_ALIAS="${LTS_ALIAS_LINE%% *}";
            LTS_VERSION="${LTS_ALIAS_LINE#* }";
            nvm_make_alias "${LTS_ALIAS}" "${LTS_VERSION}" > /dev/null 2>&1;
        done
    } <<EOF
$VERSION_LIST
EOF

    if [ -n "${LTS-}" ]; then
        if ! LTS="$(nvm_normalize_lts "lts/${LTS}")"; then
            return $?;
        fi;
        LTS="${LTS#lts/}";
    fi;
    VERSIONS="$({ command awk -v lts="${LTS-}" '{
        if (!$1) { next }
        if (lts && $10 ~ /^\-?$/) { next }
        if (lts && lts != "*" && tolower($10) !~ tolower(lts)) { next }
        if ($10 !~ /^\-?$/) {
          if ($10 && $10 != prev) {
            print $1, $10, "*"
          } else {
            print $1, $10
          }
        } else {
          print $1
        }
        prev=$10;
      }' | nvm_grep -w "${PATTERN:-.*}" | $SORT_COMMAND; } <<EOF
$VERSION_LIST
EOF
)";
    if [ -z "${VERSIONS}" ]; then
        nvm_echo 'N/A';
        return 3;
    fi;
    nvm_echo "${VERSIONS}"
}
nvm_ls_remote_iojs () 
{ 
    NVM_LTS="${NVM_LTS-}" nvm_ls_remote_index_tab iojs std "${1-}"
}
nvm_make_alias () 
{ 
    local ALIAS;
    ALIAS="${1-}";
    if [ -z "${ALIAS}" ]; then
        nvm_err "an alias name is required";
        return 1;
    fi;
    local VERSION;
    VERSION="${2-}";
    if [ -z "${VERSION}" ]; then
        nvm_err "an alias target version is required";
        return 2;
    fi;
    nvm_echo "${VERSION}" | tee "$(nvm_alias_path)/${ALIAS}" > /dev/null
}
nvm_match_version () 
{ 
    local NVM_IOJS_PREFIX;
    NVM_IOJS_PREFIX="$(nvm_iojs_prefix)";
    local PROVIDED_VERSION;
    PROVIDED_VERSION="$1";
    case "_${PROVIDED_VERSION}" in 
        "_${NVM_IOJS_PREFIX}" | '_io.js')
            nvm_version "${NVM_IOJS_PREFIX}"
        ;;
        '_system')
            nvm_echo 'system'
        ;;
        *)
            nvm_version "${PROVIDED_VERSION}"
        ;;
    esac
}
nvm_node_prefix () 
{ 
    nvm_echo 'node'
}
nvm_node_version_has_solaris_binary () 
{ 
    local NODE_VERSION;
    NODE_VERSION="$1";
    local STRIPPED_IOJS_VERSION;
    STRIPPED_IOJS_VERSION="$(nvm_strip_iojs_prefix "${NODE_VERSION}")";
    if [ "_${STRIPPED_IOJS_VERSION}" != "_${NODE_VERSION}" ]; then
        return 1;
    fi;
    nvm_version_greater_than_or_equal_to "${NODE_VERSION}" v0.8.6 && ! nvm_version_greater_than_or_equal_to "${NODE_VERSION}" v1.0.0
}
nvm_normalize_lts () 
{ 
    local LTS;
    LTS="${1-}";
    case "${LTS}" in 
        lts/-[123456789] | lts/-[123456789][0123456789]*)
            local N;
            N="$(echo "${LTS}" | cut -d '-' -f 2)";
            N=$((N+1));
            if [ $? -ne 0 ]; then
                nvm_echo "${LTS}";
                return 0;
            fi;
            local NVM_ALIAS_DIR;
            NVM_ALIAS_DIR="$(nvm_alias_path)";
            local RESULT;
            RESULT="$(command ls "${NVM_ALIAS_DIR}/lts" | command tail -n "${N}" | command head -n 1)";
            if [ "${RESULT}" != '*' ]; then
                nvm_echo "lts/${RESULT}";
            else
                nvm_err 'That many LTS releases do not exist yet.';
                return 2;
            fi
        ;;
        *)
            if [ "${LTS}" != "$(echo "${LTS}" | command tr '[:upper:]' '[:lower:]')" ]; then
                nvm_err 'LTS names must be lowercase';
                return 3;
            fi;
            nvm_echo "${LTS}"
        ;;
    esac
}
nvm_normalize_version () 
{ 
    command awk 'BEGIN {
    split(ARGV[1], a, /\./);
    printf "%d%06d%06d\n", a[1], a[2], a[3];
    exit;
  }' "${1#v}"
}
nvm_npm_global_modules () 
{ 
    local NPMLIST;
    local VERSION;
    VERSION="$1";
    NPMLIST=$(nvm use "${VERSION}" > /dev/null && npm list -g --depth=0 2> /dev/null | command sed -e '1d' -e '/UNMET PEER DEPENDENCY/d');
    local INSTALLS;
    INSTALLS=$(nvm_echo "${NPMLIST}" | command sed -e '/ -> / d' -e '/\(empty\)/ d' -e 's/^.* \(.*@[^ ]*\).*/\1/' -e '/^npm@[^ ]*.*$/ d' -e '/^corepack@[^ ]*.*$/ d' | command xargs);
    local LINKS;
    LINKS="$(nvm_echo "${NPMLIST}" | command sed -n 's/.* -> \(.*\)/\1/ p')";
    nvm_echo "${INSTALLS} //// ${LINKS}"
}
nvm_npmrc_bad_news_bears () 
{ 
    local NVM_NPMRC;
    NVM_NPMRC="${1-}";
    if [ -n "${NVM_NPMRC}" ] && [ -f "${NVM_NPMRC}" ] && nvm_grep -Ee '^(prefix|globalconfig) *=' < "${NVM_NPMRC}" > /dev/null; then
        return 0;
    fi;
    return 1
}
nvm_num_version_groups () 
{ 
    local VERSION;
    VERSION="${1-}";
    VERSION="${VERSION#v}";
    VERSION="${VERSION%.}";
    if [ -z "${VERSION}" ]; then
        nvm_echo "0";
        return;
    fi;
    local NVM_NUM_DOTS;
    NVM_NUM_DOTS=$(nvm_echo "${VERSION}" | command sed -e 's/[^\.]//g');
    local NVM_NUM_GROUPS;
    NVM_NUM_GROUPS=".${NVM_NUM_DOTS}";
    nvm_echo "${#NVM_NUM_GROUPS}"
}
nvm_nvmrc_invalid_msg () 
{ 
    local error_text;
    error_text="invalid .nvmrc!
all non-commented content (anything after # is a comment) must be either:
  - a single bare nvm-recognized version-ish
  - or, multiple distinct key-value pairs, each key/value separated by a single equals sign (=)

additionally, a single bare nvm-recognized version-ish must be present (after stripping comments).";
    local warn_text;
    warn_text="non-commented content parsed:
${1}";
    nvm_err "$(nvm_wrap_with_color_code 'r' "${error_text}")

$(nvm_wrap_with_color_code 'y' "${warn_text}")"
}
nvm_print_alias_path () 
{ 
    local NVM_ALIAS_DIR;
    NVM_ALIAS_DIR="${1-}";
    if [ -z "${NVM_ALIAS_DIR}" ]; then
        nvm_err 'An alias dir is required.';
        return 1;
    fi;
    local ALIAS_PATH;
    ALIAS_PATH="${2-}";
    if [ -z "${ALIAS_PATH}" ]; then
        nvm_err 'An alias path is required.';
        return 2;
    fi;
    local ALIAS;
    ALIAS="${ALIAS_PATH##"${NVM_ALIAS_DIR}"\/}";
    local DEST;
    DEST="$(nvm_alias "${ALIAS}" 2> /dev/null)" || :;
    if [ -n "${DEST}" ]; then
        NVM_NO_COLORS="${NVM_NO_COLORS-}" NVM_LTS="${NVM_LTS-}" DEFAULT=false nvm_print_formatted_alias "${ALIAS}" "${DEST}";
    fi
}
nvm_print_color_code () 
{ 
    case "${1-}" in 
        '0')
            return 0
        ;;
        'r')
            nvm_echo '0;31m'
        ;;
        'R')
            nvm_echo '1;31m'
        ;;
        'g')
            nvm_echo '0;32m'
        ;;
        'G')
            nvm_echo '1;32m'
        ;;
        'b')
            nvm_echo '0;34m'
        ;;
        'B')
            nvm_echo '1;34m'
        ;;
        'c')
            nvm_echo '0;36m'
        ;;
        'C')
            nvm_echo '1;36m'
        ;;
        'm')
            nvm_echo '0;35m'
        ;;
        'M')
            nvm_echo '1;35m'
        ;;
        'y')
            nvm_echo '0;33m'
        ;;
        'Y')
            nvm_echo '1;33m'
        ;;
        'k')
            nvm_echo '0;30m'
        ;;
        'K')
            nvm_echo '1;30m'
        ;;
        'e')
            nvm_echo '0;37m'
        ;;
        'W')
            nvm_echo '1;37m'
        ;;
        *)
            nvm_err "Invalid color code: ${1-}";
            return 1
        ;;
    esac
}
nvm_print_default_alias () 
{ 
    local ALIAS;
    ALIAS="${1-}";
    if [ -z "${ALIAS}" ]; then
        nvm_err 'A default alias is required.';
        return 1;
    fi;
    local DEST;
    DEST="$(nvm_print_implicit_alias local "${ALIAS}")";
    if [ -n "${DEST}" ]; then
        NVM_NO_COLORS="${NVM_NO_COLORS-}" DEFAULT=true nvm_print_formatted_alias "${ALIAS}" "${DEST}";
    fi
}
nvm_print_formatted_alias () 
{ 
    local ALIAS;
    ALIAS="${1-}";
    local DEST;
    DEST="${2-}";
    local VERSION;
    VERSION="${3-}";
    if [ -z "${VERSION}" ]; then
        VERSION="$(nvm_version "${DEST}")" || :;
    fi;
    local VERSION_FORMAT;
    local ALIAS_FORMAT;
    local DEST_FORMAT;
    local INSTALLED_COLOR;
    local SYSTEM_COLOR;
    local CURRENT_COLOR;
    local NOT_INSTALLED_COLOR;
    local DEFAULT_COLOR;
    local LTS_COLOR;
    INSTALLED_COLOR=$(nvm_get_colors 1);
    SYSTEM_COLOR=$(nvm_get_colors 2);
    CURRENT_COLOR=$(nvm_get_colors 3);
    NOT_INSTALLED_COLOR=$(nvm_get_colors 4);
    DEFAULT_COLOR=$(nvm_get_colors 5);
    LTS_COLOR=$(nvm_get_colors 6);
    ALIAS_FORMAT='%s';
    DEST_FORMAT='%s';
    VERSION_FORMAT='%s';
    local NEWLINE;
    NEWLINE='\n';
    if [ "_${DEFAULT}" = '_true' ]; then
        NEWLINE=' (default)\n';
    fi;
    local ARROW;
    ARROW='->';
    if nvm_has_colors; then
        ARROW='\033[0;90m->\033[0m';
        if [ "_${DEFAULT}" = '_true' ]; then
            NEWLINE=" \033[${DEFAULT_COLOR}(default)\033[0m\n";
        fi;
        if [ "_${VERSION}" = "_${NVM_CURRENT-}" ]; then
            ALIAS_FORMAT="\033[${CURRENT_COLOR}%s\033[0m";
            DEST_FORMAT="\033[${CURRENT_COLOR}%s\033[0m";
            VERSION_FORMAT="\033[${CURRENT_COLOR}%s\033[0m";
        else
            if nvm_is_version_installed "${VERSION}"; then
                ALIAS_FORMAT="\033[${INSTALLED_COLOR}%s\033[0m";
                DEST_FORMAT="\033[${INSTALLED_COLOR}%s\033[0m";
                VERSION_FORMAT="\033[${INSTALLED_COLOR}%s\033[0m";
            else
                if [ "${VERSION}" = '∞' ] || [ "${VERSION}" = 'N/A' ]; then
                    ALIAS_FORMAT="\033[${NOT_INSTALLED_COLOR}%s\033[0m";
                    DEST_FORMAT="\033[${NOT_INSTALLED_COLOR}%s\033[0m";
                    VERSION_FORMAT="\033[${NOT_INSTALLED_COLOR}%s\033[0m";
                fi;
            fi;
        fi;
        if [ "_${NVM_LTS-}" = '_true' ]; then
            ALIAS_FORMAT="\033[${LTS_COLOR}%s\033[0m";
        fi;
        if [ "_${DEST%/*}" = "_lts" ]; then
            DEST_FORMAT="\033[${LTS_COLOR}%s\033[0m";
        fi;
    else
        if [ "_${VERSION}" != '_∞' ] && [ "_${VERSION}" != '_N/A' ]; then
            VERSION_FORMAT='%s *';
        fi;
    fi;
    if [ "${DEST}" = "${VERSION}" ]; then
        command printf -- "${ALIAS_FORMAT} ${ARROW} ${VERSION_FORMAT}${NEWLINE}" "${ALIAS}" "${DEST}";
    else
        command printf -- "${ALIAS_FORMAT} ${ARROW} ${DEST_FORMAT} (${ARROW} ${VERSION_FORMAT})${NEWLINE}" "${ALIAS}" "${DEST}" "${VERSION}";
    fi
}
nvm_print_implicit_alias () 
{ 
    if [ "_$1" != "_local" ] && [ "_$1" != "_remote" ]; then
        nvm_err "nvm_print_implicit_alias must be specified with local or remote as the first argument.";
        return 1;
    fi;
    local NVM_IMPLICIT;
    NVM_IMPLICIT="$2";
    if ! nvm_validate_implicit_alias "${NVM_IMPLICIT}"; then
        return 2;
    fi;
    local NVM_IOJS_PREFIX;
    NVM_IOJS_PREFIX="$(nvm_iojs_prefix)";
    local NVM_NODE_PREFIX;
    NVM_NODE_PREFIX="$(nvm_node_prefix)";
    local NVM_COMMAND;
    local NVM_ADD_PREFIX_COMMAND;
    local LAST_TWO;
    case "${NVM_IMPLICIT}" in 
        "${NVM_IOJS_PREFIX}")
            NVM_COMMAND="nvm_ls_remote_iojs";
            NVM_ADD_PREFIX_COMMAND="nvm_add_iojs_prefix";
            if [ "_$1" = "_local" ]; then
                NVM_COMMAND="nvm_ls ${NVM_IMPLICIT}";
            fi;
            nvm_is_zsh && setopt local_options shwordsplit;
            local NVM_IOJS_VERSION;
            local EXIT_CODE;
            NVM_IOJS_VERSION="$(${NVM_COMMAND})" && :;
            EXIT_CODE="$?";
            if [ "_${EXIT_CODE}" = "_0" ]; then
                NVM_IOJS_VERSION="$(nvm_echo "${NVM_IOJS_VERSION}" | command sed "s/^${NVM_IMPLICIT}-//" | nvm_grep -e '^v' | command cut -c2- | command cut -d . -f 1,2 | uniq | command tail -1)";
            fi;
            if [ "_$NVM_IOJS_VERSION" = "_N/A" ]; then
                nvm_echo 'N/A';
            else
                ${NVM_ADD_PREFIX_COMMAND} "${NVM_IOJS_VERSION}";
            fi;
            return $EXIT_CODE
        ;;
        "${NVM_NODE_PREFIX}")
            nvm_echo 'stable';
            return
        ;;
        *)
            NVM_COMMAND="nvm_ls_remote";
            if [ "_$1" = "_local" ]; then
                NVM_COMMAND="nvm_ls node";
            fi;
            nvm_is_zsh && setopt local_options shwordsplit;
            LAST_TWO=$($NVM_COMMAND | nvm_grep -e '^v' | command cut -c2- | command cut -d . -f 1,2 | uniq)
        ;;
    esac;
    local MINOR;
    local STABLE;
    local UNSTABLE;
    local MOD;
    local NORMALIZED_VERSION;
    nvm_is_zsh && setopt local_options shwordsplit;
    for MINOR in $LAST_TWO;
    do
        NORMALIZED_VERSION="$(nvm_normalize_version "$MINOR")";
        if [ "_0${NORMALIZED_VERSION#?}" != "_$NORMALIZED_VERSION" ]; then
            STABLE="$MINOR";
        else
            MOD="$(awk 'BEGIN { print int(ARGV[1] / 1000000) % 2 ; exit(0) }' "${NORMALIZED_VERSION}")";
            if [ "${MOD}" -eq 0 ]; then
                STABLE="${MINOR}";
            else
                if [ "${MOD}" -eq 1 ]; then
                    UNSTABLE="${MINOR}";
                fi;
            fi;
        fi;
    done;
    if [ "_$2" = '_stable' ]; then
        nvm_echo "${STABLE}";
    else
        if [ "_$2" = '_unstable' ]; then
            nvm_echo "${UNSTABLE:-"N/A"}";
        fi;
    fi
}
nvm_print_npm_version () 
{ 
    if nvm_has "npm"; then
        local NPM_VERSION;
        NPM_VERSION="$(npm --version 2> /dev/null)";
        if [ -n "${NPM_VERSION}" ]; then
            command printf " (npm v${NPM_VERSION})";
        fi;
    fi
}
nvm_print_versions () 
{ 
    local NVM_CURRENT;
    NVM_CURRENT=$(nvm_ls_current);
    local INSTALLED_COLOR;
    local SYSTEM_COLOR;
    local CURRENT_COLOR;
    local NOT_INSTALLED_COLOR;
    local DEFAULT_COLOR;
    local LTS_COLOR;
    local NVM_HAS_COLORS;
    NVM_HAS_COLORS=0;
    INSTALLED_COLOR=$(nvm_get_colors 1);
    SYSTEM_COLOR=$(nvm_get_colors 2);
    CURRENT_COLOR=$(nvm_get_colors 3);
    NOT_INSTALLED_COLOR=$(nvm_get_colors 4);
    DEFAULT_COLOR=$(nvm_get_colors 5);
    LTS_COLOR=$(nvm_get_colors 6);
    if nvm_has_colors; then
        NVM_HAS_COLORS=1;
    fi;
    command awk -v remote_versions="$(printf '%s' "${1-}" | tr '\n' '|')" -v installed_versions="$(nvm_ls | tr '\n' '|')" -v current="$NVM_CURRENT" -v installed_color="$INSTALLED_COLOR" -v system_color="$SYSTEM_COLOR" -v current_color="$CURRENT_COLOR" -v default_color="$DEFAULT_COLOR" -v old_lts_color="$DEFAULT_COLOR" -v has_colors="$NVM_HAS_COLORS" '
function alen(arr, i, len) { len=0; for(i in arr) len++; return len; }
BEGIN {
  fmt_installed = has_colors ? (installed_color ? "\033[" installed_color "%15s\033[0m" : "%15s") : "%15s *";
  fmt_system = has_colors ? (system_color ? "\033[" system_color "%15s\033[0m" : "%15s") : "%15s *";
  fmt_current = has_colors ? (current_color ? "\033[" current_color "->%13s\033[0m" : "%15s") : "->%13s *";

  latest_lts_color = current_color;
  sub(/0;/, "1;", latest_lts_color);

  fmt_latest_lts = has_colors && latest_lts_color ? ("\033[" latest_lts_color " (Latest LTS: %s)\033[0m") : " (Latest LTS: %s)";
  fmt_old_lts = has_colors && old_lts_color ? ("\033[" old_lts_color " (LTS: %s)\033[0m") : " (LTS: %s)";

  split(remote_versions, lines, "|");
  split(installed_versions, installed, "|");
  rows = alen(lines);

  for (n = 1; n <= rows; n++) {
    split(lines[n], fields, "[[:blank:]]+");
    cols = alen(fields);
    version = fields[1];
    is_installed = 0;

    for (i in installed) {
      if (version == installed[i]) {
        is_installed = 1;
        break;
      }
    }

    fmt_version = "%15s";
    if (version == current) {
      fmt_version = fmt_current;
    } else if (version == "system") {
      fmt_version = fmt_system;
    } else if (is_installed) {
      fmt_version = fmt_installed;
    }

    padding = (!has_colors && is_installed) ? "" : "  ";

    if (cols == 1) {
      formatted = sprintf(fmt_version, version);
    } else if (cols == 2) {
      formatted = sprintf((fmt_version padding fmt_old_lts), version, fields[2]);
    } else if (cols == 3 && fields[3] == "*") {
      formatted = sprintf((fmt_version padding fmt_latest_lts), version, fields[2]);
    }

    output[n] = formatted;
  }

  for (n = 1; n <= rows; n++) {
    print output[n]
  }

  exit
}'
}
nvm_process_nvmrc () 
{ 
    local NVMRC_PATH;
    NVMRC_PATH="$1";
    local lines;
    lines=$(command sed 's/#.*//' "$NVMRC_PATH" | command sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | nvm_grep -v '^$');
    if [ -z "$lines" ]; then
        nvm_nvmrc_invalid_msg "${lines}";
        return 1;
    fi;
    local keys;
    keys='';
    local values;
    values='';
    local unpaired_line;
    unpaired_line='';
    while IFS= read -r line; do
        if [ -z "${line}" ]; then
            continue;
        else
            if [ -z "${line%%=*}" ]; then
                if [ -n "${unpaired_line}" ]; then
                    nvm_nvmrc_invalid_msg "${lines}";
                    return 1;
                fi;
                unpaired_line="${line}";
            else
                if case "$line" in 
                    *'='*)
                        true
                    ;;
                    *)
                        false
                    ;;
                esac; then
                    key="${line%%=*}";
                    value="${line#*=}";
                    key=$(nvm_echo "${key}" | command sed 's/^[[:space:]]*//;s/[[:space:]]*$//');
                    value=$(nvm_echo "${value}" | command sed 's/^[[:space:]]*//;s/[[:space:]]*$//');
                    if [ "${key}" = 'node' ]; then
                        nvm_nvmrc_invalid_msg "${lines}";
                        return 1;
                    fi;
                    if nvm_echo "${keys}" | nvm_grep -q -E "(^| )${key}( |$)"; then
                        nvm_nvmrc_invalid_msg "${lines}";
                        return 1;
                    fi;
                    keys="${keys} ${key}";
                    values="${values} ${value}";
                else
                    if [ -n "${unpaired_line}" ]; then
                        nvm_nvmrc_invalid_msg "${lines}";
                        return 1;
                    fi;
                    unpaired_line="${line}";
                fi;
            fi;
        fi;
    done <<EOF
$lines
EOF

    if [ -z "${unpaired_line}" ]; then
        nvm_nvmrc_invalid_msg "${lines}";
        return 1;
    fi;
    nvm_echo "${unpaired_line}"
}
nvm_process_parameters () 
{ 
    local NVM_AUTO_MODE;
    NVM_AUTO_MODE='use';
    while [ "$#" -ne 0 ]; do
        case "$1" in 
            --install)
                NVM_AUTO_MODE='install'
            ;;
            --no-use)
                NVM_AUTO_MODE='none'
            ;;
        esac;
        shift;
    done;
    nvm_auto "${NVM_AUTO_MODE}"
}
nvm_rc_version () 
{ 
    export NVM_RC_VERSION='';
    local NVMRC_PATH;
    NVMRC_PATH="$(nvm_find_nvmrc)";
    if [ ! -e "${NVMRC_PATH}" ]; then
        if [ "${NVM_SILENT:-0}" -ne 1 ]; then
            nvm_err "No .nvmrc file found";
        fi;
        return 1;
    fi;
    if ! NVM_RC_VERSION="$(nvm_process_nvmrc "${NVMRC_PATH}")"; then
        return 1;
    fi;
    if [ -z "${NVM_RC_VERSION}" ]; then
        if [ "${NVM_SILENT:-0}" -ne 1 ]; then
            nvm_err "Warning: empty .nvmrc file found at \"${NVMRC_PATH}\"";
        fi;
        return 2;
    fi;
    if [ "${NVM_SILENT:-0}" -ne 1 ]; then
        nvm_echo "Found '${NVMRC_PATH}' with version <${NVM_RC_VERSION}>";
    fi
}
nvm_remote_version () 
{ 
    local PATTERN;
    PATTERN="${1-}";
    local VERSION;
    if nvm_validate_implicit_alias "${PATTERN}" 2> /dev/null; then
        case "${PATTERN}" in 
            "$(nvm_iojs_prefix)")
                VERSION="$(NVM_LTS="${NVM_LTS-}" nvm_ls_remote_iojs | command tail -1)" && :
            ;;
            *)
                VERSION="$(NVM_LTS="${NVM_LTS-}" nvm_ls_remote "${PATTERN}")" && :
            ;;
        esac;
    else
        VERSION="$(NVM_LTS="${NVM_LTS-}" nvm_remote_versions "${PATTERN}" | command tail -1)";
    fi;
    if [ -n "${NVM_VERSION_ONLY-}" ]; then
        command awk 'BEGIN {
      n = split(ARGV[1], a);
      print a[1]
    }' "${VERSION}";
    else
        nvm_echo "${VERSION}";
    fi;
    if [ "${VERSION}" = 'N/A' ]; then
        return 3;
    fi
}
nvm_remote_versions () 
{ 
    local NVM_IOJS_PREFIX;
    NVM_IOJS_PREFIX="$(nvm_iojs_prefix)";
    local NVM_NODE_PREFIX;
    NVM_NODE_PREFIX="$(nvm_node_prefix)";
    local PATTERN;
    PATTERN="${1-}";
    local NVM_FLAVOR;
    if [ -n "${NVM_LTS-}" ]; then
        NVM_FLAVOR="${NVM_NODE_PREFIX}";
    fi;
    case "${PATTERN}" in 
        "${NVM_IOJS_PREFIX}" | "io.js")
            NVM_FLAVOR="${NVM_IOJS_PREFIX}";
            unset PATTERN
        ;;
        "${NVM_NODE_PREFIX}")
            NVM_FLAVOR="${NVM_NODE_PREFIX}";
            unset PATTERN
        ;;
    esac;
    if nvm_validate_implicit_alias "${PATTERN-}" 2> /dev/null; then
        nvm_err 'Implicit aliases are not supported in nvm_remote_versions.';
        return 1;
    fi;
    local NVM_LS_REMOTE_EXIT_CODE;
    NVM_LS_REMOTE_EXIT_CODE=0;
    local NVM_LS_REMOTE_PRE_MERGED_OUTPUT;
    NVM_LS_REMOTE_PRE_MERGED_OUTPUT='';
    local NVM_LS_REMOTE_POST_MERGED_OUTPUT;
    NVM_LS_REMOTE_POST_MERGED_OUTPUT='';
    if [ -z "${NVM_FLAVOR-}" ] || [ "${NVM_FLAVOR-}" = "${NVM_NODE_PREFIX}" ]; then
        local NVM_LS_REMOTE_OUTPUT;
        NVM_LS_REMOTE_OUTPUT="$(NVM_LTS="${NVM_LTS-}" nvm_ls_remote "${PATTERN-}") " && :;
        NVM_LS_REMOTE_EXIT_CODE=$?;
        NVM_LS_REMOTE_PRE_MERGED_OUTPUT="${NVM_LS_REMOTE_OUTPUT%%v4\.0\.0*}";
        NVM_LS_REMOTE_POST_MERGED_OUTPUT="${NVM_LS_REMOTE_OUTPUT#"$NVM_LS_REMOTE_PRE_MERGED_OUTPUT"}";
    fi;
    local NVM_LS_REMOTE_IOJS_EXIT_CODE;
    NVM_LS_REMOTE_IOJS_EXIT_CODE=0;
    local NVM_LS_REMOTE_IOJS_OUTPUT;
    NVM_LS_REMOTE_IOJS_OUTPUT='';
    if [ -z "${NVM_LTS-}" ] && { 
        [ -z "${NVM_FLAVOR-}" ] || [ "${NVM_FLAVOR-}" = "${NVM_IOJS_PREFIX}" ]
    }; then
        NVM_LS_REMOTE_IOJS_OUTPUT=$(nvm_ls_remote_iojs "${PATTERN-}") && :;
        NVM_LS_REMOTE_IOJS_EXIT_CODE=$?;
    fi;
    VERSIONS="$(nvm_echo "${NVM_LS_REMOTE_PRE_MERGED_OUTPUT}
${NVM_LS_REMOTE_IOJS_OUTPUT}
${NVM_LS_REMOTE_POST_MERGED_OUTPUT}" | nvm_grep -v "N/A" | command sed '/^ *$/d')";
    if [ -z "${VERSIONS}" ]; then
        nvm_echo 'N/A';
        return 3;
    fi;
    nvm_echo "${VERSIONS}" | command sed 's/ *$//g';
    return $NVM_LS_REMOTE_EXIT_CODE || $NVM_LS_REMOTE_IOJS_EXIT_CODE
}
nvm_resolve_alias () 
{ 
    if [ -z "${1-}" ]; then
        return 1;
    fi;
    local PATTERN;
    PATTERN="${1-}";
    local ALIAS;
    ALIAS="${PATTERN}";
    local ALIAS_TEMP;
    local SEEN_ALIASES;
    SEEN_ALIASES="${ALIAS}";
    local NVM_ALIAS_INDEX;
    NVM_ALIAS_INDEX=1;
    while true; do
        ALIAS_TEMP="$( ( nvm_alias "${ALIAS}" 2> /dev/null | command head -n "${NVM_ALIAS_INDEX}" | command tail -n 1 ) || nvm_echo)";
        if [ -z "${ALIAS_TEMP}" ]; then
            break;
        fi;
        if command printf "${SEEN_ALIASES}" | nvm_grep -q -e "^${ALIAS_TEMP}$"; then
            ALIAS="∞";
            break;
        fi;
        SEEN_ALIASES="${SEEN_ALIASES}\\n${ALIAS_TEMP}";
        ALIAS="${ALIAS_TEMP}";
    done;
    if [ -n "${ALIAS}" ] && [ "_${ALIAS}" != "_${PATTERN}" ]; then
        local NVM_IOJS_PREFIX;
        NVM_IOJS_PREFIX="$(nvm_iojs_prefix)";
        local NVM_NODE_PREFIX;
        NVM_NODE_PREFIX="$(nvm_node_prefix)";
        case "${ALIAS}" in 
            '∞' | "${NVM_IOJS_PREFIX}" | "${NVM_IOJS_PREFIX}-" | "${NVM_NODE_PREFIX}")
                nvm_echo "${ALIAS}"
            ;;
            *)
                nvm_ensure_version_prefix "${ALIAS}"
            ;;
        esac;
        return 0;
    fi;
    if nvm_validate_implicit_alias "${PATTERN}" 2> /dev/null; then
        local IMPLICIT;
        IMPLICIT="$(nvm_print_implicit_alias local "${PATTERN}" 2> /dev/null)";
        if [ -n "${IMPLICIT}" ]; then
            nvm_ensure_version_prefix "${IMPLICIT}";
        fi;
    fi;
    return 2
}
nvm_resolve_local_alias () 
{ 
    if [ -z "${1-}" ]; then
        return 1;
    fi;
    local VERSION;
    local EXIT_CODE;
    VERSION="$(nvm_resolve_alias "${1-}")";
    EXIT_CODE=$?;
    if [ -z "${VERSION}" ]; then
        return $EXIT_CODE;
    fi;
    if [ "_${VERSION}" != '_∞' ]; then
        nvm_version "${VERSION}";
    else
        nvm_echo "${VERSION}";
    fi
}
nvm_sanitize_auth_header () 
{ 
    nvm_echo "$1" | command sed 's/[^a-zA-Z0-9:;_. -]//g'
}
nvm_sanitize_path () 
{ 
    local SANITIZED_PATH;
    SANITIZED_PATH="${1-}";
    if [ "_${SANITIZED_PATH}" != "_${NVM_DIR}" ]; then
        SANITIZED_PATH="$(nvm_echo "${SANITIZED_PATH}" | command sed -e "s#${NVM_DIR}#\${NVM_DIR}#g")";
    fi;
    if [ "_${SANITIZED_PATH}" != "_${HOME}" ]; then
        SANITIZED_PATH="$(nvm_echo "${SANITIZED_PATH}" | command sed -e "s#${HOME}#\${HOME}#g")";
    fi;
    nvm_echo "${SANITIZED_PATH}"
}
nvm_set_colors () 
{ 
    if [ "${#1}" -eq 5 ] && nvm_echo "$1" | nvm_grep -E "^[rRgGbBcCyYmMkKeW]{1,}$" > /dev/null; then
        local INSTALLED_COLOR;
        local LTS_AND_SYSTEM_COLOR;
        local CURRENT_COLOR;
        local NOT_INSTALLED_COLOR;
        local DEFAULT_COLOR;
        INSTALLED_COLOR="$(echo "$1" | awk '{ print substr($0, 1, 1); }')";
        LTS_AND_SYSTEM_COLOR="$(echo "$1" | awk '{ print substr($0, 2, 1); }')";
        CURRENT_COLOR="$(echo "$1" | awk '{ print substr($0, 3, 1); }')";
        NOT_INSTALLED_COLOR="$(echo "$1" | awk '{ print substr($0, 4, 1); }')";
        DEFAULT_COLOR="$(echo "$1" | awk '{ print substr($0, 5, 1); }')";
        if ! nvm_has_colors; then
            nvm_echo "Setting colors to: ${INSTALLED_COLOR} ${LTS_AND_SYSTEM_COLOR} ${CURRENT_COLOR} ${NOT_INSTALLED_COLOR} ${DEFAULT_COLOR}";
            nvm_echo "WARNING: Colors may not display because they are not supported in this shell.";
        else
            nvm_echo_with_colors "Setting colors to: $(nvm_wrap_with_color_code "${INSTALLED_COLOR}" "${INSTALLED_COLOR}")$(nvm_wrap_with_color_code "${LTS_AND_SYSTEM_COLOR}" "${LTS_AND_SYSTEM_COLOR}")$(nvm_wrap_with_color_code "${CURRENT_COLOR}" "${CURRENT_COLOR}")$(nvm_wrap_with_color_code "${NOT_INSTALLED_COLOR}" "${NOT_INSTALLED_COLOR}")$(nvm_wrap_with_color_code "${DEFAULT_COLOR}" "${DEFAULT_COLOR}")";
        fi;
        export NVM_COLORS="$1";
    else
        return 17;
    fi
}
nvm_stdout_is_terminal () 
{ 
    [ -t 1 ]
}
nvm_strip_iojs_prefix () 
{ 
    local NVM_IOJS_PREFIX;
    NVM_IOJS_PREFIX="$(nvm_iojs_prefix)";
    case "${1-}" in 
        "${NVM_IOJS_PREFIX}")
            nvm_echo
        ;;
        *)
            nvm_echo "${1#"${NVM_IOJS_PREFIX}"-}"
        ;;
    esac
}
nvm_strip_path () 
{ 
    if [ -z "${NVM_DIR-}" ]; then
        nvm_err '${NVM_DIR} not set!';
        return 1;
    fi;
    command printf %s "${1-}" | command awk -v NVM_DIR="${NVM_DIR}" -v RS=: '
  index($0, NVM_DIR) == 1 {
    path = substr($0, length(NVM_DIR) + 1)
    if (path ~ "^(/versions/[^/]*)?/[^/]*'"${2-}"'.*$") { next }
  }
  # The final RT will contain a colon if the input has a trailing colon, or a null string otherwise
  { printf "%s%s", sep, $0; sep=RS } END { printf "%s", RT }'
}
nvm_supports_xz () 
{ 
    if [ -z "${1-}" ]; then
        return 1;
    fi;
    local NVM_OS;
    NVM_OS="$(nvm_get_os)";
    if [ "_${NVM_OS}" = '_darwin' ]; then
        local MACOS_VERSION;
        MACOS_VERSION="$(sw_vers -productVersion)";
        if nvm_version_greater "10.9.0" "${MACOS_VERSION}"; then
            return 1;
        fi;
    else
        if [ "_${NVM_OS}" = '_freebsd' ]; then
            if ! [ -e '/usr/lib/liblzma.so' ]; then
                return 1;
            fi;
        else
            if ! command which xz > /dev/null 2>&1; then
                return 1;
            fi;
        fi;
    fi;
    if nvm_is_merged_node_version "${1}"; then
        return 0;
    fi;
    if nvm_version_greater_than_or_equal_to "${1}" "0.12.10" && nvm_version_greater "0.13.0" "${1}"; then
        return 0;
    fi;
    if nvm_version_greater_than_or_equal_to "${1}" "0.10.42" && nvm_version_greater "0.11.0" "${1}"; then
        return 0;
    fi;
    case "${NVM_OS}" in 
        darwin)
            nvm_version_greater_than_or_equal_to "${1}" "2.3.2"
        ;;
        *)
            nvm_version_greater_than_or_equal_to "${1}" "1.0.0"
        ;;
    esac;
    return $?
}
nvm_tree_contains_path () 
{ 
    local tree;
    tree="${1-}";
    local node_path;
    node_path="${2-}";
    if [ "@${tree}@" = "@@" ] || [ "@${node_path}@" = "@@" ]; then
        nvm_err "both the tree and the node path are required";
        return 2;
    fi;
    local previous_pathdir;
    previous_pathdir="${node_path}";
    local pathdir;
    pathdir=$(dirname "${previous_pathdir}");
    while [ "${pathdir}" != '' ] && [ "${pathdir}" != '.' ] && [ "${pathdir}" != '/' ] && [ "${pathdir}" != "${tree}" ] && [ "${pathdir}" != "${previous_pathdir}" ]; do
        previous_pathdir="${pathdir}";
        pathdir=$(dirname "${previous_pathdir}");
    done;
    [ "${pathdir}" = "${tree}" ]
}
nvm_use_if_needed () 
{ 
    if [ "_${1-}" = "_$(nvm_ls_current)" ]; then
        return;
    fi;
    nvm use "$@"
}
nvm_validate_implicit_alias () 
{ 
    local NVM_IOJS_PREFIX;
    NVM_IOJS_PREFIX="$(nvm_iojs_prefix)";
    local NVM_NODE_PREFIX;
    NVM_NODE_PREFIX="$(nvm_node_prefix)";
    case "$1" in 
        "stable" | "unstable" | "${NVM_IOJS_PREFIX}" | "${NVM_NODE_PREFIX}")
            return
        ;;
        *)
            nvm_err "Only implicit aliases 'stable', 'unstable', '${NVM_IOJS_PREFIX}', and '${NVM_NODE_PREFIX}' are supported.";
            return 1
        ;;
    esac
}
nvm_version () 
{ 
    local PATTERN;
    PATTERN="${1-}";
    local VERSION;
    if [ -z "${PATTERN}" ]; then
        PATTERN='current';
    fi;
    if [ "${PATTERN}" = "current" ]; then
        nvm_ls_current;
        return $?;
    fi;
    local NVM_NODE_PREFIX;
    NVM_NODE_PREFIX="$(nvm_node_prefix)";
    case "_${PATTERN}" in 
        "_${NVM_NODE_PREFIX}" | "_${NVM_NODE_PREFIX}-")
            PATTERN="stable"
        ;;
    esac;
    VERSION="$(nvm_ls "${PATTERN}" | command tail -1)";
    if [ -z "${VERSION}" ] || [ "_${VERSION}" = "_N/A" ]; then
        nvm_echo "N/A";
        return 3;
    fi;
    nvm_echo "${VERSION}"
}
nvm_version_dir () 
{ 
    local NVM_WHICH_DIR;
    NVM_WHICH_DIR="${1-}";
    if [ -z "${NVM_WHICH_DIR}" ] || [ "${NVM_WHICH_DIR}" = "new" ]; then
        nvm_echo "${NVM_DIR}/versions/node";
    else
        if [ "_${NVM_WHICH_DIR}" = "_iojs" ]; then
            nvm_echo "${NVM_DIR}/versions/io.js";
        else
            if [ "_${NVM_WHICH_DIR}" = "_old" ]; then
                nvm_echo "${NVM_DIR}";
            else
                nvm_err 'unknown version dir';
                return 3;
            fi;
        fi;
    fi
}
nvm_version_greater () 
{ 
    command awk 'BEGIN {
    if (ARGV[1] == "" || ARGV[2] == "") exit(1)
    split(ARGV[1], a, /\./);
    split(ARGV[2], b, /\./);
    for (i=1; i<=3; i++) {
      if (a[i] && a[i] !~ /^[0-9]+$/) exit(2);
      if (b[i] && b[i] !~ /^[0-9]+$/) { exit(0); }
      if (a[i] < b[i]) exit(3);
      else if (a[i] > b[i]) exit(0);
    }
    exit(4)
  }' "${1#v}" "${2#v}"
}
nvm_version_greater_than_or_equal_to () 
{ 
    command awk 'BEGIN {
    if (ARGV[1] == "" || ARGV[2] == "") exit(1)
    split(ARGV[1], a, /\./);
    split(ARGV[2], b, /\./);
    for (i=1; i<=3; i++) {
      if (a[i] && a[i] !~ /^[0-9]+$/) exit(2);
      if (a[i] < b[i]) exit(3);
      else if (a[i] > b[i]) exit(0);
    }
    exit(0)
  }' "${1#v}" "${2#v}"
}
nvm_version_path () 
{ 
    local VERSION;
    VERSION="${1-}";
    if [ -z "${VERSION}" ]; then
        nvm_err 'version is required';
        return 3;
    else
        if nvm_is_iojs_version "${VERSION}"; then
            nvm_echo "$(nvm_version_dir iojs)/$(nvm_strip_iojs_prefix "${VERSION}")";
        else
            if nvm_version_greater 0.12.0 "${VERSION}"; then
                nvm_echo "$(nvm_version_dir old)/${VERSION}";
            else
                nvm_echo "$(nvm_version_dir new)/${VERSION}";
            fi;
        fi;
    fi
}
nvm_wrap_with_color_code () 
{ 
    local CODE;
    CODE="$(nvm_print_color_code "${1}" 2> /dev/null || :)";
    local TEXT;
    TEXT="${2-}";
    if nvm_has_colors && [ -n "${CODE}" ]; then
        nvm_echo_with_colors "\033[${CODE}${TEXT}\033[0m";
    else
        nvm_echo "${TEXT}";
    fi
}
nvm_write_nvmrc () 
{ 
    local VERSION_STRING;
    VERSION_STRING=$(nvm_version "${1-}");
    if [ "${VERSION_STRING}" = '∞' ] || [ "${VERSION_STRING}" = 'N/A' ]; then
        return 1;
    fi;
    echo "${VERSION_STRING}" | tee "$PWD"/.nvmrc > /dev/null || { 
        if [ "${NVM_SILENT:-0}" -ne 1 ]; then
            nvm_err "Warning: Unable to write version number ($VERSION_STRING) to .nvmrc";
        fi;
        return 3
    };
    if [ "${NVM_SILENT:-0}" -ne 1 ]; then
        nvm_echo "Wrote version number ($VERSION_STRING) to .nvmrc";
    fi
}
pyenv () 
{ 
    local command=${1:-};
    [ "$#" -gt 0 ] && shift;
    case "$command" in 
        activate | deactivate | rehash | shell)
            eval "$(pyenv "sh-$command" "$@")"
        ;;
        *)
            command pyenv "$command" "$@"
        ;;
    esac
}
quote () 
{ 
    local quoted=${1//\'/\'\\\'\'};
    printf "'%s'" "$quoted"
}
quote_readline () 
{ 
    local ret;
    _quote_readline_by_ref "$1" ret;
    printf %s "$ret"
}
starship_precmd () 
{ 
    STARSHIP_CMD_STATUS=$? STARSHIP_PIPE_STATUS=("${PIPESTATUS[@]}");
    if [[ -n ${BLE_ATTACHED-} && ${#BLE_PIPESTATUS[@]} -gt 0 ]]; then
        STARSHIP_PIPE_STATUS=("${BLE_PIPESTATUS[@]}");
    fi;
    if [[ -n "${BP_PIPESTATUS-}" ]] && [[ "${#BP_PIPESTATUS[@]}" -gt 0 ]]; then
        STARSHIP_PIPE_STATUS=("${BP_PIPESTATUS[@]}");
    fi;
    jobs &> /dev/null;
    local job NUM_JOBS=0 IFS=' 	
';
    for job in $(jobs -p);
    do
        [[ -n $job ]] && ((NUM_JOBS++));
    done;
    "${starship_precmd_user_func-:}";
    _starship_set_return "$STARSHIP_CMD_STATUS";
    if [[ -n "${STARSHIP_PROMPT_COMMAND-}" ]]; then
        eval "$STARSHIP_PROMPT_COMMAND";
    fi;
    local -a ARGS=(--terminal-width="${COLUMNS}" --status="${STARSHIP_CMD_STATUS}" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --jobs="${NUM_JOBS}" --shlvl="${SHLVL}");
    if [[ -n "${STARSHIP_START_TIME-}" ]]; then
        STARSHIP_END_TIME=$(/usr/local/bin/starship time);
        STARSHIP_DURATION=$((STARSHIP_END_TIME - STARSHIP_START_TIME));
        ARGS+=(--cmd-duration="${STARSHIP_DURATION}");
        STARSHIP_START_TIME="";
    fi;
    PS1="$(/usr/local/bin/starship prompt "${ARGS[@]}")";
    if [[ -n ${BLE_ATTACHED-} ]]; then
        local nlns=${PS1//[!'
']};
        bleopt prompt_rps1="$nlns$(/usr/local/bin/starship prompt --right "${ARGS[@]}")";
    fi;
    STARSHIP_PREEXEC_READY=true
}
starship_preexec () 
{ 
    local PREV_LAST_ARG=$1;
    if [ "${STARSHIP_PREEXEC_READY:-}" = "true" ]; then
        STARSHIP_PREEXEC_READY=false;
        STARSHIP_START_TIME=$(/usr/local/bin/starship time);
    fi;
    : "$PREV_LAST_ARG"
}
starship_preexec_ps0 () 
{ 
    /usr/local/bin/starship time
}
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
