# desktop-manager
A script written in Swift to optimize the macOS Workflow. Toggle between applications with Keyboard Shortcuts and hide them on toggle.

## What does it do?
While the script is running, it listens for specified keybindings that are bound to specified applications. If the keybinding gets hit, the script will hide the current frontmost application and activate the application bound to the keybinding. This can speed up your workflow by a lot.

## Compilation/Building
This command assumes you are in the "desktop-manager" directory.
```swiftc Keyboard\ Shortcuts/* main.swift```

## Usage
```./desktop-manager 'firefox=command+11' 'notes=control+39' # Open Firefox with Command + B (11 is the Keycode for b) and alalacritty with Control + Enter (39 is the Keycode for the Enter key)...```
You can find out the macOS Keycodes by searching the web or searching this file (you'll need to have the Xcode command line tools installed):
```/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h```
