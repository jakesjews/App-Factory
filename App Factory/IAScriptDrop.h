#import <Foundation/Foundation.h>
#import <Foundation/NSFileManager.h>

@interface IAScriptDrop : NSImageView

@property (strong) NSString *scriptPath;
@property (strong) IBOutlet NSTextField *scriptLabel;

@end