//
//  LNSegmentedControl.m
//
//  Created by Rex Sheng on 4/19/13.
//  Copyright (c) 2013 Log(n) LLC. All rights reserved.
//

#import "LNSegmentedControl.h"

@implementation LNSegmentedControl
{
	BOOL layoutedOnce;
}

- (void)updateSelectedStyle
{
	for (UIView *view in self.subviews) {
		BOOL selected = [[view valueForKey:@"selected"] boolValue];
		for (UILabel *label in view.subviews) {
			if ([label isKindOfClass:[UILabel class]]) {
				UIFont *font = [self titleTextAttributesForState:UIControlStateNormal][NSFontAttributeName];
				if (selected) {
					UIFont *_font = [self titleTextAttributesForState:UIControlStateSelected][NSFontAttributeName];
					if (_font) font = _font;
				}
				if (font != label.font) {
					label.font = font;
					CGRect frame = label.frame;
					frame.size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
					label.frame = frame;
				}
			}
		}
	}
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents
{
	[self updateSelectedStyle];
	[super sendActionsForControlEvents:controlEvents];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
	[super setSelectedSegmentIndex:selectedSegmentIndex];
	[self updateSelectedStyle];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	if (!layoutedOnce) {
		layoutedOnce = YES;
		[self updateSelectedStyle];
	}
}

@end
