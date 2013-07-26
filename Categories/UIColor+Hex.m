//
//  UIColor+Hex.m
//
//  Created by Rex Sheng on 4/1/13.
//  Copyright (c) 2013 Log(n) LLC. All rights reserved.
//

#import "UIColor+Hex.h"

#define MAKEBYTE(_VALUE_) (int)(_VALUE_ * 0xFF) & 0xFF

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexRGB:(NSUInteger)hex
{
	return [self colorWithHexRGB:hex alpha:1];
}

+ (UIColor *)colorWithHexWhite:(NSUInteger)hex
{
	return [self colorWithHexWhite:hex alpha:1];
}

+ (UIColor *)colorWithHexWhite:(NSUInteger)hex alpha:(CGFloat)alpha
{
	CGFloat r = hex/255.f;
	return [UIColor colorWithWhite:r alpha:alpha];
}

+ (UIColor *)colorWithHexRGB:(NSUInteger)hex alpha:(CGFloat)alpha
{
	CGFloat ff = 255.f;
	CGFloat r = ((hex & 0xff0000) >> 16) / ff;
	CGFloat g = ((hex & 0xff00) >> 8) / ff;
	CGFloat b = (hex & 0xff) / ff;
	return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

- (NSString *)hexString
{
	CGColorSpaceModel colorSpace = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));

	if (colorSpace == kCGColorSpaceModelRGB) {
		CGFloat red, green, blue;

		[self getRed:&red green:&green blue:&blue alpha:NULL];
		return [NSString stringWithFormat:@"%02x%02x%02x", MAKEBYTE(red), MAKEBYTE(green), MAKEBYTE(blue)];
	}
	else if (colorSpace == kCGColorSpaceModelMonochrome) {
		CGFloat white;

		[self getWhite:&white alpha:NULL];
		return [NSString stringWithFormat:@"%02x%02x%02x", MAKEBYTE(white), MAKEBYTE(white), MAKEBYTE(white)];
	}

	NSLog(@"Called hexString on color space %d", colorSpace);
	return nil;
}

@end
