//
//  GCAvatarView.h
//  threadflip
//
//  Created by Rex Sheng on 4/5/13.
//  Copyright (c) 2013 Rex Sheng

#import <UIKit/UIKit.h>
#import "RSMenuCellItem.h"

extern NSString * const GCAvatarViewURLKey;

@interface GCAvatarView : UIView <RSMenuCellItem>

@property (nonatomic, strong) NSURL *imageURL;
/** Change image and prevent networking changes */
@property (nonatomic, strong) UIImage *image;

@end


@interface GCAvatarView (FullScreen)

- (void)enableFullScreen;

@end