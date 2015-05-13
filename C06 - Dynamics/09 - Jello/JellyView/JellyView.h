/*
 
 Erica Sadun, http://ericasadun.com
 Inspired by http://victorbaro.com/2014/07/vbfjellyview-tutorial/
 
 */

#import <UIKit/UIKit.h>

@interface JellyView : UIView
@property (nonatomic) UIColor *color;
@property (nonatomic) CGFloat damping;
@property (nonatomic) CGFloat frequency;
@property (nonatomic) CGFloat elasticity;
@property (nonatomic) CGFloat density;
- (void) establishDynamics : (UIDynamicAnimator *) animator;
+ (instancetype) view : (CGSize) size;
@end

