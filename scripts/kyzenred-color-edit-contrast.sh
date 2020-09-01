#! /bin/bash

# The stdin is going to be a text file
# The stdout is going to be the edited text file

KDE_GLOBALS_FILE="$HOME/.config/kdeglobals";
TYPE_OF_EFFECT=${1="i"};
STYLESHEET=$(</dev/stdin);
KDE_GROUP_SETTINGS="ColorEffects:"
PATTERN="{{ }}"

case "$TYPE_OF_EFFECT" in 

    i)
        KDE_GROUP_SETTINGS="ColorEffects:Inactive"
        PATTERN="{{inactive_opacity}}"
    ;;
    d)
        KDE_GROUP_SETTINGS="ColorEffects:Disabled"
        PATTERN="{{disabled_opacity}}"
    ;;
    *)
        #error. Code is not correct
        >&2 echo "Unusual value for the type of effect value"
        exit 1
    ;;
esac

## CONTRAST EFFECT
case "$(kreadconfig5 --key "ContrastEffect" --group "$KDE_GROUP_SETTINGS" --file "$KDE_GLOBALS_FILE")" in
    0)
        #No contrast effects
    ;;
    1 | 2)
        # Fadeout
        ContrastAmount="$(kreadconfig5 --key "ContrastAmount" --group "$KDE_GROUP_SETTINGS" --file "$KDE_GLOBALS_FILE")";
        alpha=$(echo "1.0-$ContrastAmount" | bc -l);
    ;;

    *)
        #error. Code is not correct
        >&2 echo "Unusual value for the ContrastAmount value"
        exit 1
    ;;
esac

STYLESHEET="${STYLESHEET//$PATTERN/$alpha}";
echo "$STYLESHEET"