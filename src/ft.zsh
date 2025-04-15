#!/bin/zsh

# Get the path of the active Finder window
current_path=$(osascript -e 'tell application "Finder" to if (count of windows) > 0 then get POSIX path of (target of front window as text)')

# Check if a valid path was obtained
if [[ -n "$current_path" ]]; then
    echo "Current path: $current_path"

    # Use Terminal.app with improved tab creation
    osascript <<EOF
    try
        tell application "Terminal"
            activate

            if (count of windows) = 0 then
                # No windows exist, create a new one
                do script "cd \"${current_path}\""
            else
                # Create a new tab using keyboard shortcut regardless of current state
                tell application "System Events"
                    tell process "Terminal"
                        keystroke "t" using command down
                    end tell
                end tell

                # Give the new tab time to initialize
                delay 0.3

                # Change to the desired directory in the newest tab
                do script "cd \"${current_path}\"" in front window
            end if
        end tell
    on error errMsg
        display dialog "Error: " & errMsg
    end try
EOF
else
    echo "Could not get the path or there are no open Finder windows."
fi
