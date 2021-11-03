import Cocoa

// Get the command line arguments and parse them.
let arguments = CommandLine.arguments

struct Argument {
    var application: String
    var keyboardShortcut: String
}

// Parse the arguments
// The first argument (at index 0) is the file itself (desktop-manager.swift or desktop-manager when compiled)
enum ParserState {
    case application
    case shortcut
}

var items = [Argument]()

for i in 1 ..< arguments.count {
    let string = arguments[i]
    var argument = Argument.init(application: "", keyboardShortcut: "")
    var state = ParserState.application
    for character in Array(string) {
        if character == "=" {
            state = .shortcut
            continue
        }
        if state == .application {
            argument.application.append(String(character))
            continue
        } else if state == .shortcut {
            argument.keyboardShortcut.append(String(character))
        }
    }
    items.append(argument)
}
enum ShortcutParsingType {
    case modifier
    case keycode
}
// Listen for keyboard shortcuts
for item in items {
    // Parse the modifier and the keycode.
    var modifierString = ""
    var keycodeString = ""
    var parsingType = ShortcutParsingType.modifier
    for character in Array(item.keyboardShortcut) {
        if character == "+" {
            parsingType = .keycode
            continue
        }
        if parsingType == .keycode {
            keycodeString.append(character)
            continue
        }
        if parsingType == .modifier {
            modifierString.append(character)
            continue
        }
    }
    
    let keycode = UInt32(keycodeString)!
    let modifier = KeyboardShortcutModifier(rawValue: modifierString)!
    KeyboardShortcutManager(keyboardShortcut: KeyboardShortcut(key: Key(keyCode: keycode), modifiers: [modifier], events: [.keyDown])).startListeningForEvents { _ in
        let workspace = NSWorkspace.shared
        // Hide all applications
        for app in workspace.runningApplications {
            if app.localizedName != item.application {
                // Completely quit my Terminal because it launches quickly anyways and does use some memory!
                if app.localizedName == "Alacritty" {
                    app.terminate()
                }
                app.hide()
            } 
        }
        usleep(2000)
        workspace.launchApplication(item.application)
    }
}

let app = NSApplication.shared
app.activate(ignoringOtherApps: true)
app.run()
