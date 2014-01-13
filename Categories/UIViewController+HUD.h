//
//  UIViewController+HUD.h
//
//  Created by Rex Sheng on 10/11/12.
//  Copyright (c) 2012 Rex Sheng
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)displayHUD:(NSString *)text;
- (void)hideHUD:(BOOL)animated;
- (void)displayHUDError:(NSString *)title message:(NSString *)message;

@end
