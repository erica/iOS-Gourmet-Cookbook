/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

@interface FlipTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) BOOL forward;
@property (nonatomic) CGFloat duration;
@end
