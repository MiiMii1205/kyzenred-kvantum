#! /bin/sh

KVCONFIG_SRC_FILE="../Kyzenred.kvconfig"
TEMPLATE_FILE="../src/kvconfigtemplate"

if [ -e $TEMPLATE_FILE ]; then

    echo Generating standard Kvantum colors...

    TEMPLATE=$(
        < $TEMPLATE_FILE ./kyzenred-kvantum-color-edit.sh "ForegroundNormal" "Colors:Window" "window_text" |
        ./kyzenred-kvantum-color-edit.sh "BackgroundNormal" "Colors:Window" "window" |
        ./kyzenred-kvantum-color-edit.sh "BackgroundNormal" "Colors:View" "view" |
        ./kyzenred-kvantum-color-edit.sh "ForegroundNormal" "Colors:View" "text" |
        ./kyzenred-kvantum-color-edit.sh "BackgroundAlternate" "Colors:View" "view_alt" |
        ./kyzenred-kvantum-color-edit.sh "BackgroundNormal" "Colors:Selection" "highlight" |
        ./kyzenred-kvantum-color-edit.sh "ForegroundNormal" "Colors:Selection" "highlight_text" |
        ./kyzenred-kvantum-color-edit.sh "ForegroundNormal" "Colors:Button" "button_text" |
        ./kyzenred-kvantum-color-edit.sh "ForegroundLink" "Colors:Window" "link" |
        ./kyzenred-kvantum-color-edit.sh "ForegroundVisited" "Colors:Window" "visited_link" |
        ./kyzenred-kvantum-color-edit.sh "BackgroundNormal" "Colors:Button" "button_background" |
        ./kyzenred-kvantum-color-edit.sh "DecorationHover" "Colors:Button" "button_hover" 
    )

    echo Generating disabled Kvantum colors...

   TEMPLATE=$(echo "$TEMPLATE" |
        ./kyzenred-kvantum-color-edit-effects.sh "ForegroundNormal" "Colors:Window" "text-disabled" d |
        ./kyzenred-kvantum-color-edit-effects.sh "ForegroundNormal" "Colors:Button" "button-text-disabled" d 
    )   
    
    echo Generating inactive Kvantum colors...

    TEMPLATE=$(echo "$TEMPLATE" |
        ./kyzenred-kvantum-color-edit-effects.sh "BackgroundNormal" "Colors:Selection" "highlight-inactive" i 
    )

    echo Generating mixed Kvantum colors...

   TEMPLATE=$(echo "$TEMPLATE" |
        ./kyzenred-kvantum-color-edit-mix.sh "BackgroundNormal" "Colors:Window" "ForegroundNormal" "Colors:Window" "0.2" "inactive-tab-borders" |
        ./kyzenred-kvantum-color-edit-mix.sh "BackgroundNormal" "Colors:Button" "BackgroundNormal" "Colors:view" "0.5" "mid" |
        ./kyzenred-kvantum-color-edit-mix.sh "DecorationHover" "Colors:Button" "BackgroundNormal" "Colors:Button" "0.5" "mid_light" |
        ./kyzenred-kvantum-color-edit-mix.sh "BackgroundNormal" "Colors:Window" "ForegroundNormal" "Colors:Window" "0.25" "inactive-tab"
    )

    echo Generating timestamps...

    TIMESTAMP=$(date +"%D %T");
    TEMPLATE=$(echo "$TEMPLATE" | sed -e "s|{{timestamp}}|$TIMESTAMP|gi");

    echo "$TEMPLATE" > $KVCONFIG_SRC_FILE;

    echo .kvconfig file generated!
    
else
    
    >&2 echo src/kvconfigtemplate was not found. Stopped...
    exit 1
    
fi