/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <UIKit/UIKit.h>
#import "ShapeImageView.h"

extern NSString *const ScaleAndFadeKey;
extern NSString *const MarchingAntsKey;

@interface AnimatingShapeImageView : ShapeImageView
@property (nonatomic, readonly) BOOL animating;
@property (nonatomic) UIColor *primaryColor;
- (void) setAnimation : (NSString *) animationNameKey;
@end