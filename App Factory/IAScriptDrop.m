#import "IAScriptDrop.h"

@implementation IAScriptDrop

-(instancetype)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder: aDecoder];
    [self registerForDraggedTypes: @[NSURLPboardType]];
    return self;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>) sender {

    NSPasteboard *pboard = [sender draggingPasteboard];

    if ( [[pboard types] containsObject:NSURLPboardType] ) {
        NSURL *scriptURL = [NSURL URLFromPasteboard:pboard];
        
        BOOL sizeValid = [self scriptSizeValid: scriptURL];
        
        if (sizeValid) {
            self.scriptPath = scriptURL;
            [self.scriptLabel setStringValue: [self.scriptPath lastPathComponent]];
            [self.scriptLabel setTextColor:[NSColor controlDarkShadowColor]];
        } else {
            NSAlert *alert = [NSAlert alertWithMessageText:@"Error"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"Script must be larger than 28 bytes"];
            [alert runModal];
        }
        
    }
    return YES;
}

- (BOOL)scriptSizeValid:(NSURL *)scriptPath {
    
    NSString *path = [scriptPath path];
    NSFileManager *man = [NSFileManager defaultManager];
    NSError *err;
    NSDictionary *attrs = [man attributesOfItemAtPath: path error: &err];
    UInt64 result = [attrs fileSize];
    
    return (result > 28);
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {

    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;

    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];

    if ( [[pboard types] containsObject:NSURLPboardType] ) {
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }

    return NSDragOperationNone;
}

@end