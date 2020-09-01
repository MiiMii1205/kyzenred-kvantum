#! /bin/sh

# The stdin is going to be a text file
# The stdout is going to be the edited text file

COLOR_TO_USE=$( kreadconfig5 --key "$1" --group "$2" --file "$HOME/.config/kdeglobals")
COLOR_TO_USE="rgb($COLOR_TO_USE)"
PATTERN="{{$3}}";
STYLESHEET=$(sed -e "s/$PATTERN/$COLOR_TO_USE/" /dev/stdin)
echo "$STYLESHEET"