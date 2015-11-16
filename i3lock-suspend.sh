#!/bin/bash
#############################################################################
# Locks screen via i3lock and suspends to memory                            #
#############################################################################

PM_OPT=""
USAGE="$(basename $0) [-s] [-h] -- use s for suspend, h for hibernate"

# parse command options
case $1 in
    "")
        echo $USAGE
        exit 1
        ;;
    -s)
        PM_OPT='suspend'
        shift # next argument
        ;;
    -h)
        PM_OPT='hibernate'
        shift # next argument
        ;;
     *)
        # unknown option
        echo "unkonwn option: $1"
        echo $USAGE
        exit 1
        ;;
esac

# ensure i3 is open as wm
if [[ $(ps aux | grep "^$USER" | egrep -oc 'i3$') -gt 0 ]]
then
    # lock screen w/ i3lock and suspend to RAM
    i3lock && systemctl $PM_OPT
else
    # didn't find any i3 process(es)
    echo 'i3wm doesn't appear to be running. Can't lock.'
    read -r -p "do you want to $PM_OPT anyway [y/N?] "

    if [[ $($REPLY | egrep -c '[Yy]+') -gt 1 ]]
    then
        # suspend
        sytemctl $PM_OPT
    else
        exit 1
    fi
fi 

exit 0
