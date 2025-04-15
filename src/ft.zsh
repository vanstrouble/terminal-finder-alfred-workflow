#!/bin/zsh

# Get the path of the active Finder window
current_path=$(osascript -e 'tell application "Finder" to if (count of windows) > 0 then get POSIX path of (target of front window as text)')

# Check if a valid path was obtained
if [[ -n "$current_path" ]]; then
    echo "Current path: $current_path"

    # Use Terminal.app instead of iTerm
    osascript <<EOF
    -- First check if Terminal is open
    set isRunning to false
    try
        tell application "System Events" to set isRunning to exists (processes where name is "Terminal")
    end try

    tell application "Terminal"
        -- Open application first if it is closed
        if not isRunning then
            -- Open application and wait a moment for it to initialize
            launch
            delay 0.5
        end if

        -- Activate Terminal
        activate

        -- Check if there are windows
        if (count of windows) = 0 then
            -- Create a new window
            do script ""
        else
            -- There are already windows, create a new tab/window
            do script ""
        end if

        -- Navigate to the directory in the current session
        do script "cd \"${current_path}\"" in front window
    end tell
EOF
else
    echo "Could not get the path or there are no open Finder windows."
fi
