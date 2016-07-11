# RetroArch Playlist Creator
====

This is a **shellscript** version of a Windows CMD script by **/u/ShiftyAxel** on reddit.

The links for some of the discussion are in the script comments section.

This is intended for Linux / UNIX / BSD / CygWin / Babun users who want to create playlists,
when **RetroArch** won't read a rom folder.

There is now a config file ```.ra-playlist.cfg```

Invoke the script with: 

```ra-playlist.sh -h``` to get the help screen.


```ra-playlist.sh -c``` to get a list of installed cores

```ra-playlist.sh -m``` to create one or more playlists

```ra-playlist.sh -p``` to get a list of existing playlists

```ra-playlist.sh -s``` to search available playlist names for a particular system.
Playlists must be named a certain way. Fortunately, retroarch's crew assigned the 
same names to the icons that represent them. This function parses those icon names,
and presents them for you to use.


```ra-playlist.sh [no arguments]``` to show the help screen

