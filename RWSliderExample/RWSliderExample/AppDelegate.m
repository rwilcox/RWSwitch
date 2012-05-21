//
//  AppDelegate.m
//  RWSliderExample
//
//  Created by Ryan Wilcox on 5/20/12.
//  Copyright (c) 2012 Wilcox Development Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "RWSwitch.h"
#import "XCodeWorkaround.h"

@implementation AppDelegate

//@synthesize switchControl = _switchControl;
@synthesize switchWorkaroundControl;

@synthesize window = _window;
//@synthesize slider = _slider;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void) awakeFromNib {
    
    [self.slider setBackgroundImage: 
     [NSImage imageNamed:@"switch-unlocked.png"]
    ];
    
    [self.slider setAlternativeBackgroundImage:
     [NSImage imageNamed:@"switch-locked.png"]
    ];
    
    //[_slider setExtraMargin: -5];
    [self.slider setThumbImage:
     [NSImage imageNamed:@"switch-btn.png"]
     ];
    
    [self.slider setNeedsDisplay:YES];
    [self.slider display];
    
}
- (IBAction)buttonWasClicked:(id)sender {
    NSLog(@"Here I am");
}

- (RWSwitch*) slider {
    //return switchWorkaroundControl.sliderControl;
    return switchWorkaroundControl;
}
@end
