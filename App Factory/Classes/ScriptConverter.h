#import <Foundation/Foundation.h>

@interface ScriptConverter : NSObject {
    NSString *scriptPath;
    NSString *savePath;
    NSString *iconPath;
    NSString *fullAppPath;
    NSString *resourcesPath;
    NSString *iconFileName;

}

- (id) initWithPath:(NSString *)theScriptPath savePath:(NSString *) theSavePath iconPath:(NSString *) theIconPath;
- (void) createApp;

@end