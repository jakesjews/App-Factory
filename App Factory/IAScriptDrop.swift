import Foundation
import Cocoa

class IAScriptDrop: NSImageView {
    @IBOutlet var scriptLabel: NSTextField!
    var scriptPath: NSURL!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([NSURLPboardType])
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        let pboard = sender.draggingPasteboard()
        
        if !pboard.types!.contains(NSURLPboardType) {
            return true
        }
        
        let scriptUrl = NSURL(fromPasteboard: pboard)
        
        if !scriptSizeValid(scriptUrl!) {
            let alert: NSAlert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = "Script must be larger than 28 bytes"
            alert.runModal()
            return true
        }
        
        let fileContents: String
        do {
            fileContents = try String(contentsOfFile: scriptUrl!.path!, encoding: NSUTF8StringEncoding)
        }
        catch _ {
            return false
        }
        
        let line = fileContents.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())[0]
        
        if !line.containsString("#!") {
            let alert: NSAlert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText =  "Script must start with a valid shebang\nhttp://en.wikipedia.org/wiki/Shebang_(Unix)"
            alert.runModal()
            return true
        }
        
        scriptPath = scriptUrl
        scriptLabel.stringValue = scriptPath.lastPathComponent!
        scriptLabel.textColor = NSColor.controlDarkShadowColor()
        
        return true
    }
    
    func scriptSizeValid(scriptPath: NSURL) -> Bool {
        let path = scriptPath.path
        let man = NSFileManager.defaultManager()
        
        let attrs: NSDictionary?
        do {
            attrs = try man.attributesOfItemAtPath(path!)
        } catch _ {
            return false
        }
        
        let result = attrs!.fileSize()
        
        return result > 28
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        let pboard = sender.draggingPasteboard()
        
        if pboard.types!.contains(NSURLPboardType) {
            let sourceDragMask = sender.draggingSourceOperationMask()
            
            if sourceDragMask.contains(NSDragOperation.Link) {
                return NSDragOperation.Link
            } else if sourceDragMask.contains(NSDragOperation.Copy) {
                return NSDragOperation.Copy
            }
            
        }
        
        return NSDragOperation.None
    }
}
