#import <Foundation/Foundation.h>

@interface IAScriptDrop : NSImageView

@property (strong) NSURL *scriptPath;
@property (strong) IBOutlet NSTextField *scriptLabel;

@end