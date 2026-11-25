# Assuming the source directory is ~/dev/Projects/desktop-manager
cd ~/dev/Projects/desktop-manager
DIRECTORY=$(basename $PWD)

if [ $DIRECTORY != "desktop-manager" ]; then
	echo "ERROR: You need to be in the 'desktop-manager' source directory."
	exit 1
fi

echo "Waiting on your editor..."
$EDITOR launcher/desktop-manager-launcher.applescript
sh launcher/CreateApp.sh
rm -rf ~/Applications/desktop-manager-launcher.app
mv desktop-manager-launcher.app ~/Applications


# Hide dock icon (background agent)

# Path to your app bundle
APP_PATH="$HOME/Applications/desktop-manager-launcher.app"
PLIST_PATH="$APP_PATH/Contents/Info.plist"

# Check if Info.plist exists
if [ ! -f "$PLIST_PATH" ]; then
    echo "Error: Info.plist not found at $PLIST_PATH"
    exit 1
fi

# Add or update LSUIElement key using PlistBuddy
/usr/libexec/PlistBuddy -c "Add :LSUIElement bool true" "$PLIST_PATH" 2>/dev/null || \
/usr/libexec/PlistBuddy -c "Set :LSUIElement bool true" "$PLIST_PATH"

if [ $? -eq 0 ]; then
    echo "Successfully set LSUIElement to true."
    # Re-sign the app bundle to prevent Gatekeeper / Code Sign issues
    echo "Re-signing application..."
    codesign --force --deep --sign - "$APP_PATH"
    echo "Done! Restart your app to apply the changes."
else
    echo "Failed to update Info.plist."
    exit 1
fi



killall desktop-manager
open -a desktop-manager-launcher
