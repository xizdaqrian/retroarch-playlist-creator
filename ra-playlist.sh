#!/bin/bash
###############################################################################
# ra-playlist.sh
# version 0.5
# Jul-09-2016
# ~by~ Rodney Fisk
# xizdaqrian@gmail.com
# https://github.com/xizdaqrian/retroarch-playlist-creator
###############################################################################
#
#    Xizdaqrian's
#    shell mod of:
#     Shifty's RetroArch Playlist Script
#
###############################################################################
# Some useful URL's regarding the issue
# https://www.reddit.com/r/RetroArch/comments/43dj1n/playlist_creator_for_retroarch_on_windows/
# https://www.reddit.com/r/RetroArch/comments/42lovj/how_do_you_linuxlakka_guys_create_your_own/
# https://www.reddit.com/r/emulation/comments/3imlri/i_wrote_a_batch_script_to_add_unsupported_roms_to/
###############################################################################
#
# This script will create per-system ROM playlists,
# the files used to display system columns in the RetroArch XMB UI
# It exists to work around the romset checksumming that is forced
# in the current (1.2.2 at time of writing) build of RetroArch
# Put simply, this will let you create playlists with ROMs that
# the Add Content > Scan Directory/File process would usually ignore
#
# =================>  WARNING:  <============================================= 
# This script is not compatible with the
# Add Content > Scan Directory/File process
# It will erase existing playlists as part of the generation process,
# so make sure to back them up beforehand if necessary
###############################################################################
#
# =================>  WARNING:  <============================================= 
# If an existing playlist is found, it will be backed up to 'playlist'.backup.
# For example, if 'MaMe.lpl' is found, it will be backed up to 'Mame.backup'
# if the backup already exists, it will be overwritten!
###############################################################################

# For each RetroArch core, add one of these blocks below:
# RomDirs[n]=
# CoreLibs[n]=
# CoreNames[n]=
# PlaylistNames[n]=
# SupportedExtensions[n]=
#
## The numbers in square brackets need to start at 0,
# and be incremented by 1 for each block added
#
## RomDirs[n] should be set to the ROM subdirectory for
# this core (ex. "SNES" will cause the script to scan ROMDir\SNES)
#
## CoreLibs[n] should be set to the core's DLL filename (in RetroArch\cores)
#
## CoreNames[n] should be set to the human-readable name of the
# RetroArch core (bracketed names in the RetroArch 'Load Core' menu)
#
## PlaylistNames[n] should be set to the RetroArch name of this core's
# platform (look at the icon filenames in RetroArch\assets\xmb\monochrome\png\)
#
## SupportedExtensions[n] should be set to the supported extensions for this core,
# (available in the RetroArch Information -> Core Info menu)
#
## Example Config
# The config below will create playlist files for SNES, MegaDrive/Genesis and Sega Master System ROMs
#
#  RomDirs[0]=SNES
#  CoreLibs[0]=snes9x_next_libretro.so
#  CoreNames[0]=Snes9x Next
#  PlaylistNames[0]=Nintendo - Super Nintendo Entertainment System
#  SupportedExtensions[0]=*.smc *.fig *.sfc *.gd3 *.gd7 *.dx2 *.bsx *.swc
#
#  RomDirs[1]=MD
#  CoreLibs[1]=genesis_plus_gx_libretro.so
#  CoreNames[1]=Genesis Plus GX
#  PlaylistNames[1]=Sega - Mega Drive - Genesis
#  SupportedExtensions[1]=*.md *.mdx *.gen *.sg *.bin
#
#  RomDirs[2]=SMS
#  CoreLibs[2]=genesis_plus_gx_libretro.so
#  CoreNames[2]=Genesis Plus GX
#  PlaylistNames[2]=Sega - Master System - Mark III
#  SupportedExtensions[2]=*.sms *.bin

# Change these to point to your RetroArch and top-level ROM directories
#------------------------------------------------------------------------------

# Base path to retroArch - -r==readonly
declare -r RA_DIR="/cygdrive/c/Games/Emulation/Arcade/retroarch/RetroArch-v1.3.0-x86_64-Windows"

# MaMe
#SYS_NAMES[0]="MaMe"
#SYS_CORES[0]="mame2014_libretro.dll"
#SYS_ROM_DIRS[0]="/cygdrive/c/Games/Emulation/Arcade/Roms/Mame_0.161_ROMs/Keepers"
#SYS_ROM_EXTENSIONS[0]=".zip"

#------------------------------------------------------------------------------
# You can safely ignore everything below here.
#------------------------------------------------------------------------------

# Playlist requires a CRC, so we just make it zero
declare -r CRC="00000000|CRC"

check_info(){
    # if the array 'sys_names' is 0 length, then exit with error
    ## this just checks to see if the above config has been filled in.
    if [ -z "${SYS_NAMES[@]}" ]; then
        echo "No Systems are setup..."
        echo -e "Please read the script for more information\n"
        show_help
        exit 1
    fi
}

create_playlist(){

    COUNTER=0
    # Arrays always start to count elements from 0.
    # This runs from 0 to the number of elements in the array,
    ## which is the number of configs above.
    while [ "$COUNTER" -lt ${#SYS_NAMES[@]} ]; do
        TARG_FILE="$RA_DIR/Playlists/${SYS_NAMES[$COUNTER]}.lpl"
        BACKUP_FILE="$RA_DIR/Playlists/${SYS_NAMES[$COUNTER]}.backup"

        # Backup if we find a file already in place.
        if [ -f "$TARG_FILE" ]; then
            echo -e "${TARG_FILE} exists... backing up\n"
            sleep 2
            mv -v "${TARG_FILE}" "${BACKUP_FILE}"
        fi

        echo "Writing values for: ${SYS_NAMES[$COUNTER]}"
        OUTPUT_FILE="${RA_DIR}"/Playlists/"${SYS_NAMES[$COUNTER]}".lpl
        for ROM_FILE in ${SYS_ROM_DIRS[$COUNTER]}/*${SYS_EXTENSIONS[$COUNTER]}; do
            #echo "${ROM_FILE}" 
            #echo "$( basename "$ROM_FILE" ${SYS_ROM_EXTENSIONS[$COUNTER]} )"
            #echo "${SYS_ROM_EXTENSIONS[$COUNTER]}"
            #echo "$RA_DIR"/Cores/"${SYS_CORES[$COUNTER]}"
            #echo "${SYS_NAMES[$COUNTER]}"
            #echo "${CRC}"
            #echo "${SYS_NAMES[$COUNTER]}".lpl
            echo "$ROM_FILE" >> "${OUTPUT_FILE}"
            echo "$( basename "$ROM_FILE" ${SYS_ROM_EXTENSIONS[$COUNTER]} )" >> "${OUTPUT_FILE}"
            echo "${RA_DIR}"/Cores/"${SYS_CORES[$COUNTER]}" >> "${OUTPUT_FILE}"
            echo "${SYS_NAMES[$COUNTER]}" >> "${OUTPUT_FILE}"
            echo "${CRC}" >> "${OUTPUT_FILE}"
            echo "${SYS_NAMES[$COUNTER]}".lpl >> "${OUTPUT_FILE}"
        done
        COUNTER+=1
        echo "Values entered into:\n${OUTPUT_FILE}"
    done

}

search_playlist_names(){
    PNG_FOLDER="${RA_DIR}/assets/xmb/monochrome/png"
    SEARCH_TERM="${1}"

    #echo "PNG_FOLDER = ${PNG_FOLDER}"
    #echo "SEARCH_TERM = $SEARCH_TERM"
    echo "$( find "${PNG_FOLDER}" -iname "${SEARCH_TERM}*" ! -iname "${SEARCH_TERM}*-content.png" \
        -exec basename "{}" .png \; )"

    exit
}

show_banner(){
    echo  " ============================================"
    echo  "|      xizdaqrian's shell port of:           |"
    echo  "|      Shifty's RetroArch Playlist Script    |"
    echo  " ============================================"
}

show_cores(){
    echo " ============================================"
    echo "|            Installed Cores:                |"
    echo " ============================================"

    if [ "$RA_DIR" != "" ]; then
        for core in "$RA_DIR"/Cores/*.dll; do
            echo "$( basename "$core")"
        done
        exit 0
    else
        echo "No path specified for Retroarch"
        echo -e "Please read the script for more information\n"
        show_help
    fi
}


show_help(){
cat <<End-of-message
    USAGE: ra-playlist.sh [-c] [-h] [-p] [-s SYSTEM ]
    If you see this help message, then please
    open and edit the script.

    -c: List installed cores
    -h: Display this help
    -p: List existing playlists
    -s: Search for playlist names by SYSTEM
        (ex. ra-playlist.sh -s Nintendo )
End-of-message
    exit 0
}

show_playlists(){
    echo " ============================================"
    echo "|          Configured Playlists:             |"
    echo " ============================================"

    if [ "$RA_DIR" != "" ]; then
        for playlist in "$RA_DIR"/Playlists/*.lpl; do
            echo "$( basename "$playlist")"
        done
        exit 0
    else
        echo "No path specified for Retroarch"
        echo -e "Please read the script for more information\n"
        show_help
    fi
}

### Main
show_banner
while getopts chps: option
do
    case "${option}" in
        c) show_cores ;;
        h) show_help ;;
        p) show_playlists ;;
        s) search_playlist_names "${OPTARG}" ;;
    esac
done

#show_banner
check_info
create_playlist
#show_cores
#show_playlists
