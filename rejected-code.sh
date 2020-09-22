## Check and install depedencies:

# jq
# moreutils
# wslu

# Check if jq is installed, required for parsing json
# http://manpages.ubuntu.com/manpages/focal/man1/jq.1.html

# echo Checking to see if jq is installed
# if [ $(dpkg-query -W -f='${Status}' jq 2>/dev/null | grep -c "ok installed") -eq 0 ];
# then
#  echo jq not found, installing...
#  apt update
#  apt -y install jq
# else
#  echo jq found
# fi

# jq cannot parse settings.json, results in:
# "parse error: Invalid numeric literal at line 1, column 3"
# ¯\_(ツ)_/¯

# Check if moreutils is installed, required for sponge
# http://manpages.ubuntu.com/manpages/focal/en/man1/sponge.1.html

# echo Checking to see if moreutils is installed
# if [ $(dpkg-query -W -f='${Status}' moreutils 2>/dev/null | grep -c "ok installed") -eq 0 ];
# then
#  echo moreutils not found, installing...
#  apt update
#  apt -y install moreutils
# else
#  echo moreutils found
# fi

# If we can't use jq, then there's no sense in using sponge