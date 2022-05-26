#! /bin/bash
st -e python3 &
pid="$!"

# Wait for the window to open and grab its window ID
winid=''
while : ; do
    winid="`wmctrl -lp | awk -vpid=$pid '$3==pid {print $1; exit}'`"
    [[ -z "${winid}" ]] || break
done

# Focus the window we found
wmctrl -ia "${winid}"

# Make it float
i3-msg floating enable > /dev/null;

# Move it to the center for good measure
#i3-msg move position center > /dev/null;
i3-msg resize set 20 ppt 40 ppt, move position 1517 px 340 px > /dev/null;

# Wait for the application to quit
wait "${pid}";
