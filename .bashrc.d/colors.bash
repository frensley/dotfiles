# With thanks to Todd Werth
# http://blog.infinitered.com/entries/show/4

# Colors!

ANSI_RESET='0'
ANSI_BOLD='1'
ANSI_TEXT='3'
ANSI_BG='4'
ANSI_BLACK='0'
ANSI_RED='1'
ANSI_GREEN='2'
ANSI_YELLOW='3'
ANSI_BLUE='4'
ANSI_MAGENTA='5'
ANSI_CYAN='6'
ANSI_WHITE='7'

ansi_text() {
    local OPTIND OPTERR
    local color_name color background style="${ANSI_RESET}"
    while getopts "c:g:b" opt; do
        case "${opt}" in
            c)
                color_name="ANSI_${OPTARG}"
                [[ -n "${!color_name}" ]] &&
                    color="${ANSI_TEXT}${!color_name}"
                ;;
            g)
                color_name="ANSI_${OPTARG}"
                [[ -n "${!color_name}" ]] &&
                    background="${ANSI_BG}${!color_name}"
                ;;
            b)
                style="${ANSI_BOLD}"
                ;;
        esac
    done
    echo "${style}${color:+;${color}}${background:+;${background}}"
}

COLOR_NC="\033[$(ansi_text)m" # No Color
COLOR_NC_BOLD="\033[$(ansi_text -b)m" # No Color

COLOR_BLACK="\033[$(ansi_text -c BLACK)m"
COLOR_RED="\033[$(ansi_text -c RED)m"
COLOR_GREEN="\033[$(ansi_text -c GREEN)m"
COLOR_YELLOW="\033[$(ansi_text -c YELLOW)m"
COLOR_BLUE="\033[$(ansi_text -c BLUE)m"
COLOR_MAGENTA="\033[$(ansi_text -c MAGENTA)m"
COLOR_CYAN="\033[$(ansi_text -c CYAN)m"
COLOR_WHITE="\033[$(ansi_text -c WHITE)m"

COLOR_BLACK_BOLD="\033[$(ansi_text -b -c BLACK)m"
COLOR_RED_BOLD="\033[$(ansi_text -b -c RED)m"
COLOR_GREEN_BOLD="\033[$(ansi_text -b -c GREEN)m"
COLOR_YELLOW_BOLD="\033[$(ansi_text -b -c YELLOW)m"
COLOR_BLUE_BOLD="\033[$(ansi_text -b -c BLUE)m"
COLOR_MAGENTA_BOLD="\033[$(ansi_text -b -c MAGENTA)m"
COLOR_CYAN_BOLD="\033[$(ansi_text -b -c CYAN)m"
COLOR_WHITE_BOLD="\033[$(ansi_text -b -c WHITE)m"

# Solarized Aliases
# Using the mappings from
# https://github.com/tomislav/osx-lion-terminal.app-colors-solarized
SOLARIZED_COLOR_BASE03="${COLOR_BLACK_BOLD}"
SOLARIZED_COLOR_BASE02="${COLOR_BLACK}"
SOLARIZED_COLOR_BASE01="${COLOR_GREEN_BOLD}"
SOLARIZED_COLOR_BASE00="${COLOR_YELLOW_BOLD}"
SOLARIZED_COLOR_BASE0="${COLOR_BLUE_BOLD}"
SOLARIZED_COLOR_BASE1="${COLOR_CYAN_BOLD}"
SOLARIZED_COLOR_BASE2="${COLOR_WHITE}"
SOLARIZED_COLOR_BASE3="${COLOR_WHITE_BOLD}"
SOLARIZED_COLOR_YELLOW="${COLOR_YELLOW}"
SOLARIZED_COLOR_ORANGE="${COLOR_RED_BOLD}"
SOLARIZED_COLOR_RED="${COLOR_RED}"
SOLARIZED_COLOR_MAGENTA="${COLOR_MAGENTA}"
SOLARIZED_COLOR_VIOLET="${COLOR_MAGENTA_BOLD}"
SOLARIZED_COLOR_BLUE="${COLOR_BLUE}"
SOLARIZED_COLOR_CYAN="${COLOR_CYAN}"
SOLARIZED_COLOR_GREEN="${COLOR_GREEN}"

SOLARIZED_DARK_BG="${SOLARIZED_COLOR_BASE03}"
SOLARIZED_DARK_BG_HILITE="${SOLARIZED_COLOR_BASE02}"
SOLARIZED_DARK_COMMENTS="${SOLARIZED_COLOR_BASE01}"
SOLARIZED_DARK_TEXT="${SOLARIZED_COLOR_BASE0}"
SOLARIZED_DARK_EM="${SOLARIZED_COLOR_BASE1}"

SOLARIZED_LIGHT_BG="${SOLARIZED_COLOR_BASE3}"
SOLARIZED_LIGHT_BG_HILITE="${SOLARIZED_COLOR_BASE2}"
SOLARIZED_LIGHT_COMMENTS="${SOLARIZED_COLOR_BASE1}"
SOLARIZED_LIGHT_TEXT="${SOLARIZED_COLOR_BASE00}"
SOLARIZED_LIGHT_EM="${SOLARIZED_COLOR_BASE01}"

# TODO need to find a better way to detect this
SOLARIZED_MODE=DARK

_prompt_escape() {
    echo "\[${@}\]"
}

_prompt_color() {
    local color="${1}"; shift
    echo $(_prompt_escape "${!color}")${@}$(_prompt_escape "${COLOR_NC}")
}

colors() {
    local color_vars="\${!${1:-COLOR_}*}"
    local color
    for color in $(eval "echo ${color_vars}"); do
        echo -e "${!color}${color}${COLOR_NC}"
    done
}

solarized_colors() {
    colors SOLARIZED_COLOR_
}

# Enable colors in various command-line tools
#
export GREP_COLOR="$(ansi_text -c GREEN)"
export GREP_OPTIONS='--color=auto'
export CLICOLOR=1

# Try to determine whether the 'ls' command on
# this system supports the "--color" option
#
if $(ls --color >/dev/null 2>&1); then
    alias ls='ls --color=auto';
    local dircolors_file="${HOME}/.dircolors/dircolors-solarized/dircolors.ansi-universal"
    if (has dircolors &&
        [[ -f "${dircolors_file}" && -r "${dircolors_file}" ]]); then
        eval $(dircolors "${dircolors_file}")
    fi
else
    # Set colors for BSD ls (Mac OS X)
    # Borrowed from https://github.com/seebi/dircolors-solarized/issues/10
    export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
fi

# Colorful manpages
# Inspired by http://github.com/anveo/dotfiles
# and http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/

export LESS_TERMCAP_mb=$(echo -e "${SOLARIZED_COLOR_RED}") # 'blinking' text
export LESS_TERMCAP_md=$(echo -e "${SOLARIZED_COLOR_BLUE}") # 'bold' text

export LESS_TERMCAP_us=$(echo -e "${SOLARIZED_COLOR_GREEN}") # 'underlined' text
export LESS_TERMCAP_ue=$(echo -e "${COLOR_NC}") # end 'underlined' text

export LESS_TERMCAP_so=$'\E['"$(ansi_text -b -c GREEN -g WHITE)m" # 'standout' mode
# (white highlight, bold green text)
export LESS_TERMCAP_se=$(echo -e "${COLOR_NC}") # end 'standout' mode

export LESS_TERMCAP_me=$(echo -e "${COLOR_NC}") # end appearance modes


rgb2hex() {
    perl -e '
        (shift @ARGV) =~
            /rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)/ &&
                printf "#%02X%02X%02X\n", $1, $2, $3
    ' \
    "${@}"
}

hex2rgb() {
    perl -e '
        (shift @ARGV) =~
            /#?([[:xdigit:]]{2})([[:xdigit:]]{2})([[:xdigit:]]{2})/ &&
                printf "rgb(%d, %d, %d)\n", hex($1), hex($2), hex($3)
    ' \
    "${@}";
}
