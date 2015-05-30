import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet var buildAppButton: NSButton!
    @IBOutlet var scriptDrop: IAScriptDrop!
    @IBOutlet var iconDrop: IAIconDrop!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
    }
    
    @IBAction func buildAppClicked(sender : AnyObject) {
        if self.scriptDrop.scriptPath {
            let savePanel = NSSavePanel.savePanel
            savePanel.setExtensionHidden(true)
            savePanel.allowedFileTypes = ["app"]
            savePanel.allowsOtherFileTypes = false
            savePanel.nameFieldStringValue = self.scriptDrop.scriptPath.lastPathComponent.stringByDeletingPathExtension
            
            savePanel.beginWithCompletionHandler({ (result) -> Void in
                if response == NSFileHandlingPanelOKButton {
                    let converter: ScriptConverter = ScriptConverter(
                        path: scriptDrop.scriptPath,
                        savePath: savePanel.URL,
                        iconPath: self.iconDrop.iconPath
                    )
                    converter.createApp();
                }
            })
        }
        else {
            let alert: NSAlert = NSAlert(
                message: "No script selected",
                defaultButton: "OK",
                alternateButton: nil,
                otherButton: nil,
                informativeTextWithFormat: "Please select a script file"
            )
            alert.runModal();
        }
    }
}

