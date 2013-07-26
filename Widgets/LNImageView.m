//
//  LNImageView.m
//  Threadflip
//
//  Created by Rex Sheng on 6/28/13.
//  Copyright (c) 2013 Threadflip. All rights reserved.
//

#import "LNImageView.h"

@implementation LNImageView

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

	__weak id weakSelf = self;
	[self setImageWithURLRequest:request
		 placeholderImage:placeholderImage
				  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
					  LNImageView *imageView = weakSelf;
					  if (!imageView) return;
					  imageView->_networkImage = image;
					  NSTimeInterval duration = response == nil ? 0 : .3;
					  [UIView transitionWithView:imageView
										duration:duration
										 options:UIViewAnimationOptionTransitionCrossDissolve
									  animations:^{
										  imageView.image = image;
									  }
									  completion:nil];
				  } failure:nil];
}

@end
