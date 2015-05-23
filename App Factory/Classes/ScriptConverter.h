#import <Foundation/Foundation.h>

@interface ScriptConverter : NSObject {
    NSURL *scriptPath;
    NSURL *savePath;
    NSURL *iconPath;
    NSURL *fullAppPath;
    NSURL *resourcesPath;
    NSString *iconFileName;

}

- (instancetype) initWithPath:(NSURL *)theScriptPath savePath:(NSURL *) theSavePath iconPath:(NSURL *) theIconPath NS_DESIGNATED_INITIALIZER;
- (void) createApp;

@end