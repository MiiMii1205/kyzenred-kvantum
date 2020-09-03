 # Kyzenred Hacking

So you want to extend the theme, yes? First up, let's talk about what you'll need

first, you need to know that Kvantum is a pure SVG engine. This means that if you want to change things you'll need to know how SVGs works, along with good HTML and CSS knowledge.

Thankfully, there's [w3school](https://www.w3schools.com/graphics/svg_intro.asp). With their little SVG reference you'll be ready in no time to edit the theme!

## Generating

Unlike KDE, Kyzenred uses explicit bash scripts to recolor a SVG file. To regenerate the SVG, just run the `kyzenred-generate.sh` script in the `scripts` directory like so:
```bash
$ ./kyzenred-generate.sh
```
This will:
1. Generate a new SVG file
2. Generate a new `.kvconfig` file

## Recoloring
Kyzenred is dynamically colored theme. This means that its components are dynamically recolored based on the current color scheme.

Kvantum, unlike KDE's plasma and aurorae engine, doesn't actually support recoloring SVG elements. So to fix this we're using a similar technique that of GTK2.

In essence, when the script is run a special CSS stylesheet is inserted into the SVG file.

This stylesheet contains special CSS classes with color scheme specific colors. 

Each of these classes can be used on an SVG element to give them unique colors.

If you want to know more about it, I suggest you take a look at [KDE's plasma theming guide](https://techbase.kde.org/Development/Tutorials/Plasma5/ThemeDetails). There's also in this repository the `src/recolor.css` file that contains the stylesheet template to be inserted.

The theme uses a simple `sed` to replace the placeholder stylesheet with the current color scheme's color.

## `.kvconfig`

Once the SVGs are rendered, the script then generate a new `kyzenred.kvconfig` file according to the current KDE color scheme. 

The script uses `src/kvconfigtemplate` as a template to fill in most of your current color scheme's colors.

It then override the current `kyzenred.kvconfig` with the newly created `.kconfig` file.

Should you need to edit your `kyzenred.kvconfig` file it's wiser to edit `src/kvconfigtemplate` instead and rerun the `scripts/kyzenred-generate.sh` script.

### `kvconfigtemplate`

This file is actually quite similar to a standard `.kvcondfig` file with the exception of templated values.

These are easily recognizable as they are wrap in moustaches ( "{{" and "}}" ).

As long as you don't touch these everything should be fine. 

If you want to know more about this I recommend you to look at the scripts files. They are quite easy to read as long as you're familiar with bash.

