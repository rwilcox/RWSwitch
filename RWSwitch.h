// Copyright 2011 Cooliris, Inc and Wilcox Development Solutions
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <Cocoa/Cocoa.h>

enum RWSwitchCurrentValue {
    RWSwitchLeftSide,
    RWSwitchRightSide
};

/*!
 @class RWSwitch
 @abstract a UISwitch control for desktop Cocoa
 @description This is a highly modified version of SliderControl from <http://code.google.com/p/cooliris-toolkit>
    BUT it has been ported to desktop Cocoa by Ryan Wilcox of Wilcox Development Solutions

    It acts like UISwitch, which does not exist on Mac OS X
    (no, you can't make a NSSlider work like this, I tried)
 
    This version also has the advantage of being able to specify background, alternative background and thumb
    images.
 
    Using: 
    Drag a custom NSView out in IB, set its class to RWSwitch, and set the target of the view to
    whatever class you wish. The target/action will be called when the switch changes value, after
    the animation moving the switch has completed.
*/
@interface RWSwitch : NSButton {
@private
    float _value;
    float _min;
    float _max;
    BOOL _continuous;
    CGFloat _margin;
    
    NSImageView* _backgroundView;
    NSImage* _backgroundImage;
    NSImage* _alternativeBackgroundImage;
    NSImageView* _thumbView;
    int _lastValue;
}
@property(nonatomic) float value;  // Clamped
@property(nonatomic) float minimumValue;  // Default is 0.0
@property(nonatomic) float maximumValue;  // Default is 1.0
@property(nonatomic,getter=isContinuous) BOOL continuous;  // Default is YES
@property(nonatomic, retain) NSImage* backgroundImage;  // Default is nil
@property(nonatomic, retain) NSImage* alternativeBackgroundImage;
@property(nonatomic, retain) NSImage* thumbImage;  // Default is nil
@property(nonatomic) CGFloat extraMargin;  // Default is 0.0

@property(strong) id target;
@property SEL action;

/*!
 @function state
 @abstract Returns the RWSwitchCurrentValue state of the control
*/
- (NSInteger) state;

- (void) moveSliderTo: (enum RWSwitchCurrentValue) newSide animate: (BOOL) doAnimation;

@end
