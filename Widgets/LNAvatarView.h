//
//  LNAvatarView.h
//  threadflip
//
//  Created by Rex Sheng on 4/5/13.
//  Copyright (c) 2013 Log(n) LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSMenuCellItem.h"

extern NSString * const LNAvatarViewURLKey;

@interface LNAvatarView : UIView <RSMenuCellItem>

@property (nonatomic, strong) NSURL *imageURL;
/** Change image and prevent networking changes */
@property (nonatomic, strong) UIImage *image;

@end


@interface LNAvatarView (FullScreen)

- (void)enableFullScreen;

@end