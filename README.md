# ardour-scripts
My Ardour utility scripts

Ardour supports having scripts (written in the Lua language) that give you
extra features or functionality in Ardour. They can range from menu buttons
to do various things to actual DSPs that process your audio. If you ever
wanted Ardour to do something that it doesn't do already, there's a decent
chance you might be able to get it to do it through scripting.

Here you'll find any scripts I've written or modified for Ardour, but you
can find plenty more via the [Ardour website](https://ardour.org/).

There may or may not be more info on [my website](https://ajg.net.au/) as well.

ajg-autosave.lua
 - automatically creates a backup snapshot of your project every minute
 - keeps the last 5 minutes of snapshots
 - snapshots appear in the standard "Recent Sessions" dialog as snapshots.
