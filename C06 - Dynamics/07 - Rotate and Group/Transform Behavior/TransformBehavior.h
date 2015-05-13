/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <UIKit/UIKit.h>

@interface TransformBehavior : UIDynamicBehavior
- (instancetype) initWithItem: (id <UIDynamicItem>) item transform: (CGAffineTransform) transform;
@property (nonatomic) CGFloat acceleration; // defaults to 0.0025
@property (nonatomic, readonly) BOOL stopped;
@end
