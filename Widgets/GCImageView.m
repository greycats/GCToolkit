//
//  GCImageView.m
//
//  Created by Rex Sheng on 6/28/13.
//  Copyright (c) 2013 Rex Sheng

#import "GCImageView.h"

@implementation GCImageView

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

	__weak __typeof(&*self)weakSelf = self;
	[self setImageWithURLRequest:request
		 placeholderImage:placeholderImage
				  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
					  __strong __typeof(&*weakSelf)strongSelf = weakSelf;
					  if (!strongSelf) {
						  return;
					  }
					  strongSelf->_networkImage = image;
					  NSTimeInterval duration = response == nil ? 0 : .3;
					  [UIView transitionWithView:strongSelf
										duration:duration
										 options:UIViewAnimationOptionTransitionCrossDissolve
									  animations:^{
										  strongSelf.image = image;
									  }
									  completion:nil];
				  } failure:nil];
}

@end
