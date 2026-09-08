alias vim='nvim'
alias vi='nvim'
alias tlist='tmux list-sessions'
alias tkill='tmux kill-session -t'
alias tkillser='tmux kill-server'
alias vnv='. venv/bin/activate'
alias cl='clear'
alias syncserv='rsync -av --progress "/mnt/c/Users/catri/Downloads/files_for_server/" "alphacatpotat@192.168.1.107:/media/drive1/Torrents/"'
alias syncpotats='rsync -av --delete --info=progress2 "$HOME/projects/potats-place/dist/" "crowley:/srv/potatsplace/"'
alias datanotes='vi "/mnt/a/catri/Documents/Some Notes/Warlock Software/Tasks/cablepull-prisma-migration.md"'
WHISPER_BIN="$HOME/whispercpp/build/bin/whisper-cli"
WHISPER_MODEL="$HOME/whispercpp/models/ggml-large-v3-turbo.bin"
WHISPER_PROMPT_FILE="$HOME/dnd/campaign-nouns.txt"

dndscribe () {
	local input="$1"

	if [ -z "$input"]; then
		echo "usage: dndscribe <audio-file>"
		return 1
	fi

	local wav="${input%.*}.16k.wav"

	ffmpeg -hide_banner -loglevel error -y \
	-i "$input" -ar 16000 -ac 1 -c:a pcm_s16le "$wav" || return 1

	"$WHISPER_BIN" \
	-m "$WHISPER_MODEL" \
	-f "$wav" \
	-otxt -osrt -pp \
	--prompt "$(cat "$WHISPER_PROMPT_FILE" 2>/dev/null)"
}
