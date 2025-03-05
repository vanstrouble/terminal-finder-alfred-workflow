on run argv
    tell application "iTerm"
        tell the current session of current window
            write text "open -a 'Path Finder' ./"
        end tell
    end tell
end run
