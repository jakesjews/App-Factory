#import <Foundation/Foundation.h>


@interface ScriptConverter : NSObject {
    NSURL *scriptPath;
    NSURL *savePath;
    NSURL *iconPath;
    NSURL *fullAppPath;
    NSURL *resourcesPath;
    NSString *iconFileName;

}

- (id) initWithPath:(NSURL *)theScriptPath savePath:(NSURL *) theSavePath iconPath:(NSURL *) theIconPath;
- (void) createApp;

@end