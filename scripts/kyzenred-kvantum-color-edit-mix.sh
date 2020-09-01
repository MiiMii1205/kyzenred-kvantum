#! /bin/bash

# The stdin is going to be a text file
# The stdout is going to be the edited text file

COLOR_TO_USE_A=$( kreadconfig5 --key "$1" --group "$2" --file "$HOME/.config/kdeglobals")
COLOR_TO_USE_B=$( kreadconfig5 --key "$3" --group "$4" --file "$HOME/.config/kdeglobals")
# color a (array) - color b (array) - amount
lerp () {
    echo "$1+$3*($2-$1)" | bc -l
}
round_to_int()
{
    /usr/bin/printf "%.0f\n" "$(echo "scale=4; $1" | bc -l)"
};

mix() {
    local colorA;
    local colorB;

    IFS="," read -r -a colorA <<< "$1";  
    IFS="," read -r -a colorB <<< "$2";  
    
    echo "$(lerp "${colorA[0]}" "${colorB[0]}" "$3"),$(lerp "${colorA[1]}" "${colorB[1]}" "$3"),$(lerp "${colorA[2]}" "${colorB[2]}" "$3")";
}
rgb2hex() {
    IFS="," read -r -a colorRGB <<< "$1"
    echo "$(printf '%02x\n' "$(round_to_int "${colorRGB[0]}")")$(printf '%02x\n' "$(round_to_int "${colorRGB[1]}")")$(printf '%02x\n' "$(round_to_int "${colorRGB[2]}")")";
}


COLOR_TO_USE="#$(rgb2hex  "$(mix "$COLOR_TO_USE_A" "$COLOR_TO_USE_B" "$5")" )"
PATTERN="{{$6}}";
TEMPLATE=$(sed -e "s/$PATTERN/$COLOR_TO_USE/gi" /dev/stdin)
echo "$TEMPLATE"