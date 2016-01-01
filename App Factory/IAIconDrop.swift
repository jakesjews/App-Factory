import Foundation
import Cocoa

class IAIconDrop: NSImageView {
    @IBOutlet var iconLabel: NSTextField!
    var iconPath: NSURL!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([NSURLPboardType])
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        let pboard = sender.draggingPasteboard()
        if !pboard.types!.contains(NSURLPboardType) {
            return true
        }
        
        self.iconLabel.hidden = true
        self.iconPath = NSURL(fromPasteboard: pboard)
        self.image = NSImage(contentsOfURL: iconPath)
        self.needsDisplay = true
        return true
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        let sourceDragMask = sender.draggingSourceOperationMask()
        let pboard = sender.draggingPasteboard()
        
        if pboard.types!.contains(NSURLPboardType) {
            if sourceDragMask.contains(NSDragOperation.Link) {
                return NSDragOperation.Link
            } else if sourceDragMask.contains(NSDragOperation.Copy) {
                return NSDragOperation.Copy
            }
        }
        
        return NSDragOperation.None
    }
}
