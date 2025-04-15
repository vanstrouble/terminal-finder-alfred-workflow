#!/bin/zsh

# Get the path of the active Finder window
current_path=$(osascript -e 'tell application "Finder" to if (count of windows) > 0 then get POSIX path of (target of front window as text)')

# Check if no valid path was obtained (exit early pattern)
if [[ -z "$current_path" ]]; then
    echo "Could not get the path or there are no open Finder windows."
    exit 1
fi

echo "Current path: $current_path"

# Use Terminal.app with improved tab creation
osascript <<EOF
try
    tell application "Terminal"
        activate

        # Create window only if needed, otherwise create new tab
        if (count of windows) = 0 then
            do script "cd \"${current_path}\""
        else
            # Use System Events for reliable tab creation
            tell application "System Events"
                tell process "Terminal"
                    keystroke "t" using command down
                end tell
            end tell

            # Small delay to ensure tab is ready
            delay 0.2

            do script "cd \"${current_path}\"" in front window
        end if
    end tell
on error errMsg
    display dialog "Error: " & errMsg
end try
EOF
