/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "FlipTransition.h"

@implementation FlipTransition
- (instancetype) init
{
    if (!(self = [super init])) return self;
    _duration = 1.0f; // default
    _forward = YES;
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Retrieve context players
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // Set up container
    [containerView addSubview:fromController.view];
    
    // Animate
    CGFloat duration = [self transitionDuration:transitionContext];
    NSUInteger options = _forward ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown;
    [UIView transitionFromView:fromController.view toView:toController.view duration:duration options:options completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _duration;
}
@end
