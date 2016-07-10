# RetroArch Playlist Creator
====

This is a **shellscript** version of a Windows CMD script by **/u/ShiftyAxel** on reddit.

The links for some of the discussion are in the script comments section.

This is intended for Linux / UNIX / BSD / CygWin / Babun users who want to create playlists,
when **RetroArch** won't read a rom folder.

***BEFORE*** invoking the script, you should edit the relative sections.
Read the script for more info.

Invoke the script with: 

```ra-playlist.sh -h``` to get a help screen.


```ra-playlist.sh -c``` to get a list of installed cores


```ra-playlist.sh -p``` to get a list of existing playlists

```ra-playlist.sh -s``` to search available playlist names for a particular system.
Playlists must be named a certain way. Fortunately, retroarch's crew assigned the 
same names to the icons that represent them. This function parses those icon names,
and presents them for you to use.


```ra-playlist.sh [no arguments]``` to create a playlist for the system(s) you've setup in the script.

