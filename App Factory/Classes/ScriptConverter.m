#import "ScriptConverter.h"

#include <sys/stat.h>

@implementation ScriptConverter

- (instancetype) initWithPath:(NSURL *)theScriptPath savePath:(NSURL *) theSavePath iconPath:(NSURL *) theIconPath {

    self = [super init];

    if (self) {
        scriptPath = theScriptPath;
        iconPath = theIconPath;
        fullAppPath = [theSavePath URLByAppendingPathComponent:@"Contents/MacOS/"];
        resourcesPath = [theSavePath URLByAppendingPathComponent:@"Contents/Resources/"];
        iconFileName = [NSString stringWithFormat:@"%@.icns", [[iconPath lastPathComponent] stringByDeletingPathExtension]];
    }

    return self;
}

- (void) createApp {

    [self writeScript];

    if (iconPath != nil) {
        [self writeIcon];
        [self writePlist];
    }
}

- (void) writeScript {

    NSString *appFileName = [[scriptPath lastPathComponent] stringByDeletingPathExtension];
    NSURL *fullPath = [fullAppPath URLByAppendingPathComponent:appFileName];

    NSFileManager *manager = [NSFileManager defaultManager];

    [self makeScriptExecutable];

    [manager createDirectoryAtURL:fullAppPath withIntermediateDirectories:YES attributes:nil error:nil];
    [manager copyItemAtURL:scriptPath toURL:fullPath error:nil];
}

- (void)makeScriptExecutable {

    const char* cPath = [[scriptPath path] UTF8String];

    struct stat buf;
    stat(cPath, &buf);

    mode_t mode = buf.st_mode;
    mode |= S_IXUSR;
    chmod(cPath, mode);
}

- (void)writeIcon {

    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtURL:resourcesPath withIntermediateDirectories:YES attributes:nil error:nil];

    NSURL *destPath = [resourcesPath URLByAppendingPathComponent:iconFileName];

    struct CGImageSource *img = CGImageSourceCreateWithURL((__bridge CFURLRef) iconPath, nil);
    struct CGImage *ref = CGImageSourceCreateImageAtIndex(img, 1, nil);
    struct CGImageDestination *dest = CGImageDestinationCreateWithURL((__bridge CFURLRef) destPath, kUTTypeAppleICNS, 1, nil);

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

- (void)writePlist {

    NSString *content = [NSString stringWithFormat:
            @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                    "<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
                    "<plist version=\"1.0\">\n"
                    "\t<dict>\n"
                    "\t\t<key>CFBundleIconFile</key>\n"
                    "\t\t<string>%@</string>\n"
                    "\t</dict>\n"
                    "</plist>", [iconFileName stringByDeletingPathExtension]];

    NSURL *plistPath = [savePath URLByAppendingPathComponent:@"Contents/info.plist"];
    [resourcesPath URLByAppendingPathComponent:iconFileName];
    [content writeToURL:plistPath atomically:YES encoding:NSUnicodeStringEncoding error:nil];
}

@end
