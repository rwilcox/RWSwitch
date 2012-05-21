//
//  AppDelegate.h
//  RWSliderExample
//
//  Created by Ryan Wilcox on 5/20/12.
//  Copyright (c) 2012 Wilcox Development Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RWSwitch;
@class XCodeWorkaround;

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (weak) IBOutlet RWSwitch  *switchWorkaroundControl;

@property (assign) IBOutlet NSWindow *window;
//@property (weak) IBOutlet RWSwitch *slider;

@end
