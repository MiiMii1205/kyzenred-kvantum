#! /bin/bash

# The stdin is going to be a text file
# The stdout is going to be the edited text file

KDE_GLOBALS_FILE="$HOME/.config/kdeglobals";
COLOR_TO_USE=$( kreadconfig5 --key "$1" --group "$2" --file "$KDE_GLOBALS_FILE")
TYPE_OF_EFFECT=${4="i"};
STYLESHEET=$(</dev/stdin);

max() {
    if [ "$(echo "$1 > $2" | bc -l)" = "1" ]; then 
        echo "$1"
    else
        echo "$2"
    fi
}
min() {
    if [ "$(echo "$1 < $2" | bc -l)" = "1" ]; then 
        echo "$1"
    else
        echo "$2"
    fi
}

h2rgb () {
    local m1;
    local m2;
    local h;
    m1=$1;
    m2=$2;
    h=$3;
    
    while [ "$(echo "$h < 0" | bc -l)" = "1" ]; do
        h="$(echo "$h+1" | bc -l)";
    done
    while [ "$(echo "$h > 1" | bc -l)" = "1" ]; do
        h="$(echo "$h-1" | bc -l)";
    done

    if [ "$(echo "$h*6.0 < 1" | bc -l)" = "1" ]; then
        echo "$m1 + ($m2 - $m1)*$h*6" | bc -l;
    elif [ "$(echo "$h*2.0 < 1" | bc -l)" = "1" ]; then
        echo "$m2";
    elif [ "$(echo "$h*3.0 < 2" | bc -l)" = "1" ]; then
        echo "$m1 + ($m2 - $m1) * (2/3 - $h)*6" | bc -l;
    else
        echo "$m1"
    fi
}

hsl2rgb () {
    
    local maxVal 
    local minVal 
    local deltaVal;

    local h;
    local s;
    local l;

    local r;
    local g;
    local b;
    
    h=$(echo "$1/360" | bc -l);
    s=$(echo "$2/100" | bc -l);
    l=$(echo "$3/100" | bc -l);
    
    if [ "$(echo "$l<0" | bc -l)" = "1" ]; then
        l=0;
    fi
    
    if [ "$(echo "$s<0" | bc -l)" = "1" ]; then
        s=0;
    fi
    
    if [ "$(echo "$l>1" | bc -l)" = "1" ]; then
        l=1;
    fi
    
    if [ "$(echo "$s>1" | bc -l)" = "1" ]; then
        s=1;
    fi
    
    while [ "$(echo "$h<0" | bc -l)" = "1" ]; do
        h=$(echo "$h+1" | bc -l);
    done
    
    while [ "$(echo "$h>1" | bc -l)" = "1" ]; do
        h=$(echo "$h-1" | bc -l);
    done
    
    # if saturation isexacly zero, we loose
    # information for hue, since it willevaluate
    # to zero if converted back from rgb. Setting
    # saturation to a very tiny number solvesthis.
    if [ "$(echo "$s==0"|bc -l)" = "1" ]; then
        s=$(echo "0.00000000001" | bc -l);
    fi
    
    # Algorithm from the CSS3 spec: http://www.w3.org/TR/css3-color/#hsl-color.
    local m2;
    local m1;
    
    if [ "$(echo "$l <= 0.5" | bc -l )" = "1" ]; then
        m2=$(echo "$l*($s+1)" | bc -l);
    else
        m2=$(echo "($l+$s)-($l*$s)" | bc -l)
    fi
    
    m1=$(echo " ($l*2)-$m2" | bc -l);
    # round the resultcolorHSL[1]-- consider moving thicolorHSL[1]into the Color constructor
    
    local rr;
    local rrr;
    local bb;
    local bbb;
    local gg;
    
    rr=$(echo "$h + 1.0/3.0" | bc -l);
    gg="$h";
    bb=$(echo "$h - 1.0/3.0" | bc -l);

    rr=$(h2rgb "$m1" "$m2" "$rr");
    gg=$(h2rgb "$m1" "$m2" "$gg");
    bb=$(h2rgb "$m1" "$m2" "$bb");

    r=$(echo "($rr * 255.0)" | bc -l);
    g=$(echo "($gg * 255.0)" | bc -l);
    b=$(echo "($bb * 255.0)" | bc -l);
    
    r=$(round_to_int "$r");
    g=$(round_to_int "$g");
    b=$(round_to_int "$b");

    echo "$r,$g,$b";
}

rgb2hsl () {
    
    local colorRGB
    local colorHSL
    local maxVal
    local minVal
    
    local deltaVal;

    local h;
    local s;
    local l;

    local r;
    local g;
    local b;
    
    r=$(echo "$1/255" | bc -l);
    g=$(echo "$2/255" | bc -l);
    b=$(echo "$3/255" | bc -l);

    maxVal=$(max "$r" "$(max "$g" "$b")");
    minVal=$(min "$r" "$(min "$g" "$b")");
    deltaVal=$(echo "$maxVal-$minVal" | bc -l);
    
    h=0;
    l=$(echo "($maxVal+$minVal)/2.0" | bc -l);
    
    if [ "$(echo "sqrt(($maxVal - $minVal)^2) < 0.00001" | bc -l)" = "1" ]; then
        ## Achromatic
        h=0;
        s=0;
    else
        
        if [ "$(echo "$l<0.5" | bc -l)" = "1" ]; then
            
            s=$(echo "$deltaVal/($maxVal+$minVal)" | bc -l);
            
        else
            
            s=$(echo "$deltaVal/(2.0 - $maxVal - $minVal)" | bc -l);
            
        fi
        
        if [ "$(echo "$r==$maxVal" | bc -l)" = "1" ]; then
            
            local valToUse;
            
            if [ "$(echo "$g < $b" | bc -l)" = "1" ]; then
                valToUse=6
            else
                valToUse=0
            fi
            
            h=$(echo "($g - $b) / $deltaVal + $valToUse" | bc -l);
            
        elif [ "$(echo "$g == $maxVal" | bc -l)" = "1" ]; then
            
            h=$(echo "($b-$r) / $deltaVal + 2" | bc -l);
            
        elif [ "$(echo "$b == $maxVal" | bc -l)" = "1" ]; then
            
            h=$(echo "($r-$g) / $deltaVal + 4" | bc -l);
            
        fi
        
    fi
    
    echo "$(echo "$h/6*360" | bc -l),$(echo "$s*100" | bc -l),$(echo "$l*100" | bc -l)";
    
}

round_to_int()
{
    /usr/bin/printf "%.0f\n" "$(echo "scale=4; $1" | bc -l)"
};

lerp () {
    echo "$1+$3*($2-$1)" | bc -l
}

# lightness - amount
lighter () {
    min "$(echo "(1+$2)*$1" | bc -l)" 1
}

# lightness - amount
darker () {
    if [ "$(echo "$2==-1" | bc -l )" = "1" ]; then
        echo "1"
    else
       min "$(echo "$1/(1+$2)" | bc -l)" 1
    fi
}

# saturation - amount
desaturate () {
    min "$(echo "$1 * (1 - $2)" | bc -l)" 1
}



# color a (array) - color b (array) - amount
mix() {
    local colorA;
    local colorB;

    IFS="," read -r -a colorA <<< "$1";  
    IFS="," read -r -a colorB <<< "$2";  
    
    echo "$(lerp "${colorA[0]}" "${colorB[0]}" "$3"),$(lerp "${colorA[1]}" "${colorB[1]}" "$3"),$(lerp "${colorA[2]}" "${colorB[2]}" "$3")";
}
get_inactive_color() {
    
    local colorRGB;
    local alpha;
    alpha=1;
    colorRGB=();
    fadeincolorRGB=();
    IFS="," read -r -a colorRGB <<< "$1"

   # while IFS="," read -r line; do colorRGB+=("$line"); done < /dev/stdin;
   # while IFS="," read -r line; do fadeincolorRGB+=("$line"); done < <(kreadconfig5 --key "Color" --group "ColorEffects:Inactive" --file "$KDE_GLOBALS_FILE");
    
    
    # first, let's check if we need to lerp the colors
    
    if [ "$(kreadconfig5 --key "Enable" --group "$KDE_GROUP_SETTINGS" --file "$KDE_GLOBALS_FILE")" != "false" ]; then
        
        # INTENSITY EFFECT
        case "$(kreadconfig5 --key "IntensityEffect" --group "$KDE_GROUP_SETTINGS" --file "$KDE_GLOBALS_FILE")" in
            0)
                #intensity is disabled
            ;;
            1)
                #intensity is shade
                local intensityAmount 
                intensityAmount="$(kreadconfig5 --key "IntensityAmount" --group "$KDE_GROUP_SETTINGS" --file "$KDE_GLOBALS_FILE")";

                if [ "$(echo "$intensityAmount>=0" | bc -l)" = "1" ]; then
                    IFS="," read -r -a colorRGB < <(mix "1,1,1" "${colorRGB[0]},${colorRGB[1]},${colorRGB[2]}" "$intensityAmount" );
                else

                    IFS="," read -r -a colorRGB < <(mix "0,0,0" "${colorRGB[0]},${colorRGB[1]},${colorRGB[2]}" "$intensityAmount" );
                fi
                
            ;;
            2)
                #intensity is Darken

                local intensityAmount
                local colorHSL;
                colorHSL=();
                intensityAmount="$(kreadconfig5 --key "IntensityAmount" --group "$KDE_GROUP_SETTINGS" --file "$KDE_GLOBALS_FILE")";

                IFS="," read -r -a colorHSL < <(rgb2hsl "${colorRGB[0]}" "${colorRGB[1]}" "${colorRGB[2]}" );  

                colorHSL[2]=$(darker "${colorHSL[2]}" "$intensityAmount");
                
                IFS="," read -r -a colorRGB < <(hsl2rgb "${colorHSL[0]}" "${colorHSL[1]}" "${colorHSL[2]}" );

            ;;
            3)
            
                #intensity is Lighten

                local intensityAmount
                local colorHSL;
                colorHSL=();
                intensityAmount="$(kreadconfig5 --key "IntensityAmount" --group "$KDE_GROUP_SETTINGS" --file "$KDE_GLOBALS_FILE")";

                IFS="," read -r -a colorHSL < <(rgb2hsl "${colorRGB[0]}" "${colorRGB[1]}" "${colorRGB[2]}" );  
            
                colorHSL[2]=$(lighter "${colorHSL[2]}" "$intensityAmount");

                IFS="," read -r -a colorRGB < <(hsl2rgb "${colorHSL[0]}" "${colorHSL[1]}" "${colorHSL[2]}" );
                
            ;;
            *)

                #error. Code is not correct
                >&2 echo "Unusual value for the IntensityEffect value"
                exit 1
            ;;
        esac

        ## COLOR EFFECT
        case "$(kreadconfig5 --key "ColorEffect" --group "$KDE_GROUP_SETTINGS" --file "$KDE_GLOBALS_FILE")" in
        0) 
            #No effects
        ;;
        1) 
            # Desaturate

            local ColorAmount
            local colorHSL;
            colorHSL=();
            ColorAmount="$(kreadconfig5 --key "ColorAmount" --group "$KDE_GROUP_SETTINGS" --file "$KDE_GLOBALS_FILE")";

            IFS="," read -r -a colorHSL < <(rgb2hsl "${colorRGB[0]}" "${colorRGB[1]}" "${colorRGB[2]}" );  
        
            colorHSL[1]=$(desaturate "${colorHSL[1]}" "$ColorAmount");

            IFS="," read -r -a colorRGB < <(hsl2rgb "${colorHSL[0]}" "${colorHSL[1]}" "${colorHSL[2]}" );

        ;;
        2 | 3) 
            # Color Mixing
            local fadeincolorRGB;
            local ColorAmount 

            IFS="," read -r  -a fadeincolorRGB  < <(kreadconfig5 --key "Color" --group "$KDE_GROUP_SETTINGS" --file "$KDE_GLOBALS_FILE");

            ColorAmount="$(kreadconfig5 --key "ColorAmount" --group "$KDE_GROUP_SETTINGS" --file "$KDE_GLOBALS_FILE")";

            IFS="," read -r -a colorRGB < <(mix "${fadeincolorRGB[0]},${fadeincolorRGB[1]},${fadeincolorRGB[2]}" "${colorRGB[0]},${colorRGB[1]},${colorRGB[2]}" "$ColorAmount" );
         
        ;;
        *)
            #error. Code is not correct
            >&2 echo "Unusual value for the ColorEffect value"
            exit 1
        ;;

        esac
        
    fi

    echo "${colorRGB[0]},${colorRGB[1]},${colorRGB[2]}";
    
}


# To get these special colors, we need to actually parse the color and apply its effects

KDE_GROUP_SETTINGS="ColorEffects:"

case "$TYPE_OF_EFFECT" in 

    i)
        KDE_GROUP_SETTINGS="ColorEffects:Inactive"
    ;;
    d)
        KDE_GROUP_SETTINGS="ColorEffects:Disabled"
    ;;
    *)
        #error. Code is not correct
        >&2 echo "Unusual value for the type of effect value"
        exit 1
    ;;
esac

# get_inactive_color "$COLOR_TO_USE"

COLOR_TO_USE=$(get_inactive_color "$COLOR_TO_USE")
COLOR_TO_USE="rgb($COLOR_TO_USE)"
PATTERN="{{$3}}";
STYLESHEET="${STYLESHEET//$PATTERN/$COLOR_TO_USE}";
echo "$STYLESHEET"