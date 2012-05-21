
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


#import "RWSwitch.h"
#import <QuartzCore/CAAnimation.h>

@implementation RWSwitch;

@synthesize value=_value, minimumValue=_min, maximumValue=_max, continuous=_continuous, extraMargin=_margin;

- (void) _initialize {
    _max = 1.0;
    _continuous = YES;
    _lastValue = RWSwitchLeftSide;  // TODO: make this setable

    _backgroundView = [[NSImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_backgroundView];
    
    _thumbView = [[NSImageView alloc] init];
    [self addSubview:_thumbView];
    
//    self.backgroundColor = nil;
    self.autoresizesSubviews = NO;
}

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    return self;
}



#if !__has_feature(objc_arc)
- (void) dealloc {
    [_backgroundView release];
    [_thumbView release];
    
    [super dealloc];
}
#endif

- (id) initWithCoder:(NSCoder*)coder {
    if ((self = [super initWithCoder:coder])) {
        [self _initialize];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [self doesNotRecognizeSelector:_cmd];
}

- (void) _updateThumb {
    CGRect bounds = self.bounds;
    CGRect frame = _thumbView.frame;
    frame.origin.x = roundf(_margin + (_value - _min) / (_max - _min) * (bounds.size.width - 2.0 * _margin) - frame.size.width / 2.0);
    frame.origin.y = roundf(bounds.size.height / 2.0 - frame.size.height / 2.0);
    _thumbView.frame = frame;
}

- (void) setValue:(float)value {
    _value = MIN(MAX(value, _min), _max);
    [self _updateThumb];
}

- (void) setMinimumValue:(float)min {
    //DCHECK(min < _max);
    _min = min;
    [self setValue:_value];
}

- (void) setMaximumValue:(float)max {
    //DCHECK(max > _min);
    _max = max;
    [self setValue:_value];
}

- (NSImage*) backgroundImage {
    return _backgroundImage;
}

- (void) setBackgroundImage:(NSImage*)image {
    _backgroundImage = image;
   // [self _initialize];
    [self _setCurrentSliderImage: _backgroundImage];
}

- (void) _setCurrentSliderImage: (NSImage*) image {
    int yOffset = (self.bounds.size.height - image.size.height)/ 4;
    yOffset -= 10;  // TODO: Huh, why this?
    CGRect newFrame = _backgroundView.frame;
    newFrame.origin.y = yOffset;
    _backgroundView.frame = newFrame;
    _backgroundView.image = image;
    
}

- (NSImage*) alternativeBackgroundImage {
    return _alternativeBackgroundImage;
}

- (void) setAlternativeBackgroundImage: (NSImage*) image {
    _alternativeBackgroundImage = image;    
}

- (NSImage*) thumbImage {
    return _thumbView.image;
}

- (void) setThumbImage:(NSImage*)image {
    _thumbView.image = image;
    CGSize size = image.size;
    _thumbView.frame = CGRectMake(_margin, _margin, size.width, size.height);
}

- (void) setExtraMargin:(CGFloat)margin {
    _margin = margin;
    [self _updateThumb];
}

- (void) layoutSubviews {
    _backgroundView.frame = self.bounds;
    [self _updateThumb];
}

- (void) _updateValueForLocation:(CGPoint)location {
    _value = _min + MIN(MAX((location.x - _margin) / (self.bounds.size.width - 2.0 * _margin), 0.0), 1.0) * (_max - _min);
    [self _updateThumb];
}


- (void)mouseDragged:(NSEvent *)theEvent {
    [self handleDragWithEvent: theEvent];

}

- (void)mouseDown: (NSEvent *)event
{

    NSEvent *nextEvent = nil;
    while(  ([nextEvent type] != NSLeftMouseUp) && ( [nextEvent type] != NSLeftMouseDragged )  )
    {
        nextEvent = [[self window] nextEventMatchingMask: NSLeftMouseDraggedMask | NSLeftMouseUpMask];
        
        if (nextEvent.type == NSLeftMouseUp)
            [self handleClickWithEvent: nextEvent];
        
        if (nextEvent.type == NSLeftMouseDragged)
            [self handleDragWithEvent: nextEvent];
    }
}

- (void) handleDragWithEvent: (NSEvent*) event {
    NSPoint p = [self convertPoint: [event locationInWindow] fromView: nil];
    CGRect newPosition = _thumbView.frame;
    CGRect rightFrame = [self sliderRightFramePosition];
    int halfWayMark = _backgroundView.frame.size.width / 2;

    if (p.x > halfWayMark) {
        newPosition.origin.x = MIN(p.x, 
                               _backgroundView.frame.origin.x + _backgroundView.frame.size.width);
    } else {
        newPosition.origin.x = MAX(p.x, 
                                   _backgroundView.frame.origin.x + _backgroundView.frame.size.width);
    }
    
    [[_thumbView animator] setFrame:  newPosition];
    if (p.x > halfWayMark)
        [self moveSliderTo: RWSwitchRightSide];
    else {
        [self moveSliderTo: RWSwitchLeftSide];
    }
    
}

- (void) handleClickWithEvent: (NSEvent*) event {
    NSPoint p = [self convertPoint: [event locationInWindow] fromView: nil];
    int halfWayMark = _backgroundView.frame.size.width / 2;
    
    if (p.x > halfWayMark) {
        NSLog(@"right side");
        if (_lastValue == RWSwitchLeftSide)
            [self moveSliderTo: RWSwitchRightSide];
//        else
//            NSLog(@"did ignore");
    }
    else {
//        NSLog(@"left side");
        if (_lastValue == RWSwitchRightSide)
            [self moveSliderTo: RWSwitchLeftSide];
//        else
//            NSLog(@"did ignore");
    }
}

- (void) moveSliderTo: (enum RWSwitchCurrentValue) newSide {
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.delegate = self;
    
    [ _thumbView setAnimations: [NSDictionary dictionaryWithObject:animation forKey:@"frameOrigin"] ];
    if (newSide == RWSwitchRightSide) {
        if (_alternativeBackgroundImage)
            [self _setCurrentSliderImage: _alternativeBackgroundImage];
            
        [[_thumbView animator] setFrame:  [self sliderRightFramePosition]];
        _lastValue = newSide;
    }
    
    if (newSide == RWSwitchLeftSide) {
        [self _setCurrentSliderImage: _backgroundImage];
        [[_thumbView animator] setFrame:  [self sliderLeftFramePosition]];
        _lastValue = newSide;

    }
        
}

- (CGRect) sliderLeftFramePosition {
    return CGRectMake(_margin, _margin, _thumbView.image.size.width, _thumbView.image.size.height);
}

- (CGRect) sliderRightFramePosition {
    float width = _thumbView.image.size.width;
    return CGRectMake(self.frame.size.width - width, 
                      _margin, 
                      width, 
                      _thumbView.image.size.height);
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self sendAction: self.action to:self.target];
    }
}
@end
