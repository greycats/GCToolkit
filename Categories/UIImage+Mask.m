//
//  UIImage+Mask.m
//
//  Created by Rex Sheng on 4/1/13.
//  Copyright (c) 2013 Log(n) LLC. All rights reserved.
//


#import "UIImage+Mask.h"

@implementation UIImage (Mask)

- (UIImage *)maskAndOverlayWithMaskName:(NSString *)maskName
{
	UIImage *overlay = [UIImage imageNamed:[NSString stringWithFormat:@"%@_overlay", maskName]];
	UIImage *mask = [UIImage imageNamed:[NSString stringWithFormat:@"%@_mask", maskName]];
	
	CGSize size;
	if (overlay) {
		size = CGSizeMake(overlay.size.width * overlay.scale, overlay.size.height * overlay.scale);
	} else {
		size = CGSizeMake(mask.size.width * mask.scale, mask.size.height * mask.scale);
	}
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	
	CGRect maskRect = CGRectMake(0, 0, mask.size.width * mask.scale, mask.size.height * mask.scale);
	maskRect = CGRectOffset(maskRect, (rect.size.width - maskRect.size.width) / 2, ceilf((rect.size.height - maskRect.size.height) / 2));
	
	CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, CGImageGetBitsPerComponent(self.CGImage), 0, colourSpace, (CGBitmapInfo) kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colourSpace);
	
	CGContextSaveGState(context);
	CGContextClipToMask(context, maskRect, mask.CGImage);
	CGContextDrawImage(context, maskRect, self.CGImage);
	CGContextRestoreGState(context);
	if (overlay) {
		CGContextDrawImage(context, rect, overlay.CGImage);
	}
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	UIImage *image = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
	CGImageRelease(cgImage);
	return image;
}

- (UIImage *)maskedWithMaskName:(NSString *)maskName
{
	return [self maskedWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_mask", maskName]]];
}

- (UIImage *)maskedWithImage:(UIImage *)mask
{
	CGSize size = CGSizeMake(mask.size.width * mask.scale, mask.size.height * mask.scale);
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	CGRect maskRect = CGRectMake(0, 0, mask.size.width * mask.scale, mask.size.height * mask.scale);
	maskRect = CGRectOffset(maskRect, (rect.size.width - maskRect.size.width) / 2, (rect.size.height - maskRect.size.height) / 2);
	
	CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, CGImageGetBitsPerComponent(self.CGImage), 0, colourSpace, (CGBitmapInfo) kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colourSpace);
	
	CGContextClipToMask(context, maskRect, mask.CGImage);
	CGContextDrawImage(context, maskRect, self.CGImage);
	
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	UIImage *image = [UIImage imageWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
	CGImageRelease(cgImage);
	return image;
}

+ (UIImage *)imageFromColor:(UIColor *)color
{
	return [self imageFromSize:CGSizeMake(1, 1) block:^(CGContextRef context) {
		CGRect rect = CGRectMake(0, 0, 1, 1);
		CGContextSetFillColorWithColor(context, [color CGColor]);
		CGContextFillRect(context, rect);
	}];
}

+ (UIImage *)imageFromSize:(CGSize)size block:(void(^)(CGContextRef))block
{
	UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	block(context);
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

+ (UIImage *)imageFromColors:(NSArray *)colors verticalLocations:(NSArray *)locationsObjects size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
	return [self imageFromSize:size block:^(CGContextRef context) {
		CGRect rect = (CGRect){.size = size};
		UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
		CGContextAddPath(context, path.CGPath);
		
		NSMutableArray *convertedColorArray = [NSMutableArray arrayWithCapacity:colors.count];
		for (UIColor *color in colors) {
			[convertedColorArray addObject:(__bridge id)[color CGColor]];
		}
		
		CGFloat locations[locationsObjects.count];
		for (int i = 0; i < locationsObjects.count; i++) {
			locations[i] = [locationsObjects[i] floatValue];
		}
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)convertedColorArray, locations);
		CFRelease(colorSpace);
		CGContextClip(context);
		CGContextDrawLinearGradient(context, gradient, CGPointMake(0.5, 0), CGPointMake(0.5, size.height), 0);
		CFRelease(gradient);
	}];
}

+ (UIImage *)imageFromColors:(NSArray *)colors horizontalLocations:(NSArray *)locationsObjects size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
	return [self imageFromSize:size block:^(CGContextRef context) {
		CGRect rect = (CGRect){.size = size};
		UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
		CGContextAddPath(context, path.CGPath);
		
		NSMutableArray *convertedColorArray = [NSMutableArray arrayWithCapacity:colors.count];
		for (UIColor *color in colors) {
			[convertedColorArray addObject:(__bridge id)[color CGColor]];
		}
		
		CGFloat locations[locationsObjects.count];
		for (int i = 0; i < locationsObjects.count; i++) {
			locations[i] = [locationsObjects[i] floatValue];
		}
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)convertedColorArray, locations);
		CFRelease(colorSpace);
		CGContextClip(context);
		CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0.5), CGPointMake(size.width, 0.5), 0);
		CFRelease(gradient);
	}];
}

+ (UIImage *)imageFromColor:(UIColor *)color toColor:(UIColor *)toColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
	return [self imageFromColors:@[color, toColor] verticalLocations:@[@0, @1] size:size cornerRadius:cornerRadius];
}

@end
