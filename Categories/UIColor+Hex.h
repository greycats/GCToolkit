//
//  UIColor+Hex.h
//
//  Created by Rex Sheng on 4/1/13.
//  Copyright (c) 2013 Log(n) LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexRGB:(NSUInteger)hex;
+ (UIColor *)colorWithHexWhite:(NSUInteger)hex;

+ (UIColor *)colorWithHexRGB:(NSUInteger)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexWhite:(NSUInteger)hex alpha:(CGFloat)alpha;

- (NSString *)hexString;

@end
