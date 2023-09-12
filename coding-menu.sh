#!/usr/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

BOLD='\033[1m'      # Bold
UNDERLINE='\033[4m' # Underline
REVERSE='\033[7m'   # Reverse (inverts foreground and background colors)
RESET='\033[0m'     # Reset formatting

CHECKED='\u2611'
UNCHECKED='\u2610'

FILE_NAME="$HOME/.coding-menu-data.yaml"

# Define a function to display the menu dialog
show_menu() {
  local options=("$@")
  local choice

  # Use dialog to create the menu
  choice=$(dialog --backtitle "Menu" \
                  --title "Coding Menu !" \
                  --menu "Choose the time available:" 15 40 4 \
                  "${options[@]}" \
                  2>&1 >/dev/tty)

  # Check the exit status of dialog
  local status=$?
  
  # Handle the user's choice
  case $status in
    0)
        # User pressed Enter, and $choice contains the selected option
        clear
        times=$(yq '.[] | key' $FILE_NAME);
        time=$(sed -n "${choice}p" <<< $times)

        echo -e "${RED}${BOLD}Here are all the options listed for this time: $time ${RESET}" 

        values=$(yq ".[\"${time}\"]" $FILE_NAME)
        for i in $(seq 1 1 $(wc -l <<< $values)); do
            val=$(sed -n "${i}p" <<< $values)
            echo -e "${YELLOW} ${val} ${RESET}"
        done
        ;;
    1)
        # User pressed Esc or Cancel
        echo "Dialog canceled."
        ;;
    255)
        # User pressed Ctrl+C
        echo "Dialog canceled."
        ;;
    *)
        echo "Dialog canceled."
        ;;
  esac
}


# Define the options for the menu
options=()

values=$(yq '.[] | key' $FILE_NAME)

for i in $(seq 1 1 $(wc -l <<< $values)); do
    val=$(sed -n "${i}p" <<< $values)
    options+=("$i" "$val")
done

for value in "${options[@]}"
do
     echo $value
done

# Call the function to display the menu dialog
show_menu "${options[@]}"