#!/usr/bin/env bash
# Shamelessly stolen from junegunn/fzf.vim
# Link: (https://github.com/junegunn/fzf.vim/blob/master/bin/preview.sh)
#
# Modified to hide some env files in the preview window when using bat
# Helpful when streaming or making videos especially when used together with cloak
# Link: (https://github.com/laytan/cloak.nvim)

REVERSE="\x1b[7m"
RESET="\x1b[m"

if [[ $# -lt 1 ]]; then
  echo "usage: $0 [--tag] FILENAME[:LINENO][:IGNORED]"
  exit 1
fi

if [[ $1 = --tag ]]; then
  shift
  "$(dirname "${BASH_SOURCE[0]}")/tagpreview.sh" "$@"
  exit $?
fi

# Ignore if an empty path is given
[[ -z $1 ]] && exit

IFS=':' read -r -a INPUT <<< "$1"
FILE=${INPUT[0]}
CENTER=${INPUT[1]}

if [[ "$1" =~ ^[A-Za-z]:\\ ]]; then
  FILE=$FILE:${INPUT[1]}
  CENTER=${INPUT[2]}
fi

if [[ -n "$CENTER" && ! "$CENTER" =~ ^[0-9] ]]; then
  exit 1
fi
CENTER=${CENTER/[^0-9]*/}

# MS Win support
if [[ "$FILE" =~ '\' ]]; then
  if [ -z "$MSWINHOME" ]; then
    MSWINHOME="$HOMEDRIVE$HOMEPATH"
  fi
  if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    MSWINHOME="${MSWINHOME//\\/\\\\}"
    FILE="${FILE/#\~\\/$MSWINHOME\\}"
    FILE=$(wslpath -u "$FILE")
  elif [ -n "$MSWINHOME" ]; then
    FILE="${FILE/#\~\\/$MSWINHOME\\}"
  fi
fi

FILE="${FILE/#\~\//$HOME/}"
if [ ! -r "$FILE" ]; then
  echo "File not found ${FILE}"
  exit 1
fi

if [ -z "$CENTER" ]; then
  CENTER=0
fi

# Sometimes bat is installed as batcat.
if command -v batcat > /dev/null; then
  BATNAME="batcat"
elif command -v bat > /dev/null; then
  BATNAME="bat"
fi

# using BAT as the previewer
if [ -z "$FZF_PREVIEW_COMMAND" ] && [ "${BATNAME:+x}" ]; then
  # Don't show sensitive file contents in the preview window
  case "$FILE" in
    *tfvars | *.env | *.tfstate | *.pub | *.pem | *.asc)
      echo "$FILE: file contains sensitive information"
      exit $?
      ;;
    *)
      ${BATNAME} --style="${BAT_STYLE:-numbers}" --color=always --pager=never \
          --highlight-line=$CENTER -- "$FILE"
      exit $?
      ;;
  esac

fi

FILE_LENGTH=${#FILE}
MIME=$(file --dereference --mime -- "$FILE")
if [[ "${MIME:FILE_LENGTH}" =~ binary ]]; then
  echo "$MIME"
  exit 0
fi

DEFAULT_COMMAND="highlight -O ansi -l {} || coderay {} || rougify {} || cat {}"
CMD=${FZF_PREVIEW_COMMAND:-$DEFAULT_COMMAND}
CMD=${CMD//{\}/$(printf %q "$FILE")}

eval "$CMD" 2> /dev/null | awk "{ \
    if (NR == $CENTER) \
        { gsub(/\x1b[[0-9;]*m/, \"&$REVERSE\"); printf(\"$REVERSE%s\n$RESET\", \$0); } \
    else printf(\"$RESET%s\n\", \$0); \
    }"
