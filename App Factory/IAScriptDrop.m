//
// Created by jacob on 8/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "IAScriptDrop.h"


@implementation IAScriptDrop {

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    [self registerForDraggedTypes: @[NSURLPboardType]];
    return self;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];

    if ( [[pboard types] containsObject:NSURLPboardType] ) {
        self.scriptPath = [NSURL URLFromPasteboard:pboard];
        [self.scriptLabel setStringValue: [self.scriptPath lastPathComponent]];
        [self.scriptLabel setTextColor:[NSColor controlDarkShadowColor]];
    }
    return YES;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
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