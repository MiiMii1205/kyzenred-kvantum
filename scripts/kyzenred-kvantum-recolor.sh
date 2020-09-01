#! /bin/sh

SVG_SRC_FILE="Kyzenred"
SVG_SRC_FILE_EXT=".svg"
STYLE_TAG_REPLACE="</metadata>";
STYLESHEET_FILE="../src/recolor.css"

FULL_GTK2_IN_SCR_FILE="../src/$SVG_SRC_FILE-in$SVG_SRC_FILE_EXT"
FULL_GTK2_OUT_SCR_FILE="../$SVG_SRC_FILE$SVG_SRC_FILE_EXT"

if [ -e $STYLESHEET_FILE ]; then
    
    echo Generating standard colors...
        # Standart Colors
    STYLESHEET=$(
        < $STYLESHEET_FILE ./kyzenred-color-edit.sh "ForegroundNormal" "Colors:Window" "text" |
        ./kyzenred-color-edit.sh "BackgroundNormal" "Colors:Window" "background" |
        ./kyzenred-color-edit.sh "BackgroundNormal" "Colors:Selection" "highlight" |
        ./kyzenred-color-edit.sh "ForegroundNormal" "Colors:View" "view_text" |
        ./kyzenred-color-edit.sh "BackgroundNormal" "Colors:View" "view_background" |
        ./kyzenred-color-edit.sh "DecorationHover" "Colors:View" "view_hover" |
        ./kyzenred-color-edit.sh "DecorationFocus" "Colors:View" "view_focus" |
        ./kyzenred-color-edit.sh "ForegroundNormal" "Colors:Button" "button_text" |
        ./kyzenred-color-edit.sh "BackgroundNormal" "Colors:Button" "button_background" |
        ./kyzenred-color-edit.sh "DecorationFocus" "Colors:Button" "button_focus" |
        ./kyzenred-color-edit.sh "DecorationHover" "Colors:Button" "button_hover" 
    )
    
    echo Generating inactive colors...

        # Inactive Colors
    STYLESHEET=$(echo "$STYLESHEET" |
    
        ./kyzenred-color-edit-effects.sh "ForegroundInactive" "Colors:Window" "text_inactive" i |
        ./kyzenred-color-edit-effects.sh "BackgroundNormal" "Colors:Window" "background_inactive" i |
        ./kyzenred-color-edit-effects.sh "BackgroundNormal" "Colors:Selection" "highlight_inactive" i |
        ./kyzenred-color-edit-effects.sh "ForegroundInactive" "Colors:View" "view_text_inactive" i |
        ./kyzenred-color-edit-effects.sh "BackgroundNormal" "Colors:View" "view_background_inactive" i |
        ./kyzenred-color-edit-effects.sh "DecorationHover" "Colors:View" "view_hover_inactive" i |
        ./kyzenred-color-edit-effects.sh "DecorationFocus" "Colors:View" "view_focus_inactive" i |
        ./kyzenred-color-edit-effects.sh "ForegroundInactive" "Colors:Button" "button_text_inactive" i |
        ./kyzenred-color-edit-effects.sh "BackgroundNormal" "Colors:Button" "button_background_inactive" i |
        ./kyzenred-color-edit-effects.sh "DecorationFocus" "Colors:Button" "button_focus_inactive" i |
        ./kyzenred-color-edit-effects.sh "DecorationHover" "Colors:Button" "button_hover_inactive" i 
    )
    
    echo Generating disabled colors...
    # disabled Colors
    STYLESHEET=$(echo "$STYLESHEET" |

        ./kyzenred-color-edit-effects.sh "ForegroundNormal" "Colors:Window" "text_disabled" d |
        ./kyzenred-color-edit-effects.sh "BackgroundNormal" "Colors:Window" "background_disabled" d |
        ./kyzenred-color-edit-effects.sh "BackgroundNormal" "Colors:Selection" "highlight_disabled" d |
        ./kyzenred-color-edit-effects.sh "ForegroundNormal" "Colors:View" "view_text_disabled" d |
        ./kyzenred-color-edit-effects.sh "BackgroundNormal" "Colors:View" "view_background_disabled" d |
        ./kyzenred-color-edit-effects.sh "DecorationHover" "Colors:View" "view_hover_disabled" d |
        ./kyzenred-color-edit-effects.sh "DecorationFocus" "Colors:View" "view_focus_disabled" d |
        ./kyzenred-color-edit-effects.sh "ForegroundNormal" "Colors:Button" "button_text_disabled" d |
        ./kyzenred-color-edit-effects.sh "BackgroundNormal" "Colors:Button" "button_background_disabled" d |
        ./kyzenred-color-edit-effects.sh "DecorationFocus" "Colors:Button" "button_focus_disabled" d |
        ./kyzenred-color-edit-effects.sh "DecorationHover" "Colors:Button" "button_hover_disabled" d 
    )  
    
    echo Generating mixed colors...
    # disabled Colors
    STYLESHEET=$(echo "$STYLESHEET" |
        ./kyzenred-color-edit-mix.sh "BackgroundNormal" "Colors:Window" "ForegroundNormal" "Colors:Window" "0.2" "inactive-tab-borders" |
        ./kyzenred-color-edit-mix.sh "BackgroundNormal" "Colors:Window" "ForegroundNormal" "Colors:Window" "0.25" "inactive-tab" 
    )

    echo Generating special opacities...

        # contrast opacities and cleaning
    STYLESHEET=$(echo "$STYLESHEET" |
        ./kyzenred-color-edit-contrast.sh i |
        ./kyzenred-color-edit-contrast.sh d 
    )

    echo Cleaning up...

        # cleanup
    STYLESHEET=$(echo "$STYLESHEET" |
        tr '\n' ' '|
        tr '\t' ' '
    )
    
    STYLESHEET="</metadata><style>$STYLESHEET</style>";
    
    echo Refreshing SVGs...
    cp -f $FULL_GTK2_IN_SCR_FILE $FULL_GTK2_OUT_SCR_FILE && sleep 1
    
    echo "Inserting CSS <style> code..."
    sed -i "s|$STYLE_TAG_REPLACE|$STYLESHEET|" $FULL_GTK2_OUT_SCR_FILE
    
    echo SVG file generated!
else
    
    >&2 echo src/recolor.css was not found. Stopped...
    exit 1
    
fi