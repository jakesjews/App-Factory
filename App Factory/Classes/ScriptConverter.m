#import "ScriptConverter.h"

#include <sys/stat.h>

@implementation ScriptConverter

- (id) initWithPath:(NSString *)theScriptPath savePath:(NSString *) theSavePath iconPath:(NSString *) theIconPath {

    self = [super init];

    if (self) {
        scriptPath = theScriptPath;
        iconPath = theIconPath;
        fullAppPath = [NSString pathWithComponents: @[theSavePath, @"Contents/MacOS/"]];
        resourcesPath = [NSString pathWithComponents: @[theSavePath, @"Contents/Resources/"]];
        iconFileName = [NSString stringWithFormat: @"%@.icns",
                            [[iconPath lastPathComponent] stringByDeletingPathExtension]];
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

    NSFileManager *manager = [NSFileManager defaultManager];

    [manager createDirectoryAtPath: fullAppPath
       withIntermediateDirectories: YES
                        attributes: nil
                             error: nil];
    
    BOOL isDir;
    [manager fileExistsAtPath:scriptPath isDirectory:&isDir];
    
    if (isDir) {
        [self writeScriptDirectory];
    } else {
        [self writeScriptFile];
    }
}

- (void) writeScriptDirectory {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *files         = [manager contentsOfDirectoryAtPath:scriptPath error:nil];
    NSString* appName      = [scriptPath lastPathComponent];
    
    for (NSString *file in files) {
        
        NSString* fileNoExtension = [file stringByDeletingPathExtension];
        NSString* filePath        = [NSString pathWithComponents: @[scriptPath, file]];
        
        if (fileNoExtension == appName) {
            [self makeScriptExecutable: filePath];
        }
        
        [manager copyItemAtPath: filePath
                         toPath: [NSString pathWithComponents: @[fullAppPath, file]]
                          error: nil];
    }
}

- (void) writeScriptFile {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *appFileName  = [[scriptPath lastPathComponent] stringByDeletingPathExtension];
    NSString *fullPath     = [NSString pathWithComponents: @[fullAppPath, appFileName]];
    
    [self makeScriptExecutable: scriptPath];

    [manager copyItemAtPath:scriptPath toPath:fullPath error:nil];
}

- (void)makeScriptExecutable: (NSString *)path {

    const char* cPath = [path UTF8String];

    struct stat buf;
    stat(cPath, &buf);

    mode_t mode = buf.st_mode;
    mode |= S_IXUSR;
    chmod(cPath, mode);
}

- (void)writeIcon {

    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:resourcesPath withIntermediateDirectories:YES attributes:nil error:nil];

    NSString* destPath = [NSString pathWithComponents: @[resourcesPath, iconFileName]];

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

    NSString* plistPath = [NSString pathWithComponents: @[savePath, @"Contents/info.plist"]];
    [content writeToFile: plistPath
             atomically: YES
             encoding: NSUnicodeStringEncoding
             error: nil];
}

@end
