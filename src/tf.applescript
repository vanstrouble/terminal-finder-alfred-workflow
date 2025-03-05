on run argv
    tell application "Terminal"
        do script "open -a Finder ./" in first window
    end tell
end run
