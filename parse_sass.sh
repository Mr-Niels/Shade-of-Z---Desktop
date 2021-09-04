#!/bin/bash

if [[ ! "$(command -v sassc)" ]]; then
  echo "'sassc' needs to be installed to generate the CSS."
  exit 1
fi

SASSC_OPT=('-M' '-t' 'expanded')

usage(){
    cat << EOF
    Usage: $0 [OPTION]...

    OPTIONS:
    -b, --base-colour       [black|white|clay] (default: black)

    -hl, --highlight-colour [white|black|martian] (default: white)

    -h, --help              Show help
EOF
}

BASE_COLOUR='black'
HL_COLOUR='white'

while [[ "$#" -gt 0 ]]; do
    case "${1:-}" in
        -b|--base-colour)
            case "$2" in
                black)
                    BASE_COLOUR='black'
                    shift 2
                    ;;
                white)
                    BASE_COLOUR='white'
                    shift 2
                    ;;
                clay)
                    BASE_COLOUR='clay'
                    shift 2
                    ;;
                -*|'')
                    echo "WARNING: no base colour value entered, using default ($BASE_COLOUR)."
                    shift
                    ;;
                *) 
                    echo "ERROR: base colour '$2' not recognised."
                    echo "Try '$0 --help' for more information."
                    exit 1
                    ;;
            esac
            ;;
        -hl|--highlight-colour)
            case "$2" in
                black)
                    HL_COLOUR='black'
                    shift 2
                    ;;
                white)
                    HL_COLOUR='white'
                    shift 2
                    ;;
                martian)
                    HL_COLOUR='martian'
                    shift 2
                    ;;
                -*|'')
                    echo "WARNING: no highlight colour value entered, using default ($HL_COLOUR)."
                    shift
                    ;;
                *) 
                    echo "ERROR: highlight colour '$2' not recognised."
                    echo "Try '$0 --help' for more information."
                    exit 1
                    ;;
            esac
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option '${1:-}'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
    esac
done

echo "== base colour = '$BASE_COLOUR'."
echo "== highlight colour = '$HL_COLOUR'."

#  Check command avalibility
function has_command() {
  command -v $1 > /dev/null
}

#  Install needed packages
install_package() {
  if [ ! "$(which sassc 2> /dev/null)" ]; then
    echo sassc needs to be installed to generate the css.
    if has_command zypper; then
      sudo zypper in sassc
    elif has_command apt-get; then
      sudo apt-get install sassc
    elif has_command dnf; then
      sudo dnf install sassc
    elif has_command dnf; then
      sudo dnf install sassc
    elif has_command pacman; then
      sudo pacman -S --noconfirm sassc
    fi
  fi
}

# Copy settings file
cp -rf src/_sass/_settings.scss src/_sass/_settings-tmp.scss

# Applying settings
sed -i "/\$base_colour:/s/default/${BASE_COLOUR}/" src/_sass/_settings-tmp.scss
sed -i "/\$highlight_colour:/s/default/${HL_COLOUR}/" src/_sass/_settings-tmp.scss

# Genterating css
echo "== Generating the CSS..."
sassc "${SASSC_OPT[@]}" "src/gnome-shell/gnome-shell."{scss,css}

echo "== Done!"

# echo "== Generating the CSS..."

# install_package

# cp -rf src/_sass/_tweaks.scss src/_sass/_tweaks-temp.scss
# cp -rf src/gnome-shell/sass/_tweaks.scss src/gnome-shell/sass/_tweaks-temp.scss

# for color in "${_COLOR_VARIANTS[@]}"; do
#   for size in "${_SIZE_VARIANTS[@]}"; do
#       sassc "${SASSC_OPT[@]}" "src/gtk/3.0/gtk$color$size."{scss,css}
#       sassc "${SASSC_OPT[@]}" "src/gtk/4.0/gtk$color$size."{scss,css}
#       sassc "${SASSC_OPT[@]}" "src/gnome-shell/shell-3-28/gnome-shell$color$size."{scss,css}
#       sassc "${SASSC_OPT[@]}" "src/gnome-shell/shell-40-0/gnome-shell$color$size."{scss,css}
#       sassc "${SASSC_OPT[@]}" "src/cinnamon/cinnamon$color$size."{scss,css}
#   done
# done

# echo "== done!"
