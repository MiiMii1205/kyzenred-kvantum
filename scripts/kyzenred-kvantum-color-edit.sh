#! /bin/bash

# The stdin is going to be a text file
# The stdout is going to be the edited text file

COLOR_TO_USE=$( kreadconfig5 --key "$1" --group "$2" --file "$HOME/.config/kdeglobals")

rgb2hex() {
    IFS="," read -r -a colorRGB <<< "$1"
    echo "$(printf '%02x\n' "${colorRGB[0]}")$(printf '%02x\n' "${colorRGB[1]}")$(printf '%02x\n' "${colorRGB[2]}")";
}


COLOR_TO_USE="#$(rgb2hex "$COLOR_TO_USE")"
PATTERN="{{$3}}";
TEMPLATE=$(sed -e "s/$PATTERN/$COLOR_TO_USE/gi" /dev/stdin)
echo "$TEMPLATE"