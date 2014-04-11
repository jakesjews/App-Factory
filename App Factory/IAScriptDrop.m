#import "IAScriptDrop.h"

@implementation IAScriptDrop

-(id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder: aDecoder];
    [self registerForDraggedTypes: @[NSURLPboardType]];
    return self;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>) sender {

    NSPasteboard *pboard = [sender draggingPasteboard];

    if ( [[pboard types] containsObject:NSURLPboardType] ) {
        NSString *scriptPath = [[NSURL URLFromPasteboard:pboard] path];
        
        BOOL sizeValid = [self scriptSizeValid: scriptPath];
        
        if (sizeValid) {
            self.scriptPath = scriptPath;
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

- (BOOL)scriptSizeValid:(NSString *)scriptPath {
    
    NSFileManager *man = [NSFileManager defaultManager];
    NSError *err;
    NSDictionary *attrs = [man attributesOfItemAtPath: scriptPath error: &err];
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