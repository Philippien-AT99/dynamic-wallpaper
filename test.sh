#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x) - Optimized for Hyprland
## Dynamic Wallpaper : Diagnostic and test script

## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')"        GREEN="$(printf '\033[32m')"
ORANGE="$(printf '\033[33m')"     BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"    CYAN="$(printf '\033[36m')"
WHITE="$(printf '\033[37m')"      NC="$(printf '\033[0m')"

## Wallpaper directory (Current directory for testing)
DIR="`pwd`/images"
# Use 10# to prevent octal errors (08/09 hour bug)
HOUR=$((10#$(date +%H)))

## Wordsplit in ZSH
set -o shwordsplit 2>/dev/null

## Reset terminal colors
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
    return
}

## Script Termination
exit_on_signal_SIGINT() {
    { printf "${RED}\n\n%s\n\n" "[!] Test Interrupted." 2>&1; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT

## Prerequisite : Optimized for Wayland/Hyprland
Prerequisite() { 
    dependencies=(swww hyprctl)
    echo -e "${ORANGE}[*] Checking dependencies...${NC}"
    for dependency in "${dependencies[@]}"; do
        type -p "$dependency" &>/dev/null || {
            echo -e ${RED}"[!] ERROR: Could not find ${GREEN}'${dependency}'${RED}, is it installed?" >&2
            { reset_color; exit 1; }
        }
    done
    echo -e "${GREEN}[+] Dependencies found.${NC}"
}

## Usage
usage() {
	clear
    cat <<- EOF
		${RED}╺┳┓╻ ╻┏┓╻┏━┓┏┳┓╻┏━╸   ${GREEN}╻ ╻┏━┓╻  ╻  ┏━┓┏━┓┏━┓┏━╸┏━┓
		${RED} ┃┃┗┳┛┃┗┫┣━┫┃┃┃┃┃     ${GREEN}┃╻┃┣━┫┃  ┃  ┣━┛┣━┫┣━┛┣╸ ┣┳┛
		${RED}╺┻┛ ╹ ╹ ╹╹ ╹╹ ╹╹┗━╸   ${GREEN}┗┻┛╹ ╹┗━╸┗━╸╹  ╹ ╹╹  ┗━╸╹┗╸${WHITE}
		
		Dwall Test Script : Hyprland Edition
			
		Usage : `basename $0` [-h] [-p] [-s style]

		Options:
		   -h	Show this help message
		   -p	Use pywal to set wallpaper
		   -s	Name of the style to apply
		   
	EOF

    if [[ -d "$DIR" ]]; then
	    styles=(`ls "$DIR"`)
	    printf ${GREEN}"Available styles in local images/ folder:  "
	    printf -- ${ORANGE}'%s  ' "${styles[@]}"
	    printf -- '\n\n'${NC}
    fi
}

## Set wallpaper in hyprland
set_hyprland() {
    # Check if image exists
    if [[ ! -f "$1" ]]; then
        echo -e "${RED}[!] Error: Image not found at $1${NC}"
        return 1
    fi

    # Initialize swww if not running
    if ! swww query >/dev/null 2>&1; then
        echo -e "${CYAN}[*] Starting swww daemon...${NC}"
        swww init && sleep 0.5
    fi

    # Apply wallpaper with transition
    echo -e "${BLUE}[*] Applying wallpaper using swww...${NC}"
    swww img "$1" --transition-type grow --transition-pos 0.8,0.8 --transition-step 20
}

## Choose wallpaper setter (Wayland/Hyprland Only)
if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
    SETTER=set_hyprland
else
    echo -e "${RED}[!] Error: Hyprland session not detected. This test script is for Hyprland.${NC}"
    exit 1
fi

## Get Image (Handles multiple formats)
get_img() {
    local search_path="$DIR/$STYLE/$1"
    local found_file=$(ls ${search_path}.* 2>/dev/null | head -n 1)

    if [[ -f "$found_file" ]]; then
        image="$found_file"
    else
        echo -e "${RED}[!] Error: Image '$1' not found in $DIR/$STYLE/${NC}"
        exit 1
    fi
}

## Set wallpaper with pywal
pywal_set() {
    get_img "$1"
    if command -v wal >/dev/null 2>&1; then
        echo -e "${MAGENTA}[*] Running pywal...${NC}"
        wal -i "$image" -n
        $SETTER "$image"
    else
        echo -e "${RED}[!] Error: 'pywal' not found.${NC}"
        exit 1
    fi
}

## Wallpaper Setter
set_wallpaper() {
    get_img "$1"
    $SETTER "$image"
}

## Check valid style
check_style() {
    if [[ -d "$DIR/$1" ]]; then
        echo -e "${BLUE}[*] Testing style : ${MAGENTA}$1${NC}"
        STYLE="$1"
    else
        echo -e "${RED}[!] Invalid style name : ${GREEN}$1${NC}"
        exit 1
    fi
}

## Main Logic
main() {
    if [[ -n "$PYWAL" ]]; then
        pywal_set "$HOUR"
    else
        set_wallpaper "$HOUR"
    fi
    echo -e "${GREEN}[V] Test completed successfully.${NC}"
    reset_color
    exit 0
}

## Get Options
while getopts ":s:hp" opt; do
    case ${opt} in
        p) PYWAL=true ;;
        s) STYLE=$OPTARG ;;
        h) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac
done

## Run
Prerequisite
if [[ "$STYLE" ]]; then
    check_style "$STYLE"
    main
else
    usage
    exit 1
fi