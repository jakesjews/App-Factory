#import "IAIconDrop.h"


@implementation IAIconDrop {}

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
        self.iconPath = [NSURL URLFromPasteboard:pboard];

        [self.iconLabel setHidden:YES];
        // Show the selected icon image
        NSImage *newImage = [[NSImage alloc] initWithContentsOfURL:self.iconPath];
        [self setImage:newImage];
        [self setNeedsDisplay:YES];
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