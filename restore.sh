#!/bin/bash

# Prompt user

echo "This script restores your Windows Terminal settings.json.bak file as settings.json"
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
  exit 1
fi

# Restore settings

settingsbak="settings.json.bak"
if [ $wt = true ]; then
  echo "Restoring Windows Terminal settings from settings.json.bak"
  cp $localappdata$wtpath$settingsbak $localappdata$wtpath$settings
fi

settingsbak="settings.json.bak"
if [ $wtp = true ]; then
  echo "Restoring Windows Terminal Preview settings from settings.json.bak"
  cp $localappdata$wtppath$settingsbak $localappdata$wtppath$settings
fi