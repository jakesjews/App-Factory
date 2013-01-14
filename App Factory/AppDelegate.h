#import <Cocoa/Cocoa.h>

@class IAScriptDrop;
@class IAIconDrop;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSButton *buildAppButton;
@property (strong) IBOutlet IAScriptDrop *scriptDrop;
@property (strong) IBOutlet IAIconDrop *iconDrop;

-(IBAction)buildAppClicked:(id)sender;


@end
