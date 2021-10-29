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
killall desktop-manager
open -a desktop-manager-launcher
