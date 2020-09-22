#!/bin/bash

# Prompt user

echo "This script themes Ubuntu on WSL profiles in Windows Terminal and Windows Terminal Preview"
echo
echo "Your settings.json will be backed up to settings.json.bak, use restore.sh to restore it."
echo
echo "Visual assets will by copied to the same folder as settings.json."
echo
echo "This installer assumes a default Windows Terminal settings.json. If you have customization"
echo "applied you are advised to apply customizations manually."
echo 
read -p "Continue? [y/N] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Continuing..."
else
  echo "Exiting..."
  exit 0
fi

# Check if wslu is installed, required for wslvar
# http://manpages.ubuntu.com/manpages/focal/en/man1/wslvar.1.html

echo Checking to see if wslu is installed
if [ $(dpkg-query -W -f='${Status}' wslu 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
  echo wslu not found, installing...
  sudo apt update
  sudo apt -y install wslu
else
  echo wslu found
fi

# Get %LOCALAPPDATA% variable from Windows and convert to Linux path

localappdata=$(wslpath $(wslvar LOCALAPPDATA))

# Check if Windows Terminal is installed

settings="settings.json"
wtpath="/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/"
file=$localappdata$wtpath$settings
if [ -f "$file" ]; then
  echo "Windows Terminal found"
  wt=true
else
  echo "Windows Terminal not found"
  wt=false
fi

# Check if Windows Terminal Preview is installed

wtppath="/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/"
file=$localappdata$wtppath$settings
if [ -f "$file" ]; then
  echo "Windows Terminal Preview found"
  wtp=true
else
  echo "Windows Terminal Preview not found"
  wtp=false
fi

# Check if we have at least one Windows Terminal or Windows Terminal Preview

if [ $wt = true ] || [ $wtp = true ]; then
  echo "At least one Windows Terminal found"
else
  echo "No Windows Terminal found, exiting."
  echo "Please install Windows Terminal from the Microsoft Store or GitHub."
  exit 1
fi

# Check if ./assets are present

if [ -d "./assets" ]; then
  echo "Ubuntu assets found"
else
  echo "Ubuntu assets not found, exiting"
  echo "Please extract the complete Ubuntu theme archive"
  exit 1
fi

# Check if we have write permissions to stash assets

testfile=$localappdata$wtpath"testfile"
if touch "$testfile" ; then
  echo "Write permissions found"
  rm $testfile
else
  echo "Unable to create file on Windows file system, exiting"
  exit 1
fi

# Backup existing settings

settingsbak="settings.json.bak"
if [ $wt = true ]; then
  echo "Backing up Windows Terminal settings to settings.json.bak"
  cp $localappdata$wtpath$settings $localappdata$wtpath$settingsbak
fi

if [ $wtp = true ]; then
  echo "Backing up Windows Terminal Preview settings to settings.json.bak"
  cp $localappdata$wtppath$settings $localappdata$wtppath$settingsbak
fi

# Copy assets

if [ $wt = true ]; then
  echo "Copying assets to Windows Terminal"
  cp assets/* $localappdata$wtpath
fi

settingsbak="settings.json.bak"
if [ $wtp = true ]; then
  echo "Copying assets to Windows Terminal Preview"
  cp assets/* $localappdata$wtppath
fi

# Install font

echo
echo "A window will open to install the Ubuntu monospace font."
echo "Click 'Install' and then close the window."
echo

wslview assets/UbuntuMono-R.ttf

# Apply theme

if [ $wt = true ]; then

# TODO: add default user detection:
# echo "Getting default user for Ubuntu"
# defaultuser=$(wsl.exe -d "Ubuntu" --exec whoami)
# need to check Ubuntu, Ubuntu-18.04, Ubuntu, Ubuntu-Insiders

echo "Applying theme to Windows Terminal"

 sed -i \
'/"name": "Ubuntu",/a \
\                "fontFace": "Ubuntu Mono", \
\                "colorScheme" : "Yaru", \
\                "cursorColor" : "#FFFFFF", \
\                "useAcrylic" : true, \
\                "acrylicOpacity" : 0.7, \
\                "icon" : "%LOCALAPPDATA%\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\icon.png", \
\                "backgroundImage" : "%LOCALAPPDATA%\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\xenial.png", \
\                "padding" : "5, 5, 5, 5", \
\                "suppressApplicationTitle": true, \
\                "tabTitle": "Ubuntu",' $localappdata$wtpath$settings

 sed -i \
'/"name": "Ubuntu-18.04",/a \
\                "fontFace": "Ubuntu Mono", \
\                "colorScheme" : "Yaru", \
\                "cursorColor" : "#FFFFFF", \
\                "useAcrylic" : true, \
\                "acrylicOpacity" : 0.7, \
\                "backgroundImage" : "%LOCALAPPDATA%\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\bionic.png", \
\                "icon" : "%LOCALAPPDATA%\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\icon.png", \
\                "padding" : "5, 5, 5, 5", \
\                "suppressApplicationTitle": true, \
\                "tabTitle": "Ubuntu 18.04 LTS",' $localappdata$wtpath$settings

 sed -i \
'/"name": "Ubuntu-20.04",/a \
\                "fontFace": "Ubuntu Mono", \
\                "colorScheme" : "Yaru", \
\                "cursorColor" : "#FFFFFF", \
\                "useAcrylic" : true, \
\                "acrylicOpacity" : 0.7, \
\                "backgroundImage" : "%LOCALAPPDATA%\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\focal.png", \
\                "icon" : "%LOCALAPPDATA%\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\icon.png", \
\                "padding" : "5, 5, 5, 5", \
\                "suppressApplicationTitle": true, \
\                "tabTitle": "Ubuntu 20.04 LTS",' $localappdata$wtpath$settings

 sed -i \
'/"name": "Ubuntu-16.04",/a \
\                "fontFace": "Ubuntu Mono", \
\                "colorScheme" : "Yaru", \
\                "cursorColor" : "#FFFFFF", \
\                "useAcrylic" : true, \
\                "acrylicOpacity" : 0.7, \
\                "backgroundImage" : "%LOCALAPPDATA%\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\xenial.png", \
\                "icon" : "%LOCALAPPDATA%\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\icon.png", \
\                "padding" : "5, 5, 5, 5", \
\                "suppressApplicationTitle": true, \
\                "tabTitle": "Ubuntu 20.04 LTS",' $localappdata$wtpath$settings


# TODO: add:
# fix escaping of '\\' in paths (is reduced to a single \)
# \                "startingDirectory": "\\\\\\wsl$\\Ubuntu\\home\\$defaultuser", \


 if grep -q 'name" : "Yaru",' $localappdata$wtpath$settings; then
   echo "Yaru scheme detected, skipping"
 else
   sed -i \
'/"schemes": \[/a \
\        { \
\            "name" : "Yaru", \
\            "foreground": "#d3d7cf", \
\            "background": "#5E2750", \
\            "cursorColor": "#eeeeec", \
\            "black": "#2e3436", \
\            "red": "#cc0000", \
\            "green": "#4e9a06", \
\            "yellow": "#c4a000", \
\            "blue": "#3465a4", \
\            "purple": "#75507b", \
\            "cyan": "#06989a", \
\            "white": "#d3d7cf", \
\            "brightBlack": "#555753", \
\            "brightRed": "#ef2929", \
\            "brightGreen": "#8ae234", \
\            "brightYellow": "#fce94f", \
\            "brightBlue": "#729fcf", \
\            "brightPurple": "#ad7fa8", \
\            "brightCyan": "#34e2e2", \
\            "brightWhite": "#eeeeec" \
\        },
' $localappdata$wtpath$settings
 fi
fi