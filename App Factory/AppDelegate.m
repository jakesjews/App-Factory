#import "AppDelegate.h"
#import "IAScriptDrop.h"
#import "IAIconDrop.h"

@implementation AppDelegate
@synthesize buildAppButton;
@synthesize scriptDrop;
@synthesize iconDrop;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (IBAction)buildAppClicked:(id)sender {
    if (self.scriptDrop.scriptPath != nil) {
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        [savePanel setExtensionHidden:YES];
        savePanel.allowedFileTypes = @[@"app"];
        savePanel.allowsOtherFileTypes = NO;
        savePanel.nameFieldStringValue = [self getAppFilename];

        [savePanel beginWithCompletionHandler:^(NSInteger response) {
            if (response == NSFileHandlingPanelOKButton) {
                self.savePath = [savePanel URL];

                [self writeApp];

                if (self.iconDrop.iconPath != nil) {
                    [self writeIcon];
                    [self writeInfo];
                }
            }
        }];
    }
    else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"No script selected"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"Please select a script file"];
        [alert runModal];
    }
}

- (void)writeApp {
    NSURL *fullPath = [[self getAppDir] URLByAppendingPathComponent:[self getAppFilename]];

    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtURL:[self getAppDir] withIntermediateDirectories:YES attributes:nil error:nil];
    [manager copyItemAtURL:self.scriptDrop.scriptPath toURL:fullPath error:nil];
}

- (void)writeIcon
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtURL:[self getResourcesDir] withIntermediateDirectories:YES attributes:nil error:nil];

    NSURL *fullPath = [[self getResourcesDir] URLByAppendingPathComponent:[self getIconFilename]];

    struct CGImageSource *img = CGImageSourceCreateWithURL((__bridge CFURLRef) self.iconDrop.iconPath, nil);
    struct CGImage *ref = CGImageSourceCreateImageAtIndex(img, 1, nil);
    struct CGImageDestination *dest = CGImageDestinationCreateWithURL((__bridge CFURLRef) fullPath, kUTTypeAppleICNS, 1, nil);

    CGImageDestinationAddImageFromSource(dest, img, 0, nil);
    CGImageDestinationFinalize(dest);

    if(img != nil) {
        CFRelease(img);
    }
    
    if(dest != nil) {
        CFRelease(dest);
    }
    
    if(ref != nil) {
        CFRelease(ref);
    }
}

- (void)writeInfo {
    NSString *content = [NSString stringWithFormat:
            @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                    "<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
                    "<plist version=\"1.0\">\n"
                    "\t<dict>\n"
                    "\t\t<key>CFBundleIconFile</key>\n"
                    "\t\t<string>%@</string>\n"
                    "\t</dict>\n"
                    "</plist>", [[self getIconFilename] stringByDeletingPathExtension]];
    [[self getResourcesDir] URLByAppendingPathComponent:[self getIconFilename]];
    NSURL *infoPath = [self.savePath URLByAppendingPathComponent:@"Contents/info.plist"];
    [content writeToURL:infoPath atomically:YES encoding:NSUnicodeStringEncoding error:nil];
}

- (NSString *)getAppFilename {
    return [[self.scriptDrop.scriptPath lastPathComponent] stringByDeletingPathExtension];
}

- (NSString *)getIconFilename {
    NSString *noExtension = [[self.iconDrop.iconPath lastPathComponent] stringByDeletingPathExtension];
    return [NSString stringWithFormat:@"%@.icns", noExtension];
}

- (NSURL *)getAppDir {
    return [self.savePath URLByAppendingPathComponent:@"Contents/MacOS/"];
}

- (NSURL *)getResourcesDir {
    return [self.savePath URLByAppendingPathComponent:@"Contents/Resources/"];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

@end
