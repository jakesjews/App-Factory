//
//  AppDelegate.h
//  Appifer
//
//  Created by Jacob Jewell on 8/25/12.
//  Copyright (c) 2012 Jacob Jewell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IAScriptDrop;
@class IAIconDrop;

@interface AppDelegate : NSObject <NSApplicationDelegate> {}

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSButton *buildAppButton;
@property (strong) IBOutlet IAScriptDrop *scriptDrop;
@property (strong) IBOutlet IAIconDrop *iconDrop;

@property (strong) NSURL *savePath;

-(IBAction)buildAppClicked:(id)sender;


@end
