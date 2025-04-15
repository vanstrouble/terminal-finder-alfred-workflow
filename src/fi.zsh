#!/bin/zsh

# Get the path of the active Finder window
current_path=$(osascript -e 'tell application "Finder" to if (count of windows) > 0 then get POSIX path of (target of front window as text)')

# Check if a valid path was obtained
if [[ -z "$current_path" ]]; then
    echo "Could not get the path or there are no open Finder windows."
else
    echo "Current path: $current_path"

    # Use a more precise approach to handle the state of iTerm
    osascript <<EOF
    -- First check if iTerm is open
    set isRunning to false
    try
        tell application "System Events" to set isRunning to exists (processes where name is "iTerm")
    end try

    tell application "iTerm"
        -- Open application first if it is closed
        if not isRunning then
            -- Open application and wait a moment for it to initialize
            launch
            delay 0.5
        end if

        -- Activate iTerm
        activate

        -- Check if there are windows
        if (count of windows) = 0 then
            -- Create a new window
            create window with default profile
        else
            -- There are already windows, create a new tab
            tell current window
                create tab with default profile
            end tell
        end if

        -- Navigate to the directory in the current session
        tell current session of current window
            write text "cd \"${current_path}\""
        end tell
    end tell
EOF
fi
