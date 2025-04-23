#!/bin/bash
# eval i3-msg $*

# dnf install -y xwininfo xdotool

# HERE=`xdotool getwindowfocus`

# ULX=`xwininfo -id $HERE | grep "  Absolute upper-left X:" | awk '{print $4}'`
# ULY=`xwininfo -id $HERE | grep "  Absolute upper-left Y:" | awk '{print $4}'`

# # If there is no window, ULX == 1 and ULY == 1.
# if [ $ULX != "-1" -o $ULY != "-1" ]; then
#     eval `xdotool getwindowgeometry --shell $HERE`

#     # NX=`expr $WIDTH / 2`
#     # NY=`expr $HEIGHT / 2`

#     xdotool mousemove --window $WINDOW $NX $NY
# fi

set -x

# x:3864 y:581
# Define mouse coordinates for the left click (example: x=500, y=300)
MOUSE_X=3872
MOUSE_Y_1=790
MOUSE_Y_2=842

get_idle_time_wayland() {
    dbus-send --print-reply --dest=org.gnome.Mutter.IdleMonitor \
        /org/gnome/Mutter/IdleMonitor/Core \
        org.gnome.Mutter.IdleMonitor.GetIdletime \
        | awk '/uint64/ {print $2}'
}

# Function to detect if the cursor has moved in the last 5 minutes
check_cursor_idle() {
    if [ $XDG_SESSION_TYPE == "wayland" ]; then
        idle_time=$(get_idle_time_wayland)  # Requires xprintidle installed, returns idle time in milliseconds
    else
        idle_time=$(xprintidle)
    fi
    if [[ "$idle_time" -ge 300 ]]; then  # 5 minutes = 300000 milliseconds
        return 0  # Idle for 5 minutes
    else
        return 1  # Cursor moved in less than 5 minutes
    fi
}

# Infinite loop for checking idle status and performing actions
while true; do
    # Check if the cursor is idle for 5 minutes
    if check_cursor_idle; then
        echo "Cursor idle for 5 minutes, starting task..."

        # Start the task loop: switch screens, click, and repeat
        while check_cursor_idle; do
            # Switch to screen 2 (use your actual screen-switching method, e.g., keyboard shortcut)
            # xdotool key --window $(xdotool getactivewindow) F1  # Example for switching to screen 2
            xdotool set_desktop 2

            # Wait for a moment
            sleep 1

            # Left click at the specified coordinates
            xdotool mousemove $MOUSE_X $MOUSE_Y_1 click 1
            xdotool mousemove $MOUSE_X $MOUSE_Y_2 click 1
            # ydotool
            # dotool

            # Wait for 1 second before switching to the next screen
            sleep 1

            # Switch to screen 3
            # xdotool key --window $(xdotool getactivewindow) F2  # Example for switching to screen 3
            xdotool set_desktop 3
            # wmctrl -s 3

            # Wait for a moment
            sleep 1

            # Left click at the specified coordinates
            xdotool mousemove $MOUSE_X $MOUSE_Y_1 click 1
            sleep 2
            xdotool mousemove $MOUSE_X $MOUSE_Y_2 click 1

            # Check every 10 seconds if the cursor is still idle
            sleep 10
        done

        echo "Cursor moved, pausing task loop..."
    else
        # Wait for a short period before checking idle status again
        sleep 10
    fi
done
