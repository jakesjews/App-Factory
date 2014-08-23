#import <Foundation/Foundation.h>

@interface ScriptConverter : NSObject {
    NSString *scriptPath;
    NSString *savePath;
    NSString *iconPath;
    NSString *fullAppPath;
    NSString *resourcesPath;
    NSString *iconFileName;

}

- (instancetype) initWithPath:(NSString *)theScriptPath savePath:(NSString *) theSavePath iconPath:(NSString *) theIconPath NS_DESIGNATED_INITIALIZER;
- (void) createApp;

@end