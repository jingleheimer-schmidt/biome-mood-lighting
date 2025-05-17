[![Ko-fi Donate](https://img.shields.io/badge/Ko--fi-Donate%20-indianred?logo=kofi&logoColor=white)](https://ko-fi.com/asher_sky) [![GitHub Contribute](https://img.shields.io/badge/GitHub-Contribute-blue?logo=github)](https://github.com/jingleheimer-schmidt/biome-mood-lighting) [![Crowdin Translate](https://img.shields.io/badge/Crowdin-Translate-green?logo=crowdin)](https://crowdin.com/project/factorio-mods-localization) [![Mod Portal Download](https://img.shields.io/badge/Mod_Portal-Download-orange?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAsAAAALCAMAAACecocUAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9bS4tUHewg4hCwOlkQFXHUKhShQqgVWnUwufQLmjQkKS6OgmvBwY/FqoOLs64OroIg+AHi4uqk6CIl/i8ptIjx4Lgf7+497t4B/kaFqWbXOKBqlpFOJoRsblUIvSKMIHoxjJjETH1OFFPwHF/38PH1Ls6zvM/9OXqUvMkAn0A8y3TDIt4gnt60dM77xFFWkhTic+Ixgy5I/Mh12eU3zkWH/TwzamTS88RRYqHYwXIHs5KhEk8RxxRVo3x/1mWF8xZntVJjrXvyF0by2soy12kOIYlFLEGEABk1lFGBhTitGikm0rSf8PAPOn6RXDK5ymDkWEAVKiTHD/4Hv7s1C5MTblIkAQRfbPtjBAjtAs26bX8f23bzBAg8A1da219tADOfpNfbWuwI6NsGLq7bmrwHXO4AA0+6ZEiOFKDpLxSA9zP6phzQfwt0r7m9tfZx+gBkqKvUDXBwCIwWKXvd493hzt7+PdPq7wdcTnKeyn2biAAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+MIBQ4nOKPzX44AAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAAAnFBMVEUAAAAAAAAAAAAAAABBPj5EQ0NBQUFCQkJYV1daWlpcXFxfXl19enl7enp6enp9fX2Rjo2Ojo6RkZGUk5OfnJufn5+goKCioqK5uLe3t7e5ubm6urrPz8/Pz8/R0NDT0tHT09PV1dXW1tXh4ODh4eHg4ODh4eHi4eHi4uLi4uLi4uLk4+Pk5OTl5eXm5ubm5ubn5ubn5+fp6en+/vsJa+h2AAAAMnRSTlMAAgMEEBIUFR0jJSY8PUBDU1daX2hucHOTlpicxcbIyc7R0unq6+vt7e7v8vT2+Pn6+p+as4UAAAABYktHRDM31XxeAAAAYUlEQVQIHQXBBQLCQBDAwJTF3b0Uh2IH+f/jmAGA5yYygG65OFpOOoMMmqrqJWCoaZt0FizPpnpUP+6Dh+YR5PqGwtSIWvK6gqn+dl8dBZxU1VZArz2+eZjf+xkA61dUgD8jzgwslUkzIwAAAABJRU5ErkJggg==)](https://mods.factorio.com/mod/biome-mood-lighting)

# Overview

* Adds a lamp that is colored based on the biome where it is built
* Adds a constant combinator that outputs the color of the biome where it is built
* Combinator color is provided as component Red, Green, and Blue signals
* Lamp color and combinator signal values are updated when the entity is built, and every time the GUI is opened
* Biome color is based on the map color of the dominant tile in a small radius around the entity
* Includes Universal Mode startup setting to apply the biome color effect to all lamps
* Includes startup settings to hide the lamp and combinator recipes from the crafting menu

***

# Companion Mods

* [Colored Lamp Normalizer](https://mods.factorio.com/mod/circuit-color-lamp-light-parity) - Modifies circuit-controlled colored lamps to shine with the same radius and intensity as manually-colored ones
* [Subtle Lighting](https://mods.factorio.com/mod/dim_lamps) - Modifies the intensity of lamps, creating a more gradual falloff to the darkness beyond
* [Glowing Trees](https://mods.factorio.com/mod/glowing_trees) - Adds a glowing aura to the trees, and bioluminescence for foliage and decoratives

***

# Compatibility

This mod is generally compatible with all other mods, unless they remove or significantly change the base lamp or constant combinator.

***

# Translation

Help translate Biome Mood Lighting to more languages: https://crowdin.com/project/factorio-mods-localization
Currently available locale:
🇺🇸 English (en), 🇷🇺 Russian (ru)

***

# Credits

This mod was inspired by [a post on the Glowing Trees Discussion tab](https://mods.factorio.com/mod/glowing_trees/discussion/67790efaf222dda95da53fa0)
Special thanks to justarandomgeek for the [Factorio Modding Toolkit](https://github.com/justarandomgeek/vscode-factoriomod-debug), an invaluable resource

***

# License

Biome Mood Lighting © 2025 by asher_sky is licensed under Attribution-NonCommercial-ShareAlike 4.0 International.
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
