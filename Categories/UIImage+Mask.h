//
//  UIImage+Mask.h
//
//  Created by Rex Sheng on 4/1/13.
//  Copyright (c) 2013 Log(n) LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Mask)

- (UIImage *)maskedWithImage:(UIImage *)mask;
- (UIImage *)maskedWithMaskName:(NSString *)maskName;
- (UIImage *)maskAndOverlayWithMaskName:(NSString *)maskName;
+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor *)color toColor:(UIColor *)toColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)imageFromColors:(NSArray *)colors locations:(NSArray *)locationsObjects size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)imageFromSize:(CGSize)size block:(void(^)(CGContextRef))block;

@end
