//
//  LNTextField.h
//
//  Created by Rex Sheng on 9/5/12.
//  Copyright (c) 2012 Log(n) LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

//This is special. "isValid:" method returns YES if ANY ONE of flag's predicate is true. ATTENTION!
typedef NS_ENUM(NSUInteger, LNTextValidateType) {
	LNTextValidateNone = 0,
	LNTextValidateEmail = 1 << 0,
	LNTextValidateRequired = 1 << 1,
	LNTextValidateCustom = 1 << 2
};

@interface LNTextField : UITextField

@property (nonatomic) CGFloat edgeInsetX UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *clearImage;
@property (nonatomic) CGFloat placeholderAlpha UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSPredicate *validatePredicate;
@property (nonatomic, strong) NSString *validateRegularExpression;
@property (nonatomic) LNTextValidateType validateType;
@property (nonatomic, strong) NSString *failedValidateText;
@property (nonatomic, strong) NSString *failedValidateReason;
@property (nonatomic, strong) NSDictionary *textAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;

- (BOOL)isValid __deprecated; // use -validate:
- (BOOL)isValid:(NSString *)text;
- (BOOL)validate:(NSError **)error;
- (void)cleanUp;

@end


@interface UIView (LNTextFieldValidate)

- (BOOL)validateAllTextFields:(NSError **)error;

@end;