# Useful functions
# Taken from an old env
# Likely from oh-my-zsh's git plugin
git_current_branch () {
	local ref
	ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
	local ret=$?
	if [[ $ret != 0 ]]
	then
		[[ $ret == 128 ]] && return
		ref=$(command git rev-parse --short HEAD 2> /dev/null)  || return
	fi
	echo ${ref#refs/heads/}
}

gh_browse () {
	gh browse -b $(git_current_branch)
}

# Unlock Bitwarden and cache the session for mbsync/msmtp/mu4e's bw-mail-pass
bw-unlock () {
	export BW_SESSION=$(bw unlock --raw)
	mkdir -p ~/.cache
	echo "$BW_SESSION" > ~/.cache/bw-session
	chmod 600 ~/.cache/bw-session
}
