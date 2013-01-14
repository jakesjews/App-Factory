//
// Created by jacob on 1/13/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


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