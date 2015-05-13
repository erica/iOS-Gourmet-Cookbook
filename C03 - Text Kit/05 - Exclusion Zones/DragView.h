/*
 
 Erica Sadun, http://ericasadun.com
 Gourmet Recipes

 */

#import <UIKit/UIKit.h>

UIBezierPath *bunnyPath(CGSize destSize);

@interface DragView : UIView
@property (nonatomic, weak) NSTextContainer *container;
@property (nonatomic) UIBezierPath *shapePath;
+ (instancetype) instanceWithFrame: (CGRect) frame path: (UIBezierPath *) path;
@end

