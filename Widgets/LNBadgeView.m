//
//  LNBadgeView.m
//  threadflip
//
//  Created by Rex Sheng on 5/3/13.
//  Copyright (c) 2013 Log(n) LLC. All rights reserved.
//

#import "LNBadgeView.h"
#import "UIImage+Mask.h"
#import "UIColor+Hex.h"
#import <QuartzCore/QuartzCore.h>

@interface LNBadgeView ()

@property (nonatomic, weak) UIImageView *backgroundView;
@property (nonatomic, weak) UILabel *textLabel;

@end

@implementation LNBadgeView
{
	NSString *_identifier;
	id observer;
}

- (id)initWithFrame:(CGRect)frame
{
	CGFloat phi = MAX(frame.size.width, frame.size.height);
	frame.size.width = frame.size.height = phi;
	return [self initWithFrame:frame cornerRadius:phi / 2];
}

- (id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius
{
	if (self = [super initWithFrame:frame]) {
		UIImage *image = [UIImage imageFromColors:@[[UIColor colorWithHexRGB:0xfa6f77], [UIColor colorWithHexRGB:0xea2d36], [UIColor colorWithHexRGB:0xe70f19], [UIColor colorWithHexRGB:0xc50103]]
								verticalLocations:@[@0, @.49, @.5, @1]
											 size:self.bounds.size
									 cornerRadius:radius];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = self.bounds;
		imageView.layer.shadowColor = [UIColor blackColor].CGColor;
		imageView.layer.shadowOffset = CGSizeMake(0, 1.5);
		imageView.layer.shadowOpacity = .5;
		imageView.layer.shadowRadius = 1.5;
		imageView.layer.shouldRasterize = YES;
		imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
		
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.clipsToBounds = NO;
		[self addSubview:_backgroundView = imageView];
		UILabel *textLabel = [[UILabel alloc] initWithFrame:self.bounds];
		textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.textColor = [UIColor whiteColor];
		textLabel.textAlignment = NSTextAlignmentCenter;
		textLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview:_textLabel = textLabel];
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
	_backgroundImage = backgroundImage;
	self.backgroundView.image = backgroundImage;
}

- (void)setTextAttributes:(NSDictionary *)textAttributes
{
	_textAttributes = textAttributes;
	CGFloat preferedSize = .6 * self.textLabel.bounds.size.height;
	UIFont *font = textAttributes[NSFontAttributeName] ?: [UIFont systemFontOfSize:preferedSize];
	_textLabel.font = font;
	UIColor *color = textAttributes[NSForegroundColorAttributeName] ?: [UIColor whiteColor];
	_textLabel.textColor = color;
}

- (id)initWithIdentifier:(NSString *)identifier attributes:(NSDictionary *)attributes
{
	if (self = [self initWithFrame:CGRectMake(0, 0, 40, 20) cornerRadius:3]) {
		_identifier = identifier;
		self.count = [attributes[@"count"] intValue];
		if (identifier)
			observer = [[NSNotificationCenter defaultCenter] addObserverForName:identifier object:nil
																		  queue:[NSOperationQueue mainQueue]
																	 usingBlock:^(NSNotification *note) {
																		 self.count = [note.object[@"count"] unsignedIntegerValue];
																	 }];
    }
    return self;
}

- (void)setCount:(NSUInteger)count
{
	NSString *text;
	if (count == 0 || count == NSNotFound) text = nil;
	else if (count > 100) text = @"100+";
	else text = [@(count) stringValue];
	self.badgeNumber = text;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	CGSize _size = [self.badgeNumber sizeWithFont:_textLabel.font];
	return CGSizeMake(_size.width + 22, 20);
}

- (void)dealloc
{
	if (observer)
		[[NSNotificationCenter defaultCenter] removeObserver:observer];
}

- (void)setBadgeNumber:(NSString *)badgeNumber
{
	_badgeNumber = badgeNumber;
	self.hidden = !badgeNumber;
	_textLabel.text = badgeNumber;
}

@end
