//
//  LNTextField.m
//
//  Created by Rex Sheng on 9/5/12.
//  Copyright (c) 2012 Log(n) LLC. All rights reserved.
//

#import "LNTextField.h"

@implementation LNTextField

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		_edgeInsetX = 8;
		_placeholderAlpha = 1;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.keyboardType = UIKeyboardTypeDefault;
		self.returnKeyType = UIReturnKeySearch;
		self.autocapitalizationType = UITextAutocapitalizationTypeNone;
		self.clipsToBounds = YES;
		_validateType = LNTextValidateNone;
	}
	return self;
}

- (void)setTextAttributes:(NSDictionary *)textAttributes
{
	_textAttributes = textAttributes;
	UIFont *font = textAttributes[UITextAttributeFont];
	if (font) self.font = font;
	UIColor *textColor = textAttributes[UITextAttributeTextColor];
	if (textColor) self.textColor = textColor;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
	self.background = backgroundImage;
}

- (UIImage *)backgroundImage
{
	return self.background;
}

- (void)setValidateRegularExpression:(NSString *)validateRegularExpression
{
	_validateType = LNTextValidateCustom;
	self.validatePredicate = [NSPredicate predicateWithFormat:@"self matches %@", validateRegularExpression];
}
//This is special. "isValid:" method returns YES if ANY ONE of flag's predicate is true. ATTENTION!
- (BOOL)isValid:(NSString *)text
{
	if (_validateType == LNTextValidateNone) return YES;
    BOOL isValid = NO;
    NSString *reg = nil;
    NSPredicate *predicate = nil;
	if (_validateType & LNTextValidateEmail) {
        reg = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
		@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
		@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
		@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
		@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
		@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
		@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", reg];
        isValid |= [predicate evaluateWithObject:text.lowercaseString];
	}
	if (_validateType & LNTextValidateRequired) {
		reg = @"^\\S(?:.*?\\S)?$";
        predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", reg];
        isValid |= [predicate evaluateWithObject:text];
	}
	if (_validateType & LNTextValidateCustom) {
        isValid |= [_validatePredicate evaluateWithObject:text];
	}
    return isValid;
}

- (BOOL)isValid
{
	return [self isValid:self.text];
}

- (BOOL)validate:(NSError *__autoreleasing *)error
{
	if (![self isValid:self.text]) {
		if (error) {
			*error = [NSError errorWithDomain:NSArgumentDomain code:0 userInfo:@{
					NSLocalizedDescriptionKey: NSLocalizedString(self.failedValidateText, nil) ?: @"",
			 NSLocalizedFailureReasonErrorKey: NSLocalizedString(self.failedValidateReason, nil) ?: @""
					  }];
		}
		return NO;
	}
	return YES;
}

- (void)setClearImage:(UIImage *)clearImage
{
	_clearImage = clearImage;
	UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[clearButton setImage:clearImage forState:UIControlStateNormal];
	[clearButton addTarget:self action:@selector(cleanUp) forControlEvents:UIControlEventTouchUpInside];
	clearButton.frame = (CGRect) {.size = clearImage.size};
	self.rightView = clearButton;
	self.rightViewMode = UITextFieldViewModeAlways;
	self.rightView.hidden = YES;
	self.clearButtonMode = UITextFieldViewModeNever;
}

- (void)cleanUp
{
	if ([self.delegate textFieldShouldClear:self]) {
		self.text = nil;
		self.rightView.hidden = YES;
		if (![self isFirstResponder])
			[self becomeFirstResponder];
	}
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
#ifndef __IPHONE_7_0
	bounds.origin.y = (bounds.size.height - self.font.lineHeight) / 2;
	bounds.size.height = self.font.lineHeight;
#else
	if (UIDevice.currentDevice.systemVersion.floatValue < 7) {
		bounds.origin.y = (bounds.size.height - self.font.lineHeight) / 2;
		bounds.size.height = self.font.lineHeight;
	}
#endif
	bounds.origin.x = _edgeInsetX;
	if (self.leftView && self.leftViewMode == UITextFieldViewModeAlways) {
		bounds.origin.x += CGRectGetMaxX(self.leftView.frame);
	}
	bounds.size.width -= bounds.origin.x + _edgeInsetX;
	return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	return [self placeholderRectForBounds:bounds];
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
	CGFloat offset = (self.bounds.size.height - self.rightView.bounds.size.height) / 2;
	return CGRectOffset(self.rightView.bounds, self.bounds.size.width - self.rightView.bounds.size.width - offset, offset);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
	return [self placeholderRectForBounds:bounds];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
	CGFloat offset = (self.bounds.size.height - self.leftView.bounds.size.height) / 2;
	return CGRectOffset(self.leftView.bounds, offset, offset);
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
	[[self.textColor colorWithAlphaComponent:_placeholderAlpha] set];
	
	[self.placeholder drawInRect:CGRectInset(rect, 0, (rect.size.height - self.font.lineHeight) / 2) withFont:self.font];
}

@end

@implementation UIView (LNTextFieldValidate)

- (BOOL)validateAllTextFields:(NSError *__autoreleasing *)error
{
	for (LNTextField *textfield in self.subviews) {
		if ([textfield isKindOfClass:[LNTextField class]]) {
			if (![textfield validate:error]) return NO;
		}
	}
	return YES;
}

@end
