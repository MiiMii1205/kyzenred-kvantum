# Kyzenred
A full KDE theme based on gamer aesthetics and modern minimalism (Kvantum theme)

## Dependencies
- KDE >= 5
- Kvantum 
- Bash

## Installation
Just put this repository in your `~/.config/Kvantum/` directory (make a new one if it doesn't exist)

## Usage
Setting up the Kyzenred Kvantum theme is straight forward! Just follow [this](https://github.com/tsujan/Kvantum/blob/master/Kvantum/INSTALL.md#usage).

Essentially, once you've installed Kvantum (and Kyzenred), just open up the Kvantum Manager app.
From there, you'll just need to change your theme to Kyzenred. If you installed it correctly it should show up in the Kvantum theme selection menu.

## Updating the color scheme
At its core, Kyzenred comes with pre-rendered assets that matches it's official color scheme. That means that you can use Kyzenred as is.
However, Kyzenred was designed to handle (more or less) any KDE color scheme you'll throw at it.

To find out how to change your KDE color scheme, [click here](https://docs.kde.org/trunk5/en/kde-workspace/kcontrol/colors/index.html)!
### Regenerate the Kvantum assets
Generating the GUI assets for Kvantum is quite easy. 
Go to the theme's directory with a terminal and execute the `kyzenred-generate.sh` script in the `scripts` directory like so:
```bash
    $ ./kyzenred-generate.sh 
```
This usually takes no more than a second. To refresh Kvantum, you might want to either switch to another theme and back or log out and back in. 
Remember to re-run this command every time you change your color scheme, otherwise you're in for a bumpy ride!