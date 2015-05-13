/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "CustomTransitioning.h"
#import "TransitionView.h"
#import "Essentials.h"

@interface CustomTransitioning ()
@property (nonatomic, weak) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic) CALayer *transitionLayer;
@end

@implementation CustomTransitioning

- (instancetype) init
{
    if (!(self = [super init])) return self;
    _duration = 1.0f; // default
    _transitionType = kCustomFadeTransition;
    return self;
}

#pragma mark - Cube Transitions

- (CALayer *)createLayerFromView:(UIView *)aView transform:(CATransform3D)transform inView: (UIView *) containerView
{
    // Establish layer
    CALayer *imageLayer = [CALayer layer];
    imageLayer.anchorPoint = CGPointMake(1.0f, 1.0f);
    imageLayer.frame = (CGRect){.size = containerView.frame.size};
    imageLayer.transform = transform;

    // Stylize
    CGFloat borderWidth = aView.layer.borderWidth;
    CGColorRef colorRef = aView.layer.borderColor;
    aView.layer.borderWidth = 1;
    aView.layer.borderColor = [UIColor blackColor].CGColor;
    
    // Screenshot
    UIGraphicsBeginImageContextWithOptions(containerView.frame.size, NO, 0);
	[aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Restore previous style
    aView.layer.borderWidth = borderWidth;
    aView.layer.borderColor = colorRef;

    // Return new layer
    imageLayer.contents = (__bridge id) image.CGImage;
    return imageLayer;
}

- (void) constructForwardRotationLayer: (BOOL) forward
{
    UIViewController *source = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *dest = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [_transitionContext containerView];

    CALayer *transformationLayer = [CALayer layer];
    transformationLayer.frame = containerView.bounds;
    transformationLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    CATransform3D sublayerTransform = CATransform3DIdentity;
    sublayerTransform.m34 = 1.0 / -1000;
    [transformationLayer setSublayerTransform:sublayerTransform];
    [containerView.layer addSublayer:transformationLayer];
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 0);
    [transformationLayer addSublayer:[self createLayerFromView:source.view transform:transform inView:containerView]];
    
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    transform = CATransform3DTranslate(transform, containerView.frame.size.width, 0, 0);
    if (!forward)
    {
        transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
        transform = CATransform3DTranslate(transform, containerView.frame.size.width, 0, 0);
        transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
        transform = CATransform3DTranslate(transform, containerView.frame.size.width, 0, 0);
    }

    
    [transformationLayer addSublayer:[self createLayerFromView:dest.view transform:transform inView:containerView]];
    _transitionLayer = transformationLayer;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished
{
    UIViewController *source = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *dest = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    dest.view.alpha = 1.0f;
    [_transitionLayer removeFromSuperlayer];
    [source.view removeFromSuperview];
    [_transitionContext completeTransition:YES];
    _transitionContext = nil;
}

- (void)animateCubeTransition:(id<UIViewControllerContextTransitioning>)transitionContext goingForward: (BOOL) forward
{
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:fromController.view];
    [containerView addSubview:toController.view];
    
    // set up initial state
    _transitionContext = transitionContext;
    [self constructForwardRotationLayer:forward];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = _duration;
    
    CGFloat halfWidth = containerView.frame.size.width / 2.0f;
    float multiplier =  forward ? -1.0f : 1.0f;
    
    CABasicAnimation *translationX = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.x"];
    translationX.toValue = [NSNumber numberWithFloat:multiplier * halfWidth];
    
    CABasicAnimation *translationZ = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.z"];
    translationZ.toValue = [NSNumber numberWithFloat:-halfWidth];
    
    CABasicAnimation *rotationY = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
    rotationY.toValue = [NSNumber numberWithFloat: multiplier * M_PI_2];
    
    group.animations = [NSArray arrayWithObjects: rotationY, translationX, translationZ, nil];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    [CATransaction flush];
    [_transitionLayer addAnimation:group forKey:@"CubeTransition"];
}

#pragma mark - Core Image Transition
#define VALUE(struct) ({ __typeof__(struct) __struct = struct; [NSValue valueWithBytes:&__struct objCType:@encode(__typeof__(__struct))]; })

- (UIImage *) screenShot: (UIView *) view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)animateCopyMachineTransition:(id<UIViewControllerContextTransitioning>)transitionContext goingForward: (BOOL) forward
{
    // Retrieve context players
    CGFloat duration = [self transitionDuration:transitionContext];
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Set up container
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromController.view];
    [containerView addSubview:toController.view];
    
    // Transition
    TransitionView *transitionView = [[TransitionView alloc] initWithFrame:containerView.bounds];
    if (forward)
    {
        transitionView.image1 = [self screenShot:fromController.view];
        transitionView.image2 = [self screenShot:toController.view];
    }
    else
    {
        transitionView.image1 = [self screenShot:toController.view];
        transitionView.image2 = [self screenShot:fromController.view];
    }
    transitionView.duration = duration;
    transitionView.reversed = !forward;
    [containerView addSubview:transitionView];

    // Perform animation
    CustomCITransitionType transition = kCICustomTransitionCopyMachine;
    [transitionView transition:transition completion:^{
        [fromController.view removeFromSuperview];
        [transitionView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];

}

#pragma  mark - Fade Transition

- (void)animateFadeTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Retrieve context players
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // Set up container
    [containerView addSubview:fromController.view];
    [containerView addSubview:toController.view];
    
    // Establish initial state
    toController.view.alpha = 0.0f;
    
    // Perform animation
    CGFloat duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        toController.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [fromController.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - Bounce In / Squeeze out

- (void)bounceTransition:(id<UIViewControllerContextTransitioning>)transitionContext goingForward:(BOOL) forward
{
    // Retrieve context players
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    CGFloat duration = [self transitionDuration:transitionContext];
    
    // Set up container
    
    if (forward)
    {
        [containerView addSubview:fromController.view];
        [containerView addSubview:toController.view];
        CGRect frame = toController.view.frame;
        frame.origin.x -= frame.size.width;
        toController.view.frame = frame;
    }
    else
    {
        [containerView addSubview:toController.view];
        [containerView addSubview:fromController.view];
    }
    
    // Perform animation
    
    if (forward)
    {
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.4f initialSpringVelocity:0 options:0 animations:^{
            CGRect frame = toController.view.frame;
            frame.origin.x = 0;
            toController.view.frame = frame;
        } completion:^(BOOL finished) {
            [fromController.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        return;
    }
    
    // Fixed duration
    void (^animationBlock)() = ^{
        CGFloat elapsedTime = 0.0;
        CGFloat relativeDuration = 0.3f;
        
        [UIView addKeyframeWithRelativeStartTime:elapsedTime relativeDuration:relativeDuration animations:^{
            CGRect frame = fromController.view.frame;
            frame.origin.x += 0.2f * frame.size.width;
            fromController.view.frame = frame;
        }];
        
        elapsedTime += relativeDuration;
        
        [UIView addKeyframeWithRelativeStartTime:elapsedTime relativeDuration:duration - elapsedTime animations:^{
            CGRect frame = fromController.view.frame;
            frame.origin.x = - frame.size.width;
            fromController.view.frame = frame;
        }];
    };
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModePaced animations:animationBlock completion:^(BOOL finished) {
        [fromController.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

#pragma  mark - Flip Transition

- (void)animateFlipTransition:(id<UIViewControllerContextTransitioning>)transitionContext goingForward: (BOOL) forward
{
    // Retrieve context players
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    CGFloat duration = [self transitionDuration:transitionContext];

    // Set up container
    [containerView addSubview:fromController.view];

    // Animate
    NSUInteger options = forward ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown;
    [UIView transitionFromView:fromController.view toView:toController.view duration:duration options:options completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - Select Transition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (_transitionType)
    {
        case kCustomCubeForwardTransition:
            [self animateCubeTransition:transitionContext goingForward:YES];
            break;
        case kCustomCubeBackTransition:
            [self animateCubeTransition:transitionContext goingForward:NO];
            break;
        case kCustomCopyMachineForwardTransition:
            [self animateCopyMachineTransition:transitionContext goingForward:YES];
            break;
        case kCustomCopyMachineBackTransition:
            [self animateCopyMachineTransition:transitionContext goingForward:NO];
            break;
        case kCustomBounceInTransition:
            [self bounceTransition:transitionContext goingForward:YES];
            break;
        case kCustomBounceOutTransition:
            [self bounceTransition:transitionContext goingForward:NO];
            break;
        case kCustomFlipInTransition:
            [self animateFlipTransition:transitionContext goingForward:YES];
            break;
        case kCustomFlipOutTransition:
            [self animateFlipTransition:transitionContext goingForward:NO];
            break;
            
        case kCustomFadeTransition:
        default:
            [self animateFadeTransition:transitionContext];
            break;
    }
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _duration;
}

@end
