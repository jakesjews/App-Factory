#import <Foundation/Foundation.h>

@interface IAIconDrop : NSImageView

@property (strong) NSURL *iconPath;
@property (strong) IBOutlet NSTextField *iconLabel;

@end