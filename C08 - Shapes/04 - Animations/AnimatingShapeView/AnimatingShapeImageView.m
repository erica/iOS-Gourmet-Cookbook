/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "AnimatingShapeImageView.h"
#import "CALayer+Utility.h"
#import "BezierMiniPack.h"

NSString *const AnimatingShapeKey = @"AnimatingShapeKey";
NSString *const ScaleAndFadeKey = @"ScaleAndFadeKey";
NSString *const MarchingAntsKey = @"MarchingAntsKey";

NSArray *FetchAnimationLayersWithKey(UIView *view, NSString *key)
{
    NSMutableArray *layers = [NSMutableArray array];
    for (CALayer *layer in view.superview.layer.sublayers)
    {
        if ([layer.name isEqualToString:key])
            [layers addObject:layer];
    }
    return layers.copy;
}

@interface AnimatingShapeImageView ()
@property (nonatomic, readonly) NSString *animationKey;
@property (nonatomic) NSString *currentAnimation;
@end

@implementation AnimatingShapeImageView
- (NSString *) animationKey
{
    return [NSString stringWithFormat:@"%@%X", AnimatingShapeKey, (unsigned int) self];
}

- (void) removeAnimations
{
    NSArray *layers = FetchAnimationLayersWithKey(self, self.animationKey);
    [layers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (void) establishScaleAndFadeAnimation
{
    // Clean up existing animations
    [self removeAnimations];

    // Animate
    CAShapeLayer *shapeLayer = self.shapeLayer;
    UIColor *color = _primaryColor ? : [[UIColor grayColor] colorWithAlphaComponent:0.5];
    
    // Build two visible rings
    for (NSInteger ring = 0; ring < 2; ring++)
    {
        CAShapeLayer *borderShapeLayer = [CAShapeLayer layer];
        borderShapeLayer.frame = self.frame;
        borderShapeLayer.opacity = 0.5;
        borderShapeLayer.lineWidth = 2.0;
        borderShapeLayer.strokeColor = color.CGColor;
        borderShapeLayer.fillColor = color.CGColor;
        borderShapeLayer.path = shapeLayer.path;
        borderShapeLayer.name = self.animationKey;
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = shapeLayer.path;
        borderShapeLayer.mask = maskLayer;
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.toValue =  @0;
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup new];
        animationGroup.repeatCount = HUGE_VALF;
        animationGroup.duration = 2.0;
        animationGroup.beginTime = [borderShapeLayer convertTime:CACurrentMediaTime() fromLayer:nil] + ring;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.3:0:1:1];
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        
        [borderShapeLayer addAnimation:animationGroup forKey:ScaleAndFadeKey];
        [self.superview.layer sendSublayerToBack:borderShapeLayer];
    }
}

- (void) establishMarchingAntsAnimation: (CGFloat) width
{
    // Clean up existing animations
    [self removeAnimations];
    
    // Animate
    CAShapeLayer *shapeLayer = self.shapeLayer;
    UIColor *color = _primaryColor ? : [[UIColor grayColor] colorWithAlphaComponent:0.5];
    
    CAShapeLayer *borderShapeLayer = [CAShapeLayer layer];
    borderShapeLayer.frame = self.frame;
    borderShapeLayer.opacity = 0.5f;
    borderShapeLayer.lineWidth = width;
    borderShapeLayer.strokeColor = color.CGColor;
    borderShapeLayer.fillColor = [UIColor clearColor].CGColor;
    borderShapeLayer.lineDashPattern = @[@8,@8];
    borderShapeLayer.path = shapeLayer.path;
    borderShapeLayer.name = self.animationKey;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:shapeLayer.path];
    ScalePath(path, 1.1, 1.1);
    maskLayer.path = path.CGPath;
    borderShapeLayer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    animation.fromValue = @(0.0);
    animation.toValue = @(-32.0);
    animation.repeatCount = HUGE_VALF;
    animation.duration = 1.0;
    
    [borderShapeLayer addAnimation:animation forKey:MarchingAntsKey];
    [self.superview.layer sendSublayerToBack:borderShapeLayer];
}

- (void) setAnimation: (NSString *) animationNameKey
{
    _currentAnimation = animationNameKey;
    if (!self.shape)
        self.shape = [UIBezierPath bezierPathWithRect:self.bounds];

    if (!animationNameKey)
    {
        _animating = NO;
        [self removeAnimations];
        return;
    }

    if ([animationNameKey isEqualToString:ScaleAndFadeKey])
    {
        [self establishScaleAndFadeAnimation];
        _animating = YES;
    }
    else if ([animationNameKey isEqualToString:MarchingAntsKey])
    {
        [self establishMarchingAntsAnimation:8.0];
        _animating = YES;
    }
    else
    {
        NSLog(@"This is a no-op");
    }
}

- (void) setPrimaryColor:(UIColor *)primaryColor
{
    _primaryColor = primaryColor;
    [self setAnimation:_currentAnimation];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if ([keyPath isEqualToString:@"shape"])
    {
        [self setAnimation:_currentAnimation];
    }
}

- (void) setup
{
    [super setup];

    // Observe Shape Changes
    [self addObserver:self forKeyPath:@"shape" options:NSKeyValueObservingOptionNew context:NULL];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return self;
    [self setup];
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) return self;
    [self setup];
    return self;
}

- (instancetype) initWithImage:(UIImage *)image
{
    if (!(self = [super initWithImage:image])) return self;
    [self setup];
    return self;
}

- (instancetype) initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if (!(self = [super initWithImage:image highlightedImage:highlightedImage])) return self;
    [self setup];
    return self;
}

- (void) cleanup
{
    [self removeAnimations];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"shape"];
}

- (void) removeFromSuperview
{
    [self cleanup];
    [super removeFromSuperview];
}

- (void) dealloc
{
    [self cleanup];
}
@end
