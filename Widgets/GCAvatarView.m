//
//  GCAvatarView.m
//  threadflip
//
//  Created by Rex Sheng on 4/5/13.
//  Copyright (c) 2013 Rex Sheng

#import "GCAvatarView.h"
#import "GCImageView.h"
#import <objc/runtime.h>

NSString * const GCAvatarViewURLKey = @"URL";

@implementation GCAvatarView
{
	GCImageView *avatarView;
	NSString *identifier;
	id observer;
}

- (id)initWithIdentifier:(NSString *)_identifier attributes:(NSDictionary *)attributes
{
	if (self = [self initWithFrame:CGRectMake(0, 0, 30, 30)]) {
		identifier = _identifier;
		if (identifier)
			observer = [[NSNotificationCenter defaultCenter] addObserverForName:identifier object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
				self.imageURL = [NSURL URLWithString:note.object[GCAvatarViewURLKey]];
			}];
		self.imageURL = [NSURL URLWithString:attributes[GCAvatarViewURLKey]];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:observer];
}

- (CGSize)sizeThatFits:(CGSize)size
{
	return self.bounds.size;
}

- (id)initWithFrame:(CGRect)frame
{
	CGFloat radius_2 = MAX(frame.size.width, frame.size.height);
	frame.size.width = frame.size.height = radius_2;
	if (self = [super initWithFrame:frame]) {
		avatarView = [[GCImageView alloc] initWithFrame:CGRectInset(self.bounds, 2, 2)];
		avatarView.layer.masksToBounds = YES;
		avatarView.layer.cornerRadius = (radius_2 - 4) / 2;
		[self addSubview:avatarView];
		self.layer.cornerRadius = radius_2 / 2;
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL
{
	if (_image) return;
	[avatarView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"default_mugshot.png"]];
}

- (void)setImage:(UIImage *)image
{
	avatarView.image = _image = image;
}

@end


#pragma mark - GCAvatarView + FullScreen

@implementation GCAvatarView (FullScreen)

static char kFullScreenView;

- (void)_startFullScreen:(UITapGestureRecognizer *)tap
{
	if (tap.state != UIGestureRecognizerStateRecognized) return;
	if (!avatarView.networkImage && !_image) return;
	
	avatarView.hidden = YES;
	UIImageView *fullScreenImageView = [[UIImageView alloc] initWithImage:avatarView.image];
	fullScreenImageView.layer.masksToBounds = YES;
	fullScreenImageView.layer.cornerRadius = avatarView.layer.cornerRadius;
	fullScreenImageView.contentMode = UIViewContentModeScaleAspectFit;
	objc_setAssociatedObject(self, &kFullScreenView, fullScreenImageView, OBJC_ASSOCIATION_ASSIGN);
	
	fullScreenImageView.userInteractionEnabled = YES;
	UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_closeFullScreen:)];
	[fullScreenImageView addGestureRecognizer:closeTap];
	
	fullScreenImageView.frame = [self.window convertRect:avatarView.frame fromView:self];
	
	[self.window addSubview:fullScreenImageView];
	[UIView animateWithDuration:.3 animations:^{
		fullScreenImageView.frame = self.window.bounds;
		fullScreenImageView.layer.cornerRadius = 0;
	} completion:^(BOOL finished) {
		fullScreenImageView.layer.backgroundColor = [UIColor blackColor].CGColor;
	}];
}

- (void)_closeFullScreen:(UITapGestureRecognizer *)tap
{
	if (tap.state != UIGestureRecognizerStateRecognized) return;
	UIView *fullScreenImageView = objc_getAssociatedObject(self, &kFullScreenView);
	if (!fullScreenImageView) return;
	fullScreenImageView.layer.backgroundColor = [UIColor clearColor].CGColor;
	[UIView animateWithDuration:.3 animations:^{
		fullScreenImageView.frame = [self.window convertRect:avatarView.frame fromView:self];
		fullScreenImageView.layer.cornerRadius = avatarView.layer.cornerRadius;
	} completion:^(BOOL finished) {
		avatarView.hidden = NO;
		[fullScreenImageView removeFromSuperview];
		objc_setAssociatedObject(self, &kFullScreenView, nil, OBJC_ASSOCIATION_ASSIGN);
	}];
}

- (void)enableFullScreen
{
	self.userInteractionEnabled = YES;
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_startFullScreen:)];
	[self addGestureRecognizer:tap];
}

@end
