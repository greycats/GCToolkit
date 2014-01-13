//
//  GCTextField.h
//
//  Created by Rex Sheng on 9/5/12.
//  Copyright (c) 2012 Rex Sheng
//

#import <UIKit/UIKit.h>

//This is special. "isValid:" method returns YES if ANY ONE of flag's predicate is true. ATTENTION!
typedef NS_ENUM(NSUInteger, GCTextValidateType) {
	GCTextValidateNone = 0,
	GCTextValidateEmail = 1 << 0,
	GCTextValidateRequired = 1 << 1,
	GCTextValidateCustom = 1 << 2
};

@interface GCTextField : UITextField

@property (nonatomic) CGFloat edgeInsetX UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *clearImage;
@property (nonatomic) CGFloat placeholderAlpha UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSPredicate *validatePredicate;
@property (nonatomic, strong) NSString *validateRegularExpression;
@property (nonatomic) GCTextValidateType validateType;
@property (nonatomic, strong) NSString *failedValidateText;
@property (nonatomic, strong) NSString *failedValidateReason;
@property (nonatomic, strong) NSDictionary *textAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;

- (BOOL)isValid:(NSString *)text;
- (BOOL)validate:(NSError **)error;
- (void)cleanUp;

+ (void)registerValidation:(NSUInteger)validationType regularExpression:(NSString *)expression;

@end


@interface UIView (GCTextFieldValidate)

- (BOOL)validateAllTextFields:(NSError **)error;

@end;