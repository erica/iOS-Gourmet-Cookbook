/*
 
 Erica Sadun, http://ericasadun.com
 STACK BUTTON

 */

@interface StackButton : UIButton
@property (nonatomic) NSString *text;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *borderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) BOOL standaloneButton; // if not for stacking

@property (nonatomic) NSNumber *role; // 0 = top, 1 = center, 2 = bottom
+ (instancetype) topButton;
+ (instancetype) centerButton;
+ (instancetype) bottomButton;
@end
