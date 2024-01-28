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

tag_em () {
	export TAG=$(git branch --show-current)-$(date -u '+%Y%m%d%H%M%S')-buildartifacts
	git tag "${TAG}" && git push origin "${TAG}"
}

# note, using (, not { to invoke a subshells where I can set errexit and pipefail
function encrypt_secret() (
	set -o errexit -o pipefail
    if [[ -z ${1} || -z ${2} || -z ${3} ]]; then
        (>&2 echo "Must pass account, keyId and region to encrypt a secret")
        return false
    fi
    KMS_KEY_PREFIX=${KMS_KEY_PREFIX:-}
    DONE=false
    plaintext=''
    until $DONE ;do
        read -s LINE || DONE=true
        plaintext="${plaintext}${LINE}"
        if ! $DONE; then plaintext="${plaintext}\n"; fi
    done
    aws kms encrypt --profile ${1} --key-id ${KMS_KEY_PREFIX}${2} --region ${3} --plaintext fileb://<(printf "${plaintext}") --query CiphertextBlob --output text
)

function encrypt_app_secret() (
	if [[ -z ${1} || -z ${2} || -z ${3} ]]; then
        (>&2 echo "Must pass account, app and region to encrypt a secret")
        return false
    fi
    KMS_KEY_PREFIX='alias/secrets/' encrypt_secret ${1} ${2} ${3}
)

function decrypt_secret() (
    set -o errexit -o pipefail
    if [[ -z ${1} || -z ${2} ]]; then
        (>&2 echo "Must pass profile and encrypted text to decrypt a secret")
        return false
    fi
    decrypt_result=$(aws kms decrypt --profile ${1} --ciphertext-blob fileb://<(echo ${2} | base64 --decode))
    # Write the encryption key info to stderr
    key_id=$( echo $decrypt_result |  jq -r .KeyId )
    key_desc=$( aws kms describe-key --profile ${1} --key-id $key_id | jq -r .KeyMetadata.Description )
    echo "Encrypted with $key_desc" 1>&2

    # Write the plaintext to stdout (note: this won't include a newline so you can't feed the result directly into encrypt_app_secret)
    echo $decrypt_result | jq -r .Plaintext | base64 --decode
)

# $ encrypt_app_secret dev core-web-app us-east-1 | pbcopy
# $ encrypt_app_secret load core-web-app us-east-1 | pbcopy
# $ encrypt_app_secret prod core-web-app us-east-1 | pbcopy
# $ encrypt_app_secret stage core-web-app us-east-1 | pbcopy
# $ encrypt_app_secret dev dwapi us-east-1 | pbcopy
