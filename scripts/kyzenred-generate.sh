#! /bin/bash

echo "Generating new Kyzenred Kvantum SVGs elements based on the current KDE color scheme ($( kreadconfig5 --key "ColorScheme" --group "General" --file "$HOME/.config/kdeglobals"))"
./kyzenred-kvantum-recolor.sh
./kyzenred-kvrc-generator.sh
echo "Done!"
