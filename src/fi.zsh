tell application "Finder"
    set pathList to (quoted form of POSIX path of (folder of the front window as alias))
end tell

do shell script "open -a Terminal.app " & pathList & " && osascript -e 'tell application \"Terminal\" to do script \"cd " & pathList & " && exec zsh --no-rcs\" in front window'"
