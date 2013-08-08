//
//  LNBadgeView.h
//  threadflip
//
//  Created by Rex Sheng on 5/3/13.
//  Copyright (c) 2013 Log(n) LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSMenuCellItem.h"

@interface LNBadgeView : UIView <RSMenuCellItem>

@property (nonatomic, strong) NSString *badgeNumber;
@property (nonatomic, strong) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *textAttributes UI_APPEARANCE_SELECTOR;

@end
