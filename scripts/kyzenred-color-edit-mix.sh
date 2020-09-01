#! /bin/bash

# The stdin is going to be a text file
# The stdout is going to be the edited text file

COLOR_TO_USE_A=$( kreadconfig5 --key "$1" --group "$2" --file "$HOME/.config/kdeglobals")
COLOR_TO_USE_B=$( kreadconfig5 --key "$3" --group "$4" --file "$HOME/.config/kdeglobals")
round_to_int()
{
    /usr/bin/printf "%.0f\n" "$(echo "scale=4; $1" | bc -l)"
};
lerp () {
    echo "$1+$3*($2-$1)" | bc -l
}
mix() {
    local colorA;
    local colorB;

    IFS="," read -r -a colorA <<< "$1";  
    IFS="," read -r -a colorB <<< "$2";  
    
    echo "$(round_to_int "$(lerp "${colorA[0]}" "${colorB[0]}" "$3")"),$(round_to_int "$(lerp "${colorA[1]}" "${colorB[1]}" "$3")"),$(round_to_int "$(lerp "${colorA[2]}" "${colorB[2]}" "$3")")";
}


COLOR_TO_USE="rgb($(mix "$COLOR_TO_USE_A" "$COLOR_TO_USE_B" "$5"))"
PATTERN="{{$6}}";
STYLESHEET=$(sed -e "s/$PATTERN/$COLOR_TO_USE/" /dev/stdin)
echo "$STYLESHEET"