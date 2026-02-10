#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

## Dynamic Wallpaper : Set wallpapers according to current time.
## Created to work better with job schedulers (cron)

## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')"        GREEN="$(printf '\033[32m')"
ORANGE="$(printf '\033[33m')"     BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"    CYAN="$(printf '\033[36m')"
WHITE="$(printf '\033[37m')"      BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"      GREENBG="$(printf '\033[42m')"
ORANGEBG="$(printf '\033[43m')"   BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"
WHITEBG="$(printf '\033[47m')"    BLACKBG="$(printf '\033[40m')"

## Wallpaper directory
DIR="/usr/share/dynamic-wallpaper/images"
# HOUR=`date +%k`

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
    { printf "${RED}\n\n%s\n\n" "[!] Program Interrupted." 2>&1; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM() {
    { printf "${RED}\n\n%s\n\n" "[!] Program Terminated." 2>&1; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Prerequisite
Prerequisite() { 
    dependencies=(swww systemd)
    for dependency in "${dependencies[@]}"; do
        type -p "$dependency" &>/dev/null || {
            echo -e ${RED}"[!] ERROR: Could not find ${GREEN}'${dependency}'${RED}, is it installed?" >&2
            { reset_color; exit 1; }
        }
    done
}

## Usage
usage() {
	clear
    cat <<- EOF
		${RED}╺┳┓╻ ╻┏┓╻┏━┓┏┳┓╻┏━╸   ${GREEN}╻ ╻┏━┓╻  ╻  ┏━┓┏━┓┏━┓┏━╸┏━┓
		${RED} ┃┃┗┳┛┃┗┫┣━┫┃┃┃┃┃     ${GREEN}┃╻┃┣━┫┃  ┃  ┣━┛┣━┫┣━┛┣╸ ┣┳┛
		${RED}╺┻┛ ╹ ╹ ╹╹ ╹╹ ╹╹┗━╸   ${GREEN}┗┻┛╹ ╹┗━╸┗━╸╹  ╹ ╹╹  ┗━╸╹┗╸${WHITE}
		
		Dwall V3.0   : Set wallpapers according to current time.
		Developed By : Aditya Shakya (@adi1090x)
			
		Usage : `basename $0` [-h] [-p] [-s style]

		Options:
		   -h	Show this help message
		   -p	Use pywal to set wallpaper
		   -s	Name of the style to apply
		   
	EOF

	styles=(`ls "$DIR"`)
	printf ${GREEN}"Available styles:  "
	printf -- ${ORANGE}'%s  ' "${styles[@]}"
	printf -- '\n\n'${WHITE}

    cat <<- EOF
		Examples: 
		`basename $0` -s beach        Set wallpaper from 'beach' style
		`basename $0` -p -s sahara    Set wallpaper from 'sahara' style using pywal
		
	EOF
}

## Set wallpaper in hyprland
set_hyprland() {
    if [[ ! -f "$1" ]]; then
        echo "Error: Image not found at $1"
        return 1
    fi

    if ! swww query >/dev/null 2>&1; then
        swww init
        sleep 0.5 # Petit délai pour laisser le temps au démon de s'initialiser
    fi

    # 3. Apply the wallpaper
    swww img "$1" \
        --transition-type outer \
        --transition-step 20 \
        --transition-fps 60
}

## Choose wallpaper setter
## Choose wallpaper setter
if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" || "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
    SETTER=set_hyprland
elif [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    if command -v swww >/dev/null 2>&1; then
        SETTER=set_hyprland
    else
        echo -e "${RED}[!] Error: 'swww' is required for Wayland.${NC}"
        exit 1
    fi
else
    echo -e "${RED}[!] Error: This fork is optimized for Wayland/Hyprland only.${NC}"
    exit 1
fi

## Display Info
display_info() {
    local session_name="${XDG_CURRENT_DESKTOP:-Wayland}"
    [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]] && session_name="Hyprland"

    echo -e "${ORANGE}[*] Setting wallpaper in ${GREEN}${session_name}${ORANGE} session"
    echo -e "${ORANGE}[*] Using setter : ${MAGENTA}${SETTER}${NC}"
}

## Get Image
get_img() {
    local search_path="$DIR/$STYLE/$1"
    local found_file=$(ls ${search_path}.* 2>/dev/null | head -n 1)

    if [[ -f "$found_file" ]]; then
        image="$found_file"
    else
        echo -e "${RED}[!] Error: No image found for '$1' in $DIR/$STYLE/ (checked .png, .jpg, .webp, .gif)${NC}"
        exit 1
    fi
}

## Set wallpaper with matugen or pywal
setter() {
    get_img "$1"
    if command -v matugen >/dev/null 2>&1; then
            echo -e "${GREEN}[+] Generating colors with Matugen...${NC}"
            matugen image "$image" >/dev/null 2>&1
    elif command -v wal >/dev/null 2>&1; then
        wal -i "$image" -n >/dev/null 2>&1
    else
        echo -e "${YELLOW}[!] Warning: Neither 'matugen' nor 'pywal' is installed.${NC}"
        echo -e "${YELLOW}[!] Colors will not be updated.${NC}"
    fi
                
    if command -v "$SETTER" >/dev/null 2>&1; then
           $SETTER "$image"
    else
           echo -e "${RED}[!] Error: Wallpaper setter '$SETTER' not found.${NC}"
           exit 1
    fi
}

## Wallpaper Setter
set_wallpaper() {
    local cfile="$HOME/.cache/dwall_current"
    get_img "$1"
    if [[ -n "$image" ]]; then
        $SETTER "$image"
    else
        echo -e "${RED}[!] Error: Could not resolve image path for '$1'${NC}"
        exit 1
    fi

    echo "$image" > "$cfile"
}

## Check valid style
check_style() {
    display_info
    if [[ -d "$DIR/$1" ]]; then
        echo -e "${BLUE}[*] Using style : ${MAGENTA}$1${NC}"
        STYLE="$1"
    else
        echo -e "${RED}[!] Invalid style name : ${GREEN}$1${NC}"
        echo -e "${RED}[!] Available styles are : ${YELLOW}$(ls -m "$DIR")${NC}"
        exit 1
    fi
}

## Main
main() {
    local h=$((10#$(date +%H)))
    if [[ -n "$PYWAL" ]]; then
        pywal_set "$h"
    else
        set_wallpaper "$h"
    fi
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
if [[ "$STYLE" ]]; then
    check_style "$STYLE"
    main
else
    usage
    exit 1
fi