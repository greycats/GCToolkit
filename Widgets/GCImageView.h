//
//  GCImageView.h
//
//  Created by Rex Sheng on 6/28/13.
//  Copyright (c) 2013 Rex Sheng

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

/** UIImageView which will fade in network supplied images */
@interface GCImageView : UIImageView

@property (nonatomic, weak, readonly) UIImage *networkImage;

@end
