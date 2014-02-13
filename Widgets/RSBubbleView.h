//
//  RSBubbleView.h
//
//  Created by Rex Sheng on 4/28/12.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, RSBubbleType) {
	RSBubbleTopLeft = UIRectCornerTopLeft,
	RSBubbleTopRight = UIRectCornerTopRight,
	RSBubbleBottomLeft = UIRectCornerBottomLeft,
	RSBubbleBottomRight = UIRectCornerBottomRight,
	RSBubbleMiddle = 1 << 4
};

@interface RSBubbleView : UIView

@property (nonatomic) RSBubbleType arrowType UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGRect arrowSize UI_APPEARANCE_SELECTOR; // x or y is ignored, depending on arrowType. default to (30, 0, 14, 9)
@property (nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR; // cornerRadius default to 10.5

@property (nonatomic, strong) UIColor *bubbleBorderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat bubbleBorderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat whiteInset UI_APPEARANCE_SELECTOR;

@property (nonatomic, copy) NSArray *colors;
@property (nonatomic, copy) NSArray *locations;
@property (nonatomic, readonly, strong) CALayer *contentMaskLayer;

@end
