//
//  FixedControl.m
//  RWSliderExample
//
//  Created by Ryan Wilcox on 5/20/12.
//  Copyright (c) 2012 Wilcox Development Solutions. All rights reserved.
//

#import "FixedControl.h"

@implementation FixedControl

- initWithCoder: (NSCoder *)origCoder
{
	BOOL sub = YES;
	
	sub = sub && [origCoder isKindOfClass: [NSKeyedUnarchiver class]]; // no support for 10.1 nibs
	sub = sub && ![self isMemberOfClass: [NSControl class]]; // no raw NSControls
	sub = sub && [[self superclass] cellClass] != nil; // need to have something to substitute
	sub = sub && [[self superclass] cellClass] != [[self class] cellClass]; // pointless if same
	
	if( !sub )
	{
		self = [super initWithCoder: origCoder]; 
	}
	else
	{
		NSKeyedUnarchiver *coder = (id)origCoder;
		
		// gather info about the superclass's cell and save the archiver's old mapping
		Class superCell = [[self superclass] cellClass];
		NSString *oldClassName = NSStringFromClass( superCell );
		Class oldClass = [coder classForClassName: oldClassName];
		if( !oldClass )
			oldClass = superCell;
		
		// override what comes out of the unarchiver
		[coder setClass: [[self class] cellClass] forClassName: oldClassName];
		
		// unarchive
		self = [super initWithCoder: coder];
		
		// set it back
		[coder setClass: oldClass forClassName: oldClassName];
	}
	
	return self;
}

+ (void)load
{
	[self poseAsClass: [NSControl class]];
}
@end